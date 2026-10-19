# FP00626 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Planning.UIL\FP00626_PancakeSimulation_Assy.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2202 |
| only | 06.UIL\GSCM.FP.Planning.UIL\FP00626_PancakeSimulation_Assy.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 1342 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed | 1523 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > GetFpPlanInfo | 1879 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:cbo_plan_group.SelectedIndexChanged | cbo_plan_group_changed > SetCurrPlanDate_Default | 2033 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend | 565 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 621 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 624 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 627 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplyAmendCalendarCondition | 634 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Amend > ApplySearchCondition | 695 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > RefreshSpreadSheet > RefreshHeader > CheckAndGetMeasure > GetMeasure_Local | 1064 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 565 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 621 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 624 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 627 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 630 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplyAmendCalendarCondition | 634 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend > ApplySearchCondition | 695 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnPlanInfo.Click | btnPlanInfo_Click | 1772 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.chk_release.CheckedChanged | chk_release_CheckedChanged > GetFpPlanInfo | 1879 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > RefreshHeaderOnly > RefreshHeader > CheckAndGetMeasure > GetMeasure_Local | 1064 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPlanGroup | 1856 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetCurrPlanDate_Default | 2033 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetCellType | 2066 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetPancakeType | 2075 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetUnit | 2137 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.sCalendar_planday.EditValueChanged | sCalendar_planday_EditValueChanged > GetFpPlanInfo | 1879 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 16 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | PLAN_DATE, BUCKET_FROM, BUCKET_TO, DAY_INFO, WEEK_INFO, MONTH_INFO, BUCKET, CATE_INFO |
| ApplySearchCondition | Filter | BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, MODEL_NICK_NAME, ITEM_ID, NICK_NAME, RELEASE_FLAG, TOTAL_INCLUDE, INSTANCE_ID |
| ApplySearchCondition | dt.Rows[0] | CURR_DATE |
| btnPlanInfo_Click | Filter | INSTANCE_ID, PLAN_ID, PLAN_DATE, RELEASE_FLAG, CHK_PLANID |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| cbo_plan_group_changed | dtIsPast.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| cbo_plan_group_changed | Filter | PLAN_ID, PLAN_TYPE, DESCRIPTION, READ_ONLY, PLAN_NAME, PLAN_DATE, BUCKET_FROM |
| cbo_planid_changed | dtPlanId.Rows[idx] | PLAN_ID, PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| chk_release_CheckedChanged | dtIsPast.Rows[0] | CURR_DATE |
| chk_release_CheckedChanged | Filter | PLAN_ID, PLAN_TYPE, DESCRIPTION, READ_ONLY, PLAN_NAME, CURR_DATE, PLAN_DATE, BUCKET_FROM, RELEASE_FLAG |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_assy, chk_post, chk_coater, chk_shipment, chk_shipmentIn, chk_inv |
| CreateFilterDataSet | x | _MM_ |
| Find_Data | Filter | PLAN_NAME |
| Find_Data_Amend | Filter | INSTANCE_ID, PLAN_ID, CHK_PLANID |
| GetFpPlanInfo | dtPlanId.Rows[idx] | PLAN_ID, PLAN_TYPE, DESCRIPTION, READ_ONLY, NAME |
| GetMeasure_Local | row | MENU_ID, MEA_ID, MEA_NAME, MEA_VALUE, TYPE, FLAG, USER_ID |
| InitControls | Filter | USER_ID |
| RefreshHeader | row | DATA_TYPE, CATEGORY_ID, CATEGORY_NAME |
| SetCalcInventory | dsMain.Tables[0].Rows[nStartRow] | DATA_TYPE, LT, PREV_BOH_QTY, POST_BOH_QTY |
| SetCalcInventory | each_row | D_VALUE |
| SetColumnChangeByMemo | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetCurrPlanDate_Default | dtIsPast.Rows[0] | CURR_DATE, PLAN_START_DATE, PLAN_END_DATE |
| SetFpPlanFilterInit | dtPlanId.Rows[idx] | PLAN_ID, PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME |
| SetPlanGroup | dtInstance.Rows[0] | CONFIRM_AREA |
| SetPlanInfo | dtPlanId.Rows[iRow] | INSERT_ID, INSERT_TIME, DESCS, BASIC_VERSION, FACTORY_LT |
| SetPlanPeriod | dtPlanId.Rows[idx] | PLAN_ID, PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME |
| SetPlanPeriod | Filter | SITE_ID |
| SetUpdateTotalValue | each_row | IS_PLAN |
| SetUpdateTotalValue | dtResult1.Rows[0] | D_VALUE |
| SetUpdateTotalValue | dtResult1.Rows[dtResult1.Rows.Count - 1] | D_VALUE |
| SetUpdateTotalValue | dtResult2.Rows[0] | D_VALUE |
| SetUpdateTotalValue | dtResult2.Rows[dtResult2.Rows.Count - 1] | D_VALUE |
| SetUpdateTotalValue | dsMain.Tables[0].Rows[nRow] | ITEM_ID |
| SetUpdateTotalValue | Filter | PLAN_DATE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetFilter | InitControls:241, InitControls:242, InitControls:252, Find_Data_Amend:558, ApplySearchCondition:662, ApplySearchCondition:663, ApplySearchCondition:681, ApplySearchCondition:682 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | InitControls:252, Find_Data_Amend:558, ApplySearchCondition:662, ApplySearchCondition:681, ApplySearchCondition:682, ApplySearchCondition:683, cbo_plan_group_changed:1518, cbo_planid_changed:1607 | CString.GetCheckedListValue | CODE |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1013 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:186 |
| cbo_plan_group | SelectedIndexChanged | cbo_plan_group_changed | InitEvent:212 |
| cbo_planid | SelectedIndexChanged | cbo_planid_changed | InitEvent:213 |
| cbo_celltype | SelectedIndexChanged | cbo_celltype_changed | InitEvent:215 |
| cbo_pancaketype | SelectedIndexChanged | cbo_pancaketype_changed | InitEvent:216 |
| cbo_unit | SelectedIndexChanged | cbo_unit_changed | InitEvent:217 |
| txtModel | TextChanged | TxtModel_TextChanged | InitEvent:219 |
| txtModelNickName | TextChanged | TxtModelNickName_TextChanged | InitEvent:220 |
| txtNickName | TextChanged | TxtNickName_TextChanged | InitEvent:221 |
| txtItem | TextChanged | TxtItem_TextChanged | InitEvent:222 |
| dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitEvent:224 |
| chktotalinclude | CheckedChanged | chktotalinclude_CheckedChanged | InitEvent:225 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1804 |
| this.chk_release | CheckedChanged | chk_release_CheckedChanged | InitializeComponent:253 |
| this.btnPlanInfo | Click | btnPlanInfo_Click | InitializeComponent:294 |
| this.sCalendar_planday | EditValueChanged | sCalendar_planday_EditValueChanged | InitializeComponent:380 |
| this.txtModelNickName | TextChanged | TxtModelNickName_TextChanged | InitializeComponent:450 |
| this.txtNickName | TextChanged | TxtNickName_TextChanged | InitializeComponent:485 |
| this.chktotalinclude | CheckedChanged | chktotalinclude_CheckedChanged | InitializeComponent:525 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:565 |
| this.dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitializeComponent:609 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1026 |
| this.button1 | Click | button1_Click | InitializeComponent:1165 |

## 6. 컨트롤 (49개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | layoutControlItem5, layoutControlItem8, layoutControlItem9, layoutControlItem2, layoutControlItem3, layoutControlItem14, layoutControlItem4, layoutControlItem12, layoutControlItem6, layoutControlItem13, layoutControlItem7, lblSql, layoutControlItem10, layoutControlItem1, layoutControlItem17 … |
| UsrCombo | 5 | cbo_celltype, cbo_unit, cbo_planid, cbo_pancaketype, cbo_plan_group |
| UsrTextBox | 4 | txtModelNickName, txtNickName, txtItem, txtModel |
| UsrButton | 3 | btnPlanInfo, btnSql, usrButton2 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| Label | 2 | lblPlanID, label3 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| Panel | 2 | infoPanel, panel1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| CheckBox | 1 | chk_release |
| DateEdit | 1 | sCalendar_planday |
| UsrCheckBox | 1 | chktotalinclude |
| UsrDateRangePicker | 1 | dCalendar_planrange |
| SplitContainer | 1 | splitter |
| Button | 1 | button1 |
| ImageList | 1 | imageList1 |
| TextBox | 1 | tbLog |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 30 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 5 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00626 | Amend | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 |
| SCM_MST_SHEET_COLUMNS | FP00626 | PlanInfo | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend, PlanInfo
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:337, SetSheetHeaderColumn_FP@RefreshHeaderOnly:386

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetColumnHidden |  | 365 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DIVISION_ID |  |
| SetColumnHidden |  | 366 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SITE_ID |  |
| SetColumnHidden |  | 367 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CATEGORY_ID |  |
| SetColumnHidden |  | 368 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ITEM_UOM |  |
| SetColumnHidden |  | 369 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DATA_TYPE |  |
| SetColumnHidden |  | 371 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PREV_BOH_QTY |  |
| SetColumnHidden |  | 372 | 표시/라벨 변경 | set:Visible | Visible = {?false} | POST_BOH_QTY |  |
| SetColumnHidden |  | 373 | 표시/라벨 변경 | set:Visible | Visible = {?false} | BOH_QTY |  |
| SetColumnHidden |  | 374 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_BOH_QTY |  |
| SetColumnHidden |  | 375 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_BOH_QTY |  |
| SetColumnHidden |  | 376 | 표시/라벨 변경 | set:Visible | Visible = {?false} | HOLD_QTY |  |
| SetColumnHidden |  | 377 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PC_HOLD_QTY |  |
| SetColumnHidden |  | 378 | 표시/라벨 변경 | set:Visible | Visible = {?false} | JR_HOLD_QTY |  |
| RefreshHeader |  | 886 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 892 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| spdMain_CellDoubleClick |  | 1827 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | for(idx < iWeekCount) |
| InitializeComponent |  | 1042 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1043 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1044 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1045 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| PlanInfo | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
