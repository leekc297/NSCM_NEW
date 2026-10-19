# FP00518 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP00518_Shipping_Plan.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1481 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP00518_Shipping_Plan.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1080 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00518_ItemPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 574 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00518_ItemPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 562 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00518_TransportModePopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 409 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00518_TransportModePopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 383 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl | 262 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl | 269 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged > SetChangedControl | 276 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanGroup.SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | 1211 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:cboSite.SelectedIndexChanged | cboSite_SelectedIndexChanged | 493 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 1248 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboWppWeek.SelectedIndexChanged | CboWppWeek_SelectedIndexChanged | 1263 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 459 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 467 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_TransMode | 277 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| button:FindButton | FindButton > FindData > Find_Data_Item | 384 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| button:FindButton | FindButton > Find_Data > Find_Data_ShippingPlan | 826 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:popSql.OnSql | RunSqlSource > Find_Data_TransMode | 277 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:popSql.OnSql | RunSqlSource > Find_Data_Item | 384 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:popSql.OnSql | RunSqlSource > Find_Data_ShippingPlan | 826 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:popSql.OnSql | RunSqlSource > Save_Data_ShippingPlan | 1067 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_ShippingPlan | 826 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| button:SaveButton | SaveButton > Save_Data > Save_Data_ShippingPlan | 1067 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_TransMode | 277 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Item | 384 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:this.btnCreateWPP.Click | btnCreateWPP_Click | 524 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.btnCreateWPP.Click | btnCreateWPP_Click > Find_Data > Find_Data_ShippingPlan | 826 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:this.btnCreateWPP.Click | btnCreateWPP_Click > Save_Data_CreateWPP | 1156 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:this.btnImport.Click | btnImport_Click | 601 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.cboSite.SelectedIndexChanged | cboSite_SelectedIndexChanged | 493 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.chkWPP.CheckedChanged | chkWPP_CheckedChanged | 1278 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.chkWPP.CheckedChanged | chkWPP_CheckedChanged | 1284 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 459 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 467 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 160 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 166 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 177 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 181 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 187 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 197 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 198 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 212 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 224 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 233 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 262 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 269 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 276 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_TransMode | 277 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |
| event:this.Load | Form_Load > FindData > Find_Data_Item | 384 | FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | SP PR_UI_FP00518_SHIPPING_PLAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 5 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 3 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 12 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00518_SHIPPING_PLAN | MATCH | 5 | SP PR_UI_FP00518_SHIPPING_PLAN | EXEC:PR_UI_FP00518_SHIPPING_PLAN | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnCreateWPP_Click | dtNewVersion.Rows[0] | INSTANCE_ID, WPP_WEEK, WPP_SEQ |
| btnImport_Click | dtNewVersion.Rows[0] | INSTANCE_DATE, VERSION_ID |
| btnImport_Click | Application.OpenForms | FPC0100_ExcelImportPopup |
| CboPlanGroup_SelectedIndexChanged | dtCurrVersion.Rows[0] | INSTANCE_DATE, VERSION_ID |
| chkWPP_CheckedChanged | dtWppSeq.Rows[0] | MIN_DATE, MAX_DATE |
| Save_Data_ShippingPlan | dtCurrVersion.Rows[0] | INSTANCE_DATE, VERSION_ID |
| spdMain_CellClick | dtCurrVersion.Rows[0] | INSTANCE_ID, INSTANCE_DATE, VERSION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:164, InitControls:173, InitControls:185, SetChangedControl:260, SetChangedControl:266, SetChangedControl:273, btnCreateWPP_Click:522, btnImport_Click:583 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnCreateWPP | Click | btnCreateWPP_Click | InitializeComponent:174 |
| this.chkWPP | CheckedChanged | chkWPP_CheckedChanged | InitializeComponent:284 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:632 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:696 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:956 |
| this | Load | Form_Load | .ctor:113 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:295 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:296 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:297 |
| cboWppWeek | SelectedIndexChanged | CboWppWeek_SelectedIndexChanged | InitEvent:298 |
| popSql | OnSql | RunSqlSource | btnSql_Click:572 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:157 |
| this.cboSite | SelectedIndexChanged | cboSite_SelectedIndexChanged | InitializeComponent:259 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:303 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:359 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:462 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:463 |
| this | Load | Form_Load | .ctor:140 |
| this | Load | Form_Load | .ctor:151 |
| this | Load | Form_Load | .ctor:162 |
| this | Load | Form_Load | .ctor:176 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitEvent:263 |
| cboSite | SelectedIndexChanged | cboSite_SelectedIndexChanged | InitEvent:264 |
| popSql | OnSql | RunSqlSource | btnSql_Click:319 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:180 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:237 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:292 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:293 |
| this | Load | Form_Load | .ctor:124 |
| this | Load | Form_Load | .ctor:133 |
| popSql | OnSql | RunSqlSource | btnSql_Click:218 |

## 6. 컨트롤 (68개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 23 | layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem4, layoutControlItem5, layoutControlItem9, lblWppWeek, lblWppSeq, layoutControlItem2, layoutControlItem1, lblExcelImport, lblSql, layoutControlItem12, layoutControlItem1 … |
| UsrCombo | 7 | cboWppSeq, cboWppWeek, cboPlanGroup, cboCellType, cboSite, cboPlant, cboSite |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 4 | btnImport, btnSql, btnSql, btnSql |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 3 | clbPlant, clbDivision, clbDivision |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrMultiLineEditor | 2 | txtItemName, txtItemID |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| SimpleButton | 1 | btnCreateWPP |
| UsrCheckBox | 1 | chkWPP |
| UsrDateRangePicker2 | 1 | drpPeriod |
| ImageList | 1 | imageList1 |
| UsrTextBox | 1 | txtItem |
| UsrLabel | 1 | usrLabel1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 39 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00518 | ItemPopup | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_COLUMNS | FP00518 | ShippingPlan | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 |
| SCM_MST_SHEET_COLUMNS | FP00518 | TEST_TargetMultiPopup | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
| SCM_MST_SHEET_COLUMNS | FP00518 | TransportModePopup | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ShippingPlan, ItemPopup, TransportModePopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:358, SetSheetHeaderColumn_FP@SetSpreadInit:292, SetSheetHeaderColumn_FP@SetSpreadInit:188

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 362 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_ID |  |
| SetSpreadInit | 0 | 363 | 표시/라벨 변경 | set:Visible | Visible = {?false} | INSTANCE_DATE |  |
| SetSpreadInit | 0 | 364 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VERSION_ID |  |
| SetSpreadInit | 0 | 365 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 366 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PRODUCTION_TYPE |  |
| SetSpreadInit | 0 | 367 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MARKET |  |
| SetSpreadInit | 0 | 368 | 표시/라벨 변경 | set:Visible | Visible = {?false} | WPP_TYPE |  |
| SetSpreadInit | 0 | 369 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID |  |
| SetSpreadInit | 0 | 370 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN |  |
| Find_Data | ShippingPlan | 774 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 972 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 973 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 974 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 975 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 479 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 480 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 481 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 482 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 191 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FROM_PLANT_ID |  |
| SetSpreadInit | 0 | 192 | 표시/라벨 변경 | set:Visible | Visible = {?false} | TO_PLANT_NAME |  |
| SetSpreadInit | 0 | 193 | 표시/라벨 변경 | set:Visible | Visible = {?false} | LT_TOTAL |  |
| SetSpreadInit | 0 | 194 | 표시/라벨 변경 | set:Visible | Visible = {?false} | NAME |  |
| InitializeComponent |  | 309 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 310 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 311 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 312 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| ItemPopup | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| ShippingPlan | META+코드연결 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |
| TEST_TargetMultiPopup | 메타 정의만, 코드 미참조(미사용 가능) | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| TransportModePopup | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
