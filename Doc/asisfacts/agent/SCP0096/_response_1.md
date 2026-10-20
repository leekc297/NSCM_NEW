=== FILE: analysis.md ===
# SCP0096 — Shipment Working Day OSP: As-is 분석

> 출처: AsisFacts 정적 추출 Fact Pack. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | 클래스 `SCP0096_Shipment_Working_Day_OSP` |
| 화면명(Form Text) | Shipment Working Day OSP | Designer.cs:663 `this.Text` |
| 도메인 | SCP | 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\...` |
| 분류 폴더 | Master | 경로 |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.csproj` | 파일 구성 |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0096_Shipment_Working_Day_OSP\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs` | 852 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs` | 724 |
| shared | 없음 (Fact Pack에 없음) | — |
| legacy | 없음 (Fact Pack에 없음) | — |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 호출 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load (`Form_Load`) | Form_Load > InitControls > GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load (`Form_Load`) | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:FindButton | FindButton > FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| (진입점 미연결) | 필드 초기화 `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | — (UP_FX_GetCommonDataList 코드 분기) |
| (진입점 미연결) | 필드 초기화 `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` | BIZ_MATCH | — |

흐름 요약:
- **화면 로드(`Form_Load`)**: Bucket Type 코드 조회(DM0003)와 Spread 생성 → 달력 헤더 조회(SCP0009)를 합니다.
- **조회(FindButton)**: `FindData_Main` 에서 SCP0096 SP를 호출하고, `InitSpread > GetSpdTitle` 로 달력 헤더(SCP0009)를 다시 구성합니다. 조회 결과 행이 있으면(`siMain.GetMaxRowIndex() > 0`, :484) `SetSpreadColumn` 으로 컬럼 표시를 다시 적용합니다.
- **저장(SaveButton)**: `SaveData_Main` 에서 변경행(`GetChanges` :609)을 모아 파라미터 행(`p_division_id` 등)을 만든 뒤 `FindData_Main` 으로 재조회합니다. **저장 자체에 쓰는 엔드포인트/SP는 Fact Pack에서 추출되지 않았습니다 → 확인 필요.**
- `dtDayWeek`(:49), `dtValidYN`(:51)은 정적 분석상 진입점에 연결되지 않은 필드 초기화입니다. 다만 `dtValidYN` 은 `InitSpreadDateColumn:203` 의 `AddComboColumn` 인자로 쓰입니다(grid_code raw: `dtValidYN`).

### 2-1. 주석 처리된 호출

| 줄 | 값 | 상태 |
|---:|---|---|
| 456 | SCP.SCP0019_GET_WORKING_TIME | 주석 처리됨 (현행 기능 아님) |

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | 호출 위치 | SP | 참조 테이블/객체 (EXEC 전이 포함) |
|---|---|---:|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | `<field:dtDayWeek>`:49 | — | 코드 분기 UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER, SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | `<field:dtValidYN>`:51 | — | 없음 (via `Data.CallBizData` — DB 접근 여부 확인 필요) |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | GetBucketType:394 | DM0003_GET_BUCKET_TYPE_CODE | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | GetSpdTitle:831 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SELECT SCM_SYS_CALENDAR_M |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | 1 | FindData_Main:457 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | INSERT #TBLDYNAMICPIVOT_SCP0096, SELECT SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, REF STRING_SPLIT, DYNAMIC SQL |

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 확인된 동작 (Fact Pack 기준) |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:103 | InitControls > GetBucketType(DM0003), CreateSpread > InitSpread > GetSpdTitle(SCP0009) |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:249 | 내부 동작 확인 필요 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:250 | 내부 동작 확인 필요 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:251 | 내부 동작 확인 필요 (SetChangedControl:417/425 의 GetCheckedListValue 와의 관계 확인 필요) |
| clbPlantSite | SelectedIndexChanged | `ClbPlantSite_SelectedIndexChanged` | InitEvent:252 | 내부 동작 확인 필요 |
| cboDayWeek | SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | InitEvent:253 | GetCheckedListValue(:672), cboInputValue.Enabled = false(:675) / true(:679) — 분기 조건 확인 필요 |
| btnInput | Click | `BtnInput_Click` | InitEvent:254 | GetCheckedListValue(:695, :696) — 그리드 일괄 입력 로직 상세 확인 필요 |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:255 | SetSpreadColumn(:330 / :335) → M_/W_ 컬럼 Visible = chkSum.Checked |

그 외 메서드:
- `EditButton`(:288) — 툴바 Edit 버튼 처리로 보이며 `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` 를 호출합니다. 동작 상세는 확인 필요합니다.
- `cboBucketType_SelectedIndexChanged`(:311, :316) — SetSpreadColumn 을 호출하지만 **이벤트 배선이 없고, `cboBucketType` 컨트롤도 컨트롤 목록(28개)에 없습니다** → 미사용 잔존 코드인지 확인 필요합니다.

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

| 단계 | 위치 | 내용 |
|---|---|---|
| 시트 생성 | CreateSpread:142 | `AddSheet` — 시트명 `Shipment Working Day OSP` (SpdSheet.shtMain), 인자 `3 ¦ 1 ¦ 35` (인자 의미 확인 필요) |
| 메타 헤더 | InitSpread:156 | `SetSheetHeaderColumn(siMain, 3)` — SCM_MST_SHEET_COLUMNS 메타로 고정 컬럼 생성, 컬럼 헤더 3행 |
| 달력 헤더 조회 | InitSpread:151 → GetSpdTitle:831 | SCP0009_GET_SHEET_CALENDAR_3SPAN 결과(dsSpdTitle) |
| 날짜 컬럼 DB 루프 | InitSpread:159 → InitSpreadDateColumn | 시작 위치 = `GetColumnIndex(MEASURE)+1` |
| ├ `B_` 포함 컬럼 | :196 | `AddTextColumn`, 너비 0, Visible=false (숨김) |
| ├ 그 외 컬럼 | :203 | `AddComboColumn`, 너비 50, Visible=true, 데이터 `Data.Common(Data.Type.YesOrNo)` (= dtValidYN), 가운데 정렬 |
| ├ 주말 글자색 | :208 | DAY_CODE `SAT` → Blue, `SUN` → Red |
| └ 헤더 병합 | :215~:244 | 0행 = LARGE_CLASS_LABEL_NAME 병합, 1행 = SMALL_CLASS_LABEL_NAME 병합, 1~2행 = "SUM" 헤더 |
| 표시 제어 | SetSpreadColumn:350 | 태그 `D_`·`W_` 로 시작 → Visible = true |
| | SetSpreadColumn:355 | 태그 `M_`·`W_` 로 시작 → Visible = chkSum.Checked |

> `W_` 는 두 조건 모두에 들어 있습니다. 두 if 가 독립이면 마지막 할당(:355)인 `chkSum.Checked` 가 적용됩니다. if / else-if 구조는 확인 필요합니다.

### 5-1. 메타 컬럼 (grid_effective)

| 컬럼 | 라벨 | 출처 | 전 division |
|---|---|---|---|
| DIVISION_ID | Division | META | 기본 |
| PLANT_SITE_ID | Plant Site ID | META | 기본 |
| PLANT_SITE_NAME | Plant Site | META | 기본 |
| MEASURE | Measure | META | 기본 |
| WORKING_TIME_DEFAULT | Working Time Default | META | 기본 |
| LAST_INPUT_DATE | Last Input Date | META | 기본 |

(컬럼 표시 순서 SORT_ORDER_NO 는 Fact Pack에 없음 → 확인 필요)

### 5-2. Division별 차이

- 메타: 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — **14개 division 모두 6/0(필수+기본 6, 선택 0)**입니다.
- 최종 Grid: 14개 division 모두 6컬럼(META+코드연결)입니다.
- 코드 분기 중 division 변수를 비교하는 것은 없습니다(분기 판단불가 0건). **division별 Grid 차이는 없습니다.**
- 날짜 컬럼 수는 SCP0009 결과(Period)에 따라 달라집니다(DB 루프).
- 실제 SP 실행 결과와 매칭되는 시트가 없습니다(grid 단계 미실행 또는 시트명 불일치).

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---|---|---|
| 1 | 저장 SP/엔드포인트 미추출 — SaveData_Main 은 파라미터 행(p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default)을 만들지만 저장 호출 대상이 Fact Pack에 없음 | meta_reads :558~:600 |
| 2 | `dr["A"]`/`row["A"]` 컬럼 "A" 의 의미 | SaveData_Main :558, :600 |
| 3 | `p_is_save_defalut` 철자(원문 그대로) 및 Default 저장 분기 | :572, :580 |
| 4 | 저장 파라미터가 :570~:573 과 :578~:581 두 블록으로 나뉘는 분기 조건 | meta_reads |
| 5 | GetBucketType(DM0003) 결과를 바인딩하는 컨트롤 (cboBucketType 은 컨트롤 목록에 없음) | :394, :311 |
| 6 | `cboBucketType_SelectedIndexChanged` 배선 없음 — 사용 여부 | :311, :316 |
| 7 | `dtDayWeek`(LookupCommon) 의 LOOKUP 코드값과 바인딩 컨트롤(cboDayWeek 추정) | :49 |
| 8 | cboInputValue 의 데이터 원천 | 미추출 |
| 9 | `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` 내부 로직 | 미추출 |
| 10 | cboDivision / clbPlantSite 데이터 원천 SP | 엔드포인트 미추출 |
| 11 | `usrButton1`(parent 없음, 75×23)의 용도 | controls.csv :33 |
| 12 | chkSum 이 Designer 에서 Visible=false(:346) — 런타임에 다시 표시되는지 | props |
| 13 | SetSpreadColumn 의 W_ 이중 조건 구조 | :350, :355 |
| 14 | 권한(TB_FX_GroupMenuAuth 4행) 상세 값 | dbmeta CSV 별도 |
| 15 | SCP0096 SP 결과 컬럼 접두어(D_/W_/M_/B_) 체계와 SP 동적 PIVOT 컬럼 매핑 | SP DYNAMIC |

=== FILE: source_links.md ===
# SCP0096 — 소스 링크 표

경로 기준 루트: `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/`
- **CS** = `SCP0096_Shipment_Working_Day_OSP.cs`
- **DS** = `SCP0096_Shipment_Working_Day_OSP.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L49) | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] — Data.Common(LookupCommon) > Data.CallBizCommonData |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L51) | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` — Data.Common(YesOrNo) > Data.CallBizData |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L394) | GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L456) | FindData_Main | 456 | `SCP.SCP0019_GET_WORKING_TIME` — **주석 처리됨** |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L457) | FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L831) | GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L103) | .ctor | 103 | this.Load += Form_Load |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L249) | InitEvent | 249 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L250) | InitEvent | 250 | spdMain.TopChange += SpdMain_TopChange |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L251) | InitEvent | 251 | cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L252) | InitEvent | 252 | clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L253) | InitEvent | 253 | cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L254) | InitEvent | 254 | btnInput.Click += BtnInput_Click |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L255) | InitEvent | 255 | this.chkSum.CheckedChanged += chkSum_CheckedChanged |

## 3. Grid 구성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L142) | CreateSpread | 142 | AddSheet(spdMain, SpdSheet.shtMain, …, 3, 1, 35) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L143) | CreateSpread | 143 | GetSheetInfo(spdMain.Name, 0) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L144) | CreateSpread | 144 | ChangeSheet |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L151) | InitSpread | 151 | GetSpdTitle (SpreadInfo.GetSpdTitle — COLUMN_NAME, SORT_ORDER_NO) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L155) | InitSpread | 155 | InitSheet(SpdSheet.shtMain) — if(SheetName == "Shipment Working Day OSP") |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L156) | InitSpread | 156 | SetSheetHeaderColumn(siMain, 3) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L159) | InitSpread | 159 | InitSpreadDateColumn(spdInfo, nIdxDataMain = MEASURE+1) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L160) | InitSpread | 160 | SetSpreadColumn(siMain) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L196) | InitSpreadDateColumn | 196 | `B_` 포함 → AddTextColumn(너비 0, 숨김) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L203) | InitSpreadDateColumn | 203 | 그 외 → AddComboColumn(너비 50, dtValidYN, Center) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L208) | InitSpreadDateColumn | 208 | SAT=Blue / SUN=Red ForeColor |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L215) | InitSpreadDateColumn | 215~244 | ColumnHeaderSpan (Large/Small class, "SUM") |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L288) | EditButton | 288 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L311) | cboBucketType_SelectedIndexChanged | 311, 316 | SetSpreadColumn (배선 없음) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L330) | chkSum_CheckedChanged | 330, 335 | SetSpreadColumn |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L350) | SetSpreadColumn | 350 | D_/W_ → Visible = true |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L355) | SetSpreadColumn | 355 | M_/W_ → Visible = chkSum.Checked |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L484) | FindData_Main | 484 | if(GetMaxRowIndex() > 0) SetSpreadColumn |
| [DS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L628) | InitializeComponent | 628~631 | ColumnHeaderDefaultEnhanced 스타일(General 정렬, NoteIndicatorColor Red) |

## 4. 데이터·컨트롤 처리

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L121) | DefineProperty | 121 | chkSum.Checked = false |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L417) | SetChangedControl | 417, 425 | GetCheckedListValue |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L442) | FindData_Main | 442, 443 | GetCheckedListValue (조회 파라미터) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L558) | SaveData_Main | 558~581 | dr["A"], p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L600) | SaveData_Main | 600 | row["A"] |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L609) | SaveData_Main | 609 | GetChanges (FPExtensions — ROW_ID) |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L672) | CboDayWeek_SelectedIndexChanged | 672 | GetCheckedListValue |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L675) | CboDayWeek_SelectedIndexChanged | 675, 679 | cboInputValue.Enabled = false / true |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L695) | BtnInput_Click | 695, 696 | GetCheckedListValue |
| [CS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs#L815) | GetDayOfWeek | 815, 816 | row.Field("COLUMN_NAME"), dr["DAY_CODE"] |
| [DS](06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs#L663) | InitializeComponent | 663 | this.Text = "Shipment Working Day OSP" |

=== FILE: web_components.md ===
# SCP0096 — Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

| As-is 컨트롤 | 유형 | 라벨 (원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — | 1192×96, Dock Top, HidePanel | 조회조건 패널(접힘 지원) | |
| usrLayoutControl2 | UsrLayoutControl | — | 1192×96, Dock Fill | 조회조건 레이아웃 그리드 | |
| cboDivision | UsrCombo | Division* (layoutControlItem4) | 181×20 | 단일 선택 ComboBox | 필수(*) |
| clbPlantSite | UsrCheckedList | Plant Site (layoutControlItem7) | 165×21 | MultiSelect(CheckedList) | |
| dCalendar | UsrDateRangePicker3 | Period* (layoutControlItem2) | 210×22 | 기간(From~To) DateRangePicker | 필수(*) |
| cboDayWeek | UsrCombo | Day of the week (layoutControlItem3) | 134×20 | ComboBox | 원천은 dtDayWeek(LookupCommon) 추정 — 확인 필요 |
| cboInputValue | UsrCombo | Input Value (layoutControlItem1) | 124×20 | ComboBox | cboDayWeek 선택에 따라 Enabled 전환(:675/:679) |
| btnInput | UsrButton | Input (layoutControlItem10) | 77×21 | Button | 그리드 일괄 입력 |
| chkSum | UsrCheckBox | Sum (layoutSum) | 46×20, Visible=false, Checked=false | CheckBox | Designer 상 숨김 — 런타임 표시 여부 확인 필요 |
| usrButton1 | UsrButton | — | 75×23, parent 없음 | 확인 필요 | 용도 불명 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | — | 1192×553, Dock Fill | Wijmo FlexGrid (다단 헤더 3행) | |
| emptySpaceItem1~6, 9, 10 | EmptySpaceItem | — | — | 레이아웃 여백(구현 불필요) | |
| layoutControlGroup2 | LayoutControlGroup | — | 1192×96 | 레이아웃 그룹 | |

## 2. 화면 배치

- props.csv 에는 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 없음).
- 구성: 상단 `usrConditionPanel1`(Dock Top, 높이 96) / 하단 `spdMain`(Dock Fill, 높이 553).
- 상/하 비율: 96 : 553 ≈ **14.8% : 85.2%** (Designer 기준 크기, 폭 1192).
- 조회조건 행 구성: layoutControlItem 높이가 25/26 이고 그룹 높이가 96 이므로 여러 행으로 보입니다. 다만 Location 이 없어 **각 항목의 행·열 위치는 확인 필요**합니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day OSP`

연결 규칙: **META+코드연결** (CreateSpread:142 AddSheet → InitSpread:156 SetSheetHeaderColumn)

### 3-1. 메타 컬럼 (grid_effective 기준)

| 컬럼 | 라벨 | 출처 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DIVISION_ID | Division | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| PLANT_SITE_ID | Plant Site ID | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| PLANT_SITE_NAME | Plant Site | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| MEASURE | Measure | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| WORKING_TIME_DEFAULT | Working Time Default | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |
| LAST_INPUT_DATE | Last Input Date | META | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 | 기본 |

- 최종 표시 컬럼 수: 전 division **6** — division별 차이 없음.
- 순서(SORT_ORDER_NO), 너비, 편집 여부(CELL_CONTROL_OBJECT_TYPE_CODE), 고정(FIXED_FLAG)은 `dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv` 확인 필요.

### 3-2. 코드 동적 컬럼 (DB 루프 — SCP0009 결과)

| 조건 | 생성 | 너비 | 표시 | 셀 | 서식 |
|---|---|---:|---|---|---|
| COLUMN_NAME 에 `B_` 포함(index>0) | AddTextColumn | 0 | 숨김 | 텍스트 | — |
| 그 외 | AddComboColumn | 50 | 표시 | YesOrNo 콤보(dtValidYN) | 가운데 정렬, SAT=파랑·SUN=빨강 |

- 삽입 위치: MEASURE 컬럼 다음(`GetColumnIndex(MEASURE)+1`).
- 헤더 3행: 0행 = LARGE_CLASS_LABEL_NAME 병합, 1행 = SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더(1~2행 / 2행)
- 태그별 표시: `D_`·`W_` → 표시, `M_`·`W_` → `chkSum.Checked` 일 때만 표시 (W_ 최종 결과는 확인 필요)

## 4. 시트 연결 규칙

- 시트는 1개(`Shipment Working Day OSP`)이고 시트 간 연결(마스터-디테일)은 없습니다.
- `SpdMain_CellDoubleClick` 의 동작(팝업/디테일 여부)은 확인 필요합니다.

=== FILE: oracle_migration.md ===
# SCP0096 — Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 엔드포인트 | 호출 위치 | 참조 테이블 | EXEC 체인 / 특이 구문 |
|---|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | GetBucketType:394 (Form_Load) | SCM_ADM_LOOKUP_MASTER_DETAIL (SELECT) | 단독 |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle:831 (Load / 조회 / 저장 후 재조회) | SCM_SYS_CALENDAR_M (SELECT) | 단독 |
| `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | FindData_Main:457 (조회 / 저장 후 재조회) | SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT (SELECT) | INSERT `#TBLDYNAMICPIVOT_SCP0096`(임시테이블), `STRING_SPLIT`, 동적 SQL(DYNAMIC) |

주석 처리됨: `SCP0019_GET_WORKING_TIME`(:456) — 전환 대상이 아닙니다.

## 2. 공통코드 분기

| 엔드포인트 | code | 처리 | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | — | Data.CallBizData | 참조 테이블 없음 (고정값 여부 확인 필요) |

- LookupCommon 의 실제 LOOKUP 코드값은 확인 필요합니다.

## 3. FoxQuery 미등록 / 직접호출 SP

- 조회 계열 3개 SP는 모두 FoxQuery 상태가 **MATCH**입니다.
- 미등록·직접호출 SP는 Fact Pack에 없습니다.
- **저장 SP는 추출되지 않았습니다** — SaveData_Main 이 만드는 파라미터 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default` 를 받는 SP를 AS-IS 원문에서 확인해야 합니다(확인 필요).

## 4. Oracle 전환 확인 포인트

| # | 대상 | 포인트 | 근거 |
|---|---|---|---|
| 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `STRING_SPLIT`(MSSQL 전용) → Oracle 대체 필요(멀티선택 Plant Site 등 분해) | REF:STRING_SPLIT |
| 2 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `#TBLDYNAMICPIVOT_SCP0096` 로컬 임시테이블 → GTT 또는 대체 구조 | INSERT:#TBLDYNAMICPIVOT_SCP0096 |
| 3 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 동적 SQL(PIVOT 추정) → EXECUTE IMMEDIATE / OPEN FOR, 결과 컬럼명이 SCP0009 COLUMN_NAME(D_/W_/M_/B_ 접두어)과 일치해야 함 | DYNAMIC@, 코드 태그 비교 :350/:355/:196 |
| 4 | SCP0009_GET_SHEET_CALENDAR_3SPAN | 결과 컬럼 COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME 계약 유지. 코드가 `Rows[0][2]` 처럼 위치 인덱스로도 접근함 → 컬럼 순서 유지 필요 | InitSpreadDateColumn, grid_code :215 |
| 5 | DM0003_GET_BUCKET_TYPE_CODE | 단순 SELECT | — |
| 6 | 저장 SP | 미추출 — 원문 확보 후 변환 | 확인 필요 |

난이도 (사실 기준):
- **DM0003 / SCP0009: 낮음** — 단일 테이블 SELECT.
- **SCP0096: 높음** — 임시테이블, STRING_SPLIT, 동적 SQL, 5개 테이블 참조가 함께 있음.
- **저장 SP: 판단 불가** — 미추출.

=== FILE: tobe_design.md ===
# SCP0096 — TO-BE 설계 기초

## 1. 조회조건

| 컨트롤 | 라벨 | 필수 | 형태 | 비고 |
|---|---|---|---|---|
| cboDivision | Division* | Y (라벨 *) | 단일 콤보 | 데이터 원천 확인 필요. `CboDivision_SelectedIndexChanged` 연쇄 동작 확인 필요 |
| clbPlantSite | Plant Site | 확인 필요 | 멀티 체크리스트 | 값은 GetCheckedListValue 로 추출(FindData_Main:442/443) |
| dCalendar | Period* | Y (라벨 *) | 기간 From~To | SCP0009 달력 헤더와 연동 |
| chkSum | Sum | — | 체크박스 | Designer Visible=false, 기본 false. M_/W_ 컬럼 표시 토글 |

그리드 입력 보조(조회조건 영역에 있음): cboDayWeek(Day of the week), cboInputValue(Input Value), btnInput(Input).

## 2. 액션별 호출 API 후보

| 액션 | As-is 처리 | 호출 SP/엔드포인트 | TO-BE 후보 |
|---|---|---|---|
| 화면 로드 (`Form_Load`) | InitControls > GetBucketType, CreateSpread > InitSpread > GetSpdTitle | DM0003_GET_BUCKET_TYPE_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN | 콤보 조회 API + 달력 헤더 조회 API |
| 조회 (FindButton) | FindData_Main | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP + SCP0009_GET_SHEET_CALENDAR_3SPAN | 데이터 조회 API(동적 컬럼) + 헤더 API |
| 저장 (SaveButton) | SaveData_Main(GetChanges) → FindData_Main | 저장 SP 확인 필요 → 재조회 | 저장 API(변경행) + 재조회 |
| Edit (EditButton:288) | GetSheetInfo | — | 확인 필요 |
| Input (`BtnInput_Click`) | GetCheckedListValue(:695/:696) | 없음(클라이언트 처리) | 클라이언트 그리드 일괄 입력 |
| Day of week 변경 (`CboDayWeek_SelectedIndexChanged`) | cboInputValue Enabled 전환 | 없음 | 클라이언트 상태 |
| Sum 토글 (`chkSum_CheckedChanged`) | SetSpreadColumn | 없음 | 컬럼 visible 토글 |
| `SpdMain_CellDoubleClick` / `SpdMain_TopChange` | — | 확인 필요 | 확인 필요 |
| `ClbPlantSite_SelectedIndexChanged` / `CboDivision_SelectedIndexChanged` | — | 확인 필요 | 확인 필요 |

## 3. Division별 Grid 변형 요약

- 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 메타 6컬럼으로 같고, **변형이 없습니다**.
- 날짜 동적 컬럼은 Period 기준 SCP0009 결과로 생성됩니다(division 무관).

## 4. 권한(C/R/U/D) 관련 사실

- 메타 행: TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행.
- 그룹별 C/R/U/D 값은 Fact Pack 본문에 없습니다 → `dbmeta_dbo_TB_FX_GroupMenuAuth.csv` 확인 필요.
- 코드상 확인된 버튼 경로: FindButton(조회), SaveButton(저장), EditButton(:288).

## 5. 미확정 사항

1. 저장 SP 및 파라미터 계약(`p_is_save_defalut` 포함), 컬럼 "A" 의미
2. Bucket Type(DM0003) 결과의 사용처 — `cboBucketType` 컨트롤 부재
3. cboDivision / clbPlantSite / cboInputValue 데이터 원천
4. dtDayWeek LookupCommon 코드값과 cboDayWeek 바인딩 여부
5. chkSum 런타임 표시 여부, W_ 컬럼 최종 표시 규칙
6. SpdMain_CellDoubleClick / TopChange / CboDivision / ClbPlantSite 핸들러 로직
7. usrButton1 용도, 조회조건 행·열 배치
8. 메타 컬럼 순서·편집 속성(SCM_MST_SHEET_COLUMNS 원본)
9. 주석 처리됨: SCP0019_GET_WORKING_TIME — 현행 기능에서 제외
