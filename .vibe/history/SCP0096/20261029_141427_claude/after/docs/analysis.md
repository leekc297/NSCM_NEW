# SCP0096 — Shipment Working Day OSP: AS-IS 분석

> 근거: AsisFacts가 정적으로 추출한 사실 묶음(Fact Pack)만 사용했습니다. 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0096 |
| 화면명 (Form Text, Designer.cs:663) | `Shipment Working Day OSP` |
| 도메인 | SCP (경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\`) |
| 클래스 | `SCP0096_Shipment_Working_Day_OSP` |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.csproj` |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0096_Shipment_Working_Day_OSP\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs` | 852 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs` | 724 |
| shared | 없음 (Fact Pack에 없음) | – |
| legacy | 없음 (CSV에 legacy 행 0건) | – |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load > InitControls > GetBucketType` | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | `Form_Load > CreateSpread > InitSpread > GetSpdTitle` | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | `FindButton > FindData_Main` | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| button:FindButton | `FindButton > FindData_Main > InitSpread > GetSpdTitle` | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | `SaveButton > SaveData_Main > FindData_Main` | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| button:SaveButton | `SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle` | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| unreached (진입점 미연결) | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| unreached (진입점 미연결) | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |

> ⚠ **저장 SP 미검출**: `SaveButton > SaveData_Main` 경로에서 검출된 엔드포인트는 저장 후 재조회(`FindData_Main`)뿐입니다. 저장 자체를 수행하는 SP나 엔드포인트는 Fact Pack에 없습니다. SaveData_Main(558~609)이 `p_*` 파라미터 컬럼을 구성하는 사실만 확인됩니다(4장). → **확인 필요 (최우선)**

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | – | – | 코드분기 UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER, SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | – | – (via `Data.Common[case Type.YesOrNo] > Data.CallBizData`) | – |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL | – |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M | – |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_OSP, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | – |

### 3-1. 주석 처리된 호출 (활성 집계 제외)

| 줄 | 값 | 상태 |
|---:|---|---|
| 456 | SCP.SCP0019_GET_WORKING_TIME | 주석 처리됨 (commented:MATCH) — 현재 기능 아님 |

## 4. DB 데이터 컬럼 사용

| 메서드 | 줄 | 대상 | 컬럼 |
|---|---|---|---|
| SaveData_Main | 558 | dr | A |
| SaveData_Main | 560~563 | dr | p_division_id, p_plant_site_id, p_measure, p_user_id |
| SaveData_Main | 570~573 | dr | p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| SaveData_Main | 578~581 | dr | p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| SaveData_Main | 600 | row | A |
| SaveData_Main | 609 | GetChanges (FPExtensions) | ROW_ID |
| GetDayOfWeek | 815 | row (Field) | COLUMN_NAME |
| GetDayOfWeek | 816 | dr | DAY_CODE |

> 참고: `p_is_save_defalut`의 철자(defalut)는 원문 그대로입니다.
> 570~573 블록과 578~581 블록이 각각 어떤 분기 조건에서 실행되는지는 Fact Pack에 없습니다 → 확인 필요.

### 4-1. 프레임워크 메타 소비 메서드

| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:151 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | InitSpread:156 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | InitSpread:159 | (화면 자체 정의 — 프레임워크와 이름만 같음) | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| GetCheckedListValue | SetChangedControl:417·425, FindData_Main:442·443, CboDayWeek_SelectedIndexChanged:672, BtnInput_Click:695·696 | CString.GetCheckedListValue | CODE |
| GetChanges | SaveData_Main:609 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 확인된 동작 (Fact Pack 기준) |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:103 | InitControls → GetBucketType (DM0003), CreateSpread → InitSpread → GetSpdTitle (SCP0009) |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:249 | 본문 확인 필요 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:250 | 본문 확인 필요 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:251 | 본문 확인 필요 |
| clbPlantSite | SelectedIndexChanged | `ClbPlantSite_SelectedIndexChanged` | InitEvent:252 | 본문 확인 필요 |
| cboDayWeek | SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | InitEvent:253 | GetCheckedListValue(672), cboInputValue.Enabled = false(675) / true(679) — 분기 조건 확인 필요 |
| btnInput | Click | `BtnInput_Click` | InitEvent:254 | GetCheckedListValue(695, 696) — 이후 동작 확인 필요 |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:255 | SetSpreadColumn 호출(330 / 335) |

### 5-1. 배선되지 않은 메서드 (Fact Pack에서 발견)
- `cboBucketType_SelectedIndexChanged` (311, 316): SetSpreadColumn을 호출하지만 events.csv에 배선이 없고, controls.csv에도 `cboBucketType` 컨트롤이 없습니다 → 사용되지 않는 코드일 가능성이 있습니다. 확인 필요.
- `SetChangedControl` (417, 425): GetCheckedListValue를 호출하지만 어디서 호출되는지가 Fact Pack에 없습니다(프레임워크 override 여부) → 확인 필요.
- `EditButton` (288): GetSheetInfo를 호출합니다. 진입점 표에는 없습니다 → 확인 필요.

## 6. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

1. **시트 생성 (코드)**: `CreateSpread:142` AddSheet(`Shipment Working Day OSP`, 헤더 3행, 인자 1, 35) → GetSheetInfo(143) → ChangeSheet(144)
2. **META 고정 컬럼 (프레임워크)**: `InitSpread:156` SetSheetHeaderColumn(헤더 3행) → SCM_MST_SHEET_COLUMNS의 6개 컬럼: DIVISION_ID, LAST_INPUT_DATE, MEASURE, PLANT_SITE_ID, PLANT_SITE_NAME, WORKING_TIME_DEFAULT
3. **날짜 컬럼 DB 루프 (코드)**: `InitSpread:159` InitSpreadDateColumn(spdInfo, MEASURE 컬럼 인덱스+1). 원천은 GetSpdTitle의 결과(`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`)입니다.
   - 컬럼명에 `"B_"` 포함(IndexOf > 0) → AddTextColumn: 폭 0, 숨김 (196)
   - 그 외 → AddComboColumn: 폭 50, 표시, 데이터 `dtValidYN`(= Data.Common(YesOrNo)), 가로·세로 가운데 정렬 (203)
   - DAY_CODE가 SAT/SUN이면 ForeColor = SAT 파랑, 그 외(SUN) 빨강 (208)
   - 헤더 3단 Span: 0행 = LARGE_CLASS_LABEL_NAME, 1행 = SMALL_CLASS_LABEL_NAME, 각 그룹 시작 열에 "SUM" 헤더 (215~244)
4. **표시 토글 (코드)**: `SetSpreadColumn` (FindData_Main:484, chkSum_CheckedChanged:330/335에서 호출)
   - Tag가 `D_` 또는 `W_`로 시작 → Visible = true (350)
   - Tag가 `M_` 또는 `W_`로 시작 → Visible = chkSum.Checked (355)
   - `W_`는 두 조건에 모두 해당합니다. 두 if가 순차로 실행되면 최종값은 chkSum.Checked입니다 → 실행 확인 필요
5. **Designer 헤더 스타일**: InitializeComponent 628~631 (General 정렬, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`)

### 6-1. Division별 차이
- 메타: 40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC 14개 division 모두 **6/0**(필수+기본 6, 선택 0)으로 같습니다.
- 최종 Grid(grid_effective): 모든 division에서 6개 컬럼이 "기본"으로 표시되고, 차이는 **없습니다**.
- 코드 분기 조건은 division 변수를 비교하지 않습니다. 날짜 컬럼 수는 SCP0009 실행 결과(기간)에 따라 정해집니다.
- 실제 SP 실행 결과와 맞는 시트는 없습니다(grid 단계를 실행하지 않았거나 시트명 불일치) → 확인 필요.

## 7. 확인 필요 항목

| # | 항목 | 근거 |
|---|---|---|
| 1 | **저장 SP/엔드포인트 미검출** — SaveData_Main이 `p_*` 행을 구성하지만 호출 대상은 추출되지 않음 | flow.csv의 SaveButton 경로에 FindData_Main만 있음 |
| 2 | `biz:CommonData.CommonDataList` [code=LookupCommon] (`dtDayWeek`, 49)의 사용처(cboDayWeek 바인딩 여부) | 진입점 미연결로 분류됨 |
| 3 | `biz:CommonData.YesOrNo` (`dtValidYN`, 51)는 진입점 미연결로 분류됐지만, grid_code 203 원문 인자에 `dtValidYN`이 있음(날짜 Combo 셀 데이터) | 분류 간 상충 |
| 4 | DM0003_GET_BUCKET_TYPE_CODE 결과를 바인딩하는 컨트롤이 없음(cboBucketType 미존재) | controls.csv |
| 5 | `chkSum`이 Designer에서 Visible=false(346), DefineProperty에서 Checked=false(121) → M_/W_ 컬럼이 항상 숨겨지는지 | props.csv |
| 6 | `usrButton1`(75×23)의 용도와 배치(parent 없음) | controls.csv |
| 7 | CellDoubleClick / TopChange / CboDivision / ClbPlantSite 핸들러 본문 | Fact Pack 미포함 |
| 8 | 주석 처리된 `SCP.SCP0019_GET_WORKING_TIME`(456) — 주석 처리됨, 현행 아님 | commented_calls.csv |
| 9 | TB_FX_GroupMenuAuth 4행의 권한 값 | 행 내용 미포함 |
