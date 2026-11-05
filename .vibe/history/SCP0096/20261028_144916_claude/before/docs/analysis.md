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
