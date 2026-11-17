=== FILE: analysis.md ===
# SSP0045 Shipment Request — As-is 분석

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0045). 이 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SSP0045 | Fact Pack |
| 화면명(Form Text) | `Shipment Request` | props.csv `this.Text` (Designer.cs:631) |
| 도메인 | SSP | 프로젝트 `GSCM.SSP.Plan.UIL` |
| 클래스 | `SSP0045_ShipmentRequest` | endpoints.csv |
| Grid 구성 방식 | `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)` | Fact Pack §11 |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 1468 |
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.Designer.cs` | `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj` | 684 |
| shared | 없음(추출 결과 0건) | - | - |
| legacy | 없음(추출 결과 0건) | - | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load (`Form_Load`) | Form_Load > InitControls > SetChangedControl | 268 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] | BIZ_MATCH | - |
| event:this.Load (`Form_Load`) | Form_Load > InitControls > GetBucketType | 279 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load (`Form_Load`) | Form_Load > CreateSpread > InitSpread_2 | 299 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | - |
| event:this.Load (`Form_Load`) | Form_Load > CreateSpread > GetDayRange | 647 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load (`Form_Load`) | Form_Load > CreateSpread > InitSpread_2 > GetSpdTitle | 1115 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:cboDivision.SelectedIndexChanged (`CboDivision_SelectedIndexChanged`) | CboDivision_SelectedIndexChanged > SetChangedControl | 268 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] | BIZ_MATCH | - |
| event:cboBizType.SelectedIndexChanged (`CboBizType_SelectedIndexChanged`) | CboBizType_SelectedIndexChanged | 413 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] | BIZ_MATCH | - |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 | 299 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | - |
| button:FindButton | FindButton > FindData_Main | 587 | `SSP.SSP0045_GET_SHIPMENT_REQUEST` | MATCH | SSP0045_GET_SHIPMENT_REQUEST |
| button:FindButton | FindButton > FindData_Main > InitSpread_2 > GetSpdTitle | 1115 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > SaveData | 944 | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` | MATCH | SSP0045_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 587 | `SSP.SSP0045_GET_SHIPMENT_REQUEST` | MATCH | SSP0045_GET_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData > FindData_Main > InitSpread_2 | 299 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | - |
| button:SaveButton | SaveButton > SaveData > FindData_Main > InitSpread_2 > GetSpdTitle | 1115 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |

흐름 요약(추출된 경로 기준):
- **로드**: `Form_Load` → InitControls(사업장/Operation 공통코드, Bucket 코드) → CreateSpread(시트 생성, 기간 범위 조회, 시트 헤더·달력 컬럼 생성).
- **조회**: FindButton → `FindData_Main` → 시트 재초기화(InitSpread_2: 공통코드 PlantSiteByDivision + 달력 3SPAN 헤더) → `SSP0045_GET_SHIPMENT_REQUEST`.
- **저장**: SaveButton → `SaveData` → `SSP0045_SAVE_SHIPMENT_REQUEST` → 저장 후 `FindData_Main` 재조회.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체(SP 내부 EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] | BIZ_MATCH | 2 | - (코드분기 `UP_FX_GetCommonDataList`) | SELECT:SCM_MST_SITE, REF:STRING_SPLIT |
| `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | BIZ_MATCH | 1 | - (코드분기 `UP_FX_GetCommonDataList`, `UP_FX_GetCommonDataList_SCP`) | SELECT:SCM_MST_SITE, REF:STRING_SPLIT |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SCM0001_GET_SCP_DAY_PERIOD | REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SELECT:SCM_SYS_CALENDAR_M |
| `SSP.SSP0045_GET_SHIPMENT_REQUEST` | MATCH | 1 | SSP0045_GET_SHIPMENT_REQUEST | 실테이블/뷰: SCP_PLAN_VERSION_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCP_MST_BOD_N_V, SCP_ANL_SHIPMENT_PLAN_SEMI, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_CONFIRM, RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, DM_PLN_SHIPMENT_REQ, SSP_DNM_SHIP_RESULT_OWMS_V, SSP_ANL_SHIP_PLAN_40, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCM_DNM_PLAN_FROZEN_V, SCM_MST_ITEM_SN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE / 함수: FN_NEXT_DAY, STRING_SPLIT, FN_LIST_LOOKUP_VALUE, FN_GET_ANL_SHIP_FROZEN_DAY_CNT / 임시테이블 다수(#TBLDYNAMIC_*, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #STOCK) / DYNAMIC@SSP0045_GET_SHIPMENT_REQUEST |
| `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` | MATCH | 1 | SSP0045_SAVE_SHIPMENT_REQUEST | EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, #TBLDYNAMIC_SSP0045_SHPIMENTREQ, UPDATE:A, SELECT/INSERT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ_H, INSERT:SCM_SYS_LOG_BATCH |

### 3-1. 주석 처리된 호출 (활성 기능 아님)
| 줄 | 값 | 상태 |
|---:|---|---|
| 834 | `SSP.PR_SCM_SYS_LOG_BATCH` | 주석 처리됨 (commented:MATCH) — 화면 코드에서의 직접 호출은 현행 기능이 아닙니다 |

> 참고: `PR_SCM_SYS_LOG_BATCH` 는 `SSP0045_SAVE_SHIPMENT_REQUEST` SP 내부 EXEC 체인에는 존재합니다(SP 내부 호출). 화면 834줄 호출은 주석 처리된 것이므로 둘을 구분해야 합니다.

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 위치 | 연산 |
|---|---|---|---|---|
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | Designer.cs InitializeComponent:177 | += |
| this | Load | `Form_Load` | .cs .ctor:148 | += |
| this.cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:400 | += |
| this.btnItem_Id | Click | `BtnItem_Id_Click` | InitEvent:401 | += |
| this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitEvent:402 | += |
| this.cboBizType | SelectedIndexChanged | `CboBizType_SelectedIndexChanged` | InitEvent:403 | += |
| this.spdMain | TopChange | `SpdMain_TopChange` | InitEvent:405 | += |
| this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:406 | += |
| this.spdMain | CellClick | `SpdMain_CellClick` | InitEvent:407 | += |
| this.spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:408 | += |
| spdMain | ComboSelChange | `SpdMain_ComboSelChange` | SpdMain_CellClick:1252 | -= (해제) |
| spdMain | ComboSelChange | `SpdMain_ComboSelChange` | SpdMain_CellClick:1334 | += (재등록) |

핸들러별 확인된 사실:
- `chkSum_CheckedChanged`(1130) / `cboBucketType_SelectedIndexChanged`(1125): `siMain != null` 이면 `SetSpreadColumn` 호출(컬럼 표시/숨김 재계산).
- `BtnItem_Id_Click`: 1198줄에서 `txtItem_Id.Text = sItemId` 설정. 팝업 종류는 **확인 필요**.
- `SpdMain_CellClick`: 1227·1228줄 `GetCheckedListValue` 호출, 1252줄에서 ComboSelChange 해제 후 1334줄에서 재등록.
- `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_ComboSelChange` 내부 동작: **확인 필요**(Fact Pack 미추출).

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

| 단계 | 메서드:줄 | 내용 |
|---|---|---|
| 시트 생성 | CreateSpread:286 | `AddSheet(spdMain, SpdSheet.shtMain(=Shipment Request), …, 3, 1, 35)` — 숫자 인자 3/1/35 의미는 **확인 필요** |
| 메타 헤더 | InitSpread_2:313 | `SetSheetHeaderColumn(siMain, 3)` — 헤더 3행, 메타 `SCM_MST_SHEET_COLUMNS` 기반 |
| 날짜 컬럼(DB 루프) | InitSpread_2:316 → InitSpreadDateColumn | `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과 행 루프: `B_` 포함 컬럼명은 `AddTextColumn`(폭 0, 숨김, 354줄), 그 외 `AddNumColumn`(폭 70, 표시, 358줄), SAT=Blue / SUN=Red 글자색(362줄), 3단 헤더 Span(대분류·소분류·"SUM", 368~396줄) |
| 버킷 표시 | InitSpread_2:318 → SetSpreadColumn(1140~1164) | 컬럼 Tag 접두어 `D_`/`W_`/`M_` 와 `cboBucketType`(DAILY/WEEKLY/MONTHLY), `chkSum.Checked` 로 Visible 결정 |

### 5-1. division별 차이
- 메타(§10): 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 `SCM_MST_SHEET_COLUMNS` 12/0, `SCM_MST_SHEET_MEASURE` 9/0 로 **동일**.
- 최종(§12): 모든 division 표시 컬럼 12개 **동일**. 코드에 division 분기 Grid 변경 없음(판단불가 0건).
- 단, SP `SSP0045_GET_SHIPMENT_REQUEST` 내부에 `#TBLDYNAMIC_SCP0045_40_STD`, `SSP_ANL_SHIP_PLAN_40` 참조가 있어 division 40 전용 데이터 처리 분기가 SP 내부에 있을 가능성이 있음 → **확인 필요**(분기 조건 미추출).

## 6. 기타 사실
- `drpPeriod.Enabled = false` (CreateSpread:291) — 기간은 사용자 편집 불가, `SCM0001_GET_SCP_DAY_PERIOD`(GetDayRange:647)로 설정되는 것으로 보이나 대입 코드는 **확인 필요**.
- `SetChangeControl:169~176`: `Filter[GROUP_ID]`, `UserInfoContext.Current.NowGroupID`, `Filter[USER_ID]` 사용 후 `GetSSPInnerTable` 호출.
- `InitControls:199, 201`: `FP_Log2` 호출(로그).
- `Set_SumValues:660`: 결과 테이블 `MEASURE` 컬럼 사용.
- `checkValidN0`(1396~1436): `dr`/`cpDr` 의 `p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_bod_id, p_project_code, p_fcst_type` (dr 는 `p_user_id` 추가) 읽음 — 저장 전 중복/유효성 검사로 보이나 판정 로직은 **확인 필요**.
- `InsertRow:772` / `InsertRow2:803`: `ITEM_ID` 셀을 `Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, false, cboDivision, cboBizType)` 결과로 콤보 설정.

## 7. 확인 필요 항목
| # | 항목 | 이유 |
|---|---|---|
| 1 | `Data_SCP.Common(BODItemProjectRoute)` 호출 | grid_code.csv 에만 존재, 엔드포인트 목록에 없음 → SP/테이블 미확인 |
| 2 | `InsertRow`/`InsertRow2` 진입 버튼 | 어떤 버튼(행추가 등)에서 호출되는지 미추출 |
| 3 | `EditButton`(449줄) 동작 | `fps.Name == "spdMain"` 조건의 GetSheetInfo 외 미추출 |
| 4 | SaveButton:527 `SaveData` 매핑 | 메타 소비 표에서 `PersonalSettingPopup.SaveData` 로 매핑됨 — 화면 자체 `SaveData`(944줄 SAVE SP 호출)와 이름 충돌로 인한 오매핑 가능성 |
| 5 | `usrButton1` (75×23, parent 없음) | 용도·텍스트 미추출 |
| 6 | SetSpreadColumn DAILY 분기 | `W_` 가 1140줄(true)·1144줄(chkSum.Checked) 조건에 모두 포함 — 실제 결과는 실행 확인 필요 |
| 7 | 측정값(Measure) 9행 내용 | `SCM_MST_SHEET_MEASURE` 9행 존재만 확인, 행 값 미첨부 |
| 8 | SP 내부 division 40 분기 | §5-1 참조 |
| 9 | `SpdMain_TopChange` / `SpdMain_CellDoubleClick` / `SpdMain_ComboSelChange` 내부 로직 | 미추출 |

=== FILE: source_links.md ===
# SSP0045 소스 링크 (파일·줄 기준)

> 경로 기준: AS-IS 소스 루트 하위 상대경로. `.cs` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs`, `Designer.cs` = `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | SetChangedControl | 268 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] (Data.Common → Data.CallBizCommonData) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | GetBucketType | 279 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 299 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | CboBizType_SelectedIndexChanged | 413 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | FindData_Main | 587 | `SSP.SSP0045_GET_SHIPMENT_REQUEST` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | GetDayRange | 647 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | SaveData | 944 | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | GetSpdTitle | 1115 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | (주석) | 834 | `SSP.PR_SCM_SYS_LOG_BATCH` — **주석 처리됨** |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | InsertRow | 772 | `Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, …)` → ITEM_ID 콤보 (엔드포인트 미해석, 확인 필요) |
| `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs` | InsertRow2 | 803 | 동일 (BODItemProjectRoute) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `…\SSP0045_ShipmentRequest.Designer.cs` | InitializeComponent | 177 | `chkSum.CheckedChanged += chkSum_CheckedChanged` |
| `…\SSP0045_ShipmentRequest.cs` | .ctor | 148 | `this.Load += Form_Load` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 400 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 401 | `btnItem_Id.Click += BtnItem_Id_Click` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 402 | `cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 403 | `cboBizType.SelectedIndexChanged += CboBizType_SelectedIndexChanged` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 405 | `spdMain.TopChange += SpdMain_TopChange` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 406 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 407 | `spdMain.CellClick += SpdMain_CellClick` |
| `…\SSP0045_ShipmentRequest.cs` | InitEvent | 408 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| `…\SSP0045_ShipmentRequest.cs` | SpdMain_CellClick | 1252 | `spdMain.ComboSelChange -= SpdMain_ComboSelChange` |
| `…\SSP0045_ShipmentRequest.cs` | SpdMain_CellClick | 1334 | `spdMain.ComboSelChange += SpdMain_ComboSelChange` |

## 3. Grid 정의 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `…\SSP0045_ShipmentRequest.cs` | CreateSpread | 286 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35)` |
| `…\SSP0045_ShipmentRequest.cs` | CreateSpread | 287~288 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)`, `ChangeSheet` |
| `…\SSP0045_ShipmentRequest.cs` | CreateSpread | 291 | `drpPeriod.Enabled = false` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 297 | `InitSheet(siMain.SheetName)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 302~303 | `drRow[CODE]`, `drRow[NAME]` (PlantSiteByDivision 결과) |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 310 | `GetSpdTitle` 호출 |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 313 | `SetSheetHeaderColumn(siMain, 3)` (메타) |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 316 | `InitSpreadDateColumn(spdInfo, spdInfo.nIdxData)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpread_2 | 318 | `SetSpreadColumn(spdInfo)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 354 | `AddTextColumn(label, name, None, 0, false)` — `B_` 컬럼 |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 358 | `AddNumColumn(label, name, None, 70, true)` |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 362 | SAT=Blue / SUN=Red ForeColor |
| `…\SSP0045_ShipmentRequest.cs` | InitSpreadDateColumn | 368~396 | `ColumnHeaderSpan` (대분류/소분류/"SUM") |
| `…\SSP0045_ShipmentRequest.cs` | EditButton | 449 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` (if fps.Name=="spdMain") |
| `…\SSP0045_ShipmentRequest.cs` | cboBucketType_SelectedIndexChanged | 1125 | `SetSpreadColumn(siMain)` |
| `…\SSP0045_ShipmentRequest.cs` | chkSum_CheckedChanged | 1130 | `SetSpreadColumn(siMain)` |
| `…\SSP0045_ShipmentRequest.cs` | SetSpreadColumn | 1140~1164 | 버킷/Sum 별 Columns[iCol].Visible |
| `…\SSP0045_ShipmentRequest.Designer.cs` | InitializeComponent | 580~583 | ColumnHeader 기본 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 데이터/메타 접근 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| `…\SSP0045_ShipmentRequest.cs` | SetChangeControl | 169~170 | `Filter[GROUP_ID]`, `UserInfoContext.Current.NowGroupID`, `Filter[USER_ID]` |
| `…\SSP0045_ShipmentRequest.cs` | SetChangeControl | 176 | `GetSSPInnerTable` |
| `…\SSP0045_ShipmentRequest.cs` | InitControls | 199, 201 | `FP_Log2` |
| `…\SSP0045_ShipmentRequest.cs` | SetChangedControl | 264 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | SaveButton | 527 | `SaveData` 호출 |
| `…\SSP0045_ShipmentRequest.cs` | FindData_Main | 565, 568, 570 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | Set_SumValues | 660 | `dsBinding.Tables[0].Columns["MEASURE"]` |
| `…\SSP0045_ShipmentRequest.cs` | InsertRow / InsertRow2 | 755 / 786 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | BtnItem_Id_Click | 1198 | `txtItem_Id.Text = sItemId` |
| `…\SSP0045_ShipmentRequest.cs` | SpdMain_CellClick | 1227, 1228 | `GetCheckedListValue` |
| `…\SSP0045_ShipmentRequest.cs` | checkValidN0 | 1396~1405 | `dr[p_division_id … p_fcst_type]` (p_user_id 포함) |
| `…\SSP0045_ShipmentRequest.cs` | checkValidN0 | 1413~1421 | `dr.Field<>(p_* )` |
| `…\SSP0045_ShipmentRequest.cs` | checkValidN0 | 1428~1436 | `cpDr.Field<>(p_* )` |

=== FILE: web_components.md ===
# SSP0045 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 화면 배치

| 영역 | 컨트롤 | Dock | Size | 비율(세로) |
|---|---|---|---|---:|
| 상단 조회조건 | `usrConditionPanel1` (PanelType=HidePanel) → `usrLayoutControl2`(Fill) | Top | 1129×75 | 약 11.6% (75/649) |
| 하단 Grid | `spdMain` (FpSpread) | Fill | 1129×574 | 약 88.4% (574/649) |

- SplitContainer 없음(props.csv 에 Orientation·SplitterDistance 미존재) → **상(조회조건)/하(Grid 단일)** 2단 구성.
- 조회조건 패널 PanelType = `HidePanel` (접기 가능 패널로 보임, TO-BE 동작은 확인 필요).

## 2. 컨트롤 → 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | Size | TO-BE 컴포넌트 후보 |
|---|---|---|---|---|---|
| cboBizType | UsrCombo | `Operation Group*` | lblCombo.Text | 145×20 | ComboBox (필수 표시) |
| cboDivision | UsrCombo | `Division*` | lblCombo1.Text | 162×20 | ComboBox (필수 표시) |
| cboBucketType | UsrCombo | `Bucket` | lblBucket.Text | 172×20 | ComboBox (값: DAILY/WEEKLY/MONTHLY — SetSpreadColumn 비교값) |
| txtItem_Id | UsrMultiLineEditor | `Model` | lblItemId.Text | 100×21 | 멀티라인 입력(다건 입력) |
| btnItem_Id | UsrButton | (텍스트 없음) | layoutControlItem4 | 39×25 | 검색 팝업 버튼 (Model 선택 → txtItem_Id 반영, 1198줄) |
| drpPeriod | UsrDateRangePicker | `Period*` | layoutControlItem6.Text | 207×20 | DateRange (Enabled=false, CreateSpread:291) |
| clbFromSite | UsrCheckedList | `From Site` | layoutControlItem3.Text | 151×21 | MultiSelect 체크 콤보 |
| chkSum | UsrCheckBox | `Sum` | 컨트롤 Text | 180×20 | CheckBox (변경 시 Grid 컬럼 표시 재계산) |
| usrButton1 | UsrButton | (미추출) | - | 75×23 | **확인 필요** (parent 없음) |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Shipment Request` | AddSheet | 1129×574 | Wijmo FlexGrid (3단 컬럼 헤더) |
| emptySpaceItem1/3 | EmptySpaceItem | - | - | 244×29 / 456×26 | 레이아웃 여백 |
| imageList1 | ImageList | - | - | - | 해당 없음 |

## 3. 시트별 Grid 컬럼 — `Shipment Request`

연결 규칙: **META+코드연결** (메타 시트를 코드가 AddSheet/ChangeSheet 로 사용). 헤더 3행(`SetSheetHeaderColumn(siMain, 3)`).

### 3-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS 18행, grid_effective 기준)

| # | 컬럼 | 라벨 | 소스 | 전 division(40/81/81_HD/81_HG/81_HM/81_ST/81_UC/82/EE/EE_HD/EE_HG/EE_HM/EE_ST/EE_UC) |
|---:|---|---|---|---|
| 1 | DIVISION_ID | Division* | META | 기본(표시) |
| 2 | FCST_TYPE | FCST Type | META | 기본 |
| 3 | FROM_SITE | From Site* | META | 기본 |
| 4 | INCOTERMS | Incoterms* | META | 기본 |
| 5 | ITEM_ID | Model* | META | 기본 (InsertRow 시 BODItemProjectRoute 콤보) |
| 6 | LAST_UPDATED_BY | Requestor | META | 기본 |
| 7 | LT_DAY | L/T(Day) | META | 기본 |
| 8 | MEASURE_LABEL | Measure | META | 기본 |
| 9 | NICK_NAME | Nick Name | META | 기본 |
| 10 | PROJECT_CODE | Project Code | META | 기본 |
| 11 | TO_SITE | To Site* | META | 기본 |
| 12 | TR_MODE | Trans Mode* | META | 기본 |
| 13 | BOD_FROM_YYYYMMDD | BOD_FROM_YYYYMMDD | META | 숨김 |
| 14 | BOD_ID | BOD_ID | META | 숨김 |
| 15 | BOD_TO_YYYYMMDD | BOD_TO_YYYYMMDD | META | 숨김 |
| 16 | FROZEN_YYYYMMDD | FROZEN_YYYYMMDD | META | 숨김 |
| 17 | MEASURE | Measure* | META | 숨김 |
| 18 | MEASURE_COLOR | MEASURE_COLOR | META | 숨김 |

- 표시 12 / 숨김 6. **division별 표시 차이 없음**(14개 division 모두 12).
- 메타 표 순서는 grid_effective.csv 순서(알파벳)이며, 실제 화면 표시 순서(SORT_ORDER)는 **확인 필요**.
- 측정값 메타 `SCM_MST_SHEET_MEASURE` 9행(전 division 9/0) — 측정값 이름은 미첨부, **확인 필요**.

### 3-2. 코드 생성 날짜 컬럼 (DB 루프, InitSpreadDateColumn)

| 조건 | API | 폭 | 표시 | 비고 |
|---|---|---:|---|---|
| 컬럼명에 `B_` 포함 (`IndexOf("B_") > 0`) | AddTextColumn | 0 | false | 354줄 |
| 그 외 | AddNumColumn | 70 | true | 358줄 |
| DAY_CODE = SAT | ForeColor Blue | - | - | 362줄 |
| DAY_CODE = SUN | ForeColor Red | - | - | 362줄 |

- 컬럼 원천: `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과의 COLUMN_NAME / COLUMN_LABEL_NAME / DAY_CODE / LARGE_CLASS_LABEL_NAME / SMALL_CLASS_LABEL_NAME.
- 헤더 3단 Span: 0행 = 대분류(LARGE_CLASS) 묶음, 1행 = 소분류(SMALL_CLASS) 묶음, 대분류·소분류 그룹 시작 열마다 `"SUM"` 헤더(368~396줄).

### 3-3. 버킷·Sum 에 따른 컬럼 표시 (SetSpreadColumn, 컬럼 Tag 접두어 기준)

| cboBucketType | Tag 조건 | Visible | 줄 |
|---|---|---|---:|
| DAILY | `D_` 또는 `W_` 로 시작 | true | 1140 |
| DAILY | `M_` 또는 `W_` 로 시작 | chkSum.Checked | 1144 |
| WEEKLY | `D_` | false | 1149 |
| WEEKLY | `W_` | true | 1152 |
| WEEKLY | `M_` | chkSum.Checked | 1156 |
| MONTHLY | `D_` 또는 `W_` | false | 1161 |
| MONTHLY | 그 외 | true | 1164 |

> DAILY 에서 `W_` 가 1140·1144 두 조건에 모두 해당 — 최종 값은 if/else 구조 실행 확인 필요.

### 3-4. 헤더 기본 스타일 (Designer.cs 580~583)
HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`.

## 4. 시트 연결 규칙
- 시트는 `Shipment Request` 1개(`SpdSheet.shtMain`). 마스터-디테일 연결 없음.
- 조회 시 `FindData_Main` 이 `InitSpread_2` 로 시트를 다시 초기화(메타 헤더 + 날짜 컬럼 재생성) 후 데이터 바인딩.
- `ITEM_ID` 셀: 행 추가(InsertRow/InsertRow2) 시 `Division`·`Operation Group` 조건의 BODItemProjectRoute 목록으로 콤보 셀 설정(시트 잠금이 아닐 때만).
- PlantSiteByDivision 결과(CODE/NAME, InitSpread_2:299~303)의 사용 컬럼(FROM_SITE/TO_SITE 콤보 여부)은 **확인 필요**.

=== FILE: oracle_migration.md ===
# SSP0045 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 호출 위치 | 참조 객체(EXEC 체인 포함) | 난이도(사실 근거) |
|---|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | GetBucketType:279 | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL | 낮음 — 단일 테이블 SELECT |
| `SCM0001_GET_SCP_DAY_PERIOD` | SCP.SCM0001_GET_SCP_DAY_PERIOD | GetDayRange:647 | FN_MULTY_TIME, SCM_SYS_CALENDAR_M, FN_WEEKOFDAY_DATE, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE | 중간 — 사용자 함수 2종 + CTE(`CTE_DATE`) |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle:1115 | SELECT:SCM_SYS_CALENDAR_M | 낮음 — 단일 테이블 SELECT |
| `SSP0045_GET_SHIPMENT_REQUEST` | SSP.SSP0045_GET_SHIPMENT_REQUEST | FindData_Main:587 | 실테이블/뷰 23종 + 함수 4종 + 임시테이블 다수 + 동적 SQL (아래) | 높음 — 임시테이블 ·동적 SQL·STRING_SPLIT·참조 객체 수 |
| `SSP0045_SAVE_SHIPMENT_REQUEST` | SSP.SSP0045_SAVE_SHIPMENT_REQUEST | SaveData:944 | PR_SCM_SYS_LOG_BATCH, SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, #TBLDYNAMIC_SSP0045_SHPIMENTREQ, UPDATE:A, DM_PLN_SHIPMENT_REQ(SELECT/INSERT), DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH | 중간 — 배열 분해 함수·임시테이블·별칭 UPDATE·이력 INSERT |

### 1-1. `SSP0045_GET_SHIPMENT_REQUEST` 참조 상세

| 분류 | 객체 |
|---|---|
| 테이블/뷰 SELECT | SCP_PLAN_VERSION_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCP_MST_BOD_N_V, SCP_ANL_SHIPMENT_PLAN_SEMI, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_CONFIRM, RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, DM_PLN_SHIPMENT_REQ, SSP_DNM_SHIP_RESULT_OWMS_V, SSP_ANL_SHIP_PLAN_40, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCM_DNM_PLAN_FROZEN_V, SCM_MST_ITEM_SN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE |
| 함수 | FN_NEXT_DAY, STRING_SPLIT, FN_LIST_LOOKUP_VALUE, FN_GET_ANL_SHIP_FROZEN_DAY_CNT |
| 임시테이블 | #TBLDYNAMIC_PLAN, #TBLDYNAMIC_SHIP_ROW, #TBLDYNAMIC_CAL_QTY, #TBLDYNAMIC_FILTER, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TBLDYNAMIC_PLAN_ERP_RESULT, #TBLDYNAMIC_SHIP_REQ, #TBLDYNAMIC_SHIP_REQ_OWMS_RESULT, #TBLDYNAMIC_SCP0045_40_STD, #STOCK, #TBLDYNAMIC_REQUESTOR, #TBLDYNAMIC_SHIP_PIVOT |
| 임시테이블 UPDATE | #TBLDYNAMIC_SHIP_ROW |
| 동적 SQL | DYNAMIC@SSP0045_GET_SHIPMENT_REQUEST (`#TBLDYNAMIC_SHIP_PIVOT` 존재 → 피벗 동적 SQL 로 보임, 확인 필요) |

> `RESULT_ERP_C_EXIST`, `RESULT_ERP_C_NON` 이 실테이블인지 CTE 이름인지 **확인 필요**.

## 2. 공통코드 분기 (CommonData.CommonDataList)

| code | 호출 위치 | 분기 SP | 테이블/함수 |
|---|---|---|---|
| PlantByDivisionOperation | SetChangedControl:268, CboBizType_SelectedIndexChanged:413 | UP_FX_GetCommonDataList | SCM_MST_SITE, STRING_SPLIT |
| PlantSiteByDivision | InitSpread_2:299 | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, STRING_SPLIT |

## 3. FoxQuery 미등록 / 직접 호출 SP
- FoxQuery 엔드포인트 5건 모두 **MATCH**(등록 확인). 미등록 0건.
- 직접 SQL 호출: 추출 결과 0건.
- 엔드포인트 미해석: `Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, …)` (InsertRow:772, InsertRow2:803) — 대상 SP/테이블 **확인 필요**.
- 주석 처리됨: 화면 834줄 `SSP.PR_SCM_SYS_LOG_BATCH` — 현행 기능 아님(전환 대상 아님). 단 `PR_SCM_SYS_LOG_BATCH` 는 SAVE SP 내부 EXEC 로 여전히 호출됨.

## 4. Oracle 전환 시 확인 포인트

| # | 대상 | 사실 | 확인 포인트 |
|---|---|---|---|
| 1 | `SSP0045_GET_SHIPMENT_REQUEST` | 임시테이블 12종(#) CREATE/INSERT/UPDATE | Oracle GTT 또는 WITH/컬렉션으로 대체 · GTT 사용 시 세션 시작 시 비우기 필요 여부 |
| 2 | `SSP0045_GET_SHIPMENT_REQUEST` | DYNAMIC SQL + #TBLDYNAMIC_SHIP_PIVOT | 동적 피벗 → Oracle 동적 SQL(EXECUTE IMMEDIATE/OPEN FOR)·컬럼 수 가변 결과셋 처리 |
| 3 | `SSP0045_GET_SHIPMENT_REQUEST`, UP_FX_GetCommonDataList(_SCP) | `STRING_SPLIT` 참조 | MSSQL 전용 — Oracle 문자열 분해 함수로 치환 |
| 4 | `SSP0045_GET_SHIPMENT_REQUEST` | `#TBLDYNAMIC_SCP0045_40_STD`, `SSP_ANL_SHIP_PLAN_40` | division 40 전용 분기 조건 확인 |
| 5 | `SSP0045_GET_SHIPMENT_REQUEST` | 함수 FN_NEXT_DAY, FN_LIST_LOOKUP_VALUE, FN_GET_ANL_SHIP_FROZEN_DAY_CNT | Oracle 동명 함수 존재·결과 동일 여부 |
| 6 | `SSP0045_SAVE_SHIPMENT_REQUEST` | SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 배열 문자열 분해 함수의 Oracle 대응 |
| 7 | `SSP0045_SAVE_SHIPMENT_REQUEST` | `UPDATE:A` (별칭 UPDATE) | MSSQL `UPDATE A … FROM` 형태 가능 → Oracle MERGE/서브쿼리 UPDATE 로 전환(원문 확인 필요) |
| 8 | `SSP0045_SAVE_SHIPMENT_REQUEST` | DM_PLN_SHIPMENT_REQ INSERT + DM_PLN_SHIPMENT_REQ_H 이력 INSERT | NOT NULL 컬럼·이력 키 일치 확인 |
| 9 | `SSP0045_SAVE_SHIPMENT_REQUEST` | EXEC PR_SCM_SYS_LOG_BATCH, INSERT SCM_SYS_LOG_BATCH | 로그 프로시저 Oracle 대응 존재 확인 |
| 10 | `SCM0001_GET_SCP_DAY_PERIOD` | CTE_DATE, FN_MULTY_TIME, FN_WEEKOFDAY_DATE | 재귀 CTE 여부 확인 → Oracle 재귀 WITH/CONNECT BY |
| 11 | `DM0003_GET_BUCKET_TYPE_CODE` | SCM_ADM_LOOKUP_MASTER_DETAIL 단일 조회 | 단순 전환 |
| 12 | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCM_SYS_CALENDAR_M 단일 조회 | 결과 컬럼(COLUMN_NAME/LABEL/DAY_CODE/LARGE·SMALL_CLASS) 유지 — 화면 날짜 컬럼 생성 계약 |

=== FILE: tobe_design.md ===
# SSP0045 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 필수 표시 | 데이터 원천(사실) | 비고 |
|---|---|---|---|---|
| Operation Group* | cboBizType | `*` | 원천 **확인 필요** | 변경 시 `CommonData.CommonDataList` [PlantByDivisionOperation] 호출(413줄) |
| Division* | cboDivision | `*` | 원천 **확인 필요** | 변경 시 SetChangedControl → [PlantByDivisionOperation](268줄) |
| Bucket | cboBucketType | - | `DM0003_GET_BUCKET_TYPE_CODE` (GetBucketType:279) | 코드 비교값 DAILY/WEEKLY/MONTHLY · 변경 시 Grid 컬럼 표시 재계산 |
| Model | txtItem_Id (+btnItem_Id) | - | 버튼 팝업 → `txtItem_Id.Text = sItemId`(1198줄) | 팝업 종류 **확인 필요** |
| Period* | drpPeriod | `*` | `SCM0001_GET_SCP_DAY_PERIOD` (GetDayRange:647) | `Enabled=false` (편집 불가) |
| From Site | clbFromSite | - | [PlantByDivisionOperation] 결과로 채워지는 것으로 보임 — **확인 필요** | 다중 선택(`GetCheckedListValue`) |
| Sum | chkSum | - | - | 변경 시 `M_`(및 DAILY 시 `W_`) 컬럼 표시 토글 |

조건 저장(TB_FX_SearchCondition 55행) 존재 — 저장 항목 상세는 **확인 필요**.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입 | 호출 순서 | API 후보 |
|---|---|---|---|
| 화면 로드 | `Form_Load` | 공통코드[PlantByDivisionOperation] → Bucket 코드 → 공통코드[PlantSiteByDivision] → 기간 범위 → 달력 헤더 | 공통코드 API, `DM0003_GET_BUCKET_TYPE_CODE`, `SCM0001_GET_SCP_DAY_PERIOD`, `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| Division 변경 | `CboDivision_SelectedIndexChanged` | 공통코드[PlantByDivisionOperation] | 공통코드 API |
| Operation Group 변경 | `CboBizType_SelectedIndexChanged` | 공통코드[PlantByDivisionOperation] | 공통코드 API |
| Bucket 변경 / Sum 체크 | `cboBucketType_SelectedIndexChanged` / `chkSum_CheckedChanged` | SetSpreadColumn (서버 호출 없음) | FE 처리 |
| Model 검색 | `BtnItem_Id_Click` | 팝업 | 팝업 API **확인 필요** |
| 조회 | FindButton → `FindData_Main` | 공통코드[PlantSiteByDivision] → 달력 3SPAN → `SSP0045_GET_SHIPMENT_REQUEST` | 조회 API (SSP0045_GET_SHIPMENT_REQUEST) |
| 저장 | SaveButton → `SaveData` | `checkValidN0` 검증(추정 위치) → `SSP0045_SAVE_SHIPMENT_REQUEST` → 재조회 | 저장 API (SSP0045_SAVE_SHIPMENT_REQUEST) |
| 행 추가 | InsertRow / InsertRow2 | ITEM_ID 콤보 = `Data_SCP.Common(BODItemProjectRoute, division, bizType)` | API **확인 필요** / 진입 버튼 **확인 필요** |
| 편집 | EditButton(449) | GetSheetInfo | 동작 **확인 필요** |
| 셀 클릭 | `SpdMain_CellClick` | GetCheckedListValue(1227·1228), ComboSelChange 해제(1252)→재등록(1334) | FE 처리 · 서버 호출 여부 **확인 필요** |
| 기타 Grid 이벤트 | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_ComboSelChange` | 미추출 | **확인 필요** |

저장 시 행 키 후보(checkValidN0 읽는 컬럼): p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_bod_id, p_project_code, p_fcst_type (+ dr 에만 p_user_id).

## 3. division별 Grid 변형 요약
- 시트 `Shipment Request` 단일. 메타 표시 12 / 숨김 6, **14개 division 모두 동일**.
- 코드의 컬럼 변경은 division 이 아니라 **Bucket(DAILY/WEEKLY/MONTHLY)·Sum 체크** 기준.
- 날짜 컬럼은 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과로 동적 생성(3단 헤더, SAT 파랑/SUN 빨강, `B_` 컬럼 숨김).
- SP 내부 division 40 전용 처리 흔적(`SSP_ANL_SHIP_PLAN_40`, `#TBLDYNAMIC_SCP0045_40_STD`) — 결과 컬럼 차이 여부 **확인 필요**.

## 4. 권한(C/R/U/D) 관련 사실
- `TB_FX_GroupMenuAuth` 11행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행 존재 — 권한 값(C/R/U/D 플래그) 내용은 미첨부, **확인 필요**.
- 화면 코드: `SetChangeControl` 에서 `Filter[GROUP_ID]`, `NowGroupID`, `Filter[USER_ID]` 사용 후 `GetSSPInnerTable` 호출 — 그룹/사용자 기준 필터 적용 사실만 확인.
- 행 추가 시 `siMain.IsLock(siMain.SheetName) == false` 조건 — 시트 잠금 시 ITEM_ID 콤보 미설정.
- `TB_FX_Favorite` 14행(즐겨찾기) 존재.

## 5. 미확정 사항
| # | 항목 |
|---|---|
| 1 | `usrButton1` 용도, `InsertRow`/`InsertRow2`/`EditButton` 진입 버튼 |
| 2 | `BODItemProjectRoute` 데이터 원천 SP |
| 3 | Operation Group·Division 콤보 데이터 원천, From Site 목록 원천 |
| 4 | Period 값 설정 방식(SCM0001 결과 → drpPeriod 대입 코드) |
| 5 | DAILY 버킷에서 `W_` 컬럼 최종 표시 여부 |
| 6 | 측정값(SCM_MST_SHEET_MEASURE 9행) 목록·순서, 메타 컬럼 표시 순서 |
| 7 | SaveButton:527 `SaveData` 의 프레임워크 매핑(PersonalSettingPopup.SaveData) 오매핑 여부 |
| 8 | 권한 C/R/U/D 실제 값 |
| 9 | SP 내부 division 40 분기, `RESULT_ERP_C_EXIST/NON` 객체 성격 |
