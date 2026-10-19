# SCP0103 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\Popup\SCP0103_SemiStockPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.csproj | 197 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\Popup\SCP0103_SemiStockPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.csproj | 254 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.csproj | 2599 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0103_MaterialVisibility\SCP0103_MaterialVisibility.csproj | 1372 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboBucketType.SelectedIndexChanged | cboBucketType_SelectedIndexChanged > InitSpread_2 > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.chkALL.CheckedChanged | chkAll_CheckedChanged > InitSpread_2 > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.chkALL.CheckedChanged | chkAll_CheckedChanged > InitSpread_2 > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitDatasAsync > InitSearchConditionDatas | 637 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitDatasAsync > InitSearchConditionDatas > GetBucketType | 1261 | biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO |
| event:this.Load | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 2435 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | GetDivision | 2371 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | SetChangedPeriod | 2386 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 2390 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BucketType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO, INSERT:#T_M, SELECT:SCM_SYS_CALENDAR_M, INSERT:#T_W, SELECT:#T_M, INSERT:#T_D, SELECT:#T_W, CREATE:#T_WHOLE, SELECT:#T_D, INSERT:#T_WHOLE, SELECT:#T_WHOLE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| CalculateSum | dr | measure |
| GetUOM | r1 | CODE, NAME |
| GetUOM | r2 | CODE, NAME |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| spdMain_CellClick | _tblRequirementFiltered.Rows[0] | CELL_CF, YIELD_RATE |
| spdMain_MouseHover | _tblRequirementFiltered.Rows[0] | CELL_CF, YIELD_RATE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | getDivision:61, getPlant:75, getSupplier:112, getItemCategory:126, getItemId:140, getNickname:154, getMaterial:168, getUOM:258 | CString.GetCheckedListValue | CODE |
| Run | RrefreshProgressInitData:609 | ApplicationStart.Run | __Query |
| GetSpdTitle | InitSpread_2:838, InitSpread:856, cboBucketType_SelectedIndexChanged:1125 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn2 | InitSpread_2:840, cboBucketType_SelectedIndexChanged:1129 | SpreadInfo.SetSheetHeaderColumn2 | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread_2:842, InitSpread:864, cboBucketType_SelectedIndexChanged:1130 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SetSheetHeaderColumn | InitSpread:860 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:138 |
| this | Load | Form_Load | .ctor:107 |
| this | Load | Form_Load | .ctor:117 |
| this | Load | Form_Load | .ctor:595 |
| this.btnMeasure | Click | btnMeasure_Click | InitEvent:1005 |
| this.btnColumn | Click | btnColumn_Click | InitEvent:1006 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:1008 |
| this.cboSCPPlanStartYYYYMMDD | SelectedIndexChanged | cboSCPPlanStartYYYYMMDD_SelectedIndexChanged | InitEvent:1009 |
| this.cboMRPPlanStartYYYYMMDD | SelectedIndexChanged | cboMRPPlanStartYYYYMMDD_SelectedIndexChanged | InitEvent:1010 |
| this.cboOperationGroup | SelectedIndexChanged | cboOperationGroup_SelectedIndexChanged | InitEvent:1011 |
| this.clbNickname | SelectedIndexChanged | clbNickname_SelectedIndexChanged | InitEvent:1012 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:1013 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitEvent:1015 |
| this.chkALL | CheckedChanged | chkAll_CheckedChanged | InitEvent:1016 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:1019 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:1020 |
| this.spdMain | CellClick | spdMain_CellClick | InitEvent:1025 |

## 6. 컨트롤 (60개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 18 | layoutControlItem1, Division, layoutControlItem14, layoutControlItem4, layoutControlItem10, lciUOM, layoutControlItem12, lciMRPPlanStartYYYYMMDD, layoutControlItem7, lciSCPPlanStartYYYYMMDD, lciSupplier, lciItemCategory, lciMaterial, lblBucket1, lciOperaionGroup … |
| EmptySpaceItem | 10 | emptySpaceItem5, emptySpaceItem8, emptySpaceItem13, emptySpaceItem17, emptySpaceItem3, emptySpaceItem4, emptySpaceItem7, emptySpaceItem9, emptySpaceItem1, emptySpaceItem6 |
| UsrCheckedList | 7 | clbUOM, clbPlant, clbSupplier, clbItemCategory, clbMaterial, clbNickname, clbItemId |
| UsrCombo | 5 | cboDivision, cboBucketType, cboMRPPlanStartYYYYMMDD, cboSCPPlanStartYYYYMMDD, cboOperationGroup |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl2 |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup2 |
| UsrButton | 3 | usrButton1, btnMeasure, btnColumn |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrCheckBox | 2 | chkSum, chkALL |
| UsrButtonList | 1 | btnButtonList |
| UsrDateRangePicker3 | 1 | dCalendar |
| ToolTip | 1 | tooltip |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 25 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 4 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 16 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0103 | ALL | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 | 15/1 |
| SCM_MST_SHEET_MEASURE | SCP0103 | ALL | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Project, ALL
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn2@InitSpread_2:840, SetSheetHeaderColumn@InitSpread:860, SetSheetHeaderColumn2@cboBucketType_SelectedIndexChanged:1129
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn, SetSpreadColumn, InitSpreadDateColumnISO, InitSpreadDateColumnNotISO

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | Plant | PLANT_ID |  |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | Material | MATERIAL |  |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | UOM | MATERIAL_UOM |  |
| InitSpread |  | 176 | 하드코딩 | AddTextColumn | Item ID | ITEM_ID |  |
| InitSpread |  | 177 | 하드코딩 | AddNumColumn | Qty | QTY |  |
| InitSpread |  | 178 | 하드코딩 | AddTextColumn | UOM | UOM |  |
| InitSpread |  | 179 | 하드코딩 | AddNumColumnEx | CF | CELL_CF |  |
| InitSpread |  | 180 | 하드코딩 | AddNumColumn | Stock | STOCK |  |
| InitializeComponent |  | 185 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 186 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 187 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 188 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpreadDateColumnISO |  | 909 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | for(i <= dsSpdTitle.Tables[0].Rows.Count - 1) |
| InitSpreadDateColumnNotISO |  | 958 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(COLUMN_NAME.IndexOf("B_") > 0) |
| InitSpreadDateColumnNotISO |  | 962 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?DAY_CODE == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(COLUMN_NAME.IndexOf("B_") > 0) ⟫ if(DAY_CODE == "SAT"\|\| DAY_CODE == "SUN") |
| SetSpreadColumn |  | 1213 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isDaily \|\| isWeekly) |
| SetSpreadColumn |  | 1218 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "DAILY" ⟫ if(isMonthly \|\| isWeekly) |
| SetSpreadColumn |  | 1227 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isDaily) |
| SetSpreadColumn |  | 1231 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ else!(isDaily) ⟫ if(isWeekly) |
| SetSpreadColumn |  | 1236 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY" ⟫ if(isMonthly) |
| SetSpreadColumn |  | 1243 | 표시/라벨 변경 | set:Visible | Visible = {?isWeeklyISO} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "WEEKLY_ISO" |
| SetSpreadColumn |  | 1249 | 표시/라벨 변경 | set:Visible | Visible = {?isMonthly} |  | for(col <= siObj.GetMaxColumnIndex()) ⟫ switch(cboBucketType.ControlValues)case "MONTHLY" |
| SetColumnModelVisible |  | 2203 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | switch(this._operation_group)case "A" |
| SetColumnModelVisible |  | 2206 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | switch(this._operation_group)case "P" |
| InitializeComponent |  | 1239 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1240 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1241 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1242 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ALL | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Project | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
