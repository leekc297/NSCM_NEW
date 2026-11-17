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
