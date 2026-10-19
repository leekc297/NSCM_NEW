# SSP0005 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 955 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 545 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 403 | SSP.SSP0005_GET_SHIPMENT_WORKING_DAY | MATCH | SP SSP0005_GET_SHIPMENT_WORKING_DAY |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 925 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 403 | SSP.SSP0005_GET_SHIPMENT_WORKING_DAY | MATCH | SP SSP0005_GET_SHIPMENT_WORKING_DAY |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 925 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls | 168 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 925 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 941 | SCP.SCM0001_GET_SCP_PERIOD | MATCH | SP SCM0001_GET_SCP_PERIOD |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 45 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCompany> | 46 | biz:CommonData.CommonDataList [code=Company] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtDayWeek> | 47 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 48 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 910 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Company] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_COMPANY_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_COMPANY_SN |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCM0001_GET_SCP_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_PERIOD | EXEC:SCM0001_GET_SCP_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0005_GET_SHIPMENT_WORKING_DAY | MATCH | 1 | SP SSP0005_GET_SHIPMENT_WORKING_DAY | EXEC:SSP0005_GET_SHIPMENT_WORKING_DAY, INSERT:#TBLDYNAMICPIVOT_SSP0005, SELECT:SSP_MST_SHIP_CALENDAR, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SSP0005_GET_SHIPMENT_WORKING_DAY |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| GetDayOfWeek | row | COLUMN_NAME |
| GetDayOfWeek | dr | DAY_CODE |
| SaveData_Main | dr | A |
| SaveData_Main | row | A |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:168 | UsrComboBox.DataBind | CODE, NAME |
| GetSpdTitle | InitSpread:190 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:196 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:198 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | FindData_Main:387, FindData_Main:388, CboDayWeek_SelectedIndexChanged:660, BtnInput_Click:682 | CString.GetCheckedListValue | CODE |
| GetChanges | SaveData_Main:538 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:123 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:311 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:312 |
| cboDayWeek | SelectedIndexChanged | CboDayWeek_SelectedIndexChanged | InitEvent:314 |
| btnInput | Click | BtnInput_Click | InitEvent:316 |
| dsdm | Changed | SpdMain_Changed | BtnInput_Click:725 |
| dsdm | Changed | SpdMain_Changed | BtnInput_Click:821 |
| dsdm | Changed | SpdMain_Changed | SpdMain_Changed:878 |
| dsdm | Changed | SpdMain_Changed | SpdMain_Changed:902 |

## 6. 컨트롤 (20개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | layoutControlItem1, layoutControlItem10, layoutControlItem6, lcDivision, lcInputValue, layoutControlItem4 |
| UsrButton | 2 | usrButton1, btnInput |
| UsrCombo | 2 | cboDayWeek, cboCompany |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCheckedList | 1 | clbDivision |
| UsrComboBox | 1 | cboInputValue |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 3 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 2 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 19 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 569 | SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY | commented:MATCH |
| 940 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0005 | Shipment Working Day | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Working Day
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:196
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 263 | DB루프 | AddComboColumn | {?dr[DefColumns.COLUMN_LABEL_NAME]} | {?dr[DefColumns.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) |
| InitSpreadDateColumn |  | 267 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?sDayCode == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(sColumnName.IndexOf("B_") > 0) ⟫ if(sDayCode == "SAT"\|\| sDayCode == "SUN") |
| SpdMain_CellDoubleClick |  | 840 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SpdMain_CellDoubleClick |  | 843 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| SpdMain_CellDoubleClick |  | 854 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| InitializeComponent |  | 467 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 468 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 469 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 470 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Working Day | META+코드연결 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
