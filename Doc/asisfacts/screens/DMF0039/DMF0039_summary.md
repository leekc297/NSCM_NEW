# DMF0039 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.csproj | 707 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.csproj | 742 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.csproj | 64 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Master\DMF0039_ESS_Shipment_Priority\DMF0039_ESS_Shipment_Priority.csproj | 27 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0039_ESS_Shipment_Priority.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 648 |
| legacy | 06.UIL\GSCM.DM.Master.UIL\DMF0039_ESS_Shipment_Priority.Designer.cs | 06.UIL\GSCM.DM.Master.UIL\GCSM.DM.Master.UIL.csproj | 742 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 332 | DM.DMF0039_GET_ESS_SHIPMENT_PRIORITY | MATCH | SP DMF0039_GET_ESS_SHIPMENT_PRIORITY |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 616 | DM.DMF0039_GET_SPREAD_TITLE | MATCH | SP DMF0039_GET_SPREAD_TITLE |
| button:SaveButton | SaveButton > SaveData > FindData | 332 | DM.DMF0039_GET_ESS_SHIPMENT_PRIORITY | MATCH | SP DMF0039_GET_ESS_SHIPMENT_PRIORITY |
| button:SaveButton | SaveButton > SaveData | 437 | DM.DMF0039_SAVE_MST_SHIPMENT_PRIORITY | MATCH | SP DMF0039_SAVE_MST_SHIPMENT_PRIORITY |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 616 | DM.DMF0039_GET_SPREAD_TITLE | MATCH | SP DMF0039_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 116 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 616 | DM.DMF0039_GET_SPREAD_TITLE | MATCH | SP DMF0039_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 635 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM.DMF0039_GET_ESS_SHIPMENT_PRIORITY | MATCH | 1 | SP DMF0039_GET_ESS_SHIPMENT_PRIORITY | EXEC:DMF0039_GET_ESS_SHIPMENT_PRIORITY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#MKT_FCST, SELECT:DM_PLN_MKT_FCST, SELECT:SCP_MST_BOD_V, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SSO_USER_INFO, REF:STRING_SPLIT, SELECT:DM_MST_ITEM_SINGLE_V, REF:UF_FX_STRING_SPLITFORIN, SELECT:SCM_SYS_CALENDAR_M, SELECT:#MKT_FCST, SELECT:DM_MST_SHIPMENT_PRIORITY, UPDATE:#MKT_FCST, SELECT:SCM_MST_SHEET_COLUMNS, EXEC:SP_EXECUTESQL, SELECT:SPLIT |  |
| DM.DMF0039_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0039_GET_SPREAD_TITLE | EXEC:DMF0039_GET_SPREAD_TITLE, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0039_SAVE_MST_SHIPMENT_PRIORITY | MATCH | 1 | SP DMF0039_SAVE_MST_SHIPMENT_PRIORITY | EXEC:DMF0039_SAVE_MST_SHIPMENT_PRIORITY, CREATE:#RESULTS_MST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#RESULTS_MST, SELECT:#RESULTS_MST, MERGE:DM_MST_SHIPMENT_PRIORITY, INSERT:DM_MST_SHIPMENT_PRIORITY_H, DELETE:DM_MST_SHIPMENT_PRIORITY, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | dtDivision.Rows[i] | CODE |
| SetChangeControl | Filter | GROUP_ID, USER_ID, DIVISION_ID, DEPT_ID, END_CUSTOMER |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:132, InitControls:140, InitControls:148, FindData:314, FindData:315, btnProject_Click:650, btnItemId_Click:667 | CString.GetCheckedListValue | CODE |
| GetDMInnerTable | SetChangeControl:178, SetChangeControl:185, SetChangeControl:193, SetChangeControl:202 | DataService.GetDMInnerTable | CODE, DEPT_ID, DIVISION_ID, END_CUSTOMER, NAME |
| GetSpdTitle | InitSpread:233 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:234 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:295 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnProject | Click | btnProject_Click | InitializeComponent:385 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:421 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:630 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:631 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:632 |
| this | Load | Form_Load | .ctor:96 |

## 6. 컨트롤 (27개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | lblSalesSite, lblTeam, lblEndCustomer, lblProject, lblItemId, lblDivision, layoutControlItem2, layoutControlItem3, Period |
| UsrCheckedList | 3 | clbSalesSite, clbTeam, clbEndCustomer |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| UsrButton | 2 | btnProject, btnItemId |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCombo | 1 | cboDivision |
| UsrDateRangePicker | 1 | drpDateTime |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 11 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 10 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | DMF0039 | ESSPriority | · | · | · | · | · | · | · | 0/8 | · | · | · | · | · | · |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 66건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: ESSPriority
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:234
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 537 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| InitializeComponent |  | 648 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 649 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 650 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 651 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ESSPriority | META+코드연결 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
