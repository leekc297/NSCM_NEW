# FP02843 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.UIL.csproj | 3397 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.UIL.csproj | 1197 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.UIL.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP02843_UI_WH_CAPA\FP02843_UI_WH_CAPA.UIL.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > SetPlant | 2994 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetSite | 2980 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetFactory | 3009 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SetSecondHost | 343 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 320 | biz:FPCommonDataBLL.FPCommonDataList [code=ATTR_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetSecondHost | 343 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetDivision | 2960 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetSite | 2980 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetPlant | 2994 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangeControl > SetFactory | 3009 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 130 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=ATTR_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 1 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btn_setupinfo_Click | Filter | INSTANCE_ID |
| btn_setupinfo_Click | Application.OpenForms | FPC0108_btn_setupinfoPopup |
| btnColumn_Click | Application.OpenForms | FPC0097_ColumnSetForm_Popup |
| btnMemo_Click | Filter | INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnPlanInfo_Click | Filter | INSTANCE_ID, CONFIRM_AREA |
| btnPlanInfo_Click | Application.OpenForms | FPC0106_PlanInfoPopup |
| btnPlanInfo_Click | planInfoPopup.Filter | MASTER_ID, INSTANCE_ID, CONFIRM_AREA, USER_ID |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month, chk_totalBatch |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_total, chk_mpp_inqty_tot, chk_batch, chk_jr, chk_pc, chk_cell, chk_mpp_outqty_tot, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_inqty_tot, chk_outqty_tot, chk_result_in_tot, chk_result_out_tot, chk_gap_in_tot, chk_gap_out_tot, chk_seq, chk_offtime, chk_memo, chk_mpp_inqty, chk_mpp_outqty, chk_wpp_inqty, chk_wpp_outqty, chk_inqty, chk_outqty, chk_result_in, chk_result_out, chk_gap_in, chk_gap_out, chk_subTotal |
| CreateFilterDataSet | x | _MM_ |
| DrawHeader | Filter | BUCKET_FROM |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month, chk_totalBatch |
| InitControls | Filter | USER_ID, LOOKUP |
| RefreshHeader | row | DATA_TYPE |
| SaveData | dsMain.Tables[0].Rows[cnt] | WH_TEMP_CAPA, FACTORY_ID, ROLL_TYPE, ELECTRODE_TYPE, ATTR_TYPE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, WH_ID, WH_NAME, MAX_LOAD_QTY |
| SaveData | dsMain.Tables[0].Rows[j] | WH_TEMP_CAPA |
| SaveData | dtAttrType.Rows[a] | CODE, NAME |
| SaveData | dsMain.Tables[0].Rows[i] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, WH_ID, WH_NAME, ELECTRODE_TYPE, ROLL_TYPE, ATTR_TYPE, MAX_LOAD_QTY, WH_TEMP_CAPA |
| SetColumnChangeByMemo | dsResult.Tables[0].Rows[k] | DATA_TYPE, CATEGORY_ID |
| SetDivision | Filter | INSTANCE_ID |
| SetElectrode | dtElecType.Columns | ELECTRODE_TYPE |
| SetElectrode | dtElecType.Rows[i] | CODE, NAME |
| SetFactory | Filter | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| SetFactory | c | CODE |
| SetInitMemo | row | DATA_TYPE, OPERATION_ID, CATEGORY_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE |
| SetInitMemo | each_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE |
| SetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID |
| SetRollType | dtRollType.Columns | ROLL_TYPE |
| SetRollType | dtRollType.Rows[i] | CODE, NAME |
| SetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID |
| SetTotalColor | row | DATA_TYPE |
| UIFindData | dsMain.Tables[0].Rows[i] | FACTORY_ID, ROLL_TYPE, ELECTRODE_TYPE, ATTR_TYPE |
| UIFindData | dsMain.Tables[0].Columns | MAX_LOAD_QTY |
| UIFindData | siMain.ActiveSheet.Columns | ROLL_TYPE, ELECTRODE_TYPE, WH_TEMP_CAPA |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetFilter | InitControls:293, InitControls:294, InitControls:295, InitControls:296, InitControls:300, InitControls:301, UIFindData:506, SetDivision:2963 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetCheckedListValue | UIFindData:506, SetDivision:2963, mcbo_division_changed:2971, SetSite:2984, cbo_site_changed:2988, SetPlant:2998, mcbo_plant_changed:3004, SetFactory:3024 | CString.GetCheckedListValue | CODE |
| EditQuery | UIFindData:695, DrawSheet:1414 | FPExtensions.EditQuery | ROW_ID |
| SaveData | SaveButton:911 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetMeasure | RefreshSpreadSheet:1265, CheckAndGetMeasure:2562 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| LoadAmendColumn | DrawHeader:1381 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| SetInitMemo | DrawSheet:1413, RefreshHeader:1601, RefreshHeader:1617 | MemoService.SetInitMemo | CATEGORY_ID |
| SetTotalColor | DrawSheet:1423 | SpreadInfo.SetTotalColor | column_cnt, grouping_cnt, row_idx |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:2532 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |
| SetRowsUnVisible | CreateFilterDataSet:2535 | MeasureService.SetRowsUnVisible | _MM_ |
| FP_Log2 | mcbo_division_changed:2969, mcbo_division_changed:2974 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:176 |
| this | FormClosing | FP02843_UI_WH_CAPA_FormClosing | .ctor:177 |
| mcbo_Electrode | SelectedIndexChanged | mcbo_Electrode_changed | InitEvent:238 |
| mcbo_prod_type | SelectedIndexChanged | mcbo_prod_type_changed | InitEvent:239 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:242 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:243 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:244 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:245 |
| cbo_site | Click | Cbo_site_Click | InitEvent:247 |
| popSql | OnSql | RunSqlSource | btnSql_Click:3263 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:236 |
| this.dCalendar_planrange | ValueChanged | dCalendarPlanrange_changed | InitializeComponent:289 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:729 |
| this.btnBucket | Click | btnBucket_Click | InitializeComponent:903 |
| this.btnCatagory | Click | btnCatagory_Click | InitializeComponent:942 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:980 |
| this.btnSetupColor2 | Click | btn_setupinfo_Click | InitializeComponent:1035 |
| this.btnPlanInfo2 | Click | btnPlanInfo_Click | InitializeComponent:1074 |
| this.btnMemo2 | Click | btnMemo_Click | InitializeComponent:1113 |

## 6. 컨트롤 (36개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| UsrButton | 8 | btnSql, usrButton2, btnBucket, btnCatagory, btnColumn, btnSetupColor2, btnPlanInfo2, btnMemo2 |
| LayoutControlItem | 8 | lblSql, layoutControlItem5, layoutControlItem16, layoutControlItem6, layoutControlItem7, layoutControlItem8, Operation, layoutControlItem17 |
| UsrCheckedList2 | 5 | mcbo_Electrode, mcbo_factory, mcbo_plant, mcbo_division, mcbo_prod_type |
| Panel | 3 | panel2, panel4, panel1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cbo_site |
| UsrDateRangePickerWtWeek | 1 | dCalendar_planrange |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| SplitContainer | 1 | splitter |
| ImageList | 1 | imageList1 |
| TextBox | 1 | tbLog |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 12 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 3 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 18 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02843 | Amend | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:441, SetSheetHeaderColumn_FP@DrawHeader:1315

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalenderColor |  | 1494 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 1500 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null && dsMainFiltered.Good()) ⟫ if(measure.Day.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 1705 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(!columnChange) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 1711 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(!columnChange) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| SetElectrode |  | 3038 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE | ELECTRODE_TYPE |  |
| SetRollType |  | 3064 | 표시/라벨 변경 | set:ColumnName | ColumnName = CODE | ROLL_TYPE |  |
| spdMain_CellDoubleClick |  | 3286 | 표시/라벨 변경 | set:Visible | Visible = {?!spdMain.ActiveSheet.Columns[idx].Visible} |  | for(idx < iWeekCount) |
| InitializeComponent |  | 745 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 746 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 747 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 748 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
