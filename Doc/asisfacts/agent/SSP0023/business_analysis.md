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
