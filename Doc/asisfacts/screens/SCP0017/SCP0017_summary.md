# SCP0017 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0017_WaterfallProductionPlan\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0017_WaterfallProductionPlan\SCP0017_WaterfallProductionPlan.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0017_WaterfallProductionPlan\SCP0017_WaterfallProductionPlan.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0017_WaterfallProductionPlan\SCP0017_WaterfallProductionPlan.csproj | 2560 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0017_WaterfallProductionPlan\SCP0017_WaterfallProductionPlan.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0017_WaterfallProductionPlan\SCP0017_WaterfallProductionPlan.csproj | 1346 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboOperationGroup.SelectedIndexChanged | cboOperationGroup_SelectedIndexChanged > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboOperationGroup.SelectedIndexChanged | cboOperationGroup_SelectedIndexChanged > InitSpread > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.chkALL.CheckedChanged | chkAll_CheckedChanged > InitSpread_2 > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.chkALL.CheckedChanged | chkAll_CheckedChanged > InitSpread_2 > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 2518 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 301 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindData_Line | 1498 | SCP.SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL | MATCH | SP SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL |
| unreached:(진입점 미연결) | GetDivision | 2441 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 2456 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 2460 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO, INSERT:#T_M, SELECT:SCM_SYS_CALENDAR_M, INSERT:#T_W, SELECT:#T_M, INSERT:#T_D, SELECT:#T_W, CREATE:#T_WHOLE, SELECT:#T_D, INSERT:#T_WHOLE, SELECT:#T_WHOLE |  |
| SCP.SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL | MATCH | 1 | SP SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL | EXEC:SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL, SELECT:SCM_MST_TITLESET_USER, INSERT:#TBLDYNAMICPIVOT_SCP0017_02, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCP_ANL_PRODUCTION_PLAN_C, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| InitUOM | r1 | CODE, NAME |
| InitUOM | r2 | CODE, NAME |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | getDivision:68, getOperationGroup:82, getPlantSite:96, getVersion:166, getLine:180, getLine:185, getUOM:260, SetChangedPeriod:2451 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread_2:561, InitSpread:580, cboBucketType_SelectedIndexChanged:1033 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn2 | InitSpread_2:563, cboBucketType_SelectedIndexChanged:1036 | SpreadInfo.SetSheetHeaderColumn2 | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:565, InitSpread:622, cboBucketType_SelectedIndexChanged:1037 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SetSheetHeaderColumn | InitSpread:620 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:411 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:870 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:871 |
| this.btnColumn | Click | btnColumn_Click | InitEvent:872 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:874 |
| this.cboOperationGroup | SelectedIndexChanged | cboOperationGroup_SelectedIndexChanged | InitEvent:875 |
| this.clbPlantSite | SelectedIndexChanged | clbPlantSite_SelectedIndexChanged | InitEvent:876 |
| this.clbVersion | SelectedIndexChanged | cboVersion_SelectedIndexChanged | InitEvent:877 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:878 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:879 |
| this.clbUOM | SelectedIndexChanged | clbUOM_SelectedIndexChanged | InitEvent:880 |
| this.chkALL | CheckedChanged | chkAll_CheckedChanged | InitEvent:881 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:884 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:886 |

## 6. 컨트롤 (50개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | Division, layoutControlItem1, layoutControlItem7, layoutControlItem3, layoutControlItem13, layoutControlItem5, lblBucket1, layoutControlItem11, layoutControlItem9, lblIModel, lblItemId, layoutControlItem2, layoutControlItem14, layoutControlItem4, layoutControlItem10 … |
| EmptySpaceItem | 8 | emptySpaceItem5, emptySpaceItem6, emptySpaceItem7, emptySpaceItem8, emptySpaceItem10, emptySpaceItem2, emptySpaceItem11, emptySpaceItem3 |
| UsrButton | 4 | usrButton1, btnMeasure, btnColumn, btnItemId |
| UsrCheckedList | 4 | clbUOM, clbVersion, clbPlantSite, cboElectrode |
| UsrCombo | 3 | cboOperationGroup, cboDivision, cboBucketType |
| UsrCheckBox | 3 | chkGap, chkALL, chkSum |
| UsrMultiLineEditor | 2 | txtItemId, txtModelId |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker3 | 1 | dCalendar |
| TextBox | 1 | txtNickName |
| UsrCheckedList2 | 1 | clbLine |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 245 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 43 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 12 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 18 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 12 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 274 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1225 | DM.DM0003_GET_BUCKET_TYPE_CODE | commented:MATCH |
| 2495 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | commented:MATCH |
| 2537 | SCP.SCM0001_GET_SCP_PERIOD | commented:MATCH |
| 2532 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0017 | LINE | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SCP0017 | MODEL | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 | 12/4 |
| SCM_MST_SHEET_MEASURE | SCP0017 | LINE | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_MEASURE | SCP0017 | MODEL | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: MODEL
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn2@InitSpread_2:563, SetSheetHeaderColumn@InitSpread:620, SetSheetHeaderColumn2@cboBucketType_SelectedIndexChanged:1036
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, InitSpreadDateColumnISO, InitSpreadDateColumnNotISO

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 632 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "MODEL") ⟫ if(!this._division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 633 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ELECTRODE_TYPE | if(spdInfo.SheetName == "MODEL") ⟫ if(!this._division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 637 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ORIGIN_DIVISION_ID | if(spdInfo.SheetName == "MODEL") ⟫ else!(!this._division.Substring(0, 2).Equals("EE")) |
| InitSpread |  | 638 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ELECTRODE_TYPE | if(spdInfo.SheetName == "MODEL") ⟫ else!(!this._division.Substring(0, 2).Equals("EE")) |
| InitSpreadDateColumnISO |  | 747 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | for(i <= dsSpdTitle.Tables[0].Rows.Count - 1) |
| InitSpreadDateColumnNotISO |  | 823 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumnNotISO |  | 827 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetSpreadColumn |  | 1175 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isDaily \|\| isWeekly) |
| SetSpreadColumn |  | 1180 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isMonthly \|\| isWeekly) |
| SetSpreadColumn |  | 1189 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isDaily) |
| SetSpreadColumn |  | 1193 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ else!(isDaily) ⟫ if(isWeekly) |
| SetSpreadColumn |  | 1198 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isMonthly) |
| SetSpreadColumn |  | 1205 | 표시/라벨 변경 | set:Visible | Visible = {?isWeeklyISO} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY_ISO" |
| SetSpreadColumn |  | 1211 | 표시/라벨 변경 | set:Visible | Visible = {?isMonthly} |  | for(iCol <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "MONTHLY" |
| SetColumnModelVisible |  | 2314 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | switch(this._operation_group)case "A" |
| SetColumnModelVisible |  | 2317 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | switch(this._operation_group)case "P" |
| InitializeComponent |  | 1218 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1219 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1220 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1221 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| LINE | 메타 정의만, 코드 미참조(미사용 가능) | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| MODEL | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
