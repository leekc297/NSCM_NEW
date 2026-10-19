# SCP0006 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0006_ProjectRoute\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0006_ProjectRoute\SCP0006_ProjectRoute.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0006_ProjectRoute\SCP0006_ProjectRoute.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0006_ProjectRoute\SCP0006_ProjectRoute.csproj | 2143 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0006_ProjectRoute\SCP0006_ProjectRoute.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0006_ProjectRoute\SCP0006_ProjectRoute.csproj | 886 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:spdMain.CellDoubleClick | spdSite_CellDoubleClick > InitSpread > SetCalendar | 419 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 257 | biz:CommonData.CommonDataList [code=PERIOD_ \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 266 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetCalendar | 419 | biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedPeriod | 1112 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 54 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetDayRange | 1134 | SCP.GET_DATE_RANGE_1MONTH | MATCH | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CalendarMonth] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_SYS_CALENDAR_M |
| biz:CommonData.CommonDataList [code=PERIOD_ \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.GET_DATE_RANGE_1MONTH | MATCH | 1 | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| AfterSaveDataPlant | result.Tables[0].Rows[0] | result_code, result_cnt |
| checkValidN0 | dtChkSite.Rows[0] | packer_item_id_suffix, company_id, division_id, site_id |
| checkValidN6 | row | VALID_YN, ORG_TO_YYYYMMDD |
| ChkPlantOs | dtChkSite.Rows[0] | packer_item_id_suffix, company_id, division_id |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:266 | UsrComboBox.DataBind | CODE, NAME |
| SetSheetHeaderColumn | InitSpread:317, InitSpread:362, InitSpread:411 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | btnAllFind_Click:539, FindDataSite:688, FindDataSite:689, SetChangedControl:1076 | CString.GetCheckedListValue | CODE |
| SaveData | SaveDataPlant:1017 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | spdPlant_CellDoubleClick:1439 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:346 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:382 |
| this | Load | SCP0006_ProjectRoute_Load | InitializeComponent:802 |
| this | Load | Form_Load | .ctor:193 |
| dsdm | Changed | spdPlant_Change | InitEvent:221 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:225 |
| spdMain | CellDoubleClick | spdSite_CellDoubleClick | InitEvent:227 |
| spdBOM | CellDoubleClick | spdBOM_CellDoubleClick | InitEvent:228 |
| this.btnAllFind | Click | btnAllFind_Click | InitEvent:229 |
| spdPlant | CellDoubleClick | spdPlant_CellDoubleClick | InitEvent:231 |

## 6. 컨트롤 (35개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem4, Model, layoutControlItem11, Project, Period, layoutControlItem2, Status, layoutControlItem1, layoutControlItem5 |
| EmptySpaceItem | 4 | emptySpaceItem4, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrButton | 3 | btnItemId, btnProject, btnAllFind |
| FpSpread | 3 | spdBOM, spdPlant, spdMain |
| SheetView | 3 | spdBOM_Sheet1, spdPlant_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 2 | txtItemId, txtProject |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboDivision |
| UsrCheckedList | 1 | clbSalesSite |
| UsrComboBox | 1 | cboStatus |
| UsrMonthRangePicker | 1 | drpPeriod |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 182 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 11 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 47 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 44 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 165 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0006 | BOM Explosion | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 | 6/0 |
| SCM_MST_SHEET_COLUMNS | SCP0006 | Main | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SCP0006 | Plant Assign | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 | 10/2 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, BOM Explosion, Plant Assign
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:317, SetSheetHeaderColumn@InitSpread:362, SetSheetHeaderColumn@InitSpread:411

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetCalendar |  | 429 | DB루프 | AddNumColumn | {?a.Field<string>(DefColumns.YYYYMM_NAME)} | {?a.Field<string>(DefColumns.YYYYMM)} | foreach(a in dtCalendar.AsEnumerable()) |
| InitializeComponent |  | 628 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 629 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 630 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 631 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 668 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 669 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 670 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 671 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 750 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 751 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 752 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 753 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOM Explosion | META+코드연결 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Main | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Plant Assign | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
