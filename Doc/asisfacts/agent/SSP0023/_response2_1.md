=== FILE: business_analysis.md ===
# SSP0023 Shipment Plan(Electrode) — 업무분석서

> **근거 범위**: 이 문서는 AsisFacts 정적 추출 Fact Pack(SSP0023)과 1차 분석서(analysis.md · web_components.md · tobe_design.md)만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> **기준 소스**: current 사본 `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.cs`(6,823줄)와 같은 폴더의 `.Designer.cs`(2,382줄)입니다. legacy 사본(`06.UIL\GSCM.SSP.Plan.UIL\…`, 6,730줄)과 93줄이 다르며, 어떤 내용이 다른지는 확인 필요입니다.
> **주석 처리된 호출**은 0건입니다(Fact Pack §9). 아래 호출은 모두 활성 코드에서 추출했습니다. 그중 진입점이 연결되지 않은 호출(unreached)은 따로 표시했습니다.
> 관련 문서: 화면설계서 §5 액션 명세 · 단위테스트 근거 열은 이 문서 §5와 같은 엔드포인트 이름을 씁니다.

---

## 1. 업무 목적·범위

### 1-1. 목적 (Fact Pack에서 읽을 수 있는 범위)
- 전극(Electrode) 품목의 **출하계획(Shipment Plan)** 을 Measure 행 × 날짜 버킷(일·주·월) 피벗으로 조회합니다(`SSP.SSP0023_GET_SHIPMENT_PLAN`, 시트 `Shipment Plan(Electrode)`).
- 출하계획 상세, 재고 상세, 출하 실적을 조회합니다(`Shipment Plan Detail`, `Stock Detail`, `Shipment Result`).
- 출하 확정(Confirm)을 저장합니다(`SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`). 저장할 때 변경요청(Drafting) 생성, ERP I/F 테이블(`XIF_ERP_SHIP_PLAN_CONFIRM_S_SN`) 적재, 메일 발송 요청(`SSP_MST_SEND_MAIL_REQ`), DM 동기화(`PR_DM_SSP_CONFIRM_SYNC`)가 이어서 실행됩니다.
- 출하계획 시뮬레이션 값을 저장합니다(`SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU`, `SSP_ANL_SHIP_PLAN_SIMU_EE` INSERT · `SSP_ANL_SHIP_PLAN_EE` MERGE).
- 엑셀 양식을 다운로드하고(`SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL`, 시트 `Shipment Plan Detail Excel`) 업로드합니다. 업로드의 서버 처리 엔드포인트는 Fact Pack에 없어 **확인 필요**입니다.
- 업무 목적을 설명하는 문장(업무 정의서·요건)은 Fact Pack에 없습니다. 위 목적은 호출되는 SP와 쓰기 테이블에서 읽은 것입니다.

### 1-2. 범위
| 구분 | 포함 | 비고 |
|---|---|---|
| 시트 | `Shipment Plan(Electrode)`, `Shipment Plan Detail`, `Stock Detail`, `Shipment Result`, `Shipment Plan Detail Excel` | 5개 |
| 엔드포인트 | 18종, 호출 지점 24곳(endpoints.csv) | 모두 FoxQuery(`fox`) 경유이며 상태는 MATCH |
| 진입점 미연결 | `NewNonSoNo`(3645), `GetErpIFCheckNew_`(4195), `GetErpIFCheck`(4251) | 정적 분석상 현행 화면에서 실행되지 않음 |
| 메뉴 위치 | 확인 필요 | TB_FX_MenuItemInfo 2행의 내용은 Fact Pack에 없음 |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 → 메서드 → 엔드포인트) | 결과 |
|---:|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` → InitControls → GetBucketType → `DM.DM0003_GET_BUCKET_TYPE_CODE` / CreateSpread → InitSpread → GetSpdTitle → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | Bucket 콤보가 채워지고, 날짜 3단 헤더 그리드가 만들어집니다 |
| S2 | Company를 바꿉니다 | `clbCompanyID_SelectedIndexChanged` → InitSpread → GetSpdTitle → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN`. 실행 중에는 `cboPlanDate_SelectedIndexChanged` 배선을 떼었다가(5776) 다시 붙입니다(5780) | 그리드 헤더를 다시 만들고 Plan-date를 다시 구성합니다 |
| S3 | Plan-date를 바꿉니다 | `cboPlanDate_SelectedIndexChanged` → GetSpdTitle → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN`. CODE, FROM_DATE, TO_DATE를 읽습니다 | 날짜 헤더가 다시 구성됩니다 |
| S4 | Division을 바꿉니다 | `clbDivision_ID_SelectedIndexChanged`. DIVISION_ID로 필터합니다 | 하위 선택값이 필터됩니다(대상 컨트롤은 확인 필요) |
| S5 | 조회(Find)를 누릅니다 | FindButton → FindData_Main → `SSP.SSP0023_GET_SHIPMENT_PLAN` (+ InitSpread → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN`) | spdMain(`Shipment Plan(Electrode)`)에 결과를 바인딩합니다 |
| S6 | UOM Type 라디오를 바꿉니다 | `rdButton_Changed`(4420–4452), SetSpreadColumn(4479–4625) | BOH 3세트 중 1세트와 날짜 컬럼 접두어 X_/Y_/Z_ 중 1종만 표시합니다. 재조회는 없습니다 |
| S7 | Bucket, Sum, Including Past Period를 바꿉니다 | `cboBucketType_SelectedIndexChanged`, `chkSum_CheckedChanged`, `chkPastPeriod_CheckedChanged` | 날짜 컬럼 Visible이 바뀝니다(§4-3). 핸들러 본문이 SetSpreadColumn을 호출하는지는 확인 필요 |
| S8 | Measure를 고릅니다 | `BtnMeasure_Click` → InitSpread → GetSpdTitle → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 그리드를 다시 만듭니다 |
| S9 | 메인 그리드 셀을 더블클릭합니다 | `SpdMain_CellDoubleClick` → FindData_Detail → `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | spdDetail을 `Shipment Plan Detail`로 전환하고 상세를 조회합니다(1차 분석서: Measure `P_SHIP_CONFIRM_ETD` 행의 날짜 셀, ChangeSheet/ChangeActiveSheet 1798–1799) |
| S10 | 하단 조건을 넣고 btnSearch를 누릅니다 | `BtnSearch_Click` → FindData_Detail `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` / FindData_Stock_Detail `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` / FindData_ShipmentResult `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` (+ CALENDAR_3SPAN) | 3개 시트를 조회합니다. 탭별로 하나만 호출하는지 3개 모두 호출하는지는 확인 필요 |
| S11 | 상세 탭을 전환합니다 | `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged` | SheetTabIndex 0/1/2가 Detail/Stock/Result에 대응합니다(1차 분석서) |
| S12 | 상세에서 Building, Package 등을 편집합니다 | `SpdDetail_CellClick`(FACTORY_ID 셀 클릭 시 Building 콤보를 동적으로 만듦, 1718), `SpdDetail_ComboSelChange`, `SpdDetail_EditChange`, `SpdDetail_ClipboardPasted` | 편집값이 변경 행으로 반영됩니다 |
| S13 | 편집(Edit)을 누릅니다 | EditButton → GetSSPUserCheck → `SSP.SSP0002_GET_USER_INFO_LIST` | 사용자 권한을 확인합니다(판정 기준은 확인 필요) |
| S14 | 저장(Save)을 누릅니다 | SaveButton → SaveData_Detail → `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`(2435 / 2643) → GetERPInterface 체인(§3) → FindData_Main/FindData_Detail 재조회 | 확정을 저장하고 변경요청과 ERP I/F를 처리한 뒤 재조회합니다 |
| S15 | Simulation을 누릅니다 | `BtnSimulation_Click` → Simulation → `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` → `SSP.SSP0023_GET_SHIPMENT_PLAN` → `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | 시뮬레이션 값을 저장하고 재조회합니다 |
| S16 | Excel Form을 누릅니다 | `btnExcelFormDownload_Click` → FindData_Plan_Detail_DownLoad → `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` (+ CALENDAR_3SPAN) | spdSub(`Shipment Plan Detail Excel`) 양식을 내보냅니다(ExportExcel 6668/6710) |
| S17 | Upload를 누릅니다 | `btnExcelUpload_Click` → (업로드 처리는 확인 필요) → FindData_Main `SSP.SSP0023_GET_SHIPMENT_PLAN` → FindData_Detail `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | 업로드 후 Main과 Detail을 재조회합니다 |
| S18 | Material, Requestor 팝업을 엽니다 | `btnItemId_Click`, `BtnMaterialId2_Click`, `BtnRequestor_Click` | 팝업의 종류와 반환값은 확인 필요 |
| S19 | 메인 그리드에 붙여넣거나 편집합니다 | `spdMain_ClipboardPasted`(키: DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID — 1219–1225), `SpdMain_Change`, `SpdMain_TopChange` | 처리 내용은 확인 필요. Simulation 입력과의 관계도 확인 필요 |
| S20 | (데이터 변경 이벤트) | `shtPlanDetail_Change` (`dsdm.Changed`, InitEvent:818) | `dsdm`이 무엇인지와 처리 내용은 확인 필요 |

---

## 3. 업무 흐름도 (텍스트 단계)

### 3-1. 조회 흐름
```
[Form_Load]
  ├─ InitControls ─ GetBucketType ─▶ DM.DM0003_GET_BUCKET_TYPE_CODE
  │                 (dtShipmentInputPeriod VALUE/Diff_VALUE, dtCompany CODE 사용 — 출처 확인 필요)
  └─ CreateSpread ─ InitSpread ─ GetSpdTitle ─▶ SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN
                    └ SetSheetHeaderColumn ×5 (META) + InitSpreadDateColumn (DB 루프)
[조건 변경] Company ▶ InitSpread ▶ CALENDAR_3SPAN / Plan-date ▶ GetSpdTitle ▶ CALENDAR_3SPAN
[FindButton] ─ FindData_Main ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN ─ InitSpread ▶ CALENDAR_3SPAN
[spdMain 더블클릭] ─ FindData_Detail ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL
[btnSearch] ─┬ FindData_Detail ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL
             ├ FindData_Stock_Detail ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL
             └ FindData_ShipmentResult ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT ─ InitSpread ▶ CALENDAR_3SPAN
```

### 3-2. 저장 흐름 (SaveButton)
```
1. SaveData_Detail
   ├ (화면 검증) Validation_Check / ChangeData_Check / ChangeNotSendERP_Check   ← 호출 순서·조건 확인 필요
   ├ GetCheckedListValue (SaveData_Detail:2337)
   ├ ▶ SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM  (2435)
   └ ▶ SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM  (2643)   ← 두 호출의 분기·파라미터 차이 확인 필요
2. GetERPInterface
   ├ ChkConfirmChangeTime ▶ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME (6779)
   ├ GetShipmentStatusChk ▶ SSP.SSP0023_GET_SHIPMENT_STATUS (3459)  — Tables[0..2].CONFIRM_ID 사용
   ├ GetErpSoNoCnt        ▶ SSP.SSP0023_GET_ERP_SO_NO_CNT (3524)    — Tables[0].Rows[0].CNT 사용
   ├ ▶ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM (3278)
   ├ ▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (3319)
   ├ NonSoNo ▶ SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING (3846)
   └ SoNo    ▶ SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING (4081)
              └ GetErpIFCheckNew ├ ▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (4329)
                                 ├ ▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH (4355)
                                 └ ▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH (4385)
   (chkERPIFBlockYn: dtERPBlockYnIF.Rows[0] BLOCK_YN, PERIOD — 데이터 출처·호출 위치 확인 필요)
3. 재조회: FindData_Main ▶ SSP.SSP0023_GET_SHIPMENT_PLAN / FindData_Detail ▶ SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL ▶ CALENDAR_3SPAN
```
- 위 단계 번호는 flow.csv의 호출 경로 관계를 나타냅니다. **실행 순서와 분기 조건(SoNo/NonSoNo를 고르는 기준, CHG_BATCH를 2번 호출하는 조건)은 Fact Pack에 없으므로 확인 필요**입니다.

### 3-3. 시뮬레이션·엑셀 흐름
```
[btnSimulation] ─ Simulation ─▶ SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL
[formDown]      ─ FindData_Plan_Detail_DownLoad ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL ─ ExportExcel
[btnExcelUpload]─ (업로드 처리 확인 필요) ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN ─▶ SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL
```

---

## 4. 업무 규칙 (사실 근거)

### 4-1. 필수 조건 (라벨의 `*` 표기 기준, props.csv Text 원문)
| 조건 | 컨트롤 | 근거 |
|---|---|---|
| `Company*` | clbCompany_ID | layoutControlItem1 Text |
| `Division*` | clbDivision_ID | lblCombo1 Text |
| `Plan-date*` | cboPlanDate | PlanDate Text |
| `Period*` | drpPeriod | layoutControlItem6 Text. Designer에서 `Enabled=false` |
- 필수값이 비었을 때 표시하는 메시지 원문은 Fact Pack에 없어 **확인 필요**입니다.

### 4-2. 저장 검증 규칙 (검사 대상 컬럼만 사실, 조건과 메시지는 확인 필요)
| 검증 메서드 | 대상 | 컬럼 |
|---|---|---|
| Validation_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type, dom_exp |
| Validation_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |
| ChangeData_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type |
| ChangeNotSendERP_Check | Validationdr / SONoValidationdr | 위와 같음 (SONo 쪽은 5컬럼) |
| 공통 | row | confirm_id |
- 그리드 라벨에 `*`가 붙은 필수 컬럼(`Shipment Plan Detail`): `Confirm Qty*`(SHIPMENT_CONFIRM_QTY), `Shipment Date*`(SHIPMENT_DATE), `Trans Mode*`(TRANSPORT_MODE), `Building Desc.*`(FACTORY_ID), `Package Type *`(PACKAGE_TYPE).
- SO No가 있는 행(SONoValidationdr)은 factory_id, package_type, dom_exp를 검사하지 않는 것으로 컬럼 목록에서 읽힙니다. 실제 의도는 확인 필요입니다.

### 4-3. 날짜·버킷 표시 규칙 (SetSpreadColumn 4479–4642)
| UOM Type | 사용하는 접두어 | 숨기는 접두어 |
|---|---|---|
| rdButton1 `UOM` | X_ | Y_, Z_ |
| rdButton2 `Cell` | Y_ | X_, Z_ |
| rdButton3 `Pancake m` | Z_ | X_, Y_ |

| Bucket(cboBucketType.ControlValues) | `_D_` (일) | `_W_` (주) | `_M_` (월) |
|---|---|---|---|
| DAILY | 표시 | chkSum.Checked를 따름 (4491에서 표시 후 4496에서 chkSum으로 덮어씀) | chkSum.Checked를 따름 |
| WEEKLY | 숨김 | 표시 | chkSum.Checked를 따름 |
| MONTHLY | 숨김 | 숨김 | 표시 |
- **과거 기간**: `chkPastPeriod`가 꺼져 있으면, 헤더 3번째 행(Cells[2,iCol]) 값이 `SUM`이 아니고 `date > colDate`인 컬럼을 `chkPastPeriod.Checked` 값(false)으로 숨깁니다(4642).
- **날짜 컬럼 생성**(InitSpreadDateColumn 738/744): `dsSpdTitle`(= `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 결과)을 돌며 컬럼을 만듭니다. 컬럼명에 `B_`가 있으면 AddTextColumn, 그 외에는 AddNumColumn을 씁니다(1차 분석서: 폭 100, 우측 정렬, 소수 3자리, `B_` 텍스트 컬럼은 숨김).
- **주말 색상**(747): DAY_CODE가 `SAT`이면 파랑, `SUN`이면 빨강 글자색입니다.

### 4-4. BOH 컬럼 표시 규칙 (InitSpread 597–629, rdButton_Changed 4420–4452)
| 라디오 | 표시 | 숨김 |
|---|---|---|
| rdButton1 (UOM, 기본 Checked) | TOT_BOH_QTY, JR_BOH_QTY, PC_BOH_QTY | *_CELL, *_PCM |
| rdButton2 (Cell) | TOT_BOH_QTY_CELL, JR_BOH_QTY_CELL, PC_BOH_QTY_CELL | 기본, *_PCM |
| rdButton3 (Pancake m) | TOT_BOH_QTY_PCM, JR_BOH_QTY_PCM, PC_BOH_QTY_PCM | 기본, *_CELL |
- InitSpread에서는 `spdInfo.SheetName == "Shipment Plan(Electrode)"`일 때만 적용합니다. rdButton_Changed에는 시트 조건이 없어 적용 대상 시트가 확인 필요입니다.
- rdButton3에는 CheckedChanged 배선이 없습니다(events.csv). 그룹 라디오라서 rdButton1/2의 해제 이벤트로 핸들러가 실행되는지는 확인 필요입니다.

### 4-5. 상세 편집 규칙
- `SpdDetail_CellClick`: `siDetail.IsLock(SheetName) == false`일 때만 편집 동작을 합니다. 헤더 CheckBox를 클릭하면 전체 행 값을 반전합니다(1727/1755/1759). FACTORY_ID 셀을 클릭하면 Building 콤보를 동적으로 만듭니다(1718, 1차 분석서). 콤보 데이터는 GetCheckedListValue(1691)와 CODE/NAME을 씁니다.
- ERP I/F 차단: `chkERPIFBlockYn`이 BLOCK_YN과 PERIOD를 확인합니다. 차단 시 동작과 데이터 출처는 확인 필요입니다.

### 4-6. SP 내부 분기
- SP 본문의 분기 조건은 Fact Pack에 없습니다. 참조 객체만 있습니다. 예를 들어 `SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`은 `#T_CONFIRM_ID` 등 임시테이블을 만들고, `DELETE:A`(별칭 삭제)와 `DM_PLN_MKT_FCST_CONFIRM` INSERT를 합니다. 이 SP의 조건 로직은 **SP 원문 확인 필요**입니다.
- `SSP0023_GET_SHIPMENT_PLAN_DETAIL`과 `SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`은 동적 SQL(DYNAMIC)이라 정적 참조 테이블이 추출되지 않았습니다.

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기)

| # | 엔드포인트 | SP | 호출 위치(메서드:줄) | 읽기(SELECT) | 쓰기(INSERT/UPDATE/DELETE/MERGE) · EXEC |
|---:|---|---|---|---|---|
| 1 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:4656 | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 2 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | `SSP0023_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:5921 | SCM_SYS_CALENDAR_M | — |
| 3 | `SSP.SSP0023_GET_SHIPMENT_PLAN` | `SSP0023_GET_SHIPMENT_PLAN` | FindData_Main:4732 | SCM_MST_TITLESET_USER, SCM_SYS_CALENDAR_M, SSP_ANL_BOH_CUTOFF_EE, SSP_ANL_SHIP_PLAN_EE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_SHIP_REQ_EE, SSP_MST_SITE_ITEM_EE_V, SSP_DNM_FP_MRP_INTRANSIT_SN, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SSP_DNM_SHIP_RESULT_OWMS_V, SCM_MST_SHEET_MEASURE | 임시테이블만 INSERT(#TBLDYNAMICTITLEST_SSP0023, #TMP_SSP0023_* 등), DYNAMIC SQL. 함수 FN_GET_ANL_SHIP_FROZEN_DAY_CNT, STRING_SPLIT |
| 4 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | `SSP0023_GET_SHIPMENT_PLAN_DETAIL` | FindData_Detail:5357 | 동적 SQL(정적 추출 안 됨) — 확인 필요 | FN_GET_IN_STR, FN_SCM_SPLIT |
| 5 | `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` | `SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` | FindData_Stock_Detail:5468 | 동적 SQL(정적 추출 안 됨) — 확인 필요 | — |
| 6 | `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` | `SSP0023_GET_SHIPMENT_PLAN_RESULT` | FindData_ShipmentResult:5585 | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_SITE_ITEM_EE_V, SSP_MST_DELEGATE, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_MST_ITEM_SN (RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS는 CTE로 보이며 확인 필요) | FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION |
| 7 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | `SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | FindData_Plan_Detail_DownLoad:6505 | SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_PLAN_EE | — |
| 8 | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` | `SSP0023_SAVE_SHIPMENT_PLAN_SIMU` | Simulation:6027 | SSP_ANL_SHIP_PLAN_EE | INSERT SSP_ANL_SHIP_PLAN_SIMU_EE, SCM_SYS_LOG_BATCH / MERGE SSP_ANL_SHIP_PLAN_EE / EXEC SP_EXECUTESQL, PR_SCM_SYS_LOG_BATCH |
| 9 | `SSP.SSP0002_GET_USER_INFO_LIST` | `SSP0002_GET_USER_INFO_LIST` | GetSSPUserCheck:6805 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — |
| 10 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` | `SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` | SaveData_Detail:2435, 2643 | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_MST_SITE_ITEM_EE_V, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_MST_SEND_MAIL_REQ, SSP_PLAN_VERSION_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, NERP_CONV_MASTER, TB_FX_USER, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER_EE, DM_PLN_MKT_FCST_CONFIRM | INSERT/UPDATE SSP_ANL_SHIP_CONFIRM / INSERT SSP_ANL_SHIP_CONFIRM_H, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_MST_SEND_MAIL_REQ, DM_PLN_MKT_FCST_CONFIRM, SCM_SYS_LOG_BATCH / UPDATE SSP_MST_SEND_MAIL_REQ / DELETE A(별칭) / EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_MAIL_SEND_ADJUST_SUB, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SCM_SYS_LOG_BATCH(_CALL_TRAN) |
| 11 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | `SCM_SSP_CHECK_CONFIRM_CHANGETIME` | ChkConfirmChangeTime:6779 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH |
| 12 | `SSP.SSP0023_GET_SHIPMENT_STATUS` | `SSP0023_GET_SHIPMENT_STATUS` | GetShipmentStatusChk:3459 | SSP_ANL_SHIP_CONFIRM | — (STRING_SPLIT) |
| 13 | `SSP.SSP0023_GET_ERP_SO_NO_CNT` | `SSP0023_GET_ERP_SO_NO_CNT` | GetErpSoNoCnt:3524 | SSP_ANL_SHIP_CONFIRM | — |
| 14 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | GetERPInterface:3278 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 15 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | GetERPInterface:3319, GetErpIFCheckNew:4329 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | DELETE/UPDATE SSP_ANL_SHIP_CONFIRM / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 16 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | `SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | NonSoNo:3846, SoNo:4081 (+ unreached NewNonSoNo:3645) | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH |
| 17 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | GetErpIFCheckNew:4355, 4385 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SCP_SYS_LOG_BATCH |
| 18 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | **unreached** GetErpIFCheckNew_:4195, GetErpIFCheck:4251 | — | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |

- 18번은 진입점이 없는 메서드에서만 호출되어 정적 분석상 현행 화면에서는 실행되지 않습니다. TO-BE로 옮길지는 §8에서 결정할 항목입니다.

---

## 6. Division·권한별 변형

### 6-1. Division
- 메타 규칙 전개(Fact Pack §10)와 최종 Grid(§12) 모두에서 **14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 컬럼 수가 같습니다.**

| 시트 | 메타(필수+기본/선택) | 최종 표시 (?=런타임 분기) |
|---|---|---|
| `Shipment Plan(Electrode)` | 19/0 (+SCM_MST_SHEET_MEASURE 11/0) | 13 (?9) |
| `Shipment Plan Detail` | 41/0 | 44 (?9) |
| `Shipment Plan Detail Excel` | 6/0 | 9 (?9) |
| `Shipment Result` | 17/0 | 20 (?9) |
| `Stock Detail` | 28/0 | 31 (?9) |
- 코드 분기에도 division 변수를 비교하는 곳이 없습니다. 판단불가 2,268건은 모두 "런타임:화면컨트롤값"으로 분류됩니다. **Division별 Grid 변형은 없습니다.**
- `clbDivision_ID_SelectedIndexChanged`는 DIVISION_ID로 하위 목록을 필터합니다. SetChangedControl에서도 CODE와 DIVISION_ID를 씁니다.

### 6-2. 권한
| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행(행 내용 확인 필요) |
| 편집 권한 | EditButton → GetSSPUserCheck → `SSP.SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 참조) |
| 그룹 필터 | SetChangeControl:341–342에서 Filter GROUP_ID/USER_ID와 `UserInfoContext.Current.NowGroupID`를 씀. InitControls:462에서도 NowGroupID를 씀 |
| 모델 담당 필터 | `chkMyModel`, `chkDelegateeModel`, `chkTeamLeader`, `chkPartLeader`. 조회 SP가 SSP_MST_MODEL_USER와 SSP_MST_DELEGATE를 읽음. 체크박스와 SP 파라미터의 연결은 확인 필요 |
| 시트 잠금 | `siDetail.IsLock(SheetName)` |
| 프레임워크 버튼 | FindButton(R), SaveButton(C/U), EditButton. Delete 버튼 override는 Fact Pack에 없음 |

---

## 7. 외부 인터페이스 (Fact Pack에 있는 것만)
| 인터페이스 | 객체 | 관련 엔드포인트 |
|---|---|---|
| ERP 출하계획 확정 I/F (적재) | `XIF_ERP_SHIP_PLAN_CONFIRM_S_SN` INSERT | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| ERP 코드 변환 | `NERP_CONV_MASTER` SELECT | 위 저장 계열 |
| ERP 오류 확인 | `SSP_ANL_SHIP_ERP_ERROR_CONFIRM` INSERT | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| oWMS 실적·반품 | `SSP_DNM_SHIP_RESULT_OWMS(_V)`, `SSP_DNM_SHIP_RETURN_OWMS` SELECT | `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` |
| 메일 발송 | `SSP_MST_SEND_MAIL_REQ`, PR_SSP_MAIL_SEND_ADJUST_MST/SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| DM 연계 | `DM_PLN_MKT_FCST_CONFIRM` INSERT, PR_DM_SSP_CONFIRM_SYNC | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` |
- ERP 쪽 수신 방식(배치·실시간)과 전송 주기는 Fact Pack에 없어 확인 필요입니다.

---

## 8. 미확정·확인 필요
1. `SaveData_Detail`의 `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` 두 호출(2435, 2643)의 분기 조건과 파라미터 차이.
2. `GetERPInterface`에서 SoNo와 NonSoNo를 고르는 기준(`GetErpSoNoCnt`의 CNT를 쓰는지는 원문 확인 필요).
3. `GetErpIFCheckNew`에서 `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`를 2번(4355, 4385) 호출하는 조건.
4. 저장 체인의 트랜잭션 경계(엔드포인트별로 커밋하는지 여부).
5. `chkERPIFBlockYn`의 dtERPBlockYnIF(BLOCK_YN, PERIOD) 출처와 차단 시 동작.
6. `InitControls`의 dtShipmentInputPeriod(VALUE, Diff_VALUE)와 dtCompany 출처(GetSSPInnerTable 경유인지).
7. Excel Upload의 서버 처리 엔드포인트.
8. unreached 메서드 3개와 `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`을 TO-BE로 옮길지.
9. `SSP0023_GET_SHIPMENT_PLAN_DETAIL`과 `SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`의 동적 SQL 본문(참조 테이블).
10. SCM_MST_SHEET_MEASURE 11행의 Measure 정의.
11. 검증 실패 메시지 원문 전체.
12. legacy 사본과 current 사본의 93줄 차이.
13. 업무 목적·메뉴 위치(요건 문서 없음).

=== FILE: screen_design.md ===
# SSP0023 Shipment Plan(Electrode) — 화면설계서

> **근거**: Fact Pack(controls.csv · events.csv · flow.csv · endpoints.csv · props.csv · grid_rule/grid_code/grid_effective)과 1차 분석서만 사용했습니다. props.csv가 41,721자에서 잘려 일부 라벨과 SplitContainer 속성을 확인할 수 없고, 해당 항목은 **확인 필요**로 표기했습니다.
> 관련 문서: 업무분석서 §5 데이터 흐름 ↔ 이 문서 §5 액션 명세 ↔ 단위테스트 근거 열은 같은 엔드포인트 이름을 씁니다. §3 컨트롤명은 단위테스트 절차 열에 그대로 나옵니다.

---

## 1. 화면 개요
| 항목 | 값 |
|---|---|
| 화면 ID | SSP0023 |
| 화면명 | Shipment Plan(Electrode) |
| AS-IS 클래스 | `SSP0023_ShipmentPlanElectrode` |
| 도메인 | SSP (Plan) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용은 Fact Pack에 없음) |
| 소스 | `SSP0023_ShipmentPlanElectrode.cs` 6,823줄 / `.Designer.cs` 2,382줄 (current) |
| 컨트롤 수 | 88 (controls.csv) |
| Spread | `spdMain`, `spdDetail`, `spdSub` |
| Grid 구성 방식 | HYBRID: META(SetSheetHeaderColumn ×5) + DB 루프(InitSpreadDateColumn) + 코드 표시 변경 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)
```
SSP0023_ShipmentPlanElectrode (this)
├─ usrConditionPanel1  [UsrConditionPanel] Dock=Top · Size=1689×101 · UsrPanelType=HidePanel
│   └─ usrLayoutControl2  [UsrLayoutControl] Dock=Top · Size=1689×98   (Root: layoutControlGroup2 1689×106)
│       ├─ [조회조건] clbCompany_ID · clbDivision_ID · cboPlanDate · drpPeriod · cboBucketType
│       │            clbFromSite · txtItemId(+btnItemId) · txtModelId · textNickName
│       ├─ [표시옵션] usrLabel1(UOM Type) · rdButton1 · rdButton2 · rdButton3 · chkSum · btnMeasure
│       │            chkMyModel · chkDelegateeModel · chkTeamLeader · chkPartLeader · chkPastPeriod
│       └─ [버튼]     btnSimulation · formDown · btnExcelUpload
│
└─ splitContainer1  [SplitContainer]
    │   Orientation     = 확인 필요 (props.csv 잘림 구간)
    │   SplitterDistance= 확인 필요
    │   Size            = 확인 필요
    │   parent          = 확인 필요 (controls.csv 해당 행 잘림 구간)
    ├─ Panel1
    │   └─ spdMain [FpSpread] ─ spdMain_Sheet1  → 시트 "Shipment Plan(Electrode)"
    └─ Panel2
        ├─ usrLayoutControl3 [UsrLayoutControl]  (Root: layoutControlGroup3)
        │   └─ [상세 조건] txtNickName2 · txtModel2 · txtItemId2(+btnItemId2) · txtLotID
        │                 clbResultType · drpPeriod2 · drpPeriod3 · txtRequestor(+btnRequestor) · btnSearch
        ├─ spdDetail [FpSpread] ─ spdDetail_Sheet1 → 탭 "Shipment Plan Detail" / "Stock Detail" / "Shipment Result"
        └─ spdSub [FpSpread] ─ spdSub_Sheet1     → 시트 "Shipment Plan Detail Excel" (표시 여부 확인 필요)

(부모 없음) usrButton1 [UsrButton] Size=75×23 — 배치 위치·용도 확인 필요
(비시각)    imageList1 [ImageList]
```
- **상/하 또는 좌/우 분할 방향과 비율(%)**: Orientation과 SplitterDistance 값이 Fact Pack에 없어 **산출할 수 없습니다(확인 필요)**. Panel1에는 마스터 그리드(spdMain), Panel2에는 상세 조건과 상세 그리드가 있다는 것만 사실입니다.
- 조회조건 영역의 높이는 101px(usrConditionPanel1)입니다. 내부 LayoutControlItem의 행·열 배치 좌표는 Fact Pack에 없습니다(확인 필요).
- 팝업: Material(btnItemId, btnItemId2), Requestor(btnRequestor), Measure(btnMeasure). 팝업 화면 ID는 확인 필요입니다.

---

## 3. 컨트롤 명세

> 라벨 = props.csv의 Text 원문(LayoutControlItem 또는 컨트롤 Text). "확인 필요" = props.csv 잘림 구간.

### 3-1. 상단 조회조건 (usrConditionPanel1 / usrLayoutControl2)
| 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | — | Dock=Top, HidePanel | — | — | 조회조건 패널(접기 가능) |
| `usrLayoutControl2` | UsrLayoutControl | — | Dock=Top | — | — | 조회조건 그리드 레이아웃 |
| `clbCompany_ID` | UsrCombo | `Company*` | dtCompany.Rows[0].CODE (InitControls) | Y | SelectedIndexChanged → `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox(단일) |
| `clbDivision_ID` | UsrCombo | `Division*` | 확인 필요 | Y | SelectedIndexChanged → `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox(단일) |
| `cboPlanDate` | UsrCombo | `Plan-date*` | 확인 필요 (CODE/FROM_DATE/TO_DATE) | Y | SelectedIndexChanged → `cboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| `drpPeriod` | UsrDateRangePicker | `Period*` | Enabled=false | Y | — | 기간 입력(읽기 전용) |
| `cboBucketType` | UsrCombo | `Bucket` | 확인 필요 (DAILY/WEEKLY/MONTHLY) | N | SelectedIndexChanged → `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| `clbFromSite` | UsrCheckedList | `From Site` | 확인 필요 | N | — | Wijmo MultiSelect |
| `txtItemId` | UsrMultiLineEditor | `Material` | 빈값 | N | — | 멀티라인 입력 |
| `btnItemId` | UsrButton | 확인 필요 | — | — | Click → `btnItemId_Click` | 아이콘 버튼(Material 팝업) |
| `txtModelId` | UsrMultiLineEditor | 확인 필요 | 빈값 | N | — | 멀티라인 입력 |
| `textNickName` | UsrMultiLineEditor | 확인 필요 | 빈값 | N | — | 멀티라인 입력 |
| `usrLabel1` | UsrLabel | `UOM Type` | — | — | — | 라벨 |
| `rdButton1` | UsrRadio | `UOM` | Checked=true | — | CheckedChanged → `rdButton_Changed` | RadioGroup 항목 |
| `rdButton2` | UsrRadio | `Cell` | false | — | CheckedChanged → `rdButton_Changed` | RadioGroup 항목 |
| `rdButton3` | UsrRadio | `Pancake m` | false | — | **배선 없음** (events.csv) | RadioGroup 항목 |
| `chkSum` | UsrCheckBox | `Sum` | 확인 필요 | — | CheckedChanged → `chkSum_CheckedChanged` | CheckBox |
| `btnMeasure` | UsrButton | 확인 필요 | — | — | Click → `BtnMeasure_Click` | 아이콘 버튼(Measure 선택) |
| `chkMyModel` | UsrCheckBox | `My Model` | 확인 필요 | — | — | CheckBox |
| `chkDelegateeModel` | UsrCheckBox | `Delegatee Model` | 확인 필요 | — | — | CheckBox |
| `chkTeamLeader` | UsrCheckBox | `Team Leader` | 확인 필요 | — | — | CheckBox |
| `chkPartLeader` | UsrCheckBox | `Part Leader` | 확인 필요 | — | — | CheckBox |
| `chkPastPeriod` | UsrCheckBox | `Including Past Period` | 확인 필요 | — | CheckedChanged → `chkPastPeriod_CheckedChanged` | CheckBox |
| `btnSimulation` | UsrButton | `Simulation` | — | — | Click → `BtnSimulation_Click` | 버튼 |
| `formDown` | UsrButton | `Excel Form` | — | — | Click → `btnExcelFormDownload_Click` | 버튼 |
| `btnExcelUpload` | UsrButton | `Upload` | — | — | Click → `btnExcelUpload_Click` | 버튼(파일 업로드) |
| `usrButton1` | UsrButton | 확인 필요 | Size 75×23, parent 없음 | — | 배선 없음 | 미사용 여부 확인 필요 |

### 3-2. 하단 상세 조건 (splitContainer1.Panel2 / usrLayoutControl3)
| 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrLayoutControl3` | UsrLayoutControl | — | — | — | — | 상세 조건 레이아웃 |
| `txtNickName2` | UsrMultiLineEditor | 확인 필요 (layoutNickNameDetail) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `txtModel2` | UsrMultiLineEditor | 확인 필요 (layoutModelDetail) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `txtItemId2` | UsrMultiLineEditor | 확인 필요 (layoutMaterialDetail) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `btnItemId2` | UsrButton | 확인 필요 (layoutMaterialBtn) | — | — | Click → `BtnMaterialId2_Click` | 팝업 버튼 |
| `txtLotID` | UsrMultiLineEditor | 확인 필요 (layoutLotId) | 빈값 | 확인 필요 | — | 멀티라인 입력 |
| `clbResultType` | UsrCheckedList | 확인 필요 (layoutResultType) | 확인 필요 | 확인 필요 | — | Wijmo MultiSelect |
| `drpPeriod2` | UsrDateRangePicker | 확인 필요 (layoutShipmentDate2) | 확인 필요 | 확인 필요 | — | 기간 입력 |
| `drpPeriod3` | UsrDateRangePicker | 확인 필요 (layoutShipmentDate1) | 확인 필요 | 확인 필요 | — | 기간 입력 |
| `txtRequestor` | UsrTextBox | 확인 필요 (Requestor) | 빈값 | 확인 필요 | — | 텍스트 입력 |
| `btnRequestor` | UsrButton | 확인 필요 (layoutRequestorBtn) | — | — | Click → `BtnRequestor_Click` | 사용자 팝업 버튼 |
| `btnSearch` | SimpleButton | 확인 필요 (layoutSearchBtn) | — | — | Click → `BtnSearch_Click` | 상세 조회 버튼 |

### 3-3. 그리드
| 컨트롤명 | 타입 | 시트 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|
| `spdMain` | FpSpread | `Shipment Plan(Electrode)` | TopChange → `SpdMain_TopChange` · CellDoubleClick → `SpdMain_CellDoubleClick` · Change → `SpdMain_Change` · ClipboardPasted → `spdMain_ClipboardPasted` | Wijmo FlexGrid(3단 헤더 + 동적 날짜 컬럼) |
| `spdMain_Sheet1` | SheetView | (Designer 기본 시트) | — | — |
| `spdDetail` | FpSpread | `Shipment Plan Detail` / `Stock Detail` / `Shipment Result` | SheetTabClick → `SpdDetail_SheetTabClick` · ActiveSheetChanged → `SpdDetail_ActiveSheetChanged` · CellClick → `SpdDetail_CellClick` · ComboSelChange → `SpdDetail_ComboSelChange` · CellDoubleClick → `SpdDetail_CellDoubleClick` · EditChange → `SpdDetail_EditChange` · ClipboardPasted → `SpdDetail_ClipboardPasted` | 탭 + Wijmo FlexGrid 3개 |
| `spdDetail_Sheet1` | SheetView | (Designer 기본 시트) | — | — |
| `spdSub` | FpSpread | `Shipment Plan Detail Excel` | — | 엑셀 양식 전용(화면 표시 여부 확인 필요) |
| `spdSub_Sheet1` | SheetView | (Designer 기본 시트) | — | — |

- 비컨트롤 이벤트: `dsdm`.Changed → `shtPlanDetail_Change` (InitEvent:818). `dsdm`이 무엇인지는 확인 필요입니다.
- 프레임워크 버튼: FindButton(조회), SaveButton(저장), EditButton(편집). override 진입점입니다.

---

## 4. 그리드 명세

> 출처: META = SCM_MST_SHEET_COLUMNS(SetSheetHeaderColumn). CODE = 코드가 Visible을 변경. DBLOOP = InitSpreadDateColumn.
> division별 표시: 14개 division 모두 같습니다(Fact Pack §10·§12). 각 표의 "division" 열은 생략하고 여기서 한 번만 적습니다.
> 편집 가능 여부: 메타의 CELL_CONTROL_OBJECT_TYPE_CODE 값은 Fact Pack에 없습니다. 저장 검증 대상 컬럼은 "편집(검증 대상)", 나머지는 "확인 필요"로 적었습니다.

### 4-1. `Shipment Plan(Electrode)` — spdMain (메타 19/0, Measure 11행, 최종 13 (?9))
| 컬럼 | 헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 기본 | 확인 필요 |
| ELECTRODE_POST_OPER_LT | Oper. L/T | 확인 필요 | META | 기본 | 확인 필요 |
| ELECTRODE_TYPE | Elec Type | 확인 필요 | META | 기본 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Material | 확인 필요 | META | 기본 | 확인 필요 |
| MODEL_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| MEASURE_NAME | Measure | 확인 필요 | META | 기본 | 확인 필요 |
| PSI_NAME | PSI | 확인 필요 | META | 기본 | 확인 필요 |
| TEMPCOLUMN | TEMPCOLUMN | 확인 필요 | META | 기본 | 확인 필요 |
| TOT_BOH_QTY / _CELL / _PCM | BOH | 확인 필요 | META + CODE | 라디오에 따라 1개만 표시(§4-6) | 확인 필요 |
| JR_BOH_QTY / _CELL / _PCM | J/R | 확인 필요 | META + CODE | 위와 같음 | 확인 필요 |
| PC_BOH_QTY / _CELL / _PCM | Pancake | 확인 필요 | META + CODE | 위와 같음 | 확인 필요 |
| BACK_COLOR, CONFIRM_DAY, GUBUN_NUM, LAST_UPDATED_BY(Requestor), MEASURE, PLANT_ID, SCM_SITE_ID | — | — | META | 숨김 | — |
| (동적) `X_/Y_/Z_` × `D_/W_/M_` 날짜 컬럼 | COLUMN_LABEL_NAME (3단: LARGE/SMALL_CLASS_LABEL_NAME, 끝에 `SUM`) | Num(폭 100, 우측, 소수 3) / `B_` 포함 시 Text | DBLOOP (`SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN`) | §4-6 규칙 | 확인 필요 (spdMain_ClipboardPasted·SpdMain_Change가 있어 편집 가능 그리드로 보임) |
- 위 표의 컬럼은 1차 분석서(web_components §3-1)를 옮긴 것입니다. 메타 수(19)와 열거된 컬럼 수가 일치하는지는 확인 필요입니다.

### 4-2. `Shipment Plan Detail` — spdDetail 탭 0 (메타 41/0, 최종 44 (?9))
| 컬럼 | 헤더 | 출처 | 표시 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 기본 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | META | 기본 | 확인 필요 (검증 키) |
| CHANGE_REQ_NO | Change Request No | META | 기본 | 확인 필요 |
| SHIPMENT_STATUS | Status | META | 기본 | 확인 필요 |
| MODEL_ID | Model | META | 기본 | 확인 필요 |
| MODEL_USER | Model PIC | META | 기본 | 확인 필요 |
| ITEM_ID | Material | META | 기본 | 확인 필요 |
| ITEM_ID_NICK_NAME | Nick Name | META | 기본 | 확인 필요 |
| CELL_TYPE | Cell Type | META | 기본 | 확인 필요 |
| ELECTRODE_POST_OPER | Post Oper. | META | 기본 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | META | 기본 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | META | 기본 | 확인 필요 |
| SOLDTO_DESCRIPTION | Sold To Party | META | 기본 | 확인 필요 |
| SHIPTO_DESCRIPTION | Ship To Party | META | 기본 | 확인 필요 |
| DOM_EXP | DOM/EXP. | META | 기본 | 편집(검증 대상 dom_exp) |
| INCOTERMS | Incoterms | META | 기본 | 확인 필요 |
| SHIPPING_PLAN_QTY | Shipping Plan Qty | META | 기본 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Confirm Qty* | META | 기본 | 편집(검증 대상) |
| GAP | Gap | META | 기본 | 확인 필요 |
| CONFIRM_QTY_CELL | Confirm Qty (Cell) | META | 기본 | 확인 필요 |
| CONFIRM_QTY_JR | Confirm Qty (Jumboroll m) | META | 기본 | 확인 필요 |
| CONFIRM_QTY_PANCAKE | Confirm Qty (Pancake m) | META | 기본 | 확인 필요 |
| CONFIRM_QTY_ROLL_LENGTH | Confirm Qty (Cut) | META | 기본 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date* | META | 기본 | 편집(검증 대상) |
| DAYOFWEEK_NAME | Day | META | 기본 | 확인 필요 |
| Expected_Shipping_Date | Expected Shipping Date | META | 기본 | 확인 필요 |
| ETD | ETD | META | 기본 | 확인 필요 |
| ETA | ETA | META | 기본 | 확인 필요 |
| LT_DAY | L/T(Day) | META | 기본 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | META | 기본 | 편집(검증 대상) |
| FACTORY_ID | Building Desc.* | META + CODE(CellClick 시 Building 콤보 동적 생성 1718) | 기본 | 편집(검증 대상) |
| PACKAGE_TYPE | Package Type * | META | 기본 | 편집(검증 대상) |
| PACKAGE_QTY | Package Qty | META | 기본 | 확인 필요 |
| ERP_SO_NO | PO No | META | 기본 | 확인 필요 |
| REMARKS2 | Shipment No. | META | 기본 | 편집(검증 대상 remarks2) |
| REMARKS | Remarks | META | 기본 | 편집(검증 대상 remarks) |
| REMARKS3 | Customer Requirement | META | 기본 | 확인 필요 |
| REQUESTOR | Shipment Requestor | META | 기본 | 확인 필요 |
| (Updated By) | Updated By | META | 기본 | 확인 필요 |
| (Updated Date) | Updated Date | META | 기본 | 확인 필요 |
| ATTRIBUTE10 | ATTRIBUTE10 | META | 기본 | 확인 필요 |
| 숨김: BOD_ID, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, CHANGE_TYPE, EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, TO_SITE, MERGE_NUM, MODEL_ID_NICK_NAME, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID | — | META | 숨김 | — |
- 헤더 CheckBox 컬럼이 있습니다(SpdDetail_CellClick 1727–1759에서 전체 선택/해제). 해당 컬럼명은 확인 필요입니다.
- 최종 44 = 41 + BOH 3(CODE_ONLY_CHANGE 전개분). 이 시트에 실제로 적용되는지는 확인 필요입니다.

### 4-3. `Stock Detail` — spdDetail 탭 1 (메타 28/0, 최종 31 (?9), 헤더 3단)
| # | 헤더 | 컬럼 | 출처 | 표시 | 편집 |
|---:|---|---|---|---|---|
| 1 | Div | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | SCM Site | FROM_SITE | META | 기본 | 확인 필요 |
| 3 | Plant | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | Storage | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | Material | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | Version | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | Operation | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | Lot ID | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | Pallet ID | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | Lane | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | Expiration Date | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | Available Stock YN | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | Change Status | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | Package Type(oWMS) | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | MES Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 18 | QMS Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | iWMS Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 20 | oWMS Hold YN | 확인 필요 | META | 기본 | 확인 필요 |
| 21–22 | Total: UOM / Pancake M | TOTAL_QTY_UOM / TOTAL_QTY_PCM | META | 기본 | 확인 필요 |
| 23–24 | GMES: UOM / Pancake M | 확인 필요 | META | 기본 | 확인 필요 |
| 25–26 | IWMS: UOM / Pancake M | 확인 필요 | META | 기본 | 확인 필요 |
| 27–28 | OWMS: UOM / Pancake M | 확인 필요 | META | 기본 | 확인 필요 |
- 상위 헤더 그룹(Total/GMES/IWMS/OWMS)이 메타 ATTRIBUTE로 구성되는지는 확인 필요입니다.

### 4-4. `Shipment Result` — spdDetail 탭 2 (메타 17/0, 최종 20 (?9))
| # | 헤더 | 컬럼 | 출처 | 표시 | 편집 |
|---:|---|---|---|---|---|
| 1 | Div | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | Confirm/Plan ID | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | SO No | ERP_SO_NO | META | 기본 | 확인 필요 |
| 4 | Status | TYPE | META | 기본 | 확인 필요 |
| 5 | Ship Type | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | Material | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | End Customer | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | Shipment Date | YYYYMMDD | META | 기본 | 확인 필요 |
| 13 | ETD | ETD_DATE | META | 기본 | 확인 필요 |
| 14 | ETA | ETA_DATE | META | 기본 | 확인 필요 |
| 15 | Trans Mode | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | Incoterms | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | Shipment Qty | QTY | META | 기본 | 확인 필요 |

### 4-5. `Shipment Plan Detail Excel` — spdSub (메타 6/0, 최종 9 (?9))
| 컬럼 | 헤더 | 출처 | 표시 | 편집 |
|---|---|---|---|---|
| COMPANY_ID | Company* | META | 기본 | 엑셀 양식 입력 |
| DIVISION_ID | Div* | META | 기본 | 엑셀 양식 입력 |
| FROM_SITE | FromSite* | META | 기본 | 엑셀 양식 입력 |
| ITEM_ID | Material* | META | 기본 | 엑셀 양식 입력 |
| YYYYMMDD | yyyyMMdd* | META | 기본 | 엑셀 양식 입력 |
| QTY | Qty* | META | 기본 | 엑셀 양식 입력 |

### 4-6. 코드 표시 규칙 요약 (업무분석서 §4-3·§4-4와 같음)
- BOH: rdButton1 → 기본 3컬럼 / rdButton2 → _CELL 3컬럼 / rdButton3 → _PCM 3컬럼 (InitSpread 597–629, rdButton_Changed 4420–4452).
- 날짜: 접두어 X_(UOM)·Y_(Cell)·Z_(Pancake). Bucket DAILY: D 표시, W와 M은 chkSum을 따름. WEEKLY: D 숨김, W 표시, M은 chkSum을 따름. MONTHLY: D·W 숨김, M 표시. chkPastPeriod가 꺼져 있으면 과거 날짜(SUM 헤더 제외)를 숨김.
- 주말 글자색: SAT 파랑, SUN 빨강.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 (업무분석서 §5와 같은 이름) | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls → GetBucketType / CreateSpread → InitSpread → GetSpdTitle | `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | cboBucketType 채움, spdMain 헤더 생성 |
| A2 | FindButton (조회) | (프레임워크 override) FindButton | FindData_Main(GetCheckedListValue ×4: 4683–4686) → InitSpread | `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdMain `Shipment Plan(Electrode)` 바인딩 |
| A3 | EditButton | (프레임워크 override) EditButton | GetCheckedListValue(2138) → GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가능 여부 판정(기준 확인 필요) |
| A4 | SaveButton | (프레임워크 override) SaveButton | SaveData_Detail(검증) → GetERPInterface 체인 → 재조회 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0023_GET_SHIPMENT_STATUS`, `SSP.SSP0023_GET_ERP_SO_NO_CNT`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 저장 후 spdMain과 spdDetail 재조회 |
| A5 | (현행 미호출) | — (`GetErpIFCheckNew_`, `GetErpIFCheck` unreached) | 진입점 없음 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | 현행 화면에서 실행되지 않음 |
| A6 | formDown Click | `btnExcelFormDownload_Click` | FindData_Plan_Detail_DownLoad → InitSpread → ExportExcel | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdSub `Shipment Plan Detail Excel` 엑셀 내보내기 |
| A7 | btnExcelUpload Click | `btnExcelUpload_Click` | 업로드(처리 엔드포인트 확인 필요) → FindData_Main → FindData_Detail | `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | Main과 Detail 재조회 |
| A8 | btnSimulation Click | `BtnSimulation_Click` | Simulation → FindData_Main → FindData_Detail | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU`, `SSP.SSP0023_GET_SHIPMENT_PLAN`, `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 시뮬레이션 저장 후 재조회 |
| A9 | btnMeasure Click | `BtnMeasure_Click` | Measure 선택 → InitSpread | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더 재생성 |
| A10 | btnSearch Click | `BtnSearch_Click` | FindData_Detail / FindData_Stock_Detail / FindData_ShipmentResult | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdDetail 3개 시트 바인딩 |
| A11 | btnItemId Click | `btnItemId_Click` | Material 팝업 | 없음(Fact Pack 기준) | txtItemId 반영(확인 필요) |
| A12 | btnItemId2 Click | `BtnMaterialId2_Click` | Material 팝업(상세) | 없음 | txtItemId2 반영(확인 필요) |
| A13 | btnRequestor Click | `BtnRequestor_Click` | Requestor 팝업 | 없음 | txtRequestor 반영(확인 필요) |
| A14 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | cboPlanDate 배선 해제(5776) → 재구성 → 재배선(5780) → InitSpread | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | Plan-date와 헤더 재구성 |
| A15 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | DIVISION_ID 필터 | 없음 | 하위 목록 필터(대상 확인 필요) |
| A16 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | CODE/FROM_DATE/TO_DATE 읽기 → GetSpdTitle(5825) | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | 날짜 헤더 재구성 |
| A17 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | 날짜 컬럼 Visible(§4-6, SetSpreadColumn 호출 여부 확인 필요) | 없음 | D/W/M 컬럼 표시 전환 |
| A18 | rdButton1/2 CheckedChanged | `rdButton_Changed` | BOH 컬럼 Visible 전환 | 없음 | BOH 3세트 중 1세트 표시 |
| A19 | chkSum CheckedChanged | `chkSum_CheckedChanged` | 합계 컬럼 Visible | 없음 | W/M 컬럼 표시 전환 |
| A20 | chkPastPeriod CheckedChanged | `chkPastPeriod_CheckedChanged` | 과거 날짜 컬럼 Visible | 없음 | 과거 날짜 표시 전환 |
| A21 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | Detail 시트로 전환(1798–1799) → FindData_Detail | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | spdDetail `Shipment Plan Detail` |
| A22 | spdMain TopChange | `SpdMain_TopChange` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A23 | spdMain Change | `SpdMain_Change` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A24 | spdMain ClipboardPasted | `spdMain_ClipboardPasted` | 키(DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID) 기준 처리 | 없음 | 확인 필요 |
| A25 | spdDetail SheetTabClick | `SpdDetail_SheetTabClick` | SheetTabIndex 0/1/2 | 없음 | 시트 전환 |
| A26 | spdDetail ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A27 | spdDetail CellClick | `SpdDetail_CellClick` | IsLock 확인 → 헤더 CheckBox 전체 토글 / FACTORY_ID Building 콤보 생성 | 없음 | 셀 값·콤보 반영 |
| A28 | spdDetail ComboSelChange | `SpdDetail_ComboSelChange` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A29 | spdDetail CellDoubleClick | `SpdDetail_CellDoubleClick` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A30 | spdDetail EditChange | `SpdDetail_EditChange` | 처리 내용 확인 필요 | 없음 | 확인 필요 |
| A31 | spdDetail ClipboardPasted | `SpdDetail_ClipboardPasted` | CODE 참조 | 없음 | 확인 필요 |
| A32 | dsdm Changed | `shtPlanDetail_Change` | 처리 내용 확인 필요 | 없음 | 확인 필요 |

---

## 6. 검증·메시지
| 시점 | 검증 | 대상 | 메시지 |
|---|---|---|---|
| 조회 전 | 필수 조건 | Company*, Division*, Plan-date*, Period* | 원문 확인 필요 |
| 저장 전 | Validation_Check | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type, dom_exp (SO No 행은 앞 5개) | 원문 확인 필요 |
| 저장 전 | ChangeData_Check | confirm_id + 위 7컬럼 | 원문 확인 필요 |
| 저장 전 | ChangeNotSendERP_Check | confirm_id + 위 7컬럼 / SO No 행 5컬럼 | 원문 확인 필요 |
| 저장 중 | chkERPIFBlockYn | BLOCK_YN, PERIOD | 원문 확인 필요 |
| 저장 중 | ChkConfirmChangeTime | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` 결과 | 원문 확인 필요 |
| 저장 중 | GetShipmentStatusChk | `SSP.SSP0023_GET_SHIPMENT_STATUS` Tables[0..2].CONFIRM_ID | 원문 확인 필요 |
| 편집 | IsLock | 시트 잠금 시 CellClick 처리 안 함 | — |

---

## 7. 권한(C/R/U/D) 사실
| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0023_GET_SHIPMENT_PLAN`, btnSearch 상세 조회 |
| C/U | SaveButton → 확정·변경요청 저장, btnSimulation → `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` |
| D | Delete 버튼 override 없음. 삭제 성격의 SP(`SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`)는 저장 체인 안에서 호출됨 |
| 편집 권한 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST` |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행(그룹별 C/R/U/D 값은 확인 필요) |
| 그룹 기준 | `UserInfoContext.Current.NowGroupID` (SetChangeControl:341–342, InitControls:462) |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)
1. **그리드**: spdMain → Wijmo FlexGrid. 3단 헤더(LARGE/SMALL_CLASS_LABEL_NAME + 날짜 + `SUM`)는 `columnHeaders` 다중 행과 셀 병합으로 구현합니다. 날짜 컬럼은 `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 결과로 동적으로 생성합니다. X_/Y_/Z_ × D_/W_/M_ 표시 규칙(§4-6)은 FE에서 컬럼 visible 토글로 처리하고 재조회하지 않습니다.
2. **상세 탭**: spdDetail 3개 시트 → 탭 + FlexGrid 3개. FACTORY_ID Building 콤보는 셀 편집기(DataMap)로 구현합니다. 헤더 CheckBox 전체 토글을 구현합니다.
3. **컬럼 메타**: SetSheetHeaderColumn이 읽는 SCM_MST_SHEET_COLUMNS 메타를 그대로 씁니다. 5개 시트 모두 division 변형이 없습니다.
4. **엑셀**: spdSub(숨김 양식 그리드)는 TO-BE에서 FlexGrid 대신 서버 또는 FE 엑셀 양식 생성으로 대체할 수 있습니다. 결정 필요.
5. **Oracle 전환 대상 SP의 MSSQL 요소**(Fact Pack 참조 객체 기준): `STRING_SPLIT`(GET_SHIPMENT_PLAN, GET_SHIPMENT_STATUS, GET_SHIPMENT_PLAN_RESULT, GET_SHIPMENT_PLAN_DETAIL_EXCEL), `SP_EXECUTESQL`(SAVE_SHIPMENT_PLAN_SIMU), `#임시테이블`(GET_SHIPMENT_PLAN, SAVE_SHIPMENT_REQUEST_CONFIRM, SCM_SSP_DELETE_…_BY_CONFIRM), 동적 SQL(GET_SHIPMENT_PLAN, _DETAIL, _STOCK_DETAIL), `MERGE`(SAVE_SHIPMENT_PLAN_SIMU), CTE 추정 객체(GET_SHIPMENT_PLAN_RESULT). 각각 Oracle 대응(GTT·EXECUTE IMMEDIATE·REGEXP 분할 등)이 필요합니다. 구체 변환은 SP 원문 확인 후 정합니다.
6. **저장 트랜잭션**: AS-IS는 화면에서 엔드포인트를 최대 9종 순서대로 호출합니다. TO-BE에서 BE 서비스 하나로 묶을지는 분기 조건(업무분석서 §8)을 확인한 뒤 결정합니다.
7. **rdButton3 배선 없음**: TO-BE RadioGroup은 단일 change 이벤트로 3개 값을 모두 처리합니다. AS-IS의 실제 동작이 같은지는 확인 필요입니다.
8. **unreached 메서드**: `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`은 이전 대상에서 제외할 후보입니다. 확정은 필요합니다.

---

## 9. 미확정
1. splitContainer1의 Orientation, SplitterDistance, Size, parent → 분할 방향과 비율.
2. 확인 필요로 표기한 라벨(btnItemId, txtModelId, textNickName, btnMeasure, usrButton1, 하단 상세 조건 11개).
3. 체크박스(chkSum, chkPastPeriod, chkMyModel 등)의 초기값.
4. Excel Upload 처리 엔드포인트.
5. `SpdMain_TopChange`, `SpdMain_Change`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_EditChange`, `shtPlanDetail_Change` 본문의 처리 내용.
6. 각 시트 컬럼의 셀 타입과 편집 가능 여부(CELL_CONTROL_OBJECT_TYPE_CODE).
7. spdSub가 화면에 표시되는지.
8. BOH CODE_ONLY_CHANGE가 `Shipment Plan(Electrode)` 외 시트에도 적용되는지.
9. 메뉴 위치.

=== FILE: unit_test.md ===
# SSP0023 Shipment Plan(Electrode) — 단위테스트

> **근거**: 업무분석서 §5 데이터 흐름, 화면설계서 §3 컨트롤 명세와 §5 액션 명세. 근거 열에는 엔드포인트, SP, 핸들러, 시트 이름을 원문 그대로 적었습니다.
> 주석 처리된 호출(Fact Pack §9)은 0건이며 테스트 대상에서 뺐습니다. 진입점 미연결(unreached) 호출은 "현행 미호출 확인" 케이스로만 다룹니다.
> 기대결과의 메시지 원문과 분기 조건이 Fact Pack에 없는 경우 **확인 필요**로 적었습니다. 실행할 때 AS-IS 동작으로 기대값을 확정해야 합니다.
> 공통 사전조건: ADMIN/PLANNER 계정 1개로 로그인했고, SSP0023 메뉴 권한이 있습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0023-001 | 초기화 | 화면 미오픈 | 1) SSP0023 메뉴 실행 2) `cboBucketType` 펼치기 | — | `cboBucketType`에 DAILY/WEEKLY/MONTHLY 항목이 표시됨 | `Form_Load` > InitControls > GetBucketType · `DM.DM0003_GET_BUCKET_TYPE_CODE` · SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0023-002 | 초기화 | 화면 미오픈 | 1) 메뉴 실행 2) `spdMain` 헤더 확인 | — | `spdMain`에 3단 날짜 헤더와 `SUM` 헤더가 만들어짐. SAT 헤더 글자는 파랑, SUN은 빨강 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` · SP `SSP0023_GET_SHEET_CALENDAR_3SPAN` · 시트 `Shipment Plan(Electrode)` |
| TC-SSP0023-003 | 초기화 | 화면 미오픈 | 1) 메뉴 실행 2) `rdButton1`, `drpPeriod` 상태 확인 | — | `rdButton1`(UOM)이 선택됨. `drpPeriod`는 비활성(Enabled=false). `clbCompany_ID`에 dtCompany 첫 행 CODE가 설정됨 | `Form_Load` · Designer(rdButton1 Checked=true, drpPeriod Enabled=false) · InitControls(dtCompany.Rows[0].CODE) |
| TC-SSP0023-004 | 초기화(오류) | Bucket 코드 조회 실패 상황(DB 연결 차단 등) | 1) 메뉴 실행 | — | 오류 메시지가 표시되고 화면이 비정상 종료되지 않음(메시지 원문 확인 필요) | `Form_Load` · `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0023-005 | 조회 | 화면 오픈 | 1) `clbCompany_ID`, `clbDivision_ID`, `cboPlanDate` 선택 2) 조회(FindButton) | 데이터가 있는 Company/Division/Plan-date | `spdMain`에 Measure 행 × 날짜 컬럼 데이터가 표시됨 | FindButton > FindData_Main · `SSP.SSP0023_GET_SHIPMENT_PLAN` · SP `SSP0023_GET_SHIPMENT_PLAN` · 시트 `Shipment Plan(Electrode)` |
| TC-SSP0023-006 | 조회(빈 결과) | 화면 오픈 | 1) 데이터가 없는 조건으로 조회 | `txtItemId`=존재하지 않는 Material | `spdMain` 0행. 오류 없음(빈 결과 안내 메시지 여부 확인 필요) | `SSP.SSP0023_GET_SHIPMENT_PLAN` |
| TC-SSP0023-007 | 조회(오류) | SP 실행 오류 상황 | 1) 조회 | — | 오류 메시지가 표시되고 기존 그리드가 유지 또는 초기화됨(확인 필요) | `SSP.SSP0023_GET_SHIPMENT_PLAN` · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0023-008 | 그리드 | TC-005 완료 | 1) `spdMain` 컬럼 확인 | — | Div, Oper. L/T, Elec Type, From Site, Material, Model, Nick Name, Measure, PSI, TEMPCOLUMN, BOH, J/R, Pancake 표시. BACK_COLOR, CONFIRM_DAY, GUBUN_NUM, LAST_UPDATED_BY, MEASURE, PLANT_ID, SCM_SITE_ID 숨김 | 시트 `Shipment Plan(Electrode)` · SetSheetHeaderColumn(InitSpread:585) |
| TC-SSP0023-009 | 그리드 | TC-005 완료, `chkPastPeriod` 해제 | 1) 오늘 이전 날짜 컬럼 확인 2) `chkPastPeriod` 체크 | — | 1) 과거 날짜 컬럼(SUM 제외) 숨김 2) 체크 후 표시 | `chkPastPeriod_CheckedChanged` · SetSpreadColumn:4642 · 시트 `Shipment Plan(Electrode)` |
| TC-SSP0023-010 | 이벤트 | TC-005 완료 | 1) `spdMain`을 세로로 스크롤 | — | 스크롤 시 오류 없음(TopChange 처리 내용은 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0023-011 | 이벤트 | TC-005 완료, `rdButton1` 선택, `chkSum` 해제 | 1) `cboBucketType`=DAILY | DAILY | X_D_ 컬럼 표시, X_W_와 X_M_은 숨김(chkSum=false). 핸들러가 SetSpreadColumn을 호출하는지 확인 필요 | `cboBucketType_SelectedIndexChanged` · SetSpreadColumn:4491/4496 |
| TC-SSP0023-012 | 이벤트 | 위와 같음 | 1) `cboBucketType`=WEEKLY | WEEKLY | X_D_ 숨김, X_W_ 표시, X_M_은 chkSum을 따름(숨김) | `cboBucketType_SelectedIndexChanged` · SetSpreadColumn:4503/4507/4511 |
| TC-SSP0023-013 | 이벤트 | 위와 같음 | 1) `cboBucketType`=MONTHLY | MONTHLY | X_D_와 X_W_ 숨김, X_M_ 표시 | `cboBucketType_SelectedIndexChanged` · SetSpreadColumn:4518/4522 |
| TC-SSP0023-014 | 이벤트 | TC-005 완료 | 1) `rdButton2`(Cell) 선택 | — | TOT/JR/PC_BOH_QTY_CELL 표시, 기본과 _PCM 숨김. 날짜 컬럼 Y_만 표시 | `rdButton_Changed` · 4432–4440 · SetSpreadColumn:4530/4534 |
| TC-SSP0023-015 | 이벤트 | TC-005 완료 | 1) `rdButton3`(Pancake m) 선택 | — | _PCM 3컬럼 표시, 날짜 Z_만 표시. rdButton3에는 배선이 없으므로 rdButton1/2 해제 이벤트로 반영되는지 확인 | `rdButton_Changed` · 4444–4452 · events.csv(rdButton3 미배선) |
| TC-SSP0023-016 | 이벤트 | TC-005 완료, Bucket=DAILY | 1) `chkSum` 체크 2) 해제 | — | 1) X_W_와 X_M_ 합계 컬럼 표시 2) 숨김 | `chkSum_CheckedChanged` · SetSpreadColumn:4496 |
| TC-SSP0023-017 | 이벤트 | TC-005 완료 | 1) `chkPastPeriod` 해제 | — | 과거 날짜 컬럼 숨김 | `chkPastPeriod_CheckedChanged` |
| TC-SSP0023-018 | 이벤트 | TC-005 완료 | 1) `spdMain`의 Measure `P_SHIP_CONFIRM_ETD` 행 날짜 셀 더블클릭 | — | `spdDetail`이 `Shipment Plan Detail`로 전환되고 해당 조건의 상세가 조회됨 | `SpdMain_CellDoubleClick` > FindData_Detail · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` · SP `SSP0023_GET_SHIPMENT_PLAN_DETAIL` · 시트 `Shipment Plan Detail` |
| TC-SSP0023-019 | 이벤트 | TC-005 완료 | 1) `P_SHIP_CONFIRM_ETD`가 아닌 Measure 행 셀 더블클릭 | — | 상세 조회 여부는 AS-IS로 확인(확인 필요) | `SpdMain_CellDoubleClick` |
| TC-SSP0023-020 | 이벤트 | TC-005 완료 | 1) `spdMain` 편집 가능 셀 값 변경 | 숫자 1 | 변경 행 처리(내용 확인 필요). 오류 없음 | `SpdMain_Change` |
| TC-SSP0023-021 | 이벤트 | TC-005 완료 | 1) 엑셀에서 DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID와 값을 복사 2) `spdMain`에 붙여넣기 | 키가 일치하는 행 | 키가 일치하는 행에 값이 반영됨(반영 규칙 확인 필요) | `spdMain_ClipboardPasted` (1219–1225) |
| TC-SSP0023-022 | 이벤트 | 화면 오픈 | 1) `btnMeasure` 클릭 2) Measure 선택 후 확인 | Measure 1건 해제 | `spdMain` 헤더 재생성, 선택 Measure 반영 | `BtnMeasure_Click` > InitSpread > GetSpdTitle · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0023-023 | 이벤트 | 화면 오픈 | 1) `btnItemId` 클릭 2) Material 선택 | Material 1건 | `txtItemId`에 선택값 반영(팝업 종류 확인 필요) | `btnItemId_Click` |
| TC-SSP0023-024 | 이벤트 | 화면 오픈 | 1) `btnItemId2` 클릭 2) Material 선택 | Material 1건 | `txtItemId2`에 반영(확인 필요) | `BtnMaterialId2_Click` |
| TC-SSP0023-025 | 조회 | TC-005 완료 | 1) 하단 조건(`txtModel2`, `txtItemId2`, `drpPeriod2`, `drpPeriod3` 등) 입력 2) `btnSearch` 클릭 | 데이터가 있는 조건 | `spdDetail`의 `Shipment Plan Detail`, `Stock Detail`, `Shipment Result`가 조회됨(탭별 호출 범위 확인 필요) | `BtnSearch_Click` · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` · `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` · SP `SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` · `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` · SP `SSP0023_GET_SHIPMENT_PLAN_RESULT` |
| TC-SSP0023-026 | 그리드 | TC-025 완료 | 1) `Shipment Plan Detail` 탭 컬럼 확인 | — | 41개 표시 컬럼(Div … ATTRIBUTE10)이 화면설계서 §4-2 순서대로 표시. 필수 표기 Confirm Qty*, Shipment Date*, Trans Mode*, Building Desc.*, Package Type *. 숨김 컬럼 미표시 | 시트 `Shipment Plan Detail` · SetSheetHeaderColumn |
| TC-SSP0023-027 | 그리드 | TC-025 완료 | 1) `Stock Detail` 탭 컬럼 확인 | — | 28개 컬럼과 상위 헤더 Total/GMES/IWMS/OWMS × UOM/Pancake M 표시 | 시트 `Stock Detail` · `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` |
| TC-SSP0023-028 | 그리드 | TC-025 완료 | 1) `Shipment Result` 탭 컬럼 확인 | — | Div, Confirm/Plan ID, SO No, Status, Ship Type, Model, Material, Nick Name, From Site, To Site, End Customer, Shipment Date, ETD, ETA, Trans Mode, Incoterms, Shipment Qty(17개) 표시 | 시트 `Shipment Result` · `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` |
| TC-SSP0023-029 | 조회(빈 결과) | 화면 오픈 | 1) 하단 `txtLotID`에 존재하지 않는 Lot 입력 2) `btnSearch` | Lot=없는 값 | `Stock Detail` 0행. 오류 없음 | `BtnSearch_Click` · `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` |
| TC-SSP0023-030 | 이벤트 | 화면 오픈 | 1) `btnRequestor` 클릭 2) 사용자 선택 | 사용자 1명 | `txtRequestor`에 반영(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0023-031 | 저장 | TC-005 완료, `spdMain`에 시뮬레이션 값 입력 | 1) `btnSimulation` 클릭 | 수량 변경 1건 | 시뮬레이션이 저장되고(SSP_ANL_SHIP_PLAN_SIMU_EE INSERT · SSP_ANL_SHIP_PLAN_EE MERGE) Main과 Detail이 재조회됨. 저장 후 대상 행을 복원함 | `BtnSimulation_Click` > Simulation · `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` · SP `SSP0023_SAVE_SHIPMENT_PLAN_SIMU` · `SSP.SSP0023_GET_SHIPMENT_PLAN` · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` |
| TC-SSP0023-032 | 이벤트 | 화면 오픈, 조건 선택 | 1) `formDown`(Excel Form) 클릭 | — | COMPANY_ID, DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, QTY(헤더 Company*, Div*, FromSite*, Material*, yyyyMMdd*, Qty*) 양식 엑셀이 내려받아짐 | `btnExcelFormDownload_Click` > FindData_Plan_Detail_DownLoad · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` · SP `SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` · 시트 `Shipment Plan Detail Excel` |
| TC-SSP0023-033 | 이벤트 | TC-032 양식 작성 완료 | 1) `btnExcelUpload` 클릭 2) 파일 선택 | 양식 1행 | 업로드 후 `spdMain`과 `spdDetail`이 재조회됨(업로드 처리 엔드포인트 확인 필요) | `btnExcelUpload_Click` · `SSP.SSP0023_GET_SHIPMENT_PLAN` · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` |
| TC-SSP0023-034 | 이벤트 | TC-025 완료 | 1) `spdDetail` 탭 0 → 1 → 2 클릭 | — | `Shipment Plan Detail` → `Stock Detail` → `Shipment Result` 순으로 전환 | `SpdDetail_SheetTabClick` |
| TC-SSP0023-035 | 이벤트 | TC-025 완료 | 1) 활성 시트 변경 | — | 시트 변경 시 오류 없음(처리 내용 확인 필요) | `SpdDetail_ActiveSheetChanged` |
| TC-SSP0023-036 | 이벤트 | `Shipment Plan Detail` 조회 완료, 시트 잠금 해제 | 1) FACTORY_ID(Building Desc.*) 셀 클릭 | — | Building 콤보가 동적으로 생성되어 목록 표시 | `SpdDetail_CellClick` (1718, GetCheckedListValue:1691) · 시트 `Shipment Plan Detail` |
| TC-SSP0023-037 | 그리드 | 위와 같음 | 1) 헤더 CheckBox 클릭 2) 다시 클릭 | — | 1) 전체 행 체크 2) 전체 행 해제 | `SpdDetail_CellClick` (1727/1755/1759) |
| TC-SSP0023-038 | 권한 | 시트 잠금 상태(IsLock=true) | 1) 헤더 CheckBox와 FACTORY_ID 셀 클릭 | — | 잠금 해제 상태의 동작이 수행되지 않음(잠금 분기 동작 확인 필요) | `SpdDetail_CellClick` · siDetail.IsLock |
| TC-SSP0023-039 | 이벤트 | TC-036 완료 | 1) Building 콤보에서 값 선택 | Building 1건 | 선택값이 셀에 반영되고 변경 행으로 표시(확인 필요) | `SpdDetail_ComboSelChange` |
| TC-SSP0023-040 | 이벤트 | `Shipment Plan Detail` 조회 완료 | 1) 상세 셀 더블클릭 | — | 처리 내용 확인 필요. 오류 없음 | `SpdDetail_CellDoubleClick` |
| TC-SSP0023-041 | 이벤트 | 위와 같음 | 1) Confirm Qty* 셀 편집 | 수량 변경 | 편집 중 값 반영(처리 내용 확인 필요) | `SpdDetail_EditChange` |
| TC-SSP0023-042 | 이벤트 | 위와 같음 | 1) 여러 셀 복사·붙여넣기 | 코드값 셀 포함 | CODE 기준 붙여넣기 처리(확인 필요) | `SpdDetail_ClipboardPasted` |
| TC-SSP0023-043 | 이벤트 | 화면 오픈 | 1) `clbDivision_ID` 변경 | Division 변경 | DIVISION_ID 기준으로 하위 목록 필터(대상 컨트롤 확인 필요) | `clbDivision_ID_SelectedIndexChanged` |
| TC-SSP0023-044 | 이벤트 | 화면 오픈 | 1) `clbCompany_ID` 변경 | Company 변경 | `cboPlanDate` 재구성, `spdMain` 헤더 재생성. 재구성 중 `cboPlanDate_SelectedIndexChanged`가 중복 실행되지 않음(5776 해제/5780 재배선) | `clbCompanyID_SelectedIndexChanged` > InitSpread > GetSpdTitle · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0023-045 | 이벤트 | 화면 오픈 | 1) `cboPlanDate` 변경 | 다른 Plan-date | 선택 항목의 FROM_DATE~TO_DATE 기준으로 날짜 헤더 재구성 | `cboPlanDate_SelectedIndexChanged` > GetSpdTitle(5825) · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0023-046 | 이벤트 | 상세 데이터 변경 | 1) 상세 데이터 변경 발생 | — | 처리 내용 확인 필요(`dsdm`이 무엇인지 확인 필요) | `shtPlanDetail_Change` (dsdm.Changed, InitEvent:818) |
| TC-SSP0023-047 | 권한 | 편집 권한이 있는 사용자 / 없는 사용자 | 1) EditButton 클릭 | 계정 2종 | 권한 결과에 따라 편집 가능/불가(판정 기준 확인 필요) | EditButton > GetSSPUserCheck · `SSP.SSP0002_GET_USER_INFO_LIST` · SP `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0023-048 | 저장 | `Shipment Plan Detail` 조회 완료, 필수 컬럼 입력, 저장 직전 대상 행 기록 | 1) Confirm Qty*, Shipment Date*, Trans Mode*, Building Desc.*, Package Type * 입력 2) SaveButton | 유효값 | 확정이 저장되고(SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, SSP_ANL_SHIP_CONFIRM_H INSERT) 재조회됨. 시험 후 행 복원 | SaveButton > SaveData_Detail · `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` · SP `SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0023-049 | 저장(오류) | 위와 같음 | 1) Confirm Qty*를 비움 2) SaveButton | shipment_confirm_qty=빈값 | 검증 실패로 저장이 중단되고 SP가 호출되지 않음(메시지 원문 확인 필요) | SaveData_Detail · Validation_Check(shipment_confirm_qty …) · `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` 미호출 |
| TC-SSP0023-050 | 저장 | 변경요청 대상 행 존재 | 1) SaveButton | — | 확정 변경 시각 검사 SP가 호출됨(결과 분기 확인 필요) | GetERPInterface > ChkConfirmChangeTime · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` · SP `SCM_SSP_CHECK_CONFIRM_CHANGETIME` |
| TC-SSP0023-051 | 저장 | 확정 행 존재 | 1) SaveButton | — | 출하 상태 조회 결과 Tables[0..2]의 CONFIRM_ID로 상태를 확인함(차단 조건 확인 필요) | GetERPInterface > GetShipmentStatusChk · `SSP.SSP0023_GET_SHIPMENT_STATUS` · SP `SSP0023_GET_SHIPMENT_STATUS` |
| TC-SSP0023-052 | 저장 | 확정 행 존재 | 1) SaveButton | — | SO No 건수(CNT)를 조회함 | GetERPInterface > GetErpSoNoCnt · `SSP.SSP0023_GET_ERP_SO_NO_CNT` · SP `SSP0023_GET_ERP_SO_NO_CNT` |
| TC-SSP0023-053 | 저장 | SO No가 없는 확정 행(분기 조건 확인 필요) | 1) Shipment Date* 변경 2) SaveButton | 날짜 변경 | NonSoNo 경로로 변경요청이 생성됨(SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE INSERT) | GetERPInterface > NonSoNo · `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` · SP `SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0023-054 | 저장 | SO No가 있는 확정 행 | 1) Confirm Qty* 변경 2) SaveButton | 수량 변경 | SoNo 경로로 변경요청이 생성되고 GetErpIFCheckNew에서 기존 Drafting 정리와 CHG_BATCH가 실행됨(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT). CHG_BATCH 2회 호출 조건 확인 필요 | SoNo > GetErpIFCheckNew · `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` · SP `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0023-055 | 저장 | ERP 오류 상태의 변경요청 존재(조건 확인 필요) | 1) SaveButton | — | ERP 오류 확인이 기록됨(SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ/_DE UPDATE) | GetERPInterface · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · SP `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| TC-SSP0023-056 | 저장 | 확정 기준 Drafting 정리 대상 존재(조건 확인 필요) | 1) SaveButton | — | Drafting 정리 SP가 실행됨(SSP_ANL_SHIP_CONFIRM DELETE/UPDATE, XIF INSERT) | GetERPInterface:3319 · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` · SP `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0023-057 | 저장 | TC-048 완료 | 1) 저장 완료 후 그리드 확인 | — | `spdMain`과 `Shipment Plan Detail`이 재조회되어 저장값이 반영됨 | SaveData_Detail > FindData_Main / FindData_Detail · `SSP.SSP0023_GET_SHIPMENT_PLAN` · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0023-058 | 저장 | SQL 추적(Profiler 등) 활성 | 1) TC-053, TC-054 절차 수행 2) 호출 SP 목록 확인 | — | `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`이 호출되지 않음(진입점 미연결 GetErpIFCheckNew_/GetErpIFCheck) | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` · SP `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` (unreached 4195/4251) |
| TC-SSP0023-059 | 저장(오류) | ERP I/F 차단 상태(BLOCK_YN=Y, 데이터 출처 확인 필요) | 1) SaveButton | — | ERP I/F 차단 처리(메시지와 동작 확인 필요) | chkERPIFBlockYn(BLOCK_YN, PERIOD) · GetERPInterface |
| TC-SSP0023-060 | 저장(오류) | SP 실행 오류 상황 | 1) SaveButton | — | 오류 메시지가 표시되고 부분 저장 여부를 확인함(트랜잭션 경계 확인 필요) | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0023-061 | division | Division 40 계정 | 1) `clbDivision_ID`=40 2) 조회 3) btnSearch | Division 40 | 5개 시트 컬럼 구성이 메타 결과와 같음(Plan(Electrode) 13, Detail 44, Stock 31, Result 20, Excel 9 — ?9 포함) | Fact Pack §10/§12 · 시트 `Shipment Plan(Electrode)` · `Shipment Plan Detail` · `Stock Detail` · `Shipment Result` · `Shipment Plan Detail Excel` |
| TC-SSP0023-062 | division | Division 81 / 82 / EE 계정 | 1) 각 Division으로 TC-061 반복 | 81, 82, EE | 컬럼 구성이 TC-061과 같음(division 변형 없음) | Fact Pack §10/§12 · `clbDivision_ID_SelectedIndexChanged` |
| TC-SSP0023-063 | 권한 | 모델 담당자 계정 | 1) `chkMyModel` 체크 후 조회 2) `chkDelegateeModel`, `chkTeamLeader`, `chkPartLeader` 각각 체크 후 조회 | — | 담당 범위에 따라 조회 결과가 달라짐(SP 파라미터 연결 확인 필요) | `SSP.SSP0023_GET_SHIPMENT_PLAN` (SSP_MST_MODEL_USER, SSP_MST_DELEGATE) |

### 커버리지 점검
| 항목 | 대상 수 | TC |
|---|---:|---|
| 이벤트 핸들러 | 28 | `btnExcelFormDownload_Click`(032) · `btnExcelUpload_Click`(033) · `Form_Load`(001–004) · `SpdMain_TopChange`(010) · `cboBucketType_SelectedIndexChanged`(011–013) · `rdButton_Changed`(014–015) · `chkSum_CheckedChanged`(016) · `SpdMain_CellDoubleClick`(018–019) · `SpdMain_Change`(020) · `spdMain_ClipboardPasted`(021) · `BtnMeasure_Click`(022) · `btnItemId_Click`(023) · `BtnMaterialId2_Click`(024) · `BtnSearch_Click`(025, 029) · `BtnRequestor_Click`(030) · `BtnSimulation_Click`(031) · `SpdDetail_SheetTabClick`(034) · `SpdDetail_ActiveSheetChanged`(035) · `SpdDetail_CellClick`(036–038) · `SpdDetail_ComboSelChange`(039) · `SpdDetail_CellDoubleClick`(040) · `SpdDetail_EditChange`(041) · `SpdDetail_ClipboardPasted`(042) · `clbDivision_ID_SelectedIndexChanged`(043) · `clbCompanyID_SelectedIndexChanged`(044) · `cboPlanDate_SelectedIndexChanged`(045) · `chkPastPeriod_CheckedChanged`(009, 017) · `shtPlanDetail_Change`(046) |
| 엔드포인트 | 18 | `DM.DM0003_GET_BUCKET_TYPE_CODE`(001) · `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN`(002) · `SSP.SSP0023_GET_SHIPMENT_PLAN`(005) · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`(018) · `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`(025) · `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT`(025) · `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL`(032) · `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU`(031) · `SSP.SSP0002_GET_USER_INFO_LIST`(047) · `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`(048) · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`(050) · `SSP.SSP0023_GET_SHIPMENT_STATUS`(051) · `SSP.SSP0023_GET_ERP_SO_NO_CNT`(052) · `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`(053) · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`(054) · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`(055) · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`(056) · `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`(058, 미호출 확인) |
| 시트 | 5 | `Shipment Plan(Electrode)`(008) · `Shipment Plan Detail`(026) · `Stock Detail`(027) · `Shipment Result`(028) · `Shipment Plan Detail Excel`(032) |
| division | 변형 없음 | 061–062 (40, 81, 82, EE 동일성 확인) |
| 빈 결과 / 오류 | — | 빈 결과 006, 029 / 오류 004, 007, 049, 059, 060 |
