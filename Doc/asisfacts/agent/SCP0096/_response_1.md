=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SCP0096 — 소스 링크 표

> 기준 경로(AS-IS 소스 루트)는 Fact Pack에 없으므로 상대 경로로 표기했습니다. 루트 경로는 확인 필요입니다.
> - `CS` = `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs`
> - `DS` = `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:49](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L49) | `<field:dtDayWeek>` | 49 | biz:CommonData.CommonDataList [code=LookupCommon] (BIZ_MATCH, 진입점 미연결) |
| [CS:51](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L51) | `<field:dtValidYN>` | 51 | biz:CommonData.YesOrNo (BIZ_MATCH, 진입점 미연결) |
| [CS:394](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L394) | GetBucketType | 394 | DM.DM0003_GET_BUCKET_TYPE_CODE (MATCH) |
| [CS:457](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L457) | FindData_Main | 457 | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (MATCH) |
| [CS:831](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L831) | GetSpdTitle | 831 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (MATCH) |
| [CS:456](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L456) | (FindData_Main 인접) | 456 | SCP.SCP0019_GET_WORKING_TIME — **주석 처리됨** |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:103](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L103) | .ctor | 103 | this.Load += Form_Load |
| [CS:249](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L249) | InitEvent | 249 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [CS:250](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L250) | InitEvent | 250 | spdMain.TopChange += SpdMain_TopChange |
| [CS:251](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L251) | InitEvent | 251 | cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged |
| [CS:252](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L252) | InitEvent | 252 | clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged |
| [CS:253](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L253) | InitEvent | 253 | cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged |
| [CS:254](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L254) | InitEvent | 254 | btnInput.Click += BtnInput_Click |
| [CS:255](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L255) | InitEvent | 255 | this.chkSum.CheckedChanged += chkSum_CheckedChanged |

## 3. Grid 구성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:142](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L142) | CreateSpread | 142 | AddSheet(spdMain, SpdSheet.shtMain, …, 3, 1, 35) |
| [CS:143](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L143) | CreateSpread | 143 | GetSheetInfo(spdMain.Name, 0) |
| [CS:144](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L144) | CreateSpread | 144 | ChangeSheet |
| [CS:151](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L151) | InitSpread | 151 | GetSpdTitle (SpreadInfo.GetSpdTitle) |
| [CS:155](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L155) | InitSpread | 155 | InitSheet(SpdSheet.shtMain) |
| [CS:156](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L156) | InitSpread | 156 | SetSheetHeaderColumn(siMain, 3) |
| [CS:159](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L159) | InitSpread | 159 | InitSpreadDateColumn(spdInfo, nIdxDataMain) |
| [CS:160](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L160) | InitSpread | 160 | SetSpreadColumn(siMain) |
| [CS:196](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L196) | InitSpreadDateColumn | 196 | AddTextColumn — "B_" 컬럼, 폭 0, 숨김 |
| [CS:203](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L203) | InitSpreadDateColumn | 203 | AddComboColumn — 폭 50, dtValidYN, Center |
| [CS:208](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L208) | InitSpreadDateColumn | 208 | SAT=Blue / SUN=Red ForeColor |
| [CS:215](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L215) | InitSpreadDateColumn | 215~244 | ColumnHeaderSpan (Large/Small/"SUM") |
| [CS:288](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L288) | EditButton | 288 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| [CS:311](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L311) | cboBucketType_SelectedIndexChanged | 311, 316 | SetSpreadColumn (배선 없음) |
| [CS:330](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L330) | chkSum_CheckedChanged | 330, 335 | SetSpreadColumn |
| [CS:350](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L350) | SetSpreadColumn | 350 | D_/W_ → Visible=true |
| [CS:355](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L355) | SetSpreadColumn | 355 | M_/W_ → Visible=chkSum.Checked |
| [CS:484](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L484) | FindData_Main | 484 | 조회 행이 있으면 SetSpreadColumn |
| [DS:628](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L628) | InitializeComponent | 628~631 | 헤더 스타일(General, NoteIndicatorColor Red, ColumnHeaderDefaultEnhanced) |

## 4. 컨트롤 값과 데이터 처리

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS:121](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L121) | DefineProperty | 121 | chkSum.Checked = false |
| [CS:417](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L417) | SetChangedControl | 417, 425 | GetCheckedListValue |
| [CS:442](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L442) | FindData_Main | 442, 443 | GetCheckedListValue |
| [CS:558](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L558) | SaveData_Main | 558~581 | dr["A"], p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| [CS:600](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L600) | SaveData_Main | 600 | row["A"] |
| [CS:609](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L609) | SaveData_Main | 609 | GetChanges (ROW_ID) |
| [CS:672](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L672) | CboDayWeek_SelectedIndexChanged | 672 | GetCheckedListValue |
| [CS:675](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L675) | CboDayWeek_SelectedIndexChanged | 675 / 679 | cboInputValue.Enabled = false / true |
| [CS:695](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L695) | BtnInput_Click | 695, 696 | GetCheckedListValue |
| [CS:815](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L815) | GetDayOfWeek | 815, 816 | COLUMN_NAME, DAY_CODE |
| [DS:346](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L346) | InitializeComponent | 346 | chkSum.Visible = false |
| [DS:663](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L663) | InitializeComponent | 663 | this.Text = "Shipment Working Day OSP" |

=== FILE: web_components.md ===
# SCP0096 — Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨(원문) | LayoutItem | Size | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | layoutControlItem4 (236×25) | 181×20 | Wijmo ComboBox (필수) | 변경 시 CboDivision_SelectedIndexChanged |
| clbPlantSite | UsrCheckedList | `Plant Site` | layoutControlItem7 (226×25) | 165×21 | Wijmo MultiSelect | GetCheckedListValue(CODE) |
| dCalendar | UsrDateRangePicker3 | `Period*` | layoutControlItem2 (260×25) | 210×22 | 기간 선택(Date Range, 필수) | |
| cboDayWeek | UsrCombo | `Day of the week` | layoutControlItem3 (236×25) | 134×20 | Wijmo ComboBox 또는 MultiSelect (단일/다중 확인 필요) | 672에서 GetCheckedListValue 사용 |
| cboInputValue | UsrCombo | `Input Value` | layoutControlItem1 (226×25) | 124×20 | Wijmo ComboBox | cboDayWeek 변경 시 Enabled false(675)/true(679) |
| btnInput | UsrButton | `Input` (Text) | layoutControlItem10 (81×25) | 77×21 | Button | BtnInput_Click |
| chkSum | UsrCheckBox | `Sum` (Text) | layoutSum (50×25) | 46×20 | CheckBox | **Visible=false**(DS:346), Checked=false(121) |
| usrButton1 | UsrButton | (Text 없음) | – | 75×23 | 확인 필요 | parent 없음 |
| usrConditionPanel1 | UsrConditionPanel | – | – | 1192×96, Dock Top, HidePanel | 조회조건 영역 | |
| usrLayoutControl2 | UsrLayoutControl | – | – | 1192×96, Dock Fill | 조회조건 레이아웃 | |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | – | – | 1192×553, Dock Fill | Wijmo FlexGrid | 시트 `Shipment Working Day OSP` |
| emptySpaceItem1~6·9·10 | EmptySpaceItem | – | – | – | 여백(배치용) | 8개 |

## 2. 화면 배치

- props.csv에 SplitContainer는 **없습니다**. 분할 비율은 Dock과 Size 기준입니다.
- 상단: `usrConditionPanel1` Dock=Top, 높이 96
- 하단: `spdMain` Dock=Fill, 높이 553
- 상/하 비율: 96 : 553 ≈ **14.8% : 85.2%** (폭 1192 공통)
- 좌/우 분할: 없음
- 조회조건 행 구성: LayoutItem Size 높이 25~26으로 보아 2행 이상입니다. 정확한 행·열 위치(Location)는 Fact Pack에 없어 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day OSP`

연결 규칙: **META+코드연결** (메타 시트를 코드가 AddSheet/ChangeSheet로 사용). 헤더는 3행입니다.

### 3-1. 메타 고정 컬럼 (grid_effective 기준)

| 순서 | COLUMN_NAME | 라벨 | 출처 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| (메타 정렬 확인 필요) | DIVISION_ID | Division | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| | LAST_INPUT_DATE | Last Input Date | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | MEASURE | Measure | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | PLANT_SITE_ID | Plant Site ID | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | PLANT_SITE_NAME | Plant Site | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |
| | WORKING_TIME_DEFAULT | Working Time Default | META | 기본 | … 전 division 기본 | | | | | | | | | | | | |

> 14개 division 모두 6개 컬럼이 "기본"이며 division별 표시 차이는 없습니다. 메타의 SORT_ORDER_NO, 폭, 편집 여부 값은 Fact Pack에 없어 확인 필요입니다.

### 3-2. 코드 생성 날짜 컬럼 (DB 루프, MEASURE 다음 열부터)

| 조건 | API | 폭 | 표시 | 셀 | 정렬 | 스타일 |
|---|---|---:|---|---|---|---|
| COLUMN_NAME에 `"B_"` 포함(IndexOf > 0) | AddTextColumn | 0 | 숨김 | Text | – | – |
| 그 외 | AddComboColumn | 50 | 표시 | Combo (`dtValidYN` = YesOrNo) | Center/Center | DAY_CODE SAT → 파랑, SUN → 빨강 |

- 헤더 라벨은 COLUMN_LABEL_NAME이고, 원천은 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과입니다.
- 헤더 3단 Span: 0행 LARGE_CLASS_LABEL_NAME, 1행 SMALL_CLASS_LABEL_NAME, 2행 컬럼 라벨. 각 Large/Small 그룹 시작 열에 `"SUM"` 헤더가 있습니다(높이 20, 222행만 30).

### 3-3. 코드 표시 토글 (SetSpreadColumn, Tag 접두어)

| Tag 접두어 | Visible | 근거 |
|---|---|---|
| `D_` | true | 350 |
| `M_` | chkSum.Checked | 355 |
| `W_` | 350에서 true → 355에서 chkSum.Checked (순차 실행 시 최종 chkSum.Checked, 확인 필요) | 350, 355 |

- chkSum이 Visible=false이고 초기 Checked=false이므로, 사용자가 토글할 수 없어 `M_`/`W_` 컬럼은 숨겨진 상태로 남을 것으로 보입니다 → 실행 확인 필요.
- Designer 헤더 스타일(628~631): HorizontalAlignment/VerticalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 메타 행 | 코드 사용 |
|---|---|---:|---|
| Shipment Working Day OSP | META+코드연결 | 6 (SCM_MST_SHEET_COLUMNS) | AddSheet(142) → SetSheetHeaderColumn(156) → InitSpreadDateColumn(159) → SetSpreadColumn(160) |

- 시트는 1개뿐이고, 마스터-디테일 같은 시트 간 연결은 없습니다.
- 실제 SP 실행 결과와 맞는 시트가 없어(grid 단계 미실행) 실데이터 컬럼 대조는 확인 필요입니다.

=== FILE: oracle_migration.md ===
# SCP0096 — Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 엔드포인트 | 호출 경로 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | Form_Load > InitControls > GetBucketType (394) | SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL | EXEC:DM0003_GET_BUCKET_TYPE_CODE (자기 자신, 하위 EXEC 없음) |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | InitSpread > GetSpdTitle (831) — Load / Find / Save 후 재조회 | SELECT: SCM_SYS_CALENDAR_M | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN (하위 EXEC 없음) |
| `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | FindData_Main (457) — Find / Save 후 재조회 | INSERT: #TBLDYNAMICPIVOT_SCP0096 / SELECT: SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT / REF: STRING_SPLIT / DYNAMIC SQL | EXEC:SCP0096_GET_SHIPMENT_WORKING_DAY_OSP + DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |

### 1-1. 참조 테이블 집계

| 테이블 | 사용 SP |
|---|---|
| SCM_ADM_LOOKUP_MASTER_DETAIL | DM0003_GET_BUCKET_TYPE_CODE, UP_FX_GetCommonDataList |
| SCM_ADM_LOOKUP_MASTER | UP_FX_GetCommonDataList |
| SCM_SYS_CALENDAR_M | SCP0009_GET_SHEET_CALENDAR_3SPAN, SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCP_MST_SHIPMENT_WORKING_DAY_OSP | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCM_MST_SITE | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SCM_MST_LINE_OSP | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| #TBLDYNAMICPIVOT_SCP0096 (임시 테이블) | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |

## 2. 공통코드 분기

| 엔드포인트 | 코드 분기 | 경로 | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | code=LookupCommon | `Data.Common[case Type.LookupCommon] > Data.CallBizCommonData` → UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | code=YesOrNo | `Data.Common[case Type.YesOrNo] > Data.CallBizData` | 참조 테이블 없음(DB 미조회로 추출됨) — 값 목록 확인 필요 |

- LookupCommon 호출에 넘기는 Lookup 그룹 키(어떤 MASTER 코드인지)는 Fact Pack에 없습니다 → 확인 필요.
- YesOrNo 목록은 날짜 Combo 셀의 데이터(`dtValidYN`, grid_code 203)로 쓰입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

| 구분 | 내용 |
|---|---|
| FoxQuery 미등록 | 없음 — fox 엔드포인트 3건이 모두 MATCH |
| 직접 SQL / 직접 호출 | 추출되지 않음 |
| **저장 SP** | **미검출.** SaveData_Main(558~609)이 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default`를 구성하지만 호출 SP는 추출되지 않음 → 확인 필요 |
| 주석 처리됨 | SCP.SCP0019_GET_WORKING_TIME (456) — 주석 처리됨, 전환 대상 아님 |

## 4. Oracle 전환 확인 포인트

| SP | 확인 포인트 (Fact 근거) | 난이도 |
|---|---|---|
| SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | ① `REF:STRING_SPLIT` — MSSQL 전용 함수라 Oracle 대체 구현 필요 ② `INSERT:#TBLDYNAMICPIVOT_SCP0096` — 로컬 임시 테이블이라 GTT 등 대체 필요 ③ `DYNAMIC@` — 동적 SQL(테이블명으로 보아 동적 PIVOT)이라 실행 문자열 전체를 변환 대상으로 다뤄야 함 ④ 참조 테이블 5개 + 캘린더 조인 | **높음** (MSSQL 전용 함수 + 임시 테이블 + 동적 SQL 3요소가 Fact로 확인됨) |
| SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M 단일 SELECT. 결과 컬럼(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME)이 Grid 헤더 계약이므로 컬럼명과 순서를 유지해야 함 | 낮음 (참조 객체 기준. SP 본문은 Fact Pack에 없음) |
| DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL 단일 SELECT | 낮음 (참조 객체 기준) |
| 저장 SP (미검출) | 대상 테이블이 SCP_MST_SHIPMENT_WORKING_DAY_OSP / _DEFAULT인지 확인 필요(`p_is_save_defalut`, `p_working_time_default` 파라미터 존재) | 판단 불가 |

### 4-1. 공통 주의
- SP 본문은 Fact Pack에 없습니다. 위 내용은 참조 객체 추출 결과만 근거로 합니다. 전환 작업 전에 원문 SP를 최신으로 다시 조회해야 합니다.
- 날짜 컬럼 COLUMN_NAME 접두어(`D_`, `W_`, `M_`) 및 `B_` 포함 규칙이 FE 표시 로직과 맞물려 있으므로, SCP0096 GET SP의 동적 PIVOT 결과 컬럼명 규칙을 Oracle에서도 그대로 유지해야 합니다.

=== FILE: tobe_design.md ===
# SCP0096 — TO-BE 설계 요약

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 필수 | TO-BE | 비고 |
|---|---|---|---|---|
| Division* | cboDivision (UsrCombo) | 필수(`*`) | ComboBox | 변경 이벤트 있음(본문 확인 필요) |
| Plant Site | clbPlantSite (UsrCheckedList) | – | MultiSelect | FindData_Main 442/443에서 GetCheckedListValue(CODE) 사용 |
| Period* | dCalendar (UsrDateRangePicker3) | 필수(`*`) | Date Range | |
| Day of the week | cboDayWeek (UsrCombo) | – | ComboBox (다중 여부 확인 필요) | 데이터 원천 후보 biz:CommonData.CommonDataList [code=LookupCommon] (dtDayWeek) — 확인 필요 |
| Input Value | cboInputValue (UsrCombo) | – | ComboBox | Day of the week 선택에 따라 Enabled 토글 |
| (버튼) Input | btnInput | – | Button | 일괄 입력 동작 |
| Sum | chkSum (UsrCheckBox) | – | CheckBox | AS-IS **Visible=false** — TO-BE 노출 여부 확인 필요 |

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | Form_Load > InitControls > GetBucketType | DM0003_GET_BUCKET_TYPE_CODE (바인딩 대상 컨트롤 확인 필요) |
| 화면 진입 | Form_Load > CreateSpread > InitSpread > GetSpdTitle | SCP0009_GET_SHEET_CALENDAR_3SPAN (Grid 날짜 헤더) |
| 조회 | FindButton > FindData_Main | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP + SCP0009_GET_SHEET_CALENDAR_3SPAN(헤더 재생성) |
| 저장 | SaveButton > SaveData_Main → FindData_Main | **저장 SP 확인 필요** → 이후 조회 API 재호출. 파라미터: p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default. 변경 행은 GetChanges(ROW_ID) |
| Day of the week 변경 | CboDayWeek_SelectedIndexChanged | API 없음. cboInputValue Enabled 토글(675/679) |
| Input 클릭 | BtnInput_Click | API 없음(추출 기준). GetCheckedListValue 695/696 이후 동작 확인 필요 |
| Sum 토글 | chkSum_CheckedChanged | API 없음. SetSpreadColumn으로 M_/W_ 컬럼 표시 토글 |
| Division 변경 | CboDivision_SelectedIndexChanged | 확인 필요 (Plant Site 재조회 여부 등) |
| Plant Site 변경 | ClbPlantSite_SelectedIndexChanged | 확인 필요 |
| Grid 더블클릭 | SpdMain_CellDoubleClick | 확인 필요 |
| Grid 스크롤 | SpdMain_TopChange | 확인 필요 |
| (주석 처리됨) | SCP.SCP0019_GET_WORKING_TIME (456) | 주석 처리됨 — 현행 아님, 구현 대상 아님 |

## 3. Division별 Grid 변형 요약

- 시트는 `Shipment Working Day OSP` 1개입니다.
- 메타 고정 6개 컬럼(DIVISION_ID, LAST_INPUT_DATE, MEASURE, PLANT_SITE_ID, PLANT_SITE_NAME, WORKING_TIME_DEFAULT)은 14개 division 모두 "기본"입니다. **division별 변형은 없습니다.**
- 날짜 컬럼은 SCP0009 결과를 DB 루프로 돌려 동적으로 생성합니다(Combo Y/N, 폭 50, SAT 파랑 / SUN 빨강, `B_` 포함 컬럼은 숨김 Text).
- 헤더 3단(Large / Small / 컬럼)에 그룹별 `"SUM"` 헤더가 있습니다.
- Tag 접두어로 표시를 토글합니다: `D_` 표시, `M_`/`W_`는 chkSum.Checked를 따릅니다(`W_` 최종값은 확인 필요).

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | dbo.TB_FX_GroupMenuAuth 4행 (값 미포함 → C/R/U/D 확인 필요) |
| 메뉴/프로그램 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행 |
| 사용 버튼 (코드 기준) | FindButton(조회), SaveButton(저장), EditButton(288, 진입점 표 미포함 — 확인 필요) |
| 저장 사용자 | SaveData_Main이 p_user_id를 전달 |

## 5. 미확정 사항

1. 저장 SP와 엔드포인트 (최우선)
2. DM0003_GET_BUCKET_TYPE_CODE 결과의 사용처 (cboBucketType 컨트롤 없음, `cboBucketType_SelectedIndexChanged` 미배선)
3. `biz:CommonData.CommonDataList` [code=LookupCommon]의 Lookup 그룹 키와 cboDayWeek 바인딩 여부
4. `biz:CommonData.YesOrNo`가 진입점 미연결로 분류됐지만 grid_code 203에서 사용되는 상충
5. chkSum 숨김(Visible=false) 상태에서 M_/W_ 컬럼을 노출할지에 대한 TO-BE 정책
6. cboInputValue Enabled 토글 조건(675/679)과 BtnInput_Click의 일괄 입력 대상(행/열 범위)
7. SaveData_Main 570~573 / 578~581 두 블록의 분기 조건
8. CellDoubleClick / TopChange / CboDivision / ClbPlantSite 핸들러 본문
9. usrButton1의 용도
10. 메타 6개 컬럼의 정렬 순서, 폭, 편집 여부(SCM_MST_SHEET_COLUMNS 행 값 미포함)
11. TB_FX_GroupMenuAuth 4행의 권한 값
