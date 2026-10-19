# SCP0003 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0003_ProductionCapacity\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0003_ProductionCapacity\SCP0003_ProductionCapacity.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0003_ProductionCapacity\SCP0003_ProductionCapacity.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0003_ProductionCapacity\SCP0003_ProductionCapacity.csproj | 1094 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0003_ProductionCapacity\SCP0003_ProductionCapacity.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0003_ProductionCapacity\SCP0003_ProductionCapacity.csproj | 713 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnMeasure.Click | BtnMeasure_Click > SetSpreadInit > GetSpdTitle | 1055 | SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0003_GET_SHEET_CALENDAR_3SPAN |
| event:cboPeriod.SelectedIndexChanged | CboPeriod_SelectedIndexChanged > SetChangedPeriod | 841 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| event:cboPeriod.SelectedIndexChanged | CboPeriod_SelectedIndexChanged | 900 | biz:CommonData.CommonDataList [code=PERIOD_{?arg:value}] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 881 | biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 824 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 827 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 832 | biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 836 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged | 894 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:clbPlantSite.SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | 868 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_ProductionCapacity | 463 | SCP.SCP0003_GET_PRODUCTION_CAPACITY | MATCH | SP SCP0003_GET_PRODUCTION_CAPACITY |
| button:FindButton | FindButton > FindData_OutsoucingCapacity | 519 | SCP.SCP0003_GET_PRODUCTION_CAPACITY_OSP | MATCH | SP SCP0003_GET_PRODUCTION_CAPACITY_OSP |
| button:FindButton | FindButton > FindData_OutsoucingCapacity > SetSpreadInit > GetSpdTitle | 1055 | SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0003_GET_SHEET_CALENDAR_3SPAN |
| button:InsertButton | InsertButton > InsertRow > SetSpreadInit > GetSpdTitle | 1055 | SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0003_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData > FindData_OutsoucingCapacity | 519 | SCP.SCP0003_GET_PRODUCTION_CAPACITY_OSP | MATCH | SP SCP0003_GET_PRODUCTION_CAPACITY_OSP |
| button:SaveButton | SaveButton > SaveData | 659 | SCP.SCP0003_SAVE_PRODUCTION_CAPACITY_OSP | MATCH | SP SCP0003_SAVE_PRODUCTION_CAPACITY_OSP |
| button:SaveButton | SaveButton > SaveData > FindData_OutsoucingCapacity > SetSpreadInit > GetSpdTitle | 1055 | SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0003_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 164 | biz:CommonData.CommonDataList [code=PeriodType] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 165 | biz:CommonData.CommonDataList [code=PERIOD_{?arg:value}] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 824 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 827 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 832 | biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 836 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedPeriod | 841 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > SetSpreadInit > GetSpdTitle | 1055 | SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0003_GET_SHEET_CALENDAR_3SPAN |
| unreached:(진입점 미연결) | SetCalendar | 346 | biz:CommonData.CommonDataList [code=CalendarWeek] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=CalendarWeek] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M |
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PERIOD_{?arg:value}] | BIZ_MATCH | 2 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PeriodType] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT |
| SCP.SCP0003_GET_PRODUCTION_CAPACITY | MATCH | 1 | SP SCP0003_GET_PRODUCTION_CAPACITY | EXEC:SCP0003_GET_PRODUCTION_CAPACITY | ⚠ DB에 SP 없음 |
| SCP.SCP0003_GET_PRODUCTION_CAPACITY_OSP | MATCH | 1 | SP SCP0003_GET_PRODUCTION_CAPACITY_OSP | EXEC:SCP0003_GET_PRODUCTION_CAPACITY_OSP | ⚠ DB에 SP 없음 |
| SCP.SCP0003_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0003_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0003_GET_SHEET_CALENDAR_3SPAN | ⚠ DB에 SP 없음 |
| SCP.SCP0003_SAVE_PRODUCTION_CAPACITY_OSP | MATCH | 1 | SP SCP0003_SAVE_PRODUCTION_CAPACITY_OSP | EXEC:SCP0003_SAVE_PRODUCTION_CAPACITY_OSP | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SaveData | c | key_idx |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:164 | UsrComboBox.DataBind | CODE, NAME |
| GetSpdTitle | SetSpreadInit:198 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| InitSpreadDateColumn | SetSpreadInit:242 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SaveData | SaveButton:423 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData_ProductionCapacity:443, FindData_ProductionCapacity:444, FindData_ProductionCapacity:445, FindData_ProductionCapacity:446, FindData_ProductionCapacity:447, FindData_OutsoucingCapacity:507, FindData_OutsoucingCapacity:508, FindData_OutsoucingCapacity:509 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:137 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitControls:167 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitControls:168 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitControls:169 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitControls:170 |
| cboPeriod | SelectedIndexChanged | CboPeriod_SelectedIndexChanged | InitControls:171 |
| dsdm | Changed | spdMain_Changed | InitEvent:339 |
| btnMeasure | Click | BtnMeasure_Click | InitEvent:341 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:916 |
| dsdm | Changed | spdMain_Changed | spdMain_Changed:922 |

## 6. 컨트롤 (28개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem8, layoutControlItem9 |
| UsrCheckedList | 5 | clbLine, clbOperation, clbBuilding, clbPlantSite, clbDivision |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 2 | btnMeasure, btnColumn |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrComboBox | 1 | cboPeriod |
| UsrDateRangePicker | 1 | dateRangePeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Production Capacity, Outsourcing Capacity
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 1 | 216 | 하드코딩 | AddTextColumn | KEY_IDX | KEY_IDX |  |
| SetSpreadInit | 1 | 217 | 하드코딩 | AddComboColumn | Division | DIVISION_ID |  |
| SetSpreadInit | 1 | 218 | 하드코딩 | AddComboColumn | Plant Site | SCM_SITE_ID |  |
| SetSpreadInit | 1 | 219 | 하드코딩 | AddComboColumn | Building | FACTORY_ID |  |
| SetSpreadInit | 1 | 220 | 하드코딩 | AddComboColumn | Operation | OPERATION_ID |  |
| SetSpreadInit | 1 | 221 | 하드코딩 | AddComboColumn | Line | LINE_ID |  |
| SetSpreadInit | 1 | 222 | 하드코딩 | AddTextColumn | Project | PROJECT_ID |  |
| SetSpreadInit | 1 | 223 | 하드코딩 | AddTextColumn | Model | ITEM_ID |  |
| SetSpreadInit | 1 | 224 | 하드코딩 | AddTextColumn | Sort | USER_SORT_ORDER_NO |  |
| SetSpreadInit | 1 | 225 | 하드코딩 | AddTextColumn | Measure | MEASURE |  |
| InitSpreadDateColumn |  | 283 | DB루프 | AddTextColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 287 | DB루프 | AddNumColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 291 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SetCalendar |  | 360 | DB루프 | AddNumColumn | {?a.Field<string>(DefColumns.WEEK).Split('\|')[1]} | {?a.Field<string>(DefColumns.WEEK).Split('\|')[1]} | foreach(a in dtCalendar.AsEnumerable()) |
| SetCalendar |  | 362 | 표시/라벨 변경 | SetColumnHeader | 0 | {?a.Field<string>(DefColumns.WEEK).Split('\|')[1]} | foreach(a in dtCalendar.AsEnumerable()) |
| SetCalendar |  | 363 | 표시/라벨 변경 | SetColumnHeader | 1 | {?a.Field<string>(DefColumns.WEEK).Split('\|')[1]} | foreach(a in dtCalendar.AsEnumerable()) |
| InitializeComponent |  | 619 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 620 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 621 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 622 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 코드 하드코딩 전용(메타 없음) | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
