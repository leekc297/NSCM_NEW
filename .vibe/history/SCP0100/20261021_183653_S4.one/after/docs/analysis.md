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
