# FP00627 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.UIL.csproj | 1754 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.UIL.csproj | 3960 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.UIL.csproj | 316 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.UIL.csproj | 414 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00627_Cell_Simulation_Pack.UIL\FP00627_Cell_Simulation_Pack.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00627_Cell_Simulation_Pack.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1731 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\FP00627_Cell_Simulation_Pack.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 3974 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00627_MeasureSetForm_Popup.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 312 |
| legacy | 06.UIL\GSCM.FP.Planning.UIL\POPUP\FP00627_MeasureSetForm_Popup.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 401 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1453 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1454 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1455 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1455 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1456 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1456 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1453 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1454 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1455 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1455 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1456 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 1456 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1453 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1454 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1455 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1455 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1456 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btn_bucket.Click | btnBucket_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1456 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1453 | FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1454 | FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1455 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1455 | FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1456 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH |  |
| event:this.btn_category.Click | btnCatagory_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 1456 | FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 82 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_BukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_FP00600_PlanAmend_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, FORM_INS, TABLE_NAME, RELEASE_FLAG, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| ApplySearchCondition | dtFormInstance.Rows[0] | FORMATION_INSTANCE_ID |
| btnPlanInfo_Click | Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| cboPlanId_changed | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_plan, chk_planSum, chk_rec_inHouse, chk_rec_CWA, chk_rec_CMI, chk_rec_CNA, chk_rec_CNB, chk_rec_OC, chk_shipmentResult, chk_EOL, chk_productionResult, chk_eoh_moving, chk_eoh_moving_hold, chk_eoh_eol, chk_eoh_uninspection, chk_eoh_eol_hold, chk_eoh_cell_total, chk_eoh_cell_total_hold |
| CreateFilterDataSet | x | _MM_ |
| GetPlanId | Filter | POPUP_OPEN |
| GetPlanId | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| GetPlanPeriod | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| GetPlanPeriod | dtPlanId.Rows[cboPlanId.SelectedIndex] | PLAN_START_DATE, PLAN_END_DATE, PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| InitControls | c | ControlName |
| InitControls | a | ControlName, ControlValue |
| InitControls | Filter | USER_ID, MASTER_ID, INSTANCE_ID |
| InitControls | dtInstance.Rows[0] | CONFIRM_AREA |
| RefreshHeader | row | DATA_TYPE |
| SetCurrentDate | dtIsPast.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| SetCurrentDate | Filter | PLAN_DATE |
| UIFindData | Filter | PLAN_ID, POPUP_OPEN, RELEASE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetFilter | InitControls:167, InitControls:168, InitControls:179, InitControls:181, InitControls:191, InitControls:192, InitControls:193, InitControls:194 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:208, GetPlanId:301, cboInstance_changed:397, cboInstance_changed:398, cboPlanId_changed:440, UIFindData:873, ApplySearchCondition:1480 | CString.GetCheckedListValue | CODE |
| GetMeasure | CheckAndGetMeasure:593, Measure:165, InitControl:213 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1287 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:106 |
| cboInstance | SelectedIndexChanged | cboInstance_changed | InitEvent:270 |
| cboPlanId | SelectedIndexChanged | cboPlanId_changed | InitEvent:272 |
| edtTopItemId | TextChanged | edt_topItem_TextChanged | InitEvent:274 |
| edtItem | TextChanged | edt_item_TextChanged | InitEvent:275 |
| edtNickName | TextChanged | edt_NickName_TextChanged | InitEvent:276 |
| edtModelNickName | TextChanged | edt_ModelNickName_TextChanged | InitEvent:277 |
| edtCellGroup | TextChanged | edt_CellGroup_TextChanged | InitEvent:278 |
| drpPeriod | ValueChanged | drpPeriod_changed | InitEvent:280 |
| drpPlanDate | ValueChanged | drpPlanDate_changed | InitEvent:281 |
| chk_release | CheckedChanged | chk_release_CheckedChanged | InitEvent:283 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1133 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:640 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:2060 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:2061 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:2062 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:2063 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:2064 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:2065 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:2066 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:2067 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:2068 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:2069 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:2070 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:2071 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:2072 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:2073 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:2074 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:2075 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:2076 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:2077 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:2078 |
| this.btn_bucket | Click | btnBucket_Click | InitializeComponent:2335 |
| this.btn_category | Click | btnCatagory_Click | InitializeComponent:2373 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:2411 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:3700 |
| this.usrButton1 | Click | usrButton1_Click | InitializeComponent:313 |
| this.usrButton2 | Click | usrButton2_Click | InitializeComponent:351 |
| this | Load | MeasureSetForm_Load | InitializeComponent:375 |
| this | SizeChanged | MeasureSetForm_SizeChanged | InitializeComponent:376 |

## 6. 컨트롤 (166개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 51 | layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem10, layoutControlItem16, layoutControlItem18, layoutControlItem22, layoutControlItem23, layoutControlItem24, layoutControlItem25, layoutControlItem26, layoutControlItem27, layoutControlItem28, layoutControlItem31 … |
| CheckBox | 19 | chk_total, chk_rec_OC, chk_eoh_eol_hold, chk_rec_CWA, chk_eoh_eol, chk_eoh_cell_total_hold, chk_eoh_moving_hold, chk_eoh_cell_total, chk_eoh_moving, chk_rec_CNB, chk_rec_CNA, chk_shipmentResult, chk_rec_CMI, chk_rec_inHouse, chk_productionResult … |
| UsrCheckedList2 | 16 | mcbo_line, mcbo_division, mcbo_prodtype, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_planner, mcbo_site, usrCheckedList21, usrCheckedList22, usrCheckedList23, usrCheckedList24, usrCheckedList25, usrCheckedList26, usrCheckedList27 … |
| UsrButton | 14 | btnSql, btnToggleSave, usrButton1, btnExcelImport, usrButton2, btn_bucket, btn_category, btn_column, usrButton3, usrButton4, usrButton5, btnPlanInfo, usrButton1, usrButton2 |
| UsrTextBox | 11 | edtCellGroup, edtNickName, edtModelNickName, edtItem, edtTopItemId, edt_pjtGroup, usrTextBox1, usrTextBox2, usrTextBox5, usrTextBox6, usrTextBox7 |
| EmptySpaceItem | 10 | emptySpaceItem7, emptySpaceItem8, emptySpaceItem4, emptySpaceItem5, emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem10, emptySpaceItem6, emptySpaceItem9 |
| UsrCombo | 6 | cboPlanId, cboInstance, cbo_plan_group, cbo_fpplanid, usrCombo1, usrCombo2 |
| UsrCheckBox | 5 | chk_release, chk_Info, usrCheckBox1, usrCheckBox2, usrCheckBox3 |
| Panel | 5 | panel2, panel4, panel1, panel3, panel1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl4 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup4, layoutControlGroup2, layoutControlGroup5 |
| UsrDateRangePicker2 | 3 | dCalendar_planrange, drpPeriod, usrDateRangePicker22 |
| FpSpread | 3 | spdMain, spdEdit, spdInfo |
| SheetView | 3 | spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrPopupTextBox | 2 | usrPopupTextBox1, usrPopupTextBox2 |
| UsrLabel | 2 | txtPlanId, usrLabel2 |
| Label | 2 | label1, label1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDatePicker2 | 1 | drpPlanDate |
| SplitContainer | 1 | splitter |
| ImageList | 1 | imageList1 |
| TextBox | 1 | tbLog |
| DataGridView | 1 | dgEdit |

## 7. 확인 필요 (4건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1453 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1454 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1455 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1456 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00600_PlanAmend#find_BukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 21 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 2 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00627 | Amend | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 | 21/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:568, SetSheetHeaderColumn_FP@RefreshHeaderOnly:766
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| RefreshHeader |  | 717 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 723 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 2094 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2095 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2096 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2097 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2455 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2456 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2457 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2458 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2506 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2507 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2508 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2509 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 | 21 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
