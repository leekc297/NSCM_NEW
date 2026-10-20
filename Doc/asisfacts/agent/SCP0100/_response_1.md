=== FILE: analysis.md ===
# SCP0100 Global PSI Report — As-is 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0100)에 있는 사실만 썼습니다. Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> 주석 처리된 호출(commented_calls)은 **0건**입니다. 아래 표는 모두 현재 활성 코드 기준입니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0100 |
| 클래스 | `SCP0100_Global_PSI_Report` |
| 도메인 | SCP (경로 `06.UIL\GSCM.SCP.Forms.UIL\Report\…`) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\SCP0100_Global_PSI_Report.csproj` |
| 화면 유형 | 조회(Report) 화면입니다. 차트(`chartMain`)와 FarPoint Spread 3개(`spdSearchLevel`, `spdDetail`, `spdSearchLevelDetail`)로 구성됩니다. |
| Grid 구성 방식 | `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)` |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\Properties\AssemblyInfo.cs` | 37 |
| current | `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\SCP0100_Global_PSI_Report.cs` | 2056 |
| current | `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\SCP0100_Global_PSI_Report.designer.cs` | 1682 |
| shared | Fact Pack에 없음. 프레임워크 `SpreadInfo`, `CString`, `BaseForm`, `Data_REPORT`는 메서드 이름으로만 등장합니다. | — |
| legacy | Fact Pack 본문에는 없습니다. 본문 표는 current 기준입니다. | — |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---:|---|---|---:|---|---|---|
| 1 | `this.Load` → `Form_Load` | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 2 | `this.Load` → `Form_Load` | Form_Load > InitControls > GetPlanDate | 1365 | `SCP.SCP0100_GET_PLAN_DATE` | MATCH | SCP0100_GET_PLAN_DATE |
| 3 | `this.Load` → `Form_Load` | Form_Load > InitControls > SetCalendar > GetDayRange > GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | (Biz 경유) |
| 4 | `this.Shown` → `SCP0100_Global_PSI_Report_Shown` | SCP0100_Global_PSI_Report_Shown > InitControlsAfter > RefreshToSite > GetSiteList | 1342 | `SCP.SCP0100_GET_SITE` | MATCH | SCP0100_GET_SITE |
| 5 | `cboPlanDate.SelectedIndexChanged` → `CboPlanDate_SelectedIndexChanged` | CboPlanDate_SelectedIndexChanged > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 6 | `cboPlanDate.SelectedIndexChanged` → `CboPlanDate_SelectedIndexChanged` | CboPlanDate_SelectedIndexChanged > SetCalendar > GetDayRange > GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | (Biz 경유) |
| 7 | `dCalendar.ValueChanged` → `DCalendar_ValueChanged` | DCalendar_ValueChanged > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 8 | `rgrpSearchLevel.SelectedIndexChanged` → `rgrpSearchLevel_SelectedIndexChanged` | rgrpSearchLevel_SelectedIndexChanged > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 9 | `this.btnColumn.Click` → `BtnColumn_Click` | BtnColumn_Click > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 10 | `this.btnMeasure.Click` → `btnMeasure_Click` | btnMeasure_Click > InitSpread > GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0100_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | 호출 메서드:줄 | SP / SQL | 참조 테이블·객체 (EXEC 전이 포함) |
|---|---|---:|---|---|---|
| `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | GetSpdTitle:1326 | SP SCP0100_GET_SHEET_CALENDAR_3SPAN | SELECT: SCM_SYS_CALENDAR_M |
| `SCP.SCP0100_GET_SITE` | MATCH | 1 | GetSiteList:1342 | SP SCP0100_GET_SITE | SELECT: SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF: FN_SPLITSTRING |
| `SCP.SCP0100_GET_PLAN_DATE` | MATCH | 1 | GetPlanDate:1365 | SP SCP0100_GET_PLAN_DATE | INSERT/SELECT: #TMP_PLAN / SELECT: SCP_PLAN_VERSION_V, SCM_SYS_CALENDAR_M, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF: FN_CHAR_TO_DATE, FN_SPLITSTRING |
| `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] | BIZ_MATCH | 1 | GetPlanEndDate:2035 (via `Data_REPORT.CallBizCommonData`) | 미식별 | **확인 필요**: PLAN_END_DATE 코드가 조회하는 테이블 |

> 메인 데이터 조회(Report 본문·차트 데이터)를 가져오는 엔드포인트는 Fact Pack에서 **검출되지 않았습니다** (→ §7 확인 필요).

## 4. 이벤트 배선 표

| # | 대상 | 이벤트 | 핸들러 | 배선 위치 | 핸들러가 엔드포인트로 이어지는지 (flow.csv 기준) |
|---:|---|---|---|---|---|
| 1 | this | Load | `Form_Load` | .ctor:501 | GET_SHEET_CALENDAR_3SPAN, GET_PLAN_DATE, CommonDataList_REPORT |
| 2 | this | Shown | `SCP0100_Global_PSI_Report_Shown` | .ctor:502 | GET_SITE |
| 3 | clbDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitEvent:1127 | 엔드포인트 경로 없음. 내부 동작은 확인 필요 |
| 4 | cboGraphType | SelectedIndexChanged | `CboGraphType_SelectedIndexChanged` | InitEvent:1128 | 엔드포인트 경로 없음. 내부 동작은 확인 필요 |
| 5 | cboPlanDate | SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitEvent:1129 | GET_SHEET_CALENDAR_3SPAN, CommonDataList_REPORT |
| 6 | cboBucketType | SelectedIndexChanged | `CboBucketType_SelectedIndexChanged` | InitEvent:1130 | 엔드포인트 경로 없음. `if(_SI != null)` 조건에서 `SetSpreadColumn` 호출(:1804) |
| 7 | cboDisplay | SelectedIndexChanged | `CboDisplay_SelectedIndexChanged` | InitEvent:1131 | 엔드포인트 경로 없음. `splitContainer1.SplitterDistance`를 0 / 750 / 270으로 설정(:1833/:1841/:1849) |
| 8 | cboSearchLevel | SelectedIndexChanged | `CboSearchLevel_SelectedIndexChanged` | InitEvent:1132 | 엔드포인트 경로 없음. 내부 동작은 확인 필요 |
| 9 | cboUnitQty | SelectedIndexChanged | `CboUnitQty_SelectedIndexChanged` | InitEvent:1133 | 엔드포인트 경로 없음. 내부 동작은 확인 필요 |
| 10 | rgrpSearchLevel | SelectedIndexChanged | `rgrpSearchLevel_SelectedIndexChanged` | InitEvent:1134 | GET_SHEET_CALENDAR_3SPAN |
| 11 | this.btnItemId | Click | `BtnItemId_Click` | InitEvent:1136 | 엔드포인트 경로 없음. `txtItemId.Text = sItemId`(:1947) |
| 12 | this.btnMeasure | Click | `btnMeasure_Click` | InitEvent:1137 | GET_SHEET_CALENDAR_3SPAN |
| 13 | this.btnProject | Click | `BtnProject_Click` | InitEvent:1139 | 엔드포인트 경로 없음. `txtProject.Text = sProjectCode`(:1981) |
| 14 | cboPlanType | SelectedIndexChanged | `CboPlanType_SelectedIndexChanged` | InitEvent:1140 | 엔드포인트 경로 없음. 내부 동작은 확인 필요 |
| 15 | this.btnColumn | Click | `BtnColumn_Click` | InitEvent:1141 | GET_SHEET_CALENDAR_3SPAN |
| 16 | dCalendar | ValueChanged | `DCalendar_ValueChanged` | InitEvent:1143 | GET_SHEET_CALENDAR_3SPAN |
| 17 | chkCellQty | CheckedChanged | `ChkCellQty_CheckedChanged` | InitEvent:1144 | 엔드포인트 경로 없음. chkCellQty는 디자이너에서 `Visible=false` |
| 18 | chkAS | CheckedChanged | `ChkAS_CheckedChanged` | InitEvent:1145 | 엔드포인트 경로 없음. chkAS는 디자이너에서 `Visible=false` |

> InitEvent 줄 번호 1135, 1138, 1142는 배선 목록에서 비어 있습니다. 그 줄의 내용은 **확인 필요**입니다.

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

1. **시트 생성(코드 하드코딩, `CreateSpread`:684~693)**
   - `spdSearchLevel` → 시트 `SEARCH_LEVEL` (AddSheet:684, 인자 `3 ¦ 1 ¦ 30`)
   - `spdDetail` → 시트 `REPORT` (AddSheet:685)
   - `spdSearchLevelDetail` → 시트 `SEARCH_LEVEL_DETAIL` (AddSheet:686)
   - 이어서 GetSheetInfo(:688~690)와 ChangeSheet(:692, :693)를 호출합니다.
2. **메타 컬럼(프레임워크, `InitSpread`)**
   - `InitSheet(_SI.SheetName)`:702
   - `GetSpdTitle`:703 → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 호출(:1326)
   - `SetSheetHeaderColumn(_SI, 3)`:705 → SCM_MST_SHEET_COLUMNS 메타로 고정 컬럼 생성. 컬럼 헤더는 3행입니다.
3. **DB 루프 기간 컬럼(화면 자체 메서드 `InitSpreadDateColumn`:706)**
   - `dsSpdTitle.Tables[0].Rows`를 순회합니다. 이 값은 SCP0100_GET_SHEET_CALENDAR_3SPAN 결과입니다.
   - `COLUMN_NAME`에 `"B_"`가 있으면(IndexOf > 0): `AddTextColumn`, 폭 0, Visible=false (:755)
   - 그 외: `AddNumColumn`, 폭 70, Visible=true (:760)
   - 글자색
     - `M_`로 시작하고 `_plan_start_yyyymm`을 포함하면 빨강(:767)
     - `W_`로 시작하고 라벨에 "A"를 포함하면 파랑(:774)
     - `W_`로 시작하고 라벨에 "B"를 포함하면 파랑(:778)
   - 헤더 병합(ColumnHeaderSpan, :787~816)
     - 0행: `LARGE_CLASS_LABEL_NAME`
     - 1행: `SMALL_CLASS_LABEL_NAME`
     - 2행 등: 고정 문자열 `"Qty"`
4. **표시 변경(코드)**
   - `SetSpreadColumn`(:708, :1804)
     - `_bucket_type`이 "MONTHLY"이면 `M_` 접두 컬럼만 Visible이고 나머지는 숨김(:1103/:1107)
     - "WEEKLY"이면 `W_` 접두 컬럼만 Visible이고 나머지는 숨김(:1114/:1118)
   - `SetVisibleColumnCycle`:1290 → `D0`, `D1` 컬럼 숨김
   - `SetLayout`:1498~1538 → `!_is_detail`일 때 `cboSearchLevel.SelectedIndex`에 따라 PRODUCT_LEVEL1~3을 표시하거나 숨김

| cboSearchLevel.SelectedIndex | PRODUCT_LEVEL1 | PRODUCT_LEVEL2 | PRODUCT_LEVEL3 | 줄 |
|---|---|---|---|---|
| 1 | 표시 | 표시 | 숨김 | 1498~1500 |
| 2 | 표시 | 숨김 | 숨김 | 1509~1511 |
| 3 | 숨김 | 표시 | 숨김 | 1518~1520 |
| 4 | 표시 | 표시 | 표시 | 1527~1529 |
| (case 값 미추출) | 숨김 | 숨김 | 숨김 | 1536~1538 |

5. **시트 전환(`VisibleSheet`:1880~1896)**
   - spdSearchLevel, spdSearchLevelDetail, spdDetail 중 하나만 Visible이 되도록 전환합니다. 전환 조건은 **확인 필요**입니다.
   - `EnableSearchLevel`:1874 → `lciSearchLevel.Enabled = !_is_detail`

### 5-1. division별 차이

- 메타 규칙 기준으로 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 전부 컬럼 수가 같습니다.

| 시트 | 메타 (필수+기본 / 선택) | 최종 표시 |
|---|---|---|
| REPORT | 14/0 | 11 (?3) |
| SEARCH_LEVEL | 8/0 | 5 (?3) |
| SEARCH_LEVEL_DETAIL | 8/0 | 5 (?3) |
| SCM_MST_SHEET_MEASURE `Global PSI New` | 35/0 | — |

- 코드 분기에도 division 변수 비교가 없습니다. **division별 차이 없음**(추출 기준).
- `(?3)`은 PRODUCT_LEVEL1~3입니다. 실행 시점의 cboSearchLevel 값으로 정해지는 동적 분기입니다.

## 6. 프레임워크 메타 소비

| 호출 | 위치 | 읽는 메타 컬럼 |
|---|---|---|
| GetCheckedListValue | getPlanStartYYYYMMDD:215, getFromSite:306, getToSite:325, getPlanType:344, getSearchLevel:412, getDivision:466 | CODE |
| OnShown (BaseForm) | OnShown:522 | NowGroupID, USER_ID |
| GetSpdTitle | InitSpread:703 | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:705 | ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:706 | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 7. 확인 필요 항목

| # | 항목 | 사유 |
|---:|---|---|
| 1 | **메인 데이터 조회 SP** | Report 본문 3개 시트와 차트 데이터를 채우는 엔드포인트가 추출되지 않았습니다. 조회 버튼은 BaseForm 오버라이드 등을 통해 호출되는 것으로 보이며 추출 범위 밖입니다. |
| 2 | `CommonDataList_REPORT` PLAN_END_DATE의 원천 테이블 | Biz 경유 호출이라 SP·테이블이 미식별입니다. |
| 3 | 이벤트 핸들러 내부 동작 | ClbDivision, CboGraphType, CboSearchLevel, CboUnitQty, CboPlanType, ChkCellQty, ChkAS 핸들러의 내부 동작이 Fact Pack에 없습니다. |
| 4 | CboDisplay의 SplitterDistance 0/750/270 분기 조건 | 콤보 값과의 대응이 미추출입니다. |
| 5 | `VisibleSheet`·`_is_detail` 전환 조건 | rgrpSearchLevel과의 관계를 포함해 미추출입니다. |
| 6 | `SetSpreadColumn` 루프 시작 인덱스 | 고정(메타) 컬럼까지 숨김 대상인지 확인이 필요합니다. 추출된 조건은 `for(iCol < Columns.Count)`뿐입니다. |
| 7 | `SetLayout` 마지막 case 값 | 1536~1538 행의 case 라벨이 공란으로 추출되었습니다. |
| 8 | BtnItemId / BtnProject가 호출하는 팝업 화면 | 미추출입니다. |
| 9 | 차트(`chartMain`) 시리즈 구성과 CboGraphType 연동 | 미추출입니다. |
| 10 | `usrButton1` | parent가 없는 컨트롤입니다(Size 75×23). 사용 여부를 확인해야 합니다. |
| 11 | props.csv 뒷부분(약 10KB) 잘림 | layPeriod·layMeasure 등의 라벨과 SplitContainer Orientation 원문을 확인해야 합니다. |

=== FILE: source_links.md ===
# SCP0100 소스 링크 표

기준 경로: `06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0100_Global_PSI_Report\`
- `.cs` = `SCP0100_Global_PSI_Report.cs`
- `.designer.cs` = `SCP0100_Global_PSI_Report.designer.cs`

## 1. 엔드포인트 호출 지점 (전수 4건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0100_Global_PSI_Report.cs | GetSpdTitle | 1326 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` 호출 (fox) |
| SCP0100_Global_PSI_Report.cs | GetSiteList | 1342 | `SCP.SCP0100_GET_SITE` 호출 (fox) |
| SCP0100_Global_PSI_Report.cs | GetPlanDate | 1365 | `SCP.SCP0100_GET_PLAN_DATE` 호출 (fox) |
| SCP0100_Global_PSI_Report.cs | GetPlanEndDate | 2035 | `biz:CommonData.CommonDataList_REPORT` [code={?Data_REPORT.Type.PLAN_END_DATE}] (via Data_REPORT.CallBizCommonData) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | .ctor | 501 | `this.Load += Form_Load` |
| .cs | .ctor | 502 | `this.Shown += SCP0100_Global_PSI_Report_Shown` |
| .cs | InitEvent | 1127 | `clbDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| .cs | InitEvent | 1128 | `cboGraphType.SelectedIndexChanged += CboGraphType_SelectedIndexChanged` |
| .cs | InitEvent | 1129 | `cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged` |
| .cs | InitEvent | 1130 | `cboBucketType.SelectedIndexChanged += CboBucketType_SelectedIndexChanged` |
| .cs | InitEvent | 1131 | `cboDisplay.SelectedIndexChanged += CboDisplay_SelectedIndexChanged` |
| .cs | InitEvent | 1132 | `cboSearchLevel.SelectedIndexChanged += CboSearchLevel_SelectedIndexChanged` |
| .cs | InitEvent | 1133 | `cboUnitQty.SelectedIndexChanged += CboUnitQty_SelectedIndexChanged` |
| .cs | InitEvent | 1134 | `rgrpSearchLevel.SelectedIndexChanged += rgrpSearchLevel_SelectedIndexChanged` |
| .cs | InitEvent | 1136 | `this.btnItemId.Click += BtnItemId_Click` |
| .cs | InitEvent | 1137 | `this.btnMeasure.Click += btnMeasure_Click` |
| .cs | InitEvent | 1139 | `this.btnProject.Click += BtnProject_Click` |
| .cs | InitEvent | 1140 | `cboPlanType.SelectedIndexChanged += CboPlanType_SelectedIndexChanged` |
| .cs | InitEvent | 1141 | `this.btnColumn.Click += BtnColumn_Click` |
| .cs | InitEvent | 1143 | `dCalendar.ValueChanged += DCalendar_ValueChanged` |
| .cs | InitEvent | 1144 | `chkCellQty.CheckedChanged += ChkCellQty_CheckedChanged` |
| .cs | InitEvent | 1145 | `chkAS.CheckedChanged += ChkAS_CheckedChanged` |

## 3. 조회조건 값 수집 (GetCheckedListValue → CODE)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | getPlanStartYYYYMMDD | 215 | CString.GetCheckedListValue |
| .cs | getFromSite | 306 | CString.GetCheckedListValue |
| .cs | getToSite | 325 | CString.GetCheckedListValue |
| .cs | getPlanType | 344 | CString.GetCheckedListValue |
| .cs | getSearchLevel | 412 | CString.GetCheckedListValue |
| .cs | getDivision | 466 | CString.GetCheckedListValue |
| .cs | OnShown | 522 | BaseForm.OnShown (NowGroupID, USER_ID) |

## 4. Grid 구성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | CreateSpread | 684 | AddSheet spdSearchLevel → `SEARCH_LEVEL` (3 ¦ 1 ¦ 30) |
| .cs | CreateSpread | 685 | AddSheet spdDetail → `REPORT` (3 ¦ 1 ¦ 30) |
| .cs | CreateSpread | 686 | AddSheet spdSearchLevelDetail → `SEARCH_LEVEL_DETAIL` (3 ¦ 1 ¦ 30) |
| .cs | CreateSpread | 688~690 | GetSheetInfo(spdSearchLevel / spdDetail / spdSearchLevelDetail, 0) |
| .cs | CreateSpread | 692, 693 | ChangeSheet |
| .cs | InitSpread | 702 | InitSheet(_SI.SheetName) |
| .cs | InitSpread | 703 | GetSpdTitle |
| .cs | InitSpread | 705 | SetSheetHeaderColumn(_SI, 3) — 메타 컬럼 생성 |
| .cs | InitSpread | 706 | InitSpreadDateColumn(_SI, _SI.nIdxData) |
| .cs | InitSpread | 708 | SetSpreadColumn() |
| .cs | InitSpreadDateColumn | 755 | AddTextColumn (`B_` 포함, 폭 0, 숨김) |
| .cs | InitSpreadDateColumn | 760 | AddNumColumn (폭 70, 표시) |
| .cs | InitSpreadDateColumn | 767 | ForeColor = Red (`M_` + `_plan_start_yyyymm` 포함) |
| .cs | InitSpreadDateColumn | 774 | ForeColor = Blue (`W_` + 라벨 "A") |
| .cs | InitSpreadDateColumn | 778 | ForeColor = Blue (`W_` + 라벨 "B") |
| .cs | InitSpreadDateColumn | 787~816 | ColumnHeaderSpan (LARGE / SMALL_CLASS_LABEL_NAME, "Qty") |
| .cs | SetSpreadColumn | 1103 / 1107 | MONTHLY: `M_` 표시 / 그 외 숨김 |
| .cs | SetSpreadColumn | 1114 / 1118 | WEEKLY: `W_` 표시 / 그 외 숨김 |
| .cs | SetVisibleColumnCycle | 1290 | D0, D1 숨김 |
| .cs | SetLayout | 1498~1538 | PRODUCT_LEVEL1~3 표시·숨김 (cboSearchLevel.SelectedIndex) |
| .cs | CboBucketType_SelectedIndexChanged | 1804 | `if(_SI != null)` SetSpreadColumn |

## 5. 화면 동작 코드 (props)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | CboDisplay_SelectedIndexChanged | 1833 | splitContainer1.SplitterDistance = 0 |
| .cs | CboDisplay_SelectedIndexChanged | 1841 | splitContainer1.SplitterDistance = 750 |
| .cs | CboDisplay_SelectedIndexChanged | 1849 | splitContainer1.SplitterDistance = 270 |
| .cs | EnableSearchLevel | 1874 | lciSearchLevel.Enabled = !_is_detail |
| .cs | VisibleSheet | 1880~1882 | spdSearchLevel=false, spdSearchLevelDetail=false, spdDetail=true |
| .cs | VisibleSheet | 1888~1889 | spdSearchLevelDetail=true, spdSearchLevel=false |
| .cs | VisibleSheet | 1893~1896 | spdSearchLevelDetail=false, spdSearchLevel=true, spdDetail=false |
| .cs | BtnItemId_Click | 1947 | txtItemId.Text = sItemId |
| .cs | BtnProject_Click | 1981 | txtProject.Text = sProjectCode |

## 6. 디자이너 (컨트롤 선언 범위)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .designer.cs | (선언부) | 36~98 | 컨트롤 63개 선언 |
| .designer.cs | InitializeComponent | 192~197 | usrConditionPanel1: Dock=Top, 1784×102, HidePanel |
| .designer.cs | InitializeComponent | 248~284 | chkCellQty: Checked=true, Text "Cell Qty", Visible=false |
| .designer.cs | InitializeComponent | 927~929 | chkAS: Text "A/S", Visible=false |
| .designer.cs | InitializeComponent | 1055~1176 | LayoutControlItem의 Control·Text 매핑 (web_components.md §1) |
| .designer.cs | InitializeComponent | 1159 | PlanType(LayoutControlItem): Enabled=false |

=== FILE: web_components.md ===
# SCP0100 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 조회조건 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 `LayoutControlItem.Text` 또는 컨트롤 `Text` 원문입니다.

| AS-IS 컨트롤 | 유형 | LayoutItem | 라벨 원문 | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|---|
| txtItemId | UsrTextBox | layModel | `Model / Nick Name` | 150×25 | 텍스트 입력 + 검색 버튼 | btnItemId 팝업이 값을 채움(:1947) |
| btnItemId | UsrButton | layoutbtnitem | (Text `layoutControlItem3`, 기본 이름) | 39×25 | 팝업 버튼 | BtnItemId_Click |
| clbFromSite | UsrCheckedList2 | layoutControlItem1 | `From Site` | 202×21 | 멀티 선택 콤보(Wijmo MultiSelect) | getFromSite:306 |
| clbToSite | UsrCheckedList2 | lblToSite | `To Site` | 214×21 | 멀티 선택 콤보 | getToSite:325, 목록은 SCP0100_GET_SITE |
| txtCellGroup | UsrTextBox | lblCellGroup1 | `Cell Group` | 111×25 | 텍스트 입력 | — |
| txtProject | UsrTextBox | lblCellGroup | `Project` | 150×26 | 텍스트 입력 + 검색 버튼 | btnProject 팝업이 값을 채움(:1981) |
| btnProject | UsrButton | layoutControlItem2 | (Text 없음) | 39×25 | 팝업 버튼 | BtnProject_Click |
| cboBucketType | UsrCombo | lblBucket | `Bucket` | 70×20 | 단일 콤보(Wijmo ComboBox) | MONTHLY/WEEKLY 컬럼 전환 |
| cboPlanType | UsrCombo | PlanType | `Plan-type` | 70×20 | 단일 콤보 | LayoutItem Enabled=false |
| cboDisplay | UsrCombo | layDisplay | `Display` | 60×20 | 단일 콤보 | 차트/그리드 분할 변경 |
| cboGraphType | UsrCombo | lblGraphType | `Graph` | 60×20 | 단일 콤보 | 차트 유형 연동(확인 필요) |
| cboPlanDate | UsrCombo | 확인 필요(`layoutPlanDate` 추정) | 확인 필요 | 144×20 | 단일 콤보 | 목록은 SCP0100_GET_PLAN_DATE |
| dCalendar | UsrDateRangePicker3 | 확인 필요(`layPeriod` 추정) | 확인 필요 | 230×22 | 기간(From~To) 피커 | ValueChanged → 헤더 재구성 |
| btnMeasure | UsrButton | 확인 필요(`layMeasure` 추정) | 확인 필요 | 30×25 | 메저 선택 버튼 | btnMeasure_Click → InitSpread |
| btnColumn | UsrButton | 확인 필요(`layoutBtnColumn` 추정) | 확인 필요 | 30×25 | 컬럼 선택 버튼 | BtnColumn_Click → InitSpread |
| cboUnitQty | UsrCombo | 확인 필요(`layUnit_qty` 추정) | 확인 필요 | 100×20 | 단일 콤보 | — |
| cboSearchLevel | UsrCombo | 확인 필요(`lciSearchLevel` 추정) | 확인 필요 | 120×20 | 단일 콤보 | PRODUCT_LEVEL1~3 표시 제어. lciSearchLevel.Enabled = !_is_detail |
| rgrpSearchLevel | RadioGroup | 확인 필요 | 확인 필요 | 199×25 | 라디오 그룹 | 시트 전환·헤더 재구성 |
| clbDivision | UsrCheckedList2 | 확인 필요 | 확인 필요 | 179×21 | 멀티 선택 콤보 | getDivision:466 |
| chkCellQty | UsrCheckBox | — | `Cell Qty` | 80×26 | 체크박스 | Checked=true, **Visible=false** |
| chkAS | UsrCheckBox | 확인 필요(`layAS` 추정) | `A/S` | 80×25 | 체크박스 | **Visible=false** |
| usrButton1 | UsrButton | — | — | 75×23 | (미사용 후보) | parent 없음 |

> 컨트롤 이름이 비슷하다는 이유로 "추정"이라고 붙인 매핑은 모두 확인이 필요합니다. 근거가 되는 props.csv 뒷부분이 잘렸습니다. 대상은 layoutControlItem3, layoutControlItem4, layCategoryCC입니다.

## 2. 화면 배치

| 영역 | AS-IS | 사실 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1 → usrLayoutControl2 → layoutControlGroup2 | Dock=Top, Size 1784×102, UsrPanelType=HidePanel(접기 가능) |
| 본문 | splitContainer1 (parent=this) | Panel1 = `chartMain`(ChartControl), Panel2 = `spdSearchLevel` / `spdDetail` / `spdSearchLevelDetail` |
| 분할 방향(Orientation) | 확인 필요 | props.csv 해당 행이 잘렸습니다 |
| 초기 SplitterDistance / Size | 확인 필요 | 위와 같음 |
| 런타임 분할 | CboDisplay_SelectedIndexChanged | SplitterDistance = 0(:1833), 750(:1841), 270(:1849) |

- SplitterDistance=0이면 Panel1(차트)이 접히고 그리드만 보이는 구성으로 해석됩니다.
- 750과 270을 분할 비율로 바꾸려면 splitContainer1 전체 크기와 Orientation이 필요합니다. **확인 필요**
- TO-BE 후보: 상/하(또는 좌/우) Splitter 안에 Chart(Wijmo FlexChart)와 FlexGrid를 둡니다. Display 콤보 값에 따라 분할 위치를 0 / 750 / 270 px로 바꿉니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

공통 사항은 다음과 같습니다.
- 헤더는 3행입니다(SetSheetHeaderColumn(_SI, 3)).
- 메타 고정 컬럼 뒤에 SCP0100_GET_SHEET_CALENDAR_3SPAN 결과로 기간 컬럼이 DB 루프로 추가됩니다.
- **division별 표시 차이는 없습니다.** 14개 division이 모두 같습니다.

### 3-1. `REPORT` (spdDetail) — 연결 규칙: META+코드연결

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| DIVISION_ID | Div | META | 기본 |
| ITEM_ID | Model | META | 기본 |
| FROM_SITE | From Site | META | 기본 |
| TO_SITE | To Site | META | 기본 |
| INCOTERMS | INCOTERMS | META | 기본 |
| OPERATION_ID | Operation | META | 기본 |
| VARIOUS_KEY | Trans Mode or Line or Project | META | 기본 |
| CELL_GROUP | Cell Group | META | 기본 |
| CELL_CF | Cell Qty | META | 기본 |
| MEASURE_GROUP | Measure Group | META | 기본 |
| MEASURE_NAME | Measure Name | META | 기본 |
| MEASURE_UI | Measure | META | 숨김 |
| PRODUCT_LEVEL1 | Product Level1 | META + 코드 | 기본 → SetLayout 동적(?) |
| PRODUCT_LEVEL2 | Product Level2 | META + 코드 | 기본 → SetLayout 동적(?) |
| PRODUCT_LEVEL3 | Product Level3 | META + 코드 | 기본 → SetLayout 동적(?) |
| D0, D1 | (공란) | CODE_ONLY_CHANGE | → 숨김 (SetVisibleColumnCycle) |

- 최종 표시는 **11 (?3)** 입니다. 메타 순서(SORT_ORDER_NO 등)는 확인 필요입니다.

### 3-2. `SEARCH_LEVEL` (spdSearchLevel) — META+코드연결

| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| OPERATION_GROUP | Operation Group | 기본 |
| CELL_GROUP | Cell Group | 기본 |
| MEASURE_GROUP | Measure Group | 기본 |
| MEASURE_NAME | Measure Name | 기본 |
| MEASURE_UI | Measure | 숨김 |
| PRODUCT_LEVEL1~3 | Product Level1~3 | 기본 → SetLayout 동적(?) |
| D0, D1 | (공란) | → 숨김 |

- 최종 표시는 **5 (?3)** 입니다.

### 3-3. `SEARCH_LEVEL_DETAIL` (spdSearchLevelDetail) — META+코드연결

컬럼 구성은 SEARCH_LEVEL과 같습니다. DIVISION_ID, OPERATION_GROUP, CELL_GROUP, MEASURE_GROUP, MEASURE_NAME, MEASURE_UI(숨김), PRODUCT_LEVEL1~3, D0/D1(숨김)입니다.
- 최종 표시는 **5 (?3)** 입니다.

### 3-4. 기간 컬럼 (3개 시트 공통, InitSpreadDateColumn)

| 규칙 | 내용 |
|---|---|
| 원천 | SCP0100_GET_SHEET_CALENDAR_3SPAN 결과 행 (COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME) |
| `B_` 포함 컬럼 | 텍스트 컬럼, 폭 0, 숨김 |
| 그 외 | 숫자 컬럼, 폭 70, 표시 |
| 헤더 0행 | LARGE_CLASS_LABEL_NAME 병합 |
| 헤더 1행 | SMALL_CLASS_LABEL_NAME 병합, 일부 "Qty" |
| 헤더 2행 | "Qty" |
| 글자색 | `M_` + 계획시작월(_plan_start_yyyymm) = 빨강 / `W_` + 라벨 A·B = 파랑 |
| Bucket 전환 | MONTHLY → `M_*`만 표시, WEEKLY → `W_*`만 표시 (SetSpreadColumn) |

- TO-BE 후보: Wijmo FlexGrid `columnHeaders`에 3행 병합(allowMerging)을 쓰고, 동적 컬럼으로 생성합니다.

### 3-5. 메저

- SCM_MST_SHEET_MEASURE에 `Global PSI New` 35행이 있습니다(모든 division 35/0).
- 메저 행의 내역은 dbmeta CSV 참조가 필요합니다.

## 4. 시트 연결 규칙

| 시트 | Spread | 연결 | 표시 전환 |
|---|---|---|---|
| SEARCH_LEVEL | spdSearchLevel | AddSheet:684 (META 시트명과 일치) | VisibleSheet:1894에서 true, 1880/1889에서 false |
| REPORT | spdDetail | AddSheet:685 | VisibleSheet:1882에서 true, 1896에서 false |
| SEARCH_LEVEL_DETAIL | spdSearchLevelDetail | AddSheet:686 | VisibleSheet:1888에서 true, 1881/1893에서 false |

- 세 시트는 같은 Panel2에 겹쳐 있고, 한 번에 하나만 Visible입니다.
- 전환 기준 변수는 `_is_detail`로 보입니다. 정확한 조건은 **확인 필요**입니다.
- 시트 간 마스터-디테일 연동(행 선택 → 상세 조회)은 Fact Pack에 없습니다. **확인 필요**

=== FILE: oracle_migration.md ===
# SCP0100 Oracle 전환 포인트

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 위치 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0100_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN (MATCH) | GetSpdTitle:1326 | SELECT SCM_SYS_CALENDAR_M | 자기 자신만 |
| `SCP0100_GET_SITE` | SCP.SCP0100_GET_SITE (MATCH) | GetSiteList:1342 | SELECT SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF FN_SPLITSTRING | 자기 자신만 |
| `SCP0100_GET_PLAN_DATE` | SCP.SCP0100_GET_PLAN_DATE (MATCH) | GetPlanDate:1365 | INSERT/SELECT #TMP_PLAN / SELECT SCP_PLAN_VERSION_V, SCM_SYS_CALENDAR_M, SCP_PLN_INTERFACE_YN, SCP_RPT_GLOBAL_PSI_MD_MM, SCP_RPT_GLOBAL_PSI_MD_WW / REF FN_CHAR_TO_DATE, FN_SPLITSTRING | 자기 자신만 |

- 세 SP 모두 다른 SP를 EXEC로 호출하는 체인은 추출되지 않았습니다.

## 2. 공통코드 분기

| 호출 | code | 테이블 |
|---|---|---|
| biz:CommonData.CommonDataList_REPORT (GetPlanEndDate:2035) | `Data_REPORT.Type.PLAN_END_DATE` | **확인 필요** (Biz 내부 SQL 미추출) |

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 미등록(UNMATCH) 엔드포인트는 **0건**입니다. 3개 SP는 모두 MATCH입니다.
- 직접 SQL 호출은 추출되지 않았습니다. Biz 경유 1건(BIZ_MATCH)이 있습니다.
- 확인 필요 0건, 주석 처리된 호출 0건입니다.
- **메인 데이터 조회 SP가 추출되지 않았습니다.** Report 본문과 차트 데이터의 원천이 Fact Pack에 없습니다. 전환 범위를 확정하려면 원천을 먼저 확인해야 합니다.

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 포인트 (사실 근거) |
|---:|---|---|
| 1 | SCP0100_GET_PLAN_DATE | `#TMP_PLAN` 임시테이블에 INSERT 후 SELECT합니다. Oracle에서는 GTT DDL을 만들거나 CTE/WITH로 바꿔야 합니다. GTT라면 호출 단위 초기화가 필요합니다. |
| 2 | SCP0100_GET_PLAN_DATE, SCP0100_GET_SITE | `FN_SPLITSTRING`을 참조합니다. 멀티선택 문자열 분해 함수를 Oracle에서 어떻게 대체하거나 이관할지 확인해야 합니다. 화면의 getFromSite / getToSite / getPlanType / getDivision이 멀티선택 CODE를 넘깁니다. |
| 3 | SCP0100_GET_PLAN_DATE | `FN_CHAR_TO_DATE`를 참조합니다. 문자→날짜 변환 함수의 Oracle 존재 여부와 포맷을 확인해야 합니다. |
| 4 | SCP0100_GET_PLAN_DATE | 뷰 `SCP_PLAN_VERSION_V`가 Oracle에 있는지 확인해야 합니다. |
| 5 | SCP0100_GET_SITE, SCP0100_GET_PLAN_DATE | 결과 테이블 `SCP_RPT_GLOBAL_PSI_MD_MM`(월)과 `_WW`(주) 2종을 조회합니다. 화면의 Bucket(MONTHLY/WEEKLY) 구분과 연관되는지 확인이 필요합니다. |
| 6 | SCP0100_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M 기반으로 동적 헤더 행을 반환합니다. 화면이 소비하는 결과 컬럼 계약은 다음과 같습니다: COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME, SORT_ORDER_NO. 또 컬럼명 접두 규칙(`M_`, `W_`, `B_` 포함)을 그대로 유지해야 합니다. |
| 7 | 공통 | MSSQL 고유 구문(날짜 함수, TOP, ISNULL 등)이 있는지는 SP 원문을 봐야 판단할 수 있습니다. Fact Pack에는 원문이 없어 **확인 필요**입니다. |

## 5. 난이도 (사실 근거만)

- SP 3개, EXEC 체인 없음, 참조 테이블은 6종(뷰 1 포함)입니다. 함수 2종과 임시테이블 1종이 있습니다.
- 임시테이블과 사용자 함수 의존은 GET_PLAN_DATE에 몰려 있습니다. 세 SP 중 상대적으로 전환 항목이 가장 많습니다.
- 메인 조회 SP가 미식별이라 **전체 난이도는 판정할 수 없습니다(확인 필요)**.

=== FILE: tobe_design.md ===
# SCP0100 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 조건 | AS-IS 컨트롤 | 값 수집 | 초기값·목록 원천 | 비고 |
|---|---|---|---|---|
| Plan Date | cboPlanDate | 확인 필요 | SCP0100_GET_PLAN_DATE (Form_Load > InitControls) | 변경 시 헤더 재구성과 기간 재계산 |
| 기간 | dCalendar (DateRangePicker) | getPlanStartYYYYMMDD:215 관련(확인 필요) | SetCalendar > GetDayRange > GetPlanEndDate (CommonDataList_REPORT PLAN_END_DATE) | 변경 시 헤더 재구성 |
| Division | clbDivision (멀티) | getDivision:466 | 확인 필요 | — |
| From Site | clbFromSite (멀티) | getFromSite:306 | 확인 필요 | — |
| To Site | clbToSite (멀티) | getToSite:325 | SCP0100_GET_SITE (Shown > InitControlsAfter > RefreshToSite) | — |
| Plan-type | cboPlanType | getPlanType:344 | 확인 필요 | LayoutItem Enabled=false |
| Search Level | cboSearchLevel / rgrpSearchLevel | getSearchLevel:412 | 확인 필요 | PRODUCT_LEVEL 표시 제어, 시트 전환 |
| Bucket | cboBucketType | — | 확인 필요 | MONTHLY / WEEKLY |
| Model / Nick Name | txtItemId + btnItemId | — | 팝업(확인 필요) | — |
| Project | txtProject + btnProject | — | 팝업(확인 필요) | — |
| Cell Group | txtCellGroup | — | — | — |
| Unit Qty | cboUnitQty | — | 확인 필요 | — |
| Display / Graph | cboDisplay / cboGraphType | — | 확인 필요 | 화면 표시 전용 |
| Cell Qty / A/S | chkCellQty / chkAS | — | — | 둘 다 Visible=false (숨김 컨트롤) |

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 핸들러 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | `Form_Load` | `SCP0100_GET_SHEET_CALENDAR_3SPAN`(헤더) / `SCP0100_GET_PLAN_DATE`(Plan Date) / CommonDataList_REPORT PLAN_END_DATE |
| 화면 표시 후 | `SCP0100_Global_PSI_Report_Shown` | `SCP0100_GET_SITE`(To Site) |
| Plan Date 변경 | `CboPlanDate_SelectedIndexChanged` | SCP0100_GET_SHEET_CALENDAR_3SPAN, CommonDataList_REPORT PLAN_END_DATE |
| 기간 변경 | `DCalendar_ValueChanged` | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| Search Level 라디오 변경 | `rgrpSearchLevel_SelectedIndexChanged` | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 메저 버튼 | `btnMeasure_Click` | SCP0100_GET_SHEET_CALENDAR_3SPAN (+ 메저 선택 UI는 확인 필요) |
| 컬럼 버튼 | `BtnColumn_Click` | SCP0100_GET_SHEET_CALENDAR_3SPAN (+ 컬럼 선택 UI는 확인 필요) |
| Bucket 변경 | `CboBucketType_SelectedIndexChanged` | API 없음. FE 컬럼 표시 전환(M_/W_) |
| Display 변경 | `CboDisplay_SelectedIndexChanged` | API 없음. 분할 위치 0/750/270 |
| Search Level 콤보 변경 | `CboSearchLevel_SelectedIndexChanged` | 확인 필요 (SetLayout은 PRODUCT_LEVEL1~3 표시) |
| Division / Graph / Unit Qty / Plan-type 변경 | `ClbDivision_SelectedIndexChanged`, `CboGraphType_SelectedIndexChanged`, `CboUnitQty_SelectedIndexChanged`, `CboPlanType_SelectedIndexChanged` | 확인 필요 |
| Model / Project 팝업 | `BtnItemId_Click`, `BtnProject_Click` | 팝업 화면은 확인 필요 |
| Cell Qty / A/S 체크 | `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged` | 확인 필요 (컨트롤 숨김) |
| **조회(본문·차트 데이터)** | 확인 필요 | **미식별 — 최우선 확인 대상** |

## 3. division별 Grid 변형 요약

- REPORT는 11 (?3), SEARCH_LEVEL은 5 (?3), SEARCH_LEVEL_DETAIL은 5 (?3)입니다. 14개 division 모두 같습니다.
- 메타와 코드 모두 division 분기가 없습니다. TO-BE에서도 division별 컬럼 분기가 필요 없습니다(추출 기준).
- 실제로 바뀌는 축은 division이 아니라 다음 셋입니다.
  1. Bucket(MONTHLY/WEEKLY)
  2. Search Level(PRODUCT_LEVEL1~3)
  3. 시트 전환(_is_detail)

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SCP0100 행 4건이 있습니다. 그룹별 C/R/U/D 값은 dbmeta CSV를 확인해야 합니다. |
| TB_FX_MenuItemInfo / TB_FX_ProgramInfo | 각 1건 |
| TB_FX_Favorite | 2건 |
| TB_FX_SearchCondition | 23건 (저장된 조회조건) |
| SCM_MST_TITLESET_USER | 526건 (사용자 타이틀셋) |
| 세션 | BaseForm.OnShown:522가 NowGroupID와 USER_ID를 사용합니다 |
| 저장/삭제 | 저장·삭제 엔드포인트가 추출되지 않았습니다. 조회 전용(R) 화면으로 보이지만 **확인 필요**입니다. |

## 5. 미확정 사항

1. 메인 데이터 조회 SP와 차트 데이터 원천
2. PLAN_END_DATE 공통코드 조회 테이블
3. 이벤트 핸들러 11종의 내부 로직
   - 엔드포인트 경로가 없는 핸들러는 13종입니다. 이 중 CboBucketType과 CboDisplay는 §2에 동작이 일부 확인되어 제외했습니다.
4. `_is_detail` 결정 조건과 VisibleSheet 전환 규칙
5. CboDisplay 값과 SplitterDistance(0/750/270)의 대응, splitContainer1 Orientation과 Size
6. SetSpreadColumn이 고정 메타 컬럼까지 숨기는지 여부(루프 시작 인덱스)
7. SetLayout 마지막 case 값
8. Model / Project 팝업 화면 ID
9. 라벨 미확인 LayoutItem: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layoutControlItem3, layAS, layCategoryCC, layoutControlItem4, layoutPlanDate
10. 숨김 컨트롤(chkCellQty, chkAS)과 parent 없는 usrButton1을 이관할지 여부
11. SCM_MST_SHEET_MEASURE `Global PSI New` 35행의 메저 정의와 TO-BE 메타 이관
