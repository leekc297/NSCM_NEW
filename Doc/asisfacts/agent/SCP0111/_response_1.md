=== FILE: analysis.md ===
# SCP0111 Integration PSI — As-is 분석

> 근거: AsisFacts 정적 추출 Fact Pack에 있는 사실만 썼습니다. 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0111 |
| 화면명(Form Text) | `Integration PSI` (Designer.cs:905 `this.Text`) |
| 도메인 | SCP (프로젝트 경로 `GSCM.SCP.Forms.UIL\Analysis`) |
| 클래스 | `SCP0111_IntegrationPSI` |
| csproj | `06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.csproj` |

### 1-1. 파일 구성
| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0111_IntegrationPSI\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.cs` | 2136 |
| current | `...\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.Designer.cs` | 989 |
| shared | 없음 (Fact Pack에 없음) | - |
| legacy | 없음 (Fact Pack 본문에 legacy 행 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| Form_Load (`this.Load`) | Form_Load > InitControls > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| Form_Load | Form_Load > CreateSpread > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| Form_Load | Form_Load > GetEssPackLineAll | 490 | `SCP.SCP0111_GET_ESS_PACK_LINE` | MATCH |
| Form_Load | Form_Load > InitControls > GetBucketType | 1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH |
| CboDivision_SelectedIndexChanged | > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| CboPlanDate_SelectedIndexChanged | > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| CboPlanDate_SelectedIndexChanged | > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| CboPlanType_SelectedIndexChanged | > SetChangedPeriod | 287, 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| _defaultDataModel_Changed | (직접) | 1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| FindButton | FindButton > FindData_Main | 874 | `SCP.SCP0111_GET_INTEGRATION_PSI` | MATCH |
| FindButton | FindButton > FindData_Main > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| EditButton | EditButton | 554 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| EditButton | EditButton | 622 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH |
| SaveButton | SaveButton > SaveData | 1154, 1242, 1511 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| SaveButton | SaveButton > SaveData | 1205 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH |
| SaveButton | SaveButton > SaveData | 1379 | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | MATCH |
| SaveButton | SaveButton > SaveData | 1637 | `SCP.SCP0111_SAVE_INTEGRATION_PSI` | MATCH |
| SaveButton | SaveButton > SaveData > FindData_Main | 874 | `SCP.SCP0111_GET_INTEGRATION_PSI` (저장 후 재조회) | MATCH |
| SaveButton | SaveButton > SaveData > FindData_Main > InitSpread > SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH |
| (진입점 미연결) | `<field:dtPeriod>` 필드 초기화 | 66 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH |

- SaveData 안에서 `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`(1379)과 `SCP0111_SAVE_INTEGRATION_PSI`(1637)이 모두 호출됩니다. **둘 중 어느 쪽을 언제 타는지(분기 조건)는 Fact Pack에 없어 확인 필요**입니다. SaveData:1159에서 `FoxUserInfoContext.Current.NowGroupID`를 읽는 사실은 있지만, 이 값이 분기 조건인지는 확인되지 않았습니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체 |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=CalendarMonth] | BIZ_MATCH | 8 | (UP_FX_GetCommonDataList 코드 분기) | SCM_SYS_CALENDAR_M |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 3 | (UP_FX_GetCommonDataList 코드 분기) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0111_GET_ESS_PACK_LINE` | MATCH | 1 | SCP0111_GET_ESS_PACK_LINE | SCM_MST_LINE_OSP, SCM_MST_SITE |
| `SCP.SCP0111_GET_INTEGRATION_PSI` | MATCH | 1 | SCP0111_GET_INTEGRATION_PSI | SCP_ANL_PSI_INTEGRATION, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN, #SCP_ANL_PSI_INTEGRATION_ITEM, STRING_SPLIT, 동적 SQL |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | MATCH | 1 | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | SCP_ANL_PSI_INTEGRATION(SELECT/UPDATE/INSERT), SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI` | MATCH | 1 | SCP0111_SAVE_INTEGRATION_PSI | SCP_ANL_PSI_INTEGRATION 외 다수(oracle_migration.md §1 참조) |

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:167 |
| btnNickName | Click | `BtnNickName_Click` | InitEvent:360 |
| btnItemId | Click | `BtnItemId_Click` | InitEvent:362 |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:363 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:364 |
| spdMain | CellClick | `spdMain_CellClick` | InitEvent:365 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:367 |
| cboPlanDate | SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitEvent:368 |
| cboPlanType | SelectedIndexChanged | `CboPlanType_SelectedIndexChanged` | InitEvent:369 |
| _defaultDataModel | Changed | `_defaultDataModel_Changed` | InitEvent:374 |

핸들러 동작 중 Fact Pack에 있는 것:
- `BtnNickName_Click`:1887 — `txtNickName.Text = sNickName`. 어떤 팝업이나 데이터 원천에서 값을 가져오는지는 확인 필요입니다.
- `BtnItemId_Click`:1926 — `txtItemId.Text = sItemId`. 원천은 확인 필요입니다.
- `spdMain_CellClick`:1781~1786 — `dtLine.Rows[i]`·`drLine`의 CODE와 NAME을 읽습니다. dtLine이 어디서 오는지(GetEssPackLineAll 결과인지)는 확인 필요입니다.
- `SpdMain_CellDoubleClick`, `SpdMain_TopChange` — 엔드포인트 호출도, 동작 사실도 Fact Pack에 없어 확인 필요입니다.
- btnCellItem_Id에는 Click 배선이 없습니다(Designer에서 Visible=false).

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

| 단계 | 메서드:줄 | 내용 |
|---|---|---|
| 시트 생성 | CreateSpread:299 | `AddSheet(spdMain, "Integration PSI", "Integration PSI", 1, 1, 35)` — 숫자 인자 3개의 의미는 확인 필요 |
| 시트 초기화 | InitSpread:312 | `InitSheet("Integration PSI")` |
| 메타 컬럼 | InitSpread:333 | `SetSheetHeaderColumn(spdInfo, 1)` → SCM_MST_SHEET_COLUMNS 메타(COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG 등) |
| 화면 자체 메서드 | InitSpread:336 → SetSpreadColumn | 컬럼 Tag 접두가 `D_` 또는 `W_`면 숨김(392), `M_`이면 표시(396) |
| DB 루프 컬럼 | SetCalendar:354 | `dtCalendar`(CommonDataList CalendarMonth, 345)를 돌면서 `AddNumColumn(YYYYMM_NAME, YYYYMM, None, 75, true)`로 월 컬럼을 동적으로 추가 |
| 표시 전환 | SetVisibleSheetColumns:1069~1082 | 편집 모드 여부(`siMain.OF.IsEditMode`)에 따라 표시 전환(아래 표) |

SetVisibleSheetColumns 표시 전환:
| 컬럼 | IsEditMode = true | IsEditMode = false |
|---|---|---|
| SEQ_FLAG | 폭 60, 표시 | 폭 0, 숨김 |
| MEASURE | 폭 80, 표시 | 폭 0, 숨김 |
| PLANT_ID | 폭 65, 표시 | 폭 0, visible=true |
| TO_SITE | 폭 75, 표시 | 폭 0, visible=true |

### 5-1. Division별 차이
- 메타 규칙상 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 **SHEET_COLUMNS 22/0, SHEET_MEASURE 7/0으로 같습니다**. division별 차이가 없습니다.
- 코드에 division 비교 분기가 없습니다(분기 판단 불가 0건).
- 최종 표시 컬럼은 division마다 22개입니다(grid_effective). 여기에는 동적 월 컬럼과 IsEditMode에 따른 숨김(SEQ_FLAG, MEASURE)이 반영되지 않았습니다. 그래서 **조회 모드의 실제 표시 수는 확인 필요**입니다.
- 실제 SP 실행 결과와 매칭되는 시트가 없습니다(grid 단계 미실행 또는 시트명 불일치).

## 6. 확인 필요 항목
1. SaveData에서 `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` / `SCP0111_SAVE_INTEGRATION_PSI` 중 무엇을 타는지(분기 조건).
2. 4-2장에 SaveButton:816 → `PersonalSettingPopup.SaveData`로 해석된 호출이 있습니다. 화면 로컬 `SaveData`를 잘못 해석한 것인지 확인해야 합니다.
3. `RefreshPlanDate` / `RefreshPlanType` / `RefreshPlanSeq`가 쓰는 데이터 원천(dtPlanTypeFN 등)의 엔드포인트가 Fact Pack에 없습니다.
4. `InsertRow`(960, NowGroupID 읽음)가 어느 버튼이나 이벤트에서 진입하는지.
5. `SpdMain_CellDoubleClick` / `SpdMain_TopChange` 내부 동작.
6. 줄 66 `<field:dtPeriod>` LookupCommon 호출은 진입점과 연결되지 않았습니다(필드 초기화 시점에 실행되는지).
7. `usrButton1`(parent 없음, 75x23)을 실제로 쓰는지.
8. AddSheet 인자 `1, 1, 35`의 의미(헤더 행 수, 고정 컬럼 수 등).
9. TB_FX_SearchCondition 19행, TITLESET_USER 7행, GroupMenuAuth 4행의 내용.
10. 주석 처리된 호출(commented_calls)은 0건입니다.

=== FILE: source_links.md ===
# SCP0111 소스 링크 표

기준 파일 약어:
- **CS** = `06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.cs`
- **DS** = `06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0111_IntegrationPSI\SCP0111_IntegrationPSI.Designer.cs`

## 1. 엔드포인트 호출 지점 (16건, 전부)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtPeriod>` | 66 | `biz:CommonData.CommonDataList` [code=LookupCommon] (진입점 미연결) |
| CS | SetChangedPeriod | 287 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SetChangedPeriod | 288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SetCalendar | 345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | GetEssPackLineAll | 490 | `SCP.SCP0111_GET_ESS_PACK_LINE` |
| CS | EditButton | 554 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | EditButton | 622 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | FindData_Main | 874 | `SCP.SCP0111_GET_INTEGRATION_PSI` |
| CS | GetBucketType | 1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| CS | SaveData | 1154 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SaveData | 1205 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | SaveData | 1242 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SaveData | 1379 | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` |
| CS | SaveData | 1511 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| CS | SaveData | 1637 | `SCP.SCP0111_SAVE_INTEGRATION_PSI` |
| CS | _defaultDataModel_Changed | 1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 167 | `this.Load += Form_Load` |
| CS | InitEvent | 360 | `btnNickName.Click += BtnNickName_Click` |
| CS | InitEvent | 362 | `btnItemId.Click += BtnItemId_Click` |
| CS | InitEvent | 363 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 364 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 365 | `spdMain.CellClick += spdMain_CellClick` |
| CS | InitEvent | 367 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| CS | InitEvent | 368 | `cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged` |
| CS | InitEvent | 369 | `cboPlanType.SelectedIndexChanged += CboPlanType_SelectedIndexChanged` |
| CS | InitEvent | 374 | `_defaultDataModel.Changed += _defaultDataModel_Changed` |

## 3. Grid 구성 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 299 | `AddSheet(spdMain, "Integration PSI", "Integration PSI", 1, 1, 35)` |
| CS | CreateSpread | 300 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| CS | CreateSpread | 301 | `ChangeSheet` |
| CS | InitSpread | 312 | `InitSheet("Integration PSI")` |
| CS | InitSpread | 333 | `SetSheetHeaderColumn(spdInfo, 1)` (메타) |
| CS | InitSpread | 336 | `SetSpreadColumn(siMain)` (화면 로컬) |
| CS | SetCalendar | 354 | `AddNumColumn(YYYYMM_NAME, YYYYMM, FPMerge.None, 75, true)` — dtCalendar 루프 |
| CS | SetSpreadColumn | 392 | Tag `D_` 또는 `W_` → Visible=false |
| CS | SetSpreadColumn | 396 | Tag `M_` → Visible=true |
| CS | EditButton | 545 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| CS | SetVisibleSheetColumns | 1069 / 1070 / 1072 / 1073 | IsEditMode: SEQ_FLAG 60 / MEASURE 80 / PLANT_ID 65 / TO_SITE 75 표시 |
| CS | SetVisibleSheetColumns | 1078 / 1079 / 1081 / 1082 | 조회 모드: SEQ_FLAG 0 숨김 / MEASURE 0 숨김 / PLANT_ID 0 / TO_SITE 0 |
| DS | InitializeComponent | 858~861 | 헤더 기본 스타일(HorizontalAlignment, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced, VerticalAlignment) |

## 4. 데이터·메타 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangedPeriod | 249, 250 | `GetCheckedListValue` (CODE) |
| CS | SetChangedPeriod | 258 | `dtPeriod.Rows[0]["CODE"]` |
| CS | SetChangedPeriod | 273 | `dtScpPlanPeriod.Rows[0]["HORIZON_END_DATE"]` |
| CS | SetChangedPeriod | 290, 291 | `UsrComboBox.DataBind` (CODE, NAME) |
| CS | RefreshPlanDate | 403 | `GetCheckedListValue` |
| CS | RefreshPlanDate | 418, 422 | `dtPlanTypeFN.Rows[i]["PLANDATE"]` |
| CS | RefreshPlanType | 438, 439 | `GetCheckedListValue` |
| CS | RefreshPlanSeq | 448, 449, 450 | `GetCheckedListValue` |
| CS | EditButton | 559 | `FoxUserInfoContext.Current.NowGroupID` |
| CS | EditButton | 629 | `dtMultiChildItem.Rows[i]["NAME"]` |
| CS | SaveButton | 816 | `SaveData` 호출(Fact Pack이 PersonalSettingPopup.SaveData로 해석 — 확인 필요) |
| CS | InsertRow | 960 | `FoxUserInfoContext.Current.NowGroupID` |
| CS | SaveData | 1159 | `FoxUserInfoContext.Current.NowGroupID` |
| CS | SaveData | 1213 | `dtTemp.Rows[0]["CODE"]` |
| CS | SaveData | 1247, 1516 | `dtToMonth.Rows[k]["CODE"]` |
| CS | SaveData | 1298, 1332, 1587 | `dtMonth.Rows[k]["CODE"]` |
| CS | spdMain_CellClick | 1781 | `dtLine.Rows[i]` NAME, CODE |
| CS | spdMain_CellClick | 1785, 1786 | `drLine` CODE, NAME |
| CS | BtnNickName_Click | 1887 | `txtNickName.Text = sNickName` |
| CS | BtnItemId_Click | 1926 | `txtItemId.Text = sItemId` |
| CS | OnShown | 1932 | `BaseForm.OnShown` (NowGroupID, USER_ID) |

=== FILE: web_components.md ===
# SCP0111 Integration PSI — Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다.

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 레이아웃 아이템 | Size | 비고 | TO-BE 후보 |
|---|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | lblCombo1 | 218x26 | 필수 표시(*) · 변경 이벤트 | 공용 Division 콤보(필수) |
| cboPlanDate | UsrCombo | `Plan-date*` | PlanDate | 207x26 | 필수 표시(*) · 변경 이벤트 | 공용 콤보(필수) |
| cboPlanType | UsrCombo | `Plan-type` | PlanType | 205x26 | **Visible=false** (Designer:450) · 변경 이벤트 | 숨김 — 코드에서 표시 전환하는지 확인 필요 |
| cmbFromMonth | UsrComboBox | `Period` | layoutControlItem2 | 103x26 | SetChangedPeriod에서 DataBind | 기간 From 콤보 |
| cmbToMonth | UsrComboBox | ` ~` | layoutControlItem5 | 103x26 | SetChangedPeriod에서 DataBind | 기간 To 콤보 |
| txtNickName | UsrMultiLineEditor | `Nick Name` | lblNickName | 227x21 | | 멀티라인 입력 |
| btnNickName | UsrButton | (Text 없음) | layoutControlItem3 | 37x23 | Click → BtnNickName_Click | 입력 옆 팝업 버튼 |
| txtItemId | UsrMultiLineEditor | `Model` | lblItemId | 292x21 | | 멀티라인 입력 |
| btnItemId | UsrButton | (layoutControlItem1 Text `layoutControlItem3`) | layoutControlItem1 | 37x23 | Click → BtnItemId_Click | 입력 옆 팝업 버튼 |
| txtCellItemId | UsrMultiLineEditor | `Cell Model` | lblCellItem | 223x21 | | 멀티라인 입력 |
| btnCellItem_Id | UsrButton | - | layoutControlItem4 | 37x23 | **Visible=false**, Click 배선 없음 | 미노출 |
| chkQty | UsrCheckBox | `Qty < 0` | layoutControlItem6 | 309x38 | | CheckBox |
| usrButton1 | UsrButton | - | (parent 없음) | 75x23 | 사용 여부 확인 필요 | - |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Integration PSI` | - | 2021x865 | Dock Fill | Wijmo FlexGrid |
| pnlCondition | UsrConditionPanel | - | - | 2021x112 | Dock Top, PanelType.HidePanel | 조회조건 영역 |

## 2. 화면 배치
- props.csv에 SplitContainer가 **없습니다**. 그래서 분할 비율은 없습니다.
- 위아래 Dock 배치입니다.
  - 상단: `pnlCondition` Dock=Top, 높이 112 (2021x112) — 조회조건
  - 본문: `spdMain` Dock=Fill, 높이 865 (2021x865) — 그리드 단일
  - 높이 비율로는 조회조건 약 11.5% : 그리드 약 88.5% (112 : 865)입니다.
- 조회조건 레이아웃은 `usrLayoutControl2`(Dock Fill, 2021x112) / `layoutControlGroup2`입니다. 개별 아이템 좌표가 Fact Pack에 없어 정확한 행·열 배치는 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Integration PSI`

연결 규칙: **META+코드연결** (AddSheet:299 → InitSheet:312 → SetSheetHeaderColumn:333)

### 3-1. 메타 컬럼 (grid_effective 기준, 모든 division 동일)
| # | COLUMN | Label | 표시 |
|---:|---|---|---|
| 1 | BOH_QTY | BOH | 기본 |
| 2 | CELL_CF | Cell Coversion Factor | 기본 |
| 3 | CELL_ITEM_ID | Cell Model | 기본 |
| 4 | CELL_MODEL_NICK_NAME | Cell Model Nick Name | 기본 |
| 5 | COMPANY_ID | Company | 기본 |
| 6 | DIVISION_ID | Division | 기본 |
| 7 | INCOTERMS | Incoterms | 기본 |
| 8 | ITEM_ID | Model | 기본 |
| 9 | LINE_ID | Line | 기본 |
| 10 | MEASURE | MEASURE | 기본 (단, 조회 모드에서 코드가 숨김) |
| 11 | MEASURE_COLOR | MEASURE_COLOR | 숨김 |
| 12 | MEASURE_LABEL | Measure | 기본 |
| 13 | MEASURE_ORDER_NO | MEASURE_ORDER_NO | 숨김 |
| 14 | NICK_NAME | Nick Name | 기본 |
| 15 | OPERATION_GROUP | Operation | 기본 |
| 16 | PLAN_TYPE | Plan Type | 기본 |
| 17 | PLANT_ID | Plant | 기본 (조회 모드 폭 0) |
| 18 | PLANT_ID_DESCRIPTION | Plant | 기본 |
| 19 | SEQ_FLAG | SEQ_FLAG | 기본 (단, 조회 모드에서 코드가 숨김) |
| 20 | TO_PRODUCT | To Product | 기본 |
| 21 | TO_SITE | To Site | 기본 (조회 모드 폭 0) |
| 22 | TO_SITE_DESCRIPTION | To Site | 기본 |
| 23 | UOM | UOM | 기본 |
| 24 | VALUE_TYPE | Valuation Type | 기본 |

- 표시 22개 + 숨김 2개(MEASURE_COLOR, MEASURE_ORDER_NO)입니다.
- SCM_MST_SHEET_MEASURE 7행(7/0)은 Measure 행 정의입니다. 각 행의 값은 Fact Pack에 없어 확인 필요입니다.
- 원문 라벨 `Cell Coversion Factor`의 철자는 메타 원문 그대로 옮겼습니다.

### 3-2. 코드 하드코딩·동적 컬럼
| 구분 | 위치 | 내용 |
|---|---|---|
| DB 루프 | SetCalendar:354 | CalendarMonth 결과의 행마다 월 컬럼을 추가합니다. 헤더 = `YYYYMM_NAME`, 바인딩 = `YYYYMM`, 숫자, 폭 75, 병합 없음, 표시 |
| Tag 규칙 | SetSpreadColumn:392/396 | Tag가 `D_` 또는 `W_`로 시작하면 숨김, `M_`로 시작하면 표시합니다(월 단위만 노출) |
| 모드 전환 | SetVisibleSheetColumns:1069~1082 | 편집 모드: SEQ_FLAG(60), MEASURE(80), PLANT_ID(65), TO_SITE(75) 표시. 조회 모드: SEQ_FLAG·MEASURE 숨김, PLANT_ID·TO_SITE 폭 0 |
| 헤더 스타일 | Designer:858~861 | ColumnHeaderDefaultEnhanced 상속, NoteIndicatorColor=Red |

### 3-3. Division별 표시 차이
- 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 **22개로 같습니다**. 차이가 없습니다.
- 코드에 division 분기가 없습니다.

## 4. 시트 연결 규칙
- 시트는 `Integration PSI` 1개입니다. 탭이나 마스터-디테일 연결은 없습니다.
- 셀 클릭(`spdMain_CellClick`)에서 Line CODE/NAME(dtLine)을 참조합니다. 셀 편집 콤보(Line 선택)로 쓰이는 것으로 보이지만 확인 필요입니다.
- `SpdMain_CellDoubleClick`, `SpdMain_TopChange` 동작은 확인 필요입니다.

=== FILE: oracle_migration.md ===
# SCP0111 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 위치 | 유형 | 참조 객체 (EXEC 체인 포함) |
|---|---|---|---|
| `SCP0111_GET_ESS_PACK_LINE` | GetEssPackLineAll:490 (Form_Load) | 조회 | SELECT: SCM_MST_LINE_OSP, SCM_MST_SITE |
| `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:1095 (Form_Load > InitControls) | 조회(공용 DM) | SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP0111_GET_INTEGRATION_PSI` | FindData_Main:874 (Find / Save 후 재조회) | 조회 | SELECT: SCP_ANL_PSI_INTEGRATION, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN · INSERT: #SCP_ANL_PSI_INTEGRATION_ITEM · REF: STRING_SPLIT · **동적 SQL**(DYNAMIC@SCP0111_GET_INTEGRATION_PSI) |
| `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | SaveData:1379 | 저장 | EXEC: PR_SCM_SYS_LOG_BATCH · REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL · SCP_ANL_PSI_INTEGRATION(SELECT/UPDATE/INSERT) · INSERT: SCM_SYS_LOG_BATCH |
| `SCP0111_SAVE_INTEGRATION_PSI` | SaveData:1637 | 저장 | 아래 상세 |

### 1-1. `SCP0111_SAVE_INTEGRATION_PSI` 참조 객체 상세
- **EXEC**: PR_SCM_SYS_LOG_BATCH
- **함수/REF**: FN_GET_LOOKUP_VALUE, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL
- **영구 테이블·뷰 쓰기**: INSERT/UPDATE SCP_ANL_PSI_INTEGRATION, INSERT SCM_SYS_LOG_BATCH, `UPDATE:X`(별칭 X — 실제 대상 확인 필요)
- **영구 테이블·뷰 읽기**: SCM_MST_SITE, SCP_ANL_PSI_INTEGRATION, SCP_MST_BOM_ELEC, SCM_MST_YIELD_VER_H_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_CELL_PROD_ASSY_MAP, SCP_MST_FINAL_ITEM, SCP_MST_FORMATION, SCM_ADM_LOOKUP_MASTER, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCM_MST_BOM_EFFECTIVE_SN_V, SCM_MST_ITEM_SN, SCP_MST_TACT_TIME_OSP, SCP_MST_FORMATION_V, SCM_CODE_LOOKUP_VALUE
- **임시 테이블(#) 20종**: #ELEC_PLANT, #CELL_ELEC_PLANT_MAPPING, #TMP_SCP_ANL_PSI_INTEGRATION_230, #TMP_PSI_INTEGRATION_YIELD_VER_H_V_230, #TMP_SCP_ANL_PSI_INTEGRATION_CELL, #TMP_PSI_INTEGRATION_YIELD_VER_H_V, #TMP_YIELD_VER_H_V_A, #TMP_SCP_ANL_PSI_INTEGRATION_530, #TMP_TCO_NO_CA2_ITEM_PROD, #TMP_PSI_INTEGRATION_750_SMALL, #TMP_PSI_INTEGRATION_350_SMALL, #TEM_SCP_ANL_PSI_INTEGRATION_350, #TMP_PSI_INTEGRATION_230_ITEM_SMALL(CREATE 명시), #TMP_PSI_INTEGRATION_SMALL_230, #TMP_PSI_INTEGRATION_SMALL_330 (+ GET SP의 #SCP_ANL_PSI_INTEGRATION_ITEM)
  - 위에 이름이 나열된 #테이블은 SAVE SP 15종 + GET SP 1종입니다. "20종" 표기는 정정합니다. 정확한 개수는 SP 원문으로 재확인하세요.

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)

| code | 참조 테이블 | 호출 수 | 호출 위치 |
|---|---|---:|---|
| CalendarMonth | SCM_SYS_CALENDAR_M | 8 | SetChangedPeriod:287·288, SetCalendar:345, EditButton:554, SaveData:1154·1242·1511, _defaultDataModel_Changed:1980 |
| LookupCommon | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 3 | `<field:dtPeriod>`:66(진입점 미연결), EditButton:622, SaveData:1205 |

- LookupCommon 호출의 LOOKUP_TYPE 인자 값은 Fact Pack에 없어 확인 필요입니다.

## 3. FoxQuery 미등록·직접 호출 SP
- 엔드포인트 5개는 모두 **MATCH**(FoxQuery 등록 확인)입니다. 미등록이나 직접 SQL 호출은 Fact Pack에 없습니다.
- RefreshPlanDate / RefreshPlanType / RefreshPlanSeq가 쓰는 데이터(dtPlanTypeFN 등)의 원천 엔드포인트는 추출되지 않았습니다. 확인 필요입니다.

## 4. Oracle 전환 시 확인 포인트 (사실 기반)

| # | 대상 | 사실 | 전환 포인트 |
|---|---|---|---|
| 1 | SCP0111_GET_INTEGRATION_PSI | REF: STRING_SPLIT | MSSQL 전용 함수이므로 Oracle 대체(분할 함수 또는 JSON_TABLE 등)가 필요합니다 |
| 2 | SCP0111_GET_INTEGRATION_PSI | DYNAMIC SQL | 동적 SQL 원문(월 컬럼 PIVOT 여부 등)을 확인한 뒤 EXECUTE IMMEDIATE / SYS_REFCURSOR로 전환합니다 |
| 3 | GET·SAVE SP | #임시 테이블 다수 | GTT로 바꾸고, 저장 SP 시작 시 초기화를 확인합니다 |
| 4 | SAVE 2종 | SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 배열 문자열 분할 함수의 Oracle 대응 객체가 있는지 확인합니다 |
| 5 | SAVE 2종 | EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH | 공용 로그 프로시저의 Oracle 버전이 있는지 확인합니다 |
| 6 | SCP0111_SAVE_INTEGRATION_PSI | REF: FN_GET_LOOKUP_VALUE | 공용 함수의 Oracle 버전이 있는지 확인합니다 |
| 7 | SCP0111_SAVE_INTEGRATION_PSI | `UPDATE:X` | 별칭 기반 UPDATE…FROM 구문입니다. Oracle MERGE 또는 상관 UPDATE로 바꿔야 합니다(원문 확인 필요) |
| 8 | SCP0111_SAVE_INTEGRATION_PSI | #TMP_PSI_INTEGRATION_230_ITEM_SMALL CREATE 명시 | 런타임 CREATE TABLE이므로 GTT 사전 DDL이 필요합니다 |
| 9 | DM0003_GET_BUCKET_TYPE_CODE | DM 공용 SP | 다른 화면에서도 쓰는 공용 SP입니다. Oracle 전환 여부를 확인하고, SCP0111 전용 수정은 금지합니다 |
| 10 | 저장 분기 | ADMIN / 일반 2종 | 분기 조건을 C#에서 확인한 뒤 TO-BE 저장 API 분기를 설계합니다 |

### 난이도 근거
- `SCP0111_SAVE_INTEGRATION_PSI`: 참조 객체가 60개를 넘고, #임시 테이블이 15종 이상이며, 뷰 5종(SCM_MST_YIELD_VER_H_V, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCM_MST_BOM_EFFECTIVE_SN_V, SCP_MST_FORMATION_V 등)과 함수·로그 EXEC를 포함합니다. **상** (추출 사실의 규모 기준)
- `SCP0111_GET_INTEGRATION_PSI`: STRING_SPLIT과 동적 SQL을 포함합니다. **중** (동적 SQL 원문은 미확인)
- `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`: 단일 테이블 SELECT/UPDATE/INSERT에 배열 분할과 로그를 더한 구조입니다. **중**
- `SCP0111_GET_ESS_PACK_LINE`, `DM0003_GET_BUCKET_TYPE_CODE`: 단순 SELECT입니다. **하**

=== FILE: tobe_design.md ===
# SCP0111 Integration PSI — TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순서(추정 아님: Designer 선언 순서 아님 — 배치 좌표 확인 필요) | 라벨 원문 | 컨트롤 | 필수 | 데이터 원천 |
|---|---|---|---|---|
| - | `Division*` | cboDivision | Y(*) | 확인 필요 (Division 콤보 원천이 Fact Pack에 없음) |
| - | `Plan-date*` | cboPlanDate | Y(*) | 확인 필요 (RefreshPlanDate — dtPlanTypeFN.PLANDATE) |
| - | `Plan-type` | cboPlanType | - | Visible=false. 원천 확인 필요(RefreshPlanType) |
| - | `Period` ~ ` ~` | cmbFromMonth ~ cmbToMonth | 확인 필요 | CommonDataList CalendarMonth (SetChangedPeriod:287/288, DataBind:290/291) |
| - | `Nick Name` | txtNickName + btnNickName | - | 팝업 원천 확인 필요 |
| - | `Model` | txtItemId + btnItemId | - | 팝업 원천 확인 필요 |
| - | `Cell Model` | txtCellItemId (btnCellItem_Id 숨김) | - | 직접 입력 |
| - | (체크) `Qty < 0` | chkQty | - | - |

- TB_FX_SearchCondition에 SCP0111 행이 19개 있습니다. 조회조건 저장 대상과 순서는 이 행으로 확인해야 합니다.

연동 동작:
- Division / Plan-date / Plan-type을 바꾸면 SetChangedPeriod가 실행되어 Period From/To 콤보를 다시 채웁니다.
- Plan-date를 바꾸면 InitSpread > SetCalendar로 그리드 월 컬럼을 다시 생성합니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | Form_Load | `SCP0111_GET_ESS_PACK_LINE`, `DM0003_GET_BUCKET_TYPE_CODE`, CommonDataList(CalendarMonth) |
| 조건 변경 | Cbo*_SelectedIndexChanged, _defaultDataModel_Changed | CommonDataList(CalendarMonth) |
| 조회(Find) | FindButton > FindData_Main | `SCP0111_GET_INTEGRATION_PSI` + 월 컬럼용 CommonDataList(CalendarMonth) |
| 편집(Edit) | EditButton | CommonDataList(CalendarMonth, LookupCommon). 편집 모드에서 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE를 표시 |
| 저장(Save) | SaveButton > SaveData | `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` 또는 `SCP0111_SAVE_INTEGRATION_PSI`(분기 조건 확인 필요) → 저장 후 `SCP0111_GET_INTEGRATION_PSI` 재조회 |
| 행 추가 | InsertRow (NowGroupID 사용) | 진입 버튼 확인 필요 |
| 셀 클릭 | spdMain_CellClick | Line CODE/NAME 참조(dtLine 원천 확인 필요) |

## 3. Division별 Grid 변형 요약
- 메타: 모든 division이 SHEET_COLUMNS 22/0, SHEET_MEASURE 7/0으로 같습니다. **변형이 없습니다**.
- 코드: division 분기가 없습니다.
- 공통 코드 변형:
  - 월 동적 컬럼(CalendarMonth, 폭 75)
  - Tag D_/W_ 숨김, M_ 표시
  - 편집 모드/조회 모드에 따른 SEQ_FLAG·MEASURE·PLANT_ID·TO_SITE 전환

## 4. 권한(C/R/U/D) 관련 사실
- 메타: TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있습니다. 권한 플래그 값은 Fact Pack에 없어 확인 필요입니다.
- 코드: EditButton:559, InsertRow:960, SaveData:1159에서 `FoxUserInfoContext.Current.NowGroupID`를 읽습니다. 그룹별로 동작이 다를 수 있지만 조건은 확인 필요입니다.
- 저장 SP가 `_ADMIN` / 일반 2종으로 나뉘어 있는 사실이 있습니다.
- 버튼 오버라이드로는 Find / Edit / Save만 Fact Pack에 있습니다. Delete 관련 사실은 없습니다.

## 5. 미확정 사항
1. ADMIN 저장 / 일반 저장의 분기 조건과, NowGroupID와의 관계.
2. Plan-date / Plan-type / Plan-seq 콤보의 데이터 원천(RefreshPlanDate / RefreshPlanType / RefreshPlanSeq).
3. Division 콤보 원천.
4. Nick Name / Model 팝업 원천.
5. InsertRow 진입점, SpdMain_CellDoubleClick / SpdMain_TopChange 동작.
6. SaveButton:816 SaveData의 해석(PersonalSettingPopup으로 오인했는지).
7. SHEET_MEASURE 7행의 Measure 목록과 순서. MEASURE_COLOR를 쓰는 방식.
8. GET SP 동적 SQL의 컬럼 생성 규칙. D_/W_/M_ Tag 컬럼과 어떻게 대응하는지.
9. 조회조건 실제 배치 순서(좌표 미추출).
10. `<field:dtPeriod>`:66 LookupCommon 호출 시점.
