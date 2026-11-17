=== FILE: business_analysis.md ===
# SSP0021 Shipment Plan — 업무분석서

> **근거 범위**: AsisFacts 정적 추출 Fact Pack(SSP0021)과 1차 분석서(analysis.md · web_components.md · tobe_design.md)만 사용했다. Fact Pack에 없는 내용은 **확인 필요**로 적었다.
> **대상 파일**: 현행(current) `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.cs`(6583줄), `SSP0021_ShipmentPlan.Designer.cs`(1566줄). 구버전 사본(legacy) `06.UIL\GSCM.SSP.Plan.UIL\...`는 집계하지 않았다.
> **주석 처리된 호출**: 1건(320줄)이 있다. 현행 기능이 아니므로 이 문서의 시나리오·규칙·데이터 흐름에 넣지 않았다.
> **문서 간 참조**: §5 데이터 흐름의 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 '근거' 열과 같은 표기를 쓴다.

---

## 1. 업무 목적·범위

### 1.1 목적 (Fact Pack에서 확인되는 기능 범위만)
| # | 기능 | 근거 |
|---:|---|---|
| F1 | 출하계획(Shipment Plan)을 Division·Company·From Site·Plan-date·Model 조건으로 조회한다. 날짜 버킷(Daily/Weekly/Monthly) 열과 Measure 행으로 보여 준다 | FindButton → `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, SCM_MST_SHEET_MEASURE 9건 |
| F2 | 메인 그리드 셀을 더블클릭하면 그 셀에 맞는 상세 시트를 조회한다: 출하계획 상세, ERP 재고 위치, oWMS 재고, Hold 재고, MES 재고 | `SpdMain_CellDoubleClick` → 상세 조회 엔드포인트 6종 |
| F3 | 하단 상세 조건 영역에서 활성 상세 시트와 출하실적(Shipment Result)을 다시 조회한다 | `BtnSearch_Click` → 상세 조회 엔드포인트 6종 |
| F4 | Shipment Plan Detail에서 출하 확정 수량·일자·운송수단 등을 편집해 저장한다. 저장하면 출하요청 확정·변경요청(Drafting)이 등록되고 ERP I/F 테이블에 기록된다 | SaveButton → `SaveData_Detail` → `GetERPInterface` 체인 |
| F5 | Hold stock 데이터를 저장한다 | SaveButton → `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` (⚠ DB에 SP 없음) |
| F6 | 편집 전에 사용자 권한을 확인한다 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST` |
| F7 | Simulation 버튼을 제공한다 | `BtnSimulation_Click`. 엔드포인트 호출 없음. 계산 로직은 **확인 필요** |

### 1.2 범위 수치 (Fact Pack 집계)
| 항목 | 값 |
|---|---|
| 활성 엔드포인트 | 23종, 호출 지점 28개 (endpoints.csv) |
| 기능 흐름 행 | 43행 (flow.csv. 진입점 미연결 3행 포함) |
| 이벤트 배선 | 28행, 핸들러 26종 (events.csv) |
| 컨트롤 | 58개 (controls.csv) |
| 그리드 시트 | 9개: Shipment Plan / Shipment Plan Detail / Stock Location Detail / oWMS Detail / Hold stock / Hold stock Detail / MES Stock / MES Stock Detail / Shipment Result |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. 내용은 Fact Pack 미포함) |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---:|---|---|---|
| S1 | 화면을 연다 | `Form_Load` → InitControls → SetChangedControl → `SSP.SSP0021_GET_SHIPMENT_DIVISION` / GetBucketType → `DM.DM0003_GET_BUCKET_TYPE_CODE` / CreateSpread → InitSpread → GetSpdTitle → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Division·Bucket 콤보 구성. 메인·상세 그리드 헤더 생성. 상세 시트의 활성 시트는 Shipment Plan Detail(CreateSpread 594줄) |
| S2 | Division을 바꾼다 | `clbDivision_ID_SelectedIndexChanged`: c["DIVISION_ID"], dtDiv_Company_ID.Rows[0]["NAME"] 읽음 | Company 관련 값 반영. dtDiv_Company_ID의 데이터 출처는 **확인 필요** |
| S3 | Company를 바꾼다 | `clbCompanyID_SelectedIndexChanged`: `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` 호출(5916줄). cboPlanDate 이벤트 해제(5933줄, `-=`) 후 재연결(5937줄, `+=`). InitSpread → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | From Site 목록 갱신, 그리드 헤더 재구성 |
| S4 | Plan-date를 바꾼다 | `cboPlanDate_SelectedIndexChanged`: row CODE, dr FROM_DATE/TO_DATE 읽음(5963~5970줄) → GetSpdTitle(5981줄) → InitSpreadDateColumn(5983줄) | Period(drpPeriod, 비활성)에 FROM/TO 반영, 날짜 열 재생성 |
| S5 | Bucket을 바꾸거나 Sum을 체크/해제한다 | `cboBucketType_SelectedIndexChanged`(SetSpreadColumn 4451줄) / `chkSum_CheckedChanged`(SetSpreadColumn 4456줄) | DB 호출 없이 D_/W_/M_ 태그 열의 표시를 전환 (§4 R10) |
| S6 | Measure 버튼을 누른다 | `BtnMeasure_Click` → InitSpread → GetSpdTitle → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 메인 그리드 재구성. 측정 항목 선택 UI는 **확인 필요** |
| S7 | 조회(툴바 Find)를 누른다 | FindButton → FindData_Main(GetCheckedListValue 4563~4571줄) → `SSP.SSP0021_GET_SHIPMENT_PLAN` → InitSpread → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Shipment Plan 시트(spdMain)에 결과 표시 |
| S8 | 메인 셀을 더블클릭한다 | `SpdMain_CellDoubleClick`(2059~2094줄): 클릭 열과 MEASURE/BOH_TYPE 값으로 분기 | 상세 시트 전환·조회 (§4 R12) |
| S9 | 상세 조건(Shipment Date·Model·Requestor 등)을 입력하고 Search를 누른다 | `BtnSearch_Click` → 활성 상세 시트에 맞는 FindData_* 호출 | 상세 시트 재조회. 시트별 분기 조건식은 **확인 필요** |
| S10 | Model / Requestor 팝업 버튼을 누른다 | `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click` (엔드포인트 없음) | 입력란(txtItemId / txtModel2 / txtRequestor)에 반영. 팝업 대상은 **확인 필요** |
| S11 | 편집(툴바 Edit)을 누른다 | EditButton → GetSSPUserCheck → `SSP.SSP0002_GET_USER_INFO_LIST` | 사용자 정보 확인 후 편집 허용 여부 결정. 판정식은 **확인 필요** |
| S12 | Shipment Plan Detail을 편집하고 저장(툴바 Save)한다 | SaveButton → SaveData_Detail → Validation_Check → `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` / GetERPInterface 체인 → 재조회 | 확정·변경요청 저장, ERP I/F 기록, 메인·상세·Hold 재조회 |
| S13 | Hold stock 시트를 편집하고 저장한다 | SaveData_Detail(2784·2822줄) → `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` → FindData_hold_stock → `SSP.SSP0021_GET_HOLD_STOCK` | ⚠ DB에 SP가 없어 실제 동작은 **확인 필요** |
| S14 | Simulation을 누른다 | `BtnSimulation_Click`. Simulation 메서드가 row DIVISION_ID·FROM_SITE·ITEM_ID, dr["Container_Qty"]를 읽는다(6124~6130줄). 핸들러와 이 메서드의 연결은 Fact Pack에 없다 | **확인 필요** |

---

## 3. 업무 흐름도 (텍스트)

```
[화면 진입] Form_Load
  ├─ InitControls ─ SetChangeControl(GetSSPInnerTable ×8, GROUP_ID·USER_ID 필터)
  │               ├─ SetChangedControl ─▶ SSP.SSP0021_GET_SHIPMENT_DIVISION ─▶ Division 콤보
  │               └─ GetBucketType     ─▶ DM.DM0003_GET_BUCKET_TYPE_CODE   ─▶ Bucket 콤보
  └─ CreateSpread ─ InitSpread ─ GetSpdTitle ─▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN ─▶ 날짜 헤더
        ▼
[조회조건 설정]
  Division 변경 ─ clbDivision_ID_SelectedIndexChanged
  Company 변경  ─ clbCompanyID_SelectedIndexChanged ─▶ SSP.SSP0021_GET_SHIPMENT_FROM_SITE (From Site)
                                                  └▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
  Plan-date 변경 ─ cboPlanDate_SelectedIndexChanged ─▶ Period(FROM/TO) + SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
  Bucket/Sum 변경 ─ SetSpreadColumn (열 표시만 전환, DB 호출 없음)
        ▼
[조회] FindButton ─ FindData_Main ─▶ SSP.SSP0021_GET_SHIPMENT_PLAN ─▶ spdMain(Shipment Plan)
        ▼
[상세 탐색] SpdMain_CellDoubleClick
  ├─ MEASURE=SHIP_PLAN (날짜 열)  ─▶ SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL  ─▶ Shipment Plan Detail
  ├─ BOH_QTY & BOH_TYPE=ERP       ─▶ SSP.SSP0021_GET_STOCK_LOCATION_DETAIL ─▶ Stock Location Detail
  ├─ BOH_QTY & BOH_TYPE=oWMS      ─▶ SSP.SSP0021_GET_OWMS_DETAIL           ─▶ oWMS Detail
  ├─ BOH_QTY & BOH_TYPE=HOLD      ─▶ SSP.SSP0021_GET_HOLD_STOCK            ─▶ Hold stock
  └─ BOH_QTY & BOH_TYPE=MES       ─▶ SSP.SSP0021_GET_MES_STOCK_DETAIL / SSP.SSP0021_GET_MES_STOCK ─▶ MES Stock Detail / MES Stock
  [상세 재조회] BtnSearch_Click ─▶ 위 상세 엔드포인트 + SSP.SSP0021_GET_SHIPMENT_RESULT(Shipment Result)
        ▼
[편집] EditButton ─ GetSSPUserCheck ─▶ SSP.SSP0002_GET_USER_INFO_LIST
        ▼
[저장] SaveButton ─ SaveData_Detail
  ├─ Validation_Check (shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks)
  ├─ ▶ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM (2664줄)
  ├─ ▶ SSP.SSP0021_SAVE_HOLD_STOCK_DATA (2822줄, ⚠ DB 미존재)
  ├─ GetERPInterface
  │    ├─ ChkConfirmChangeTime ▶ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME
  │    ├─ GetErpSoNoCnt        ▶ SSP.SSP0021_GET_ERP_SO_NO_CNT (CNT)
  │    ├─ GetShipmentStatusChk ▶ SSP.SSP0021_GET_SHIPMENT_STATUS (Tables[0~2].CONFIRM_ID)
  │    ├─ ▶ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM (3352줄)
  │    ├─ ▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (3393줄)
  │    ├─ NonSoNo ▶ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING (3521줄)
  │    └─ SoNo    ▶ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING (3742줄)
  │              └─ GetErpIFCheckNew ▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (4019줄)
  │                                  ▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH (4045·4075줄)
  └─ 재조회: FindData_Main / FindData_Detail / FindData_hold_stock
             ▶ SSP.SSP0021_GET_SHIPMENT_PLAN / SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL / SSP.SSP0021_GET_HOLD_STOCK

[진입점 미연결(정적)] GetErpIFCheck(3941) · GetErpIFCheckNew_(4404) ▶ SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING
                      NewNonSoNo(4290) ▶ SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING
```
- 저장 체인의 단계별 실행 순서와 분기 조건(어느 행이 CONFIRM 또는 DRAFTING으로 가는지, ERROR_CONFIRM·DELETE_BY_CONFIRM 호출 조건)은 Fact Pack에 조건식이 없다. **확인 필요**. 위 그림은 줄 번호 순서로 그린 것이다.

---

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거 |
|---:|---|---|
| R1 | 조회조건 필수 표기: `Division*`, `Company*`, `Plan-date*`, `Period*` (라벨 원문에 `*`). 필수값 검증 코드의 위치와 메시지는 **확인 필요** | props.csv Text |
| R2 | Period(drpPeriod)는 `Enabled=false`다. 사용자가 입력하지 않고 Plan-date의 FROM_DATE/TO_DATE로 채운다 | props.csv 471줄, cboPlanDate_SelectedIndexChanged 5967~5970줄 |
| R3 | Company를 바꾸는 동안 cboPlanDate의 SelectedIndexChanged를 해제(`-=` 5933줄)했다가 재연결(`+=` 5937줄)한다. 회사 변경 중 Plan-date 이벤트가 연쇄로 실행되지 않게 막는다 | events.csv |
| R4 | From Site 목록은 Company 선택에 따라 `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`로 조회한다. 다중 선택값은 GetCheckedListValue(CODE)로 전달한다 | flow.csv, 4-2절 |
| R5 | 사용자 그룹 `UserInfoContext.Current.NowGroupID`를 InitControls·SetChangeControl·SetChangedControl·clbCompanyID_SelectedIndexChanged에서 사용한다. SetChangeControl은 GROUP_ID·USER_ID로 필터한다(338~339줄) | Fact Pack 4장 |
| R6 | Plan-date 판정(Plan_Current_Check)은 Tmp_dtPlanDate.Rows[0]의 CODE·NAME·FROM_DATE·TO_DATE를 쓴다(5540~5559줄). Plan-date 콤보의 데이터 원천은 **확인 필요** | Fact Pack 4장 |
| R7 | 입력 기간 설정: InitControls가 dtShipmentInputPeriod.Rows[0]/[1]의 VALUE·Diff_VALUE를 읽는다. 데이터 출처와 의미는 **확인 필요** | Fact Pack 4장 |
| R8 | 날짜 열 생성(DB 루프): `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과를 행마다 돈다. 컬럼명에 `B_`가 있으면(`IndexOf("B_") > 0`) Text 열(너비 0, 숨김), 없으면 Num 열(너비 70)을 만든다. DAY_CODE가 SAT이면 글자색 Blue, SUN이면 Red | InitSpreadDateColumn 862·866·870줄 |
| R9 | 메인 헤더는 3행이다. LARGE_CLASS_LABEL_NAME·SMALL_CLASS_LABEL_NAME으로 Span을 만들고 "SUM" 헤더를 둔다. Shipment Plan의 MergePolicy는 Always | InitSpread 610·627줄, 877~906줄 |
| R10 | Bucket/Sum 열 표시 규칙(SetSpreadColumn): **DAILY** = D_·W_ 열 Visible=true(4469줄), 이어서 M_·W_ 열 Visible=chkSum.Checked(4474줄). W_ 열의 최종값은 실행 순서상 **확인 필요**. **WEEKLY** = D_ false(4481줄), W_ true(4485줄), M_ = chkSum.Checked(4490줄). **MONTHLY** = D_·W_ false(4497줄), M_ true(4501줄) | grid_code.csv |
| R11 | Bucket 콤보 값은 `DM.DM0003_GET_BUCKET_TYPE_CODE`(SCM_ADM_LOOKUP_MASTER_DETAIL)에서 온다. 코드 분기에 쓰는 값은 DAILY/WEEKLY/MONTHLY | flow.csv, grid_code.csv |
| R12 | 메인 더블클릭 분기: 클릭 열 ≥ MEASURE+1이고 MEASURE == "SHIP_PLAN"이면 Shipment Plan Detail. 클릭 열이 BOH_QTY이면 BOH_TYPE에 따라 "ERP" → Stock Location Detail, "oWMS" → oWMS Detail, "HOLD" → Hold stock, "MES" → MES Stock Detail(2088~2089줄)·MES Stock(2093~2094줄) | SpdMain_CellDoubleClick 2059~2094줄 |
| R13 | 저장 전 검증(Validation_Check): confirm_id 기준으로 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks를 검증한다. SO No가 없는 행(Validationdr)과 있는 행(SONoValidationdr)을 따로 검증한다(3006~3011, 3053~3058, 3143~3148줄). 각 필드의 검증 조건식과 메시지는 **확인 필요** | Fact Pack 4장 |
| R14 | 메타 라벨의 필수 표기(`*`): Shipment Plan Detail = `Shipment Qty*`, `Shipment Date*`, `Trans Mode*`. Hold stock = `Amend Qty*`, `End Date*` | grid_effective |
| R15 | SO No 유무로 저장 경로가 나뉜다: NonSoNo / SoNo → `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`. SoNo 경로에서만 GetErpIFCheckNew가 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`(2회)를 호출한다 | flow.csv |
| R16 | ERP SO 건수 확인: GetErpSoNoCnt가 결과 Tables[0].Rows[0]["CNT"]를 확인한다(3853줄). 판정 기준값은 **확인 필요** | Fact Pack 4장 |
| R17 | 출하 상태 확인: GetShipmentStatusChk가 결과 Tables[0]·[1]·[2]의 CONFIRM_ID를 확인한다(3882·3896·3911줄). 테이블별 의미는 **확인 필요** | Fact Pack 4장 |
| R18 | ERP I/F 차단 확인: chkERPIFBlockYn이 dtERPBlockYnIF.Rows[0]의 BLOCK_YN(2930줄)·PERIOD(2939줄)를 읽는다. 조회 엔드포인트와 차단 시 동작은 **확인 필요** | Fact Pack 4장 |
| R19 | 확정 변경 시각 확인: ChkConfirmChangeTime → `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`(SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 조회). 판정 결과의 사용 방식은 **확인 필요** | flow.csv |
| R20 | 상세 그리드 잠금: SpdDetail_CellClick이 `siDetail.IsLock(SheetName) == false`일 때만 헤더 체크박스(CheckBoxCellType) 클릭으로 전체 선택/해제를 토글한다(1802·1837·1841줄) | grid_code.csv |
| R21 | 합계: CalculateSum / Set_SumValues가 measure 컬럼 기준으로 합계를 낸다(5630·5753·4675줄). 계산식은 **확인 필요** | Fact Pack 4장 |
| R22 | division 82 전용 너비: Shipment Result의 CHILD_QTY Width = 75 (InitSpread 727줄, `p_division_id.ToString().Trim() == "82"`) | grid_code.csv |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

> 표기: 읽기 = SELECT 대상, 쓰기 = INSERT/UPDATE/DELETE/MERGE 대상(`#` = 임시 테이블). 내부 EXEC 전이는 endpoints.csv `objects` 원문 기준이다.

| # | 엔드포인트 | SP | 호출 진입점 (flow.csv) | 읽기 테이블 | 쓰기 테이블 |
|---:|---|---|---|---|---|
| 1 | `SSP.SSP0021_GET_SHIPMENT_DIVISION` | `SSP0021_GET_SHIPMENT_DIVISION` | Form_Load > InitControls > SetChangedControl (493) | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE (FN_GET_LOOKUP_VALUE) | #RETURNTABLE(임시) |
| 2 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | SaveButton > SaveData_Detail (2664) | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_MST_SEND_MAIL_REQ, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, NERP_CONV_MASTER, TB_FX_USER, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_PROJECT, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER_EE | UPDATE/INSERT SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT/UPDATE SSP_MST_SEND_MAIL_REQ, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH, #TBLSSPADJUSTMAILSEND·#T_CONFIRM_ID·#T_SSP·#T_SSP_SUM·#T_MKT_RESULT. 내부 EXEC: PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_SCP_SYS_LOG_BATCH, PR_SSP_MAIL_SEND_ADJUST_SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 3 | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | `SSP0021_SAVE_HOLD_STOCK_DATA` | SaveButton > SaveData_Detail (2822) | **확인 필요** (⚠ DB에 SP 없음) | **확인 필요** |
| 4 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | … > GetERPInterface (3352) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN) |
| 5 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | … > GetERPInterface (3393), … > SoNo > GetErpIFCheckNew (4019) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 |
| 6 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | `SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | … > GetERPInterface > NonSoNo (3521), … > SoNo (3742) / 미연결 NewNonSoNo (4290) | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH (내부 EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCM_SYS_LOG_BATCH, PR_SCP_SYS_LOG_BATCH) |
| 7 | `SSP.SSP0021_GET_ERP_SO_NO_CNT` | `SSP0021_GET_ERP_SO_NO_CNT` | … > GetERPInterface > GetErpSoNoCnt (3843) | SSP_ANL_SHIP_CONFIRM (결과 CNT) | — |
| 8 | `SSP.SSP0021_GET_SHIPMENT_STATUS` | `SSP0021_GET_SHIPMENT_STATUS` | … > GetERPInterface > GetShipmentStatusChk (3868) | SSP_ANL_SHIP_CONFIRM (STRING_SPLIT. 결과 Tables[0~2].CONFIRM_ID) | — |
| 9 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | `SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | **진입점 미연결**: GetErpIFCheck (3941), GetErpIFCheckNew_ (4404) | — | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH |
| 10 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | … > SoNo > GetErpIFCheckNew (4045, 4075) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCP_SYS_LOG_BATCH) |
| 11 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | Form_Load > InitControls > GetBucketType (4513) | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 12 | `SSP.SSP0021_GET_SHIPMENT_PLAN` | `SSP0021_GET_SHIPMENT_PLAN` | FindButton > FindData_Main (4598), SaveButton > SaveData_Detail > FindData_Main | SCM_MST_TITLESET_USER, SSP_DNM_GMES_STOCK_81_82, SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, MST_STOCK, MST_LOCATION, PACKER_STOCK, SCM_MST_SITE, SCM_MST_ITEM_SN, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SSP_MST_LOCATION_V, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SCP_PLAN_VERSION_V, SSP_DNM_FP_AMEND_SHIPAVAL, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCP_MST_BOD_N_V, SCP_MST_SHIPMENT_LOT_SIZE, SSP_ANL_SHIP_PLAN_C, SCM_CODE_LOOKUP_VALUE (동적 SQL 포함) | 임시: #TBLDYNAMICTITLEST_SSP0021, #TMP_RESULT_TABLE(MERGE), #TMP_BOHDATA_STORAGE, #TMP_BOHDATA, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE, #TMP_RESULT_PIVOT_TABLE_OLD. `UPDATE:C`는 별칭으로 보이며 대상은 **확인 필요** |
| 13 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | `SSP0021_GET_SHIPMENT_PLAN_DETAIL` | FindData_Detail (4877): SpdMain_CellDoubleClick / BtnSearch_Click / SaveData_Detail | 동적 SQL(DYNAMIC@) + FN_GET_IN_STR, FN_SCM_SPLIT. 정적 추출 테이블 없음 → **확인 필요** | — |
| 14 | `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` | `SSP0021_GET_STOCK_LOCATION_DETAIL` | FindData_Stock_Detail (4990): SpdMain_CellDoubleClick / BtnSearch_Click | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SCM_MST_ITEM_SN | — |
| 15 | `SSP.SSP0021_GET_OWMS_DETAIL` | `SSP0021_GET_OWMS_DETAIL` | FindData_oWMS_Detail (5087): SpdMain_CellDoubleClick / BtnSearch_Click | SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_MST_MODEL_USER, SCM_MST_ITEM_SN | — |
| 16 | `SSP.SSP0021_GET_SHIPMENT_RESULT` | `SSP0021_GET_SHIPMENT_RESULT` | BtnSearch_Click > FindData_Shipment_Result (5180) | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MODEL_COMP_TEMP_SN, SCM_ITEM_M_SN, SCM_ITEM_CLASS_M_SN, SCM_DNM_EXFACTORY_RESULT, SCM_MST_ITEM_SN, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS. RESULT_ERP_C_EXIST·RESULT_CHILD_QTY·RESULT_ERP_C_NON·PLAN_SSP·RESULT_OWMS·RETURN_OWMS가 CTE인지 실객체인지 **확인 필요** | — |
| 17 | `SSP.SSP0021_GET_HOLD_STOCK` | `SSP0021_GET_HOLD_STOCK` | FindData_hold_stock (5283): SpdMain_CellDoubleClick / SaveData_Detail | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_ITEM_SN | — |
| 18 | `SSP.SSP0021_GET_MES_STOCK` | `SSP0021_GET_MES_STOCK` | FindData_MES_stock (5382): SpdMain_CellDoubleClick / BtnSearch_Click | SSP_DNM_GMES_STOCK_81_82 | — |
| 19 | `SSP.SSP0021_GET_MES_STOCK_DETAIL` | `SSP0021_GET_MES_STOCK_DETAIL` | FindData_MES_stock_Detail (5482): SpdMain_CellDoubleClick / BtnSearch_Click | SSP_DNM_GMES_STOCK_81_82 | — |
| 20 | `SSP.SSP0002_GET_USER_INFO_LIST` | `SSP0002_GET_USER_INFO_LIST` | EditButton > GetSSPUserCheck (5850) | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — |
| 21 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | (FoxQuery 미등록 **NOT_IN_FOXQUERY**. DB 객체 P 존재) | clbCompanyID_SelectedIndexChanged (5916) | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (DB 보강 결과) | — |
| 22 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle (6063): Form_Load / FindButton / SaveButton / BtnMeasure_Click / BtnSearch_Click / SpdMain_CellDoubleClick / clbCompanyID_SelectedIndexChanged / cboPlanDate_SelectedIndexChanged | SCM_SYS_CALENDAR_M | — |
| 23 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | `SCM_SSP_CHECK_CONFIRM_CHANGETIME` | … > GetERPInterface > ChkConfirmChangeTime (6561) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH) |

- SP 22종(Fact Pack 기준): `SSP0021_GET_SHIPMENT_DIVISION`, `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0021_SAVE_HOLD_STOCK_DATA`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP0021_GET_ERP_SO_NO_CNT`, `SSP0021_GET_SHIPMENT_STATUS`, `SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `DM0003_GET_BUCKET_TYPE_CODE`, `SSP0021_GET_SHIPMENT_PLAN`, `SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP0021_GET_OWMS_DETAIL`, `SSP0021_GET_SHIPMENT_RESULT`, `SSP0021_GET_HOLD_STOCK`, `SSP0021_GET_MES_STOCK`, `SSP0021_GET_MES_STOCK_DETAIL`, `SSP0002_GET_USER_INFO_LIST`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCM_SSP_CHECK_CONFIRM_CHANGETIME`. 23번째 엔드포인트 `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`는 FoxQuery에 SP 매핑이 없어 SP 목록에서 빠지고, DB 객체(P)로만 확인된다.
- 프레임워크 메타 조회(엔드포인트 집계 외): `DataService.GetSSPInnerTable` ×8(SetChangeControl 345~380), `DataService.FP_Log2` ×2(InitControls 408·419), `SpreadInfo.SetSheetHeaderColumn`(SCM_MST_SHEET_COLUMNS), `SpreadInfo.GetSpdTitle`.

---

## 6. Division·권한별 변형

### 6.1 Division
| 항목 | 사실 |
|---|---|
| 대상 division | 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC (14개) |
| 메타 표시 컬럼 수 | 9개 시트 모두 14개 division에서 같다: Hold stock 10, Hold stock Detail 10, MES Stock 9, MES Stock Detail 13, oWMS Detail 25, Shipment Plan 8, Shipment Plan Detail 42, Shipment Result 18, Stock Location Detail 20 |
| SCM_MST_SHEET_MEASURE | Shipment Plan Measure 9건, 전 division 동일 |
| 코드 분기 | **1건**: division `82`일 때 Shipment Result `CHILD_QTY` Width=75 (InitSpread 727줄). 표시 여부가 아니라 너비만 바꾼다 |
| Division 목록 | `SSP.SSP0021_GET_SHIPMENT_DIVISION`이 TB_FX_USERGROUPAUTHEXTENTION을 참조한다. 사용자 그룹별로 목록이 달라질 수 있으나 판정식은 **확인 필요** |
| 테이블명 | `SSP_DNM_GMES_STOCK_81_82`(MES 재고)의 이름에 81·82가 들어 있다. division 81/82 외 데이터 유무는 **확인 필요** |

### 6.2 권한 (C/R/U/D)
| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0021_GET_SHIPMENT_PLAN`. 상세 조회 엔드포인트 6종 + `SSP.SSP0021_GET_SHIPMENT_RESULT` |
| U/C | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST`(사용자 확인). SaveButton → 저장 체인(§5 #2~#10, #23) |
| D | 툴바 DeleteButton 진입점은 flow.csv에 없다. 삭제성 SP(`SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, DELETE SSP_ANL_SHIP_CONFIRM)는 저장 체인 안에서만 호출된다 |
| 그룹 | `UserInfoContext.Current.NowGroupID`(InitControls 443, SetChangedControl 497, SetChangeControl 338, clbCompanyID_SelectedIndexChanged 5922). SetChangeControl Filter GROUP_ID·USER_ID |
| 시트 잠금 | `siDetail.IsLock(SheetName)` (SpdDetail_CellClick) |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 14행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. 그룹별 C/R/U/D 값은 **확인 필요** |

---

## 7. 외부 인터페이스 (Fact Pack에 객체가 있는 것만)

| 인터페이스 객체 | 방향 | 기록/참조 SP | 비고 |
|---|---|---|---|
| XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | INSERT | `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | 이름에 XIF_ERP_ 접두가 있다. 수신 시스템과 전송 주기는 **확인 필요** |
| XIF_SCS_PACK_SHIP_PLAN_S_SN | INSERT | `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | 수신 시스템 **확인 필요** |
| NERP_CONV_MASTER | SELECT | 저장 계열 SP | ERP 코드 변환 마스터로 보이나 **확인 필요** |
| SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | ERP 오류 확인 기록 |
| SSP_ANL_OWMS_STOCK_C2, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS | SELECT | `SSP0021_GET_OWMS_DETAIL`, `SSP0021_GET_SHIPMENT_PLAN`, `SSP0021_GET_SHIPMENT_RESULT` | oWMS 재고·실적 데이터 |
| SSP_DNM_GMES_STOCK_81_82 | SELECT | `SSP0021_GET_MES_STOCK`, `SSP0021_GET_MES_STOCK_DETAIL`, `SSP0021_GET_SHIPMENT_PLAN` | MES 재고 데이터 |
| MST_STOCK, MST_LOCATION, PACKER_STOCK | SELECT | `SSP0021_GET_SHIPMENT_PLAN` | 스키마·소유 시스템 **확인 필요** |
| SSP_MST_SEND_MAIL_REQ, #TBLSSPADJUSTMAILSEND, PR_SSP_MAIL_SEND_ADJUST_MST/SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG | INSERT/UPDATE/EXEC | `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | 저장 시 메일 발송 요청 처리 |
| PR_DM_SSP_CONFIRM_SYNC | EXEC | `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | DM 영역 동기화 프로시저 |

---

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| U1 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`가 FoxQuery에 미등록이다(NOT_IN_FOXQUERY). DB에는 객체 P가 있다. 호출 방식과 파라미터를 확인해야 한다 | 5916줄 |
| U2 | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`는 FoxQuery에 있으나 **DB에 SP가 없다**. Hold stock 저장 기능의 실제 동작과 원본 SP를 확보해야 한다 | 2822줄 |
| U3 | 진입점 미연결 메서드 3개: GetErpIFCheck(3941), NewNonSoNo(4290), GetErpIFCheckNew_(4404). `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`은 이 미연결 메서드에서만 호출된다 | flow.csv unreached |
| U4 | 저장 체인 각 단계의 분기 조건과 실행 순서. 특히 ERROR_CONFIRM / DELETE_BY_CONFIRM / CONFIRM / DRAFTING 선택 조건 | flow.csv에 조건식 없음 |
| U5 | Validation_Check 필드별 검증 조건과 메시지 문구 | Fact Pack 4장 |
| U6 | chkERPIFBlockYn의 dtERPBlockYnIF 데이터 출처와 차단 동작 | 2930·2939줄 |
| U7 | Company·Plan-date 콤보 데이터 원천, dtShipmentInputPeriod·dtDiv_Company_ID·dtMyCompany 출처, GetSSPInnerTable 8회 호출의 code 값 | Fact Pack 4장 |
| U8 | Hold stock / Hold stock Detail 시트를 생성하는 위치(CreateSpread 551~555줄 미표시), SheetTabIndex 3·4 처리 | grid_code.csv |
| U9 | BtnSearch_Click의 시트별 분기식. drpPeriod2와 drpPeriod3의 용도 구분 | flow.csv |
| U10 | `BtnSimulation_Click`과 Simulation 메서드의 연결, 계산식 | 6124~6130줄 |
| U11 | `SSP0021_GET_SHIPMENT_PLAN_DETAIL` 동적 SQL의 참조 테이블 | DYNAMIC@ |
| U12 | `SSP0021_GET_SHIPMENT_PLAN`의 `UPDATE:C` 대상(별칭) | endpoints.csv |
| U13 | 그리드 실제 컬럼 순서(SORT_ORDER). grid_effective는 알파벳순이다 | grid_effective.csv |
| U14 | "실제 SP 실행 결과와 매칭되는 시트 없음": grid 단계 미실행 또는 시트명 불일치 | Fact Pack 10장 |
| U15 | 메뉴 위치와 그룹별 메뉴 권한 값 | TB_FX_* 메타 |

=== FILE: screen_design.md ===
# SSP0021 Shipment Plan — 화면설계서

> **근거**: Fact Pack(controls.csv · props.csv · events.csv · flow.csv · grid_effective · grid_code.csv)과 1차 분석서. props.csv는 일부가 잘려 있어 미확인 라벨은 **확인 필요**로 적었다.
> **문서 간 참조**: §5 액션 명세의 엔드포인트 = 업무분석서 §5 데이터 흐름의 엔드포인트. §3 컨트롤명 = 단위테스트 '절차' 열에서 쓰는 이름.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0021 |
| 화면명 | Shipment Plan (클래스 `SSP0021_ShipmentPlan`) |
| 도메인 | SSP (`GSCM.SSP.Forms.UIL\Plan`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용 미포함) |
| 화면 유형 | 조회조건(접기 패널) + 상/하 분할 그리드. 상단 = 출하계획 매트릭스(spdMain), 하단 = 상세 조건 줄 + 다중 시트 상세 그리드(spdDetail) |
| 그리드 구성 방식 | HYBRID: META(SCM_MST_SHEET_COLUMNS) + DB 루프(날짜 열) + 코드 표시/라벨 변경 |
| 툴바 | FindButton / EditButton / SaveButton (프레임워크 툴바 진입점. 배선 구조는 **확인 필요**) |

---

## 2. 화면 레이아웃

### 2.1 분할 트리 (controls.csv parent 체인 + props.csv Dock·Size·Orientation·SplitterDistance)

```
this (Form)  폭 1689
├─ usrConditionPanel1 [UsrConditionPanel] Dock=Top, 1689×73, UsrPanelType=HidePanel(접기 가능)
│   └─ usrLayoutControl2 [UsrLayoutControl] Dock=Top, 1689×77  (layoutControlGroup2 1689×77)
│        ※ 자식(77)이 부모 패널(73)보다 큼. 실제 표시 높이는 확인 필요
└─ splitContainer1 [SplitContainer] Dock=Fill, 1689×576, Orientation=Horizontal(상/하), SplitterDistance=303
    ├─ Panel1 (상) 303 / 576 = 52.6%
    │   └─ spdMain [FpSpread] Dock=Fill, 1689×303  (spdMain_Sheet1 → 시트 "Shipment Plan")
    └─ Panel2 (하) 273 / 576 = 47.4%
        ├─ usrLayoutControl3 [UsrLayoutControl] Dock=Top, 1689×40  (layoutControlGroup3 1689×49) ≈ 14.7%
        └─ spdDetail [FpSpread] Dock=Fill, 1689×229 (spdDetail_Sheet1 → 상세 시트 8개) ≈ 83.9%
            ※ 40 + 229 = 269. Panel2 273과 4px 차이 — SplitterWidth 미추출, 확인 필요
(parent 없음) usrButton1 [UsrButton] 75×23 — 화면 배치 여부 확인 필요
(parent 없음) imageList1 [ImageList]
```
- 세로 비율(폼 높이 73 + 576 = 649 기준): 조회조건 영역 11.2%, 분할 영역 88.8%.

### 2.2 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│ [툴바] Find │ Edit │ Save                                                (프레임워크)    │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ usrConditionPanel1 (HidePanel, 접기 가능) > usrLayoutControl2                             │
│ Division*[clbDivision_ID▼] Company*[clbCompany_ID▼] From Site[clbPlantSite☑▼]            │
│ Plan-date*[cboPlanDate▼] Period*[drpPeriod ~ (비활성)] Bucket[cboBucketType▼]            │
│ [☐ Sum chkSum] [btnMeasure] [Simulation btnSimulation] [☐ Show SQL chkSql]               │
│ Model[txtItemId ...............................................][btnItemId]             │
│ ※ 행·열 배치 좌표(Location)는 props.csv에 없어 위 행 구분은 Size 기준 추정 배치가 아님 → 확인 필요 │
├══════════════════════════════════ splitContainer1 (Horizontal) ═══════════════════════════┤
│ Panel1 52.6%  spdMain : Shipment Plan                                                     │
│ ┌ Div │ From Site │ Model │ Nick Name │ PSI │ BOH_TYPE │ BOH_QTY │ Measure │ [날짜 열…] SUM ┐ │
│ │ (헤더 3행: LARGE/SMALL CLASS Span, MergePolicy=Always)                                 │ │
│ └──────────────────────────────────────────────────────────────────────────────────────┘ │
├──────────────────────────────────────── splitter (303) ───────────────────────────────────┤
│ Panel2 47.4%  usrLayoutControl3 (40)                                                      │
│ Shipment Date[drpPeriod2 ~] Shipment Date[drpPeriod3 ~] Model[txtModel2][btnItemID2]      │
│ (라벨 확인 필요)[txtRequestor][btnRequestor] (라벨 확인 필요)[clbResultType☑▼]            │
│ (라벨 확인 필요)[txtBoxID] [Search btnSearch]                                             │
│ spdDetail (229) 시트 탭:                                                                  │
│ [Shipment Plan Detail][Stock Location Detail][oWMS Detail][Hold stock?][Hold stock Detail?]│
│ [MES Stock][MES Stock Detail][Shipment Result]   (탭 순서 3·4는 확인 필요)                 │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.3 영역 정의
| 영역 | 구성 컨트롤 | 비고 |
|---|---|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl2: clbDivision_ID, clbCompany_ID, clbPlantSite, cboPlanDate, drpPeriod, cboBucketType, chkSum, txtItemId, chkSql | 접기 가능 패널 |
| 버튼(조회조건 내) | btnItemId, btnMeasure, btnSimulation | |
| 상단 그리드 | spdMain / spdMain_Sheet1 | Shipment Plan |
| 하단 조건 | usrLayoutControl3: drpPeriod2, drpPeriod3, txtModel2, btnItemID2, txtRequestor, btnRequestor, clbResultType, txtBoxID, btnSearch | 상세 재조회 |
| 하단 그리드 | spdDetail / spdDetail_Sheet1 | 상세 시트 8개 |
| 팝업 | btnItemId_Click, BtnItemID2_Click, BtnRequestor_Click, BtnMeasure_Click가 여는 팝업 | 팝업 화면 ID **확인 필요** |
| 배치 미확인 | usrButton1 | parent 없음 |

---

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 크기 | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|---|
| 1 | `usrButton1` | UsrButton | (Text 미추출) | 75×23 | — | — | 없음 | 확인 필요 (parent 없음, 반영 여부 판단) |
| 2 | `usrConditionPanel1` | UsrConditionPanel | — | 1689×73, Dock Top | HidePanel | — | 없음 | 공용 조회조건 패널(접기) |
| 3 | `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2`(컨트롤 Text) | 1689×77, Dock Top | — | — | 없음 | 조회조건 레이아웃 |
| 4 | `chkSql` | UsrCheckBox | `Show SQL` (lblSql) | 98×20 | 확인 필요 | — | 배선 없음 | 확인 필요 (개발용 여부) |
| 5 | `btnSimulation` | UsrButton | `Simulation` | 106×25 | — | — | `BtnSimulation_Click` | Button |
| 6 | `clbCompany_ID` | UsrCombo | `Company*` (layoutControlItem1) | 178×20 | 확인 필요 (dtMyCompany NAME) | Y(`*`) | `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox |
| 7 | `chkSum` | UsrCheckBox | `Sum` (layoutControlItem8) | 84×25 | 확인 필요 | — | `chkSum_CheckedChanged` | CheckBox |
| 8 | `btnMeasure` | UsrButton | (Text 없음, layoutControlItem10) | 39×25 | — | — | `BtnMeasure_Click` | 아이콘 버튼(팝업) |
| 9 | `btnItemId` | UsrButton | (Text 없음, layoutControlItem2) | 39×24 | — | — | `btnItemId_Click` | 아이콘 버튼(팝업) |
| 10 | `clbPlantSite` | UsrCheckedList | `From Site` (layoutControlItem7) | 220×21 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` 결과 | — | 없음(GetCheckedListValue) | Wijmo MultiSelect |
| 11 | `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | 197×20 | **Enabled=false**, Plan-date FROM/TO | Y(`*`) | 없음 | InputDate ×2 (읽기전용) |
| 12 | `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 695×21 | 빈값(확인 필요) | — | 없음 | 다중값 입력 |
| 13 | `clbDivision_ID` | UsrCombo | `Division*` (lblCombo1) | 150×20 | `SSP.SSP0021_GET_SHIPMENT_DIVISION` 결과 | Y(`*`) | `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox |
| 14 | `cboPlanDate` | UsrCombo | `Plan-date*` (PlanDate) | 138×20 | 확인 필요 | Y(`*`) | `cboPlanDate_SelectedIndexChanged` (Company 변경 중 -=/+=) | Wijmo ComboBox |
| 15 | `cboBucketType` | UsrCombo | `Bucket` (lblBucket) | 320×20 | `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과 (DAILY/WEEKLY/MONTHLY) | — | `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| 16 | `spdMain` | FpSpread | — | 1689×303, Dock Fill | — | — | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_Change`, `SpdMain_ClipboardPasted` | Wijmo FlexGrid (다단 헤더, allowMerging) |
| 17 | `spdMain_Sheet1` | SheetView | 시트 `Shipment Plan` | — | — | — | — | FlexGrid columns 정의 |
| 18 | `spdDetail` | FpSpread | — | 1689×229, Dock Fill | 활성 시트 Shipment Plan Detail | — | `SpdDetail_TopChange`, `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_CellClick`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_EditChange`, `SpdDetail_ClipboardPasted` | Tab + 시트별 Wijmo FlexGrid |
| 19 | `spdDetail_Sheet1` | SheetView | 상세 시트 8개 | — | — | — | — | FlexGrid columns 정의 |
| 20 | `usrLayoutControl3` | UsrLayoutControl | `usrLayoutControl3`(컨트롤 Text) | 1689×40, Dock Top | — | — | 없음 | 하단 조건 레이아웃 |
| 21 | `btnRequestor` | UsrButton | (Text 없음, layoutControlItem9) | 39×24 | — | — | `BtnRequestor_Click` | 아이콘 버튼(팝업) |
| 22 | `txtRequestor` | UsrTextBox | 확인 필요 (LayoutControlItem `Requestor`, Text 잘림) | 147×25 | 확인 필요 | — | 없음 | TextInput |
| 23 | `btnSearch` | SimpleButton | `Search` (layoutControlItem3) | 47×25 | — | — | `BtnSearch_Click` | Button |
| 24 | `txtModel2` | UsrMultiLineEditor | `Model` (layoutControlItem4) | 264×21 | 확인 필요 | — | 없음 | 다중값 입력 |
| 25 | `btnItemID2` | UsrButton | `layoutControlItem2` (layoutControlItem5 Text 원문. 화면 표시 여부 확인 필요) | 39×25 | — | — | `BtnItemID2_Click` | 아이콘 버튼(팝업) |
| 26 | `drpPeriod2` | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 197×20 | 확인 필요 | — | `DrpPeriod2_ValueChanged` | InputDate ×2 |
| 27 | `drpPeriod3` | UsrDateRangePicker | `Shipment Date` (layoutControlItem13) | 197×20 | 확인 필요 | — | 없음 | InputDate ×2 |
| 28 | `clbResultType` | UsrCheckedList | 확인 필요 | 104×21 | 확인 필요 | — | 없음 | Wijmo MultiSelect |
| 29 | `txtBoxID` | UsrMultiLineEditor | 확인 필요 | 205×21 | 확인 필요 | — | 없음 | 다중값 입력 |

- 기타 컨트롤: splitContainer1(SplitContainer), layoutControlGroup2/3, LayoutControlItem 21개, EmptySpaceItem 4개, imageList1. 이들은 레이아웃용이고 이벤트 배선이 없다.
- `dsdm`(Changed → `shtDetail_Change`)은 controls.csv에 없는 개체다. 정체는 **확인 필요**.

---

## 4. 그리드 명세

### 4.0 공통
- **출처**: 9개 시트 모두 META(`SpreadInfo.SetSheetHeaderColumn` ← SCM_MST_SHEET_COLUMNS, InitSpread 610·634·647·658·698·708·718줄)다. Shipment Plan에는 날짜 열 DB 루프(HARDCODED 코드 생성)가 더해진다.
- **타입**: META `CELL_CONTROL_OBJECT_TYPE_CODE` 값이 Fact Pack에 없어 컬럼별 셀 타입은 **확인 필요**다. 아래 표의 타입 열은 코드에서 확인된 것만 적었다.
- **division별 표시**: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 모두 같다(표에서는 '전 div 동일'). 예외는 Shipment Result CHILD_QTY 너비(82 → 75) 1건.
- **편집 가능**: 셀 Locked 메타가 Fact Pack에 없다. 라벨 `*`와 저장 검증 필드에서 확인되는 것만 '편집(근거)'로 적었고 나머지는 **확인 필요**. 시트 잠금은 `siDetail.IsLock(SheetName)`으로 판정한다.
- **순서**: 표의 컬럼 순서는 grid_effective의 알파벳순이다. 실제 순서(SORT_ORDER)는 **확인 필요**.

### 4.1 Shipment Plan (spdMain, 표시 8 / 메타 13 + 날짜 DB 루프 열)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| BACK_COLOR | Back Color | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BOH_QTY | BOH_QTY | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 (더블클릭 대상) |
| BOH_TYPE | BOH_TYPE | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CONFIRM_DAY | Confrim Day | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | Site | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_YN | Lot_YN | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MEASURE | Measure | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MEASURE_NAME | Measure | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PSI | PSI | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| (날짜 열, 컬럼명에 `B_` 포함) | COLUMN_LABEL_NAME | 숨김(너비 0) | Text (AddTextColumn) | HARDCODED(DB 루프, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | 전 div 동일 | 확인 필요 |
| (날짜 열, 그 외) | COLUMN_LABEL_NAME | 표시(너비 70). SAT 파랑 / SUN 빨강. D_/W_/M_ 태그별 Bucket·Sum 규칙 적용 | Num (AddNumColumn) | HARDCODED(DB 루프) | 전 div 동일 | 확인 필요 (`SpdMain_Change`·`SpdMain_ClipboardPasted` 배선 있음) |
- 헤더 3행(LARGE/SMALL CLASS Span + "SUM"). MergePolicy = Always. Measure 행 9건(SCM_MST_SHEET_MEASURE).

### 4.2 Shipment Plan Detail (표시 42 / 메타 69)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| A_COUNTRY | A Contry | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| A_PORT_CODE | A Port Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| A_PORT_NAME | A Port Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ATTRIBUTE10 | ATTRIBUTE10 | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BOD_ID | bod_id | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 표시 | 확인 필요(콤보 후보, `SpdDetail_ComboSelChange`) | META | 전 div 동일 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHANGE_REQ_NO | Change Request No | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHANGE_TYPE | CHANGE_TYPE | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CHECK_NEED_YN | Checked | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CITY_NAME | City Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 (검증 키 confirm_id) |
| COUNTRY_NAME | Country Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EDIT_MAIN | EDIT_MAIN | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EDIT_REMARKS | EDIT_REMARKS | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ELECTRODE_TYPE | ELECTRODE_TYPE | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ELECTRODE_YN | ELECTRODE_YN | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| END_CUSTOMER | End Customer | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ERP_SO_NO | SO No | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 (SO No 유무 → NonSoNo/SoNo 분기) |
| ERP_STATUS | erp_status | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETA | ETA | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETD | ETD | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| Expected_Shipping_Date | Expected Shipping Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FCST_TYPE | FCST Type | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | From Site ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| INCOTERMS | Incoterms | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LT_DAY | L/T(Day) | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MODEL_USER | Model PIC | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MTK_OWNER | MKT Owner | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_A_COUNTRY | A Country | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_A_PORT_CODE | A Port | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_BOD_ID | new bod | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_CUSTOMER_LT | Customer LT | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_D_COUNTRY | D Country | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_D_PORT_CODE | D Port | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_ETA | ETA | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_ETD | ETD | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_INCOTERMS | new incoterms | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_LT_DAY | L/T(Day) | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_ROUTE_ID | Route | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_SHIPMENT_DATE | Shipment Date* | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_TO_CITY | To City | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_TO_COUNTRY | To Country | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NEW_TRANSPORT_MODE | Trans Mode | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ORIGIN_TO_DIVISION_ID | ORIGIN_TO_DIVISION_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROJECT_CODE | Project Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROJECT_NAME | Project Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| REMARKS | Remarks | 표시 | 확인 필요 | META | 전 div 동일 | 편집(근거: Validation_Check remarks) |
| REMARKS2 | Building | 표시 | 확인 필요 | META | 전 div 동일 | 편집(근거: Validation_Check remarks2) |
| REMARKS3 | Customer Requirement | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| REQUESTOR | Shipment Requestor | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*` + Validation_Check shipment_confirm_qty) |
| SHIPMENT_DATE | Shipment Date* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*` + Validation_Check shipment_date) |
| SHIPMENT_STATUS | Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPTO_CITY_NAME | Ship To City Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPTO_DESCRIPTION | Ship To Party | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIPTO_REGION_NAME | Ship To Region Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SOLDTO_DESCRIPTION | Sold To Party | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TEAM | Team | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TO_SITE | To Site ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*` + Validation_Check TRANSPORT_MODE) |
| UPDATED_BY | Updated By | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| UPDATED_DATE | Updated Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
- 헤더 체크박스 전체 선택/해제(`SpdDetail_CellClick`)가 적용되는 열은 **확인 필요**.

### 4.3 Stock Location Detail (표시 20 / 메타 20)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| AVAILABLE_DATE | Available Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| AVAILABLE_QTY | Available Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| COMPANY_ID | Company | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CUTOFF_DATE | Cutoff Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DEFECT_QTY | Deffect Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLDING_DATE | Holding Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MOVING_QTY | Moving Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OUTSOURCING_FACTORY | Outsourcing Factory | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OUTSOURCING_FLAG | Outsourcing Flag | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PLANT_ID | Plant | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QTY_UOM | Qty Uom | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STOCK_TYPE | Stock Type | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STORAGE_DESCRIPTION | Storage | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STORAGE_ID | Storage ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TOTAL_QTY | Total Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| WIPHOLD_YN | Wiphold Yn | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.4 oWMS Detail (표시 25 / 메타 25)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| ALLOCATION_QTY | Allocation Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| AVAILABLE_QTY | Available Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CAPA_GRADE | Capa. Grade | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CUSTOMER_CODE | Customer Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| CUSTOMER_NAME | Customer Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EXPIRATION_QTY | Expiration Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| GRADE | Grade | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_QTY | Hold Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LONG_TERM_QTY | Long-term Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_ID | Lot ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_ISSUE_DATE | Lot Issue Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MOVING_QTY | Moving Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PACKING_QTY | Packing Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PACKING_STATUS | Packing Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PALLET_ID | Pallet ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PLANT_ID | Plant ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| RECEIVING_QTY | Reciving Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SOC | SOC | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STOCK_QTY | Stock Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STOCK_STATUS | Inventory Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| STORAGE_ID | Storage | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| UNDECIDED_QTY | Undecided Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.5 Hold stock (표시 10 / 메타 12)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | Site | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_NM | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_ID | HOLD_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_QTY | Amend Qty* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*`) |
| HOLD_YYYYMMDD | Start Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATE_DATE | Last Updated Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date* | 표시 | 확인 필요 | META | 전 div 동일 | 편집·필수(근거: `*`) |
| REMARKS | Remarks | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
- 저장 엔드포인트 `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`는 ⚠ DB에 SP가 없다.

### 4.6 Hold stock Detail (표시 10 / 메타 12)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | Site | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE_NM | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_ID | HOLD_ID | 숨김 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_QTY | Amend Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| HOLD_YYYYMMDD | Start Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATE_DATE | Last Updated Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| REMARKS | Remarks | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
- 이 시트를 생성하거나 전환하는 코드 위치는 Fact Pack 표시 범위에서 확인되지 않았다 → **확인 필요**.

### 4.7 MES Stock (표시 9 / 메타 9)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| AVAILABLE_STOCK | Available Stock | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BEFORE_OQC | Before OQC | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_COMPLETE | OQC Complete | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_INSP_REQUEST | OQC Insp Request | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_NG | OQC NG | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QMS_MES_HOLD | QMS/MES Hold | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TOTAL | Total | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.8 MES Stock Detail (표시 13 / 메타 13)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| AVAILABLE_YN | Available stock YN | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| BOXID | Box ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| EXP_INSP_VALID_DATE | Exp Insp Vaild Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOT_QTY | Lot Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| LOTID | Lot ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MES_HOLD_YN | MES Hold YN | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| MES_UNHOLD_SCHD_DATE | MES Unhold Sched Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| OQC_INSP_RESULT | OQC Insp Result | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PRJT_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROD_VALID_DATE | Prod Valid Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PRODID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QMS_HOLD_YN | QMS Hold YN | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QMS_UNHOLD_SCHD_DATE | QMS Unhold Sched Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.9 Shipment Result (표시 18 / 메타 18)
| 컬럼 | 헤더 | 표시 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|---|
| CHILD_QTY | Shipment Pack Qty | 표시 | 확인 필요 | META + 코드(Width) | **82: Width=75** (InitSpread 727줄) / 그 외: 메타 너비 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| DIVISION_ID | Div | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| END_CUSTOMER | End Customer | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ERP_SO_NO | SO No | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETA_DATE | ETA | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ETD_DATE | ETD | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| FROM_SITE | From Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| INCOTERMS | Incoterms | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| ITEM_ID | Model | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| NICK_NAME | Nick Name | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| PROJECT_CODE | Prj Code | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| QTY | Shipment Qty | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| SHIP_TYPE | Ship Type | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TO_SITE | To Site | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| TYPE | Status | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |
| YYYYMMDD | Shipment Date | 표시 | 확인 필요 | META | 전 div 동일 | 확인 필요 |

### 4.10 시트 탭·생성 순서
| 항목 | 사실 |
|---|---|
| CreateSpread 생성 순서 | 548 Shipment Plan Detail → 549 Stock Location Detail → 550 oWMS Detail → (551~555 미표시) → 556 MES Stock → 557 MES Stock Detail → 559 Shipment Result → 594 Shipment Plan Detail 활성 |
| SpdDetail_SheetTabClick 분기(2138~2154줄) | 0 = Shipment Plan Detail, 1 = Stock Location Detail, 2 = oWMS Detail, 5 = Shipment Result. 3·4와 Hold stock 계열은 **확인 필요** |

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls → SetChangedControl / GetBucketType, CreateSpread → InitSpread → GetSpdTitle | `SSP.SSP0021_GET_SHIPMENT_DIVISION`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | clbDivision_ID, cboBucketType 구성. spdMain·spdDetail 헤더 생성 |
| A2 | 툴바 Find | FindButton(프레임워크) | FindData_Main → InitSpread | `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain(Shipment Plan) |
| A3 | 툴바 Edit | EditButton(프레임워크) | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 허용 여부 (판정 **확인 필요**) |
| A4 | 툴바 Save | SaveButton(프레임워크) | SaveData_Detail → Validation_Check → 저장 → GetERPInterface → 재조회 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0021_GET_ERP_SO_NO_CNT`, `SSP.SSP0021_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, 재조회 `SSP.SSP0021_GET_SHIPMENT_PLAN`·`SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`·`SSP.SSP0021_GET_HOLD_STOCK`·`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain, spdDetail(Shipment Plan Detail / Hold stock) 갱신 |
| A5 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | c["DIVISION_ID"], dtDiv_Company_ID NAME 읽음 | 없음 | Company 관련 값 반영(**확인 필요**) |
| A6 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | From Site 조회. cboPlanDate 이벤트 -=(5933) / +=(5937). InitSpread | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | clbPlantSite, 그리드 헤더 |
| A7 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | FROM_DATE/TO_DATE → drpPeriod. GetSpdTitle → InitSpreadDateColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | drpPeriod, spdMain 날짜 열 |
| A8 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | SetSpreadColumn (4451줄) | 없음 | spdMain D_/W_/M_ 열 표시 |
| A9 | chkSum 변경 | `chkSum_CheckedChanged` | SetSpreadColumn (4456줄) | 없음 | spdMain 합계(M_ 등) 열 표시 |
| A10 | btnMeasure 클릭 | `BtnMeasure_Click` | InitSpread → GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재구성 |
| A11 | btnItemId 클릭 | `btnItemId_Click` | 팝업(대상 **확인 필요**) | 없음 | txtItemId |
| A12 | btnItemID2 클릭 | `BtnItemID2_Click` | 팝업(대상 **확인 필요**) | 없음 | txtModel2 |
| A13 | btnRequestor 클릭 | `BtnRequestor_Click` | 요청자 팝업(**확인 필요**) | 없음 | txtRequestor |
| A14 | btnSimulation 클릭 | `BtnSimulation_Click` | Simulation(6124~6130줄, 연결 **확인 필요**) | 없음 | **확인 필요** |
| A15 | btnSearch 클릭 | `BtnSearch_Click` | 활성 시트에 맞는 FindData_* | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0021_GET_OWMS_DETAIL`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, `SSP.SSP0021_GET_MES_STOCK`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 해당 상세 시트 |
| A16 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | 클릭 열·MEASURE·BOH_TYPE 분기(2059~2094줄) | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0021_GET_OWMS_DETAIL`, `SSP.SSP0021_GET_HOLD_STOCK`, `SSP.SSP0021_GET_MES_STOCK`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 시트 전환 + 데이터 |
| A17 | spdMain 값 변경 | `SpdMain_Change` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A18 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A19 | spdMain 스크롤 | `SpdMain_TopChange` | 세부 로직 **확인 필요** (상·하 스크롤 동기화 여부) | 없음 | **확인 필요** |
| A20 | spdDetail 스크롤 | `SpdDetail_TopChange` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A21 | spdDetail 탭 클릭 | `SpdDetail_SheetTabClick` | ChangeSheet/ChangeActiveSheet(인덱스 0·1·2·5) | 없음 | 활성 시트 전환 |
| A22 | spdDetail 활성 시트 변경 | `SpdDetail_ActiveSheetChanged` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A23 | spdDetail 셀 클릭 | `SpdDetail_CellClick` | IsLock=false + 헤더 체크박스이면 전체 토글(1802·1837·1841줄) | 없음 | 체크 열 일괄 변경 |
| A24 | spdDetail 콤보 선택 | `SpdDetail_ComboSelChange` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A25 | spdDetail 더블클릭 | `SpdDetail_CellDoubleClick` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A26 | spdDetail 편집 | `SpdDetail_EditChange` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A27 | spdDetail 붙여넣기 | `SpdDetail_ClipboardPasted` | c["CODE"] 매칭(1509줄) | 없음 | 붙여넣은 값 코드 변환(**확인 필요**) |
| A28 | drpPeriod2 변경 | `DrpPeriod2_ValueChanged` | 세부 로직 **확인 필요** | 없음 | **확인 필요** |
| A29 | dsdm 변경 | `shtDetail_Change` | dsdm 개체 정체 **확인 필요** | 없음 | **확인 필요** |
| A30 | (진입점 미연결) | GetErpIFCheck / GetErpIFCheckNew_ / NewNonSoNo | 정적 분석상 호출 경로 없음 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | 현행 화면 액션 아님. 사용 여부 **확인 필요** |

엔드포인트 23종 대조: `SSP.SSP0021_GET_SHIPMENT_DIVISION`(A1) · `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`(A4) · `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`(A4) · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`(A4) · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`(A4) · `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`(A4·A30) · `SSP.SSP0021_GET_ERP_SO_NO_CNT`(A4) · `SSP.SSP0021_GET_SHIPMENT_STATUS`(A4) · `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`(A30) · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`(A4) · `DM.DM0003_GET_BUCKET_TYPE_CODE`(A1) · `SSP.SSP0021_GET_SHIPMENT_PLAN`(A2·A4) · `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`(A4·A15·A16) · `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`(A15·A16) · `SSP.SSP0021_GET_OWMS_DETAIL`(A15·A16) · `SSP.SSP0021_GET_SHIPMENT_RESULT`(A15) · `SSP.SSP0021_GET_HOLD_STOCK`(A4·A16) · `SSP.SSP0021_GET_MES_STOCK`(A15·A16) · `SSP.SSP0021_GET_MES_STOCK_DETAIL`(A15·A16) · `SSP.SSP0002_GET_USER_INFO_LIST`(A3) · `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`(A6) · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`(A1·A2·A4·A6·A7·A10·A15·A16) · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`(A4).

---

## 6. 검증·메시지

| # | 검증 | 대상 | 근거 | 메시지 |
|---:|---|---|---|---|
| V1 | 조회조건 필수 | Division*, Company*, Plan-date*, Period* | 라벨 `*` | 메시지 문구·검증 위치 **확인 필요** |
| V2 | 저장 행 검증(SO No 없음) | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks | Validation_Check(Validationdr) 3006~3011줄 등 | **확인 필요** |
| V3 | 저장 행 검증(SO No 있음) | 위와 같은 5개 필드 | Validation_Check(SONoValidationdr) | **확인 필요** |
| V4 | 그리드 필수 표기 | Shipment Qty*, Shipment Date*, Trans Mode* / Amend Qty*, End Date* | 메타 라벨 | **확인 필요** |
| V5 | ERP I/F 차단 | BLOCK_YN, PERIOD | chkERPIFBlockYn 2930·2939줄 | **확인 필요** |
| V6 | 확정 변경 시각 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | **확인 필요** |
| V7 | ERP SO 건수 | CNT | `SSP.SSP0021_GET_ERP_SO_NO_CNT` 3853줄 | **확인 필요** |
| V8 | 출하 상태 | Tables[0~2].CONFIRM_ID | `SSP.SSP0021_GET_SHIPMENT_STATUS` | **확인 필요** |
| V9 | 시트 잠금 | IsLock(SheetName) | SpdDetail_CellClick | 메시지 없음(토글 차단만, 확인 필요) |

---

## 7. 권한 (C/R/U/D) 사실

| 구분 | 진입점 | 근거 |
|---|---|---|
| C | SaveButton (신규 확정 INSERT SSP_ANL_SHIP_CONFIRM, 변경요청 INSERT) | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| R | FindButton, BtnSearch_Click, SpdMain_CellDoubleClick | 조회 엔드포인트 |
| U | EditButton(사용자 확인) → SaveButton | `SSP.SSP0002_GET_USER_INFO_LIST` |
| D | 툴바 DeleteButton 진입점 없음. 저장 체인 내부에서만 DELETE SSP_ANL_SHIP_CONFIRM | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| 그룹·메뉴 | NowGroupID, TB_FX_GroupMenuAuth 14행 | 그룹별 값 **확인 필요** |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| # | 항목 | AS-IS | To-Be 고려 |
|---:|---|---|---|
| T1 | 상단 매트릭스 | FpSpread, 헤더 3행 Span, MergePolicy Always, 동적 날짜 열 | Wijmo FlexGrid columnHeaders 다단 행 + allowMerging. 날짜 열은 캘린더 API 결과로 동적 생성. `B_` 열 숨김, SAT/SUN 색은 셀 포맷 |
| T2 | Bucket/Sum 표시 전환 | SetSpreadColumn(태그 D_/W_/M_) | FE 열 visible 토글. DAILY의 W_ 최종값은 AS-IS 실행으로 먼저 확인 |
| T3 | 상세 다중 시트 | spdDetail 시트 8개 + 탭 | 탭 + 시트별 FlexGrid. 탭 인덱스 3·4(Hold 계열)는 AS-IS 확인 후 구성 |
| T4 | 헤더 체크박스 | CheckBoxCellType 헤더 토글 | FlexGrid 헤더 체크박스(잠금 시 비활성) |
| T5 | 조회조건 | UsrCombo / UsrCheckedList / UsrDateRangePicker / UsrMultiLineEditor | 공용 ComboBox / MultiSelect / 기간 입력 / 다중값 입력. drpPeriod는 읽기전용 |
| T6 | 이벤트 해제·재연결 | cboPlanDate 이벤트 -=/+= | 상태 업데이트 중 연쇄 조회 억제 플래그로 같은 동작 보장 |
| T7 | FoxQuery 미등록 SP | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | Mapper 신규 등록. DB 객체 P의 원문으로 Oracle 변환 |
| T8 | DB 미존재 SP | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | 원본 확보 전 구현 보류 → 확인 필요 |
| T9 | MSSQL 구문 | STRING_SPLIT, #임시테이블, MERGE #TMP, 동적 SQL(DYNAMIC@), UF_FX_STRING_SPLIT | Oracle 19c: 분할 함수/파이프라인 함수, GTT 또는 WITH, 동적 SQL은 EXECUTE IMMEDIATE / REF CURSOR |
| T10 | 저장 체인 | UI가 여러 SP를 순차 호출 | BE Service 트랜잭션 경계 설계. 단계별 분기 조건은 AS-IS 원문으로 먼저 확정 |
| T11 | 다중 결과셋 | `SSP0021_GET_SHIPMENT_STATUS` Tables[0~2] | Oracle에서 REF CURSOR 3개 또는 API 분리 |
| T12 | 개발용 컨트롤 | chkSql(Show SQL), usrButton1(parent 없음) | 반영 여부 판단 필요 |
| T13 | 미연결 메서드 | GetErpIFCheck / GetErpIFCheckNew_ / NewNonSoNo | 구현 제외 후보(확인 필요) |

---

## 9. 미확정

1. 메뉴 위치, 그룹별 메뉴 권한.
2. txtRequestor·clbResultType·txtBoxID 라벨(props.csv 잘림), btnItemID2 LayoutControlItem Text(`layoutControlItem2`)의 실제 표시 여부.
3. 조회조건 영역의 행·열 배치(Location 미추출). usrLayoutControl2(77)와 usrConditionPanel1(73)의 높이 차이.
4. Panel2 높이 273 중 4px 차이(SplitterWidth).
5. Hold stock / Hold stock Detail 시트 생성 위치, 탭 인덱스 3·4.
6. 그리드 컬럼 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE), Locked 여부, 실제 컬럼 순서.
7. 핸들러 세부 로직: SpdMain_TopChange, SpdDetail_TopChange, SpdMain_Change, SpdMain_ClipboardPasted, SpdDetail_ActiveSheetChanged, SpdDetail_ComboSelChange, SpdDetail_CellDoubleClick, SpdDetail_EditChange, DrpPeriod2_ValueChanged, shtDetail_Change(dsdm), BtnSimulation_Click.
8. 팝업 대상 화면(btnItemId, btnItemID2, btnRequestor, btnMeasure).
9. 검증 메시지 문구 전체.
10. `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`(DB 미존재), `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`(FoxQuery 미등록).

=== FILE: unit_test.md ===
# SSP0021 Shipment Plan — 단위테스트 케이스

> **근거**: 업무분석서 §4 규칙·§5 데이터 흐름, 화면설계서 §3 컨트롤·§5 액션 명세. 절차 열의 컨트롤명은 화면설계서 §3과 같은 이름을 쓴다.
> **기대결과 원칙**: Fact Pack에서 확인되는 동작만 적었다. 메시지 문구나 판정 기준처럼 확인되지 않은 부분은 "AS-IS 실행 결과와 동일(확인 필요)"로 적었다.
> **제외**: 주석 처리된 호출 1건(320줄)은 테스트 케이스로 만들지 않았다.
> **공통 사전조건**: 시험 계정은 SSP0021 메뉴 권한 보유, 시험 Division 데이터 존재.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0021-001 | 초기화 | 로그인 완료 | 화면을 연다 | — | clbDivision_ID 목록이 구성된다(사용자 그룹 기준) | `Form_Load`, `SSP.SSP0021_GET_SHIPMENT_DIVISION`, `SSP0021_GET_SHIPMENT_DIVISION` |
| TC-SSP0021-002 | 초기화 | 로그인 완료 | 화면을 열고 cboBucketType 목록을 확인한다 | — | Bucket 목록이 구성되고 DAILY/WEEKLY/MONTHLY 값이 있다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0021-003 | 초기화 | 로그인 완료 | 화면을 열고 spdMain 헤더를 확인한다 | — | Shipment Plan 시트 헤더 3행(LARGE/SMALL CLASS Span + SUM)과 날짜 열이 생성된다 | `Form_Load`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, Shipment Plan |
| TC-SSP0021-004 | 초기화 | 로그인 완료 | 화면을 열고 spdDetail 활성 시트를 확인한다 | — | 활성 시트가 Shipment Plan Detail이다(CreateSpread 594줄) | `Form_Load`, Shipment Plan Detail |
| TC-SSP0021-005 | 초기화 | 화면 진입 | drpPeriod에 직접 입력을 시도한다 | 임의 날짜 | drpPeriod가 비활성(Enabled=false)이라 입력할 수 없다 | `Form_Load`, `cboPlanDate_SelectedIndexChanged` |
| TC-SSP0021-006 | 이벤트 | 화면 진입 | clbDivision_ID에서 다른 Division을 고른다 | Division=81 | DIVISION_ID 기준으로 Company 관련 값이 반영된다(반영 대상 확인 필요) | `clbDivision_ID_SelectedIndexChanged` |
| TC-SSP0021-007 | 이벤트 | Division 선택 | clbCompany_ID를 바꾼다 | Company=시험 회사 | clbPlantSite 목록이 갱신되고 spdMain 헤더가 재구성된다. 처리 중 cboPlanDate 변경 이벤트가 연쇄 실행되지 않는다(-= 5933 / += 5937) | `clbCompanyID_SelectedIndexChanged`, `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-008 | 조회(오류) | To-Be From Site API 미등록 또는 SP 오류 상황 | clbCompany_ID를 바꾼다 | Company=시험 회사 | 오류 메시지가 표시되고 화면이 멈추지 않는다. AS-IS FoxQuery 미등록 상태의 동작은 확인 필요 | `clbCompanyID_SelectedIndexChanged`, `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` |
| TC-SSP0021-009 | 이벤트 | Company 선택 | cboPlanDate를 바꾼다 | Plan-date=목록 두 번째 값 | drpPeriod에 FROM_DATE~TO_DATE가 반영되고 spdMain 날짜 열이 다시 생성된다 | `cboPlanDate_SelectedIndexChanged`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-010 | 그리드 | 조회 완료 | cboBucketType을 DAILY로 고른다 | Bucket=DAILY, chkSum 해제 | D_ 열 표시. M_ 열은 chkSum.Checked(false)에 따라 숨김. W_ 열 최종 표시값은 AS-IS 실행 결과와 동일(확인 필요) | `cboBucketType_SelectedIndexChanged`, Shipment Plan |
| TC-SSP0021-011 | 그리드 | 조회 완료 | cboBucketType을 WEEKLY로 고른다 | Bucket=WEEKLY, chkSum 해제 | D_ 숨김, W_ 표시, M_ 숨김 | `cboBucketType_SelectedIndexChanged`, Shipment Plan |
| TC-SSP0021-012 | 그리드 | 조회 완료 | cboBucketType을 MONTHLY로 고른다 | Bucket=MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged`, Shipment Plan |
| TC-SSP0021-013 | 그리드 | 조회 완료, Bucket=WEEKLY | chkSum을 체크한다 | chkSum=체크 | M_ 열이 표시된다(체크 해제 시 숨김) | `chkSum_CheckedChanged`, Shipment Plan |
| TC-SSP0021-014 | 조회 | Division·Company·Plan-date 선택 | 툴바 Find를 누른다 | Division=81, Company=시험 회사, From Site 전체, txtItemId 빈값 | spdMain(Shipment Plan)에 Measure 행·날짜 열 데이터가 표시된다. 표시 컬럼은 Div·From Site·Model·Nick Name·PSI·BOH_TYPE·BOH_QTY·Measure 8개 | FindButton, `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SSP0021_GET_SHIPMENT_PLAN`, Shipment Plan |
| TC-SSP0021-015 | 조회(빈 결과) | 조회조건 선택 | txtItemId에 없는 모델을 넣고 Find를 누른다 | txtItemId=NOTEXIST | spdMain에 데이터 행이 없다. 오류 없이 헤더는 유지된다 | FindButton, `SSP.SSP0021_GET_SHIPMENT_PLAN` |
| TC-SSP0021-016 | 조회(검증) | 화면 진입 | clbCompany_ID 또는 cboPlanDate를 비우고 Find를 누른다 | Company=빈값 | 필수(`*`) 항목 누락 메시지가 표시되고 조회되지 않는다. 메시지 문구는 확인 필요 | FindButton, `SSP.SSP0021_GET_SHIPMENT_PLAN` |
| TC-SSP0021-017 | 그리드 | 조회 완료 | spdMain 날짜 열을 확인한다 | — | 컬럼명에 `B_`가 있는 열은 숨김(너비 0). 그 외는 너비 70 숫자 열. 토요일 헤더 글자 파랑, 일요일 빨강 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, Shipment Plan |
| TC-SSP0021-018 | 그리드 | 조회 완료 | spdMain 셀 병합을 확인한다 | — | MergePolicy=Always에 따라 같은 값 셀이 병합된다 | FindButton, Shipment Plan |
| TC-SSP0021-019 | 그리드 | 조회 완료 | spdMain에서 MEASURE=SHIP_PLAN 행의 날짜 셀을 더블클릭한다 | 날짜 열 셀 | spdDetail이 Shipment Plan Detail로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP0021_GET_SHIPMENT_PLAN_DETAIL`, Shipment Plan Detail |
| TC-SSP0021-020 | 그리드 | 조회 완료 | BOH_TYPE=ERP 행의 BOH_QTY 셀을 더블클릭한다 | — | Stock Location Detail로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, `SSP0021_GET_STOCK_LOCATION_DETAIL`, Stock Location Detail |
| TC-SSP0021-021 | 그리드 | 조회 완료 | BOH_TYPE=oWMS 행의 BOH_QTY 셀을 더블클릭한다 | — | oWMS Detail로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_OWMS_DETAIL`, `SSP0021_GET_OWMS_DETAIL`, oWMS Detail |
| TC-SSP0021-022 | 그리드 | 조회 완료 | BOH_TYPE=HOLD 행의 BOH_QTY 셀을 더블클릭한다 | — | Hold stock 시트로 전환되고 데이터가 표시된다 | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_HOLD_STOCK`, `SSP0021_GET_HOLD_STOCK`, Hold stock |
| TC-SSP0021-023 | 그리드 | 조회 완료 | BOH_TYPE=MES 행의 BOH_QTY 셀을 더블클릭한다 | — | MES Stock Detail(2088~2089줄)과 MES Stock(2093~2094줄)이 조회된다. 최종 활성 시트는 AS-IS 실행 결과와 동일(확인 필요) | `SpdMain_CellDoubleClick`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, `SSP0021_GET_MES_STOCK_DETAIL`, `SSP.SSP0021_GET_MES_STOCK`, `SSP0021_GET_MES_STOCK`, MES Stock, MES Stock Detail |
| TC-SSP0021-024 | 그리드(빈 결과) | 조회 완료 | BOH_QTY가 아니고 MEASURE+1 미만인 열(예: Model)을 더블클릭한다 | ITEM_ID 셀 | 상세 조회가 일어나지 않는다(분기 조건 불충족) | `SpdMain_CellDoubleClick` |
| TC-SSP0021-025 | 조회 | spdDetail 활성 시트=Shipment Plan Detail | drpPeriod2·txtModel2를 입력하고 btnSearch를 누른다 | Shipment Date=시험 기간, Model=시험 모델 | Shipment Plan Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, Shipment Plan Detail |
| TC-SSP0021-026 | 조회 | 활성 시트=Stock Location Detail | btnSearch를 누른다 | txtModel2=시험 모델 | Stock Location Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL`, Stock Location Detail |
| TC-SSP0021-027 | 조회 | 활성 시트=oWMS Detail | btnSearch를 누른다 | txtModel2=시험 모델 | oWMS Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_OWMS_DETAIL`, oWMS Detail |
| TC-SSP0021-028 | 조회 | 활성 시트=Shipment Result | drpPeriod3·clbResultType을 입력하고 btnSearch를 누른다 | 시험 기간, Result Type 전체 | Shipment Result가 조회되고 InitSpread로 헤더가 재구성된다(입력 컨트롤과 시트의 대응은 확인 필요) | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, `SSP0021_GET_SHIPMENT_RESULT`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, Shipment Result |
| TC-SSP0021-029 | 조회 | 활성 시트=MES Stock / MES Stock Detail | txtBoxID를 입력하고 btnSearch를 누른다 | Box ID=시험 값 | MES Stock / MES Stock Detail이 다시 조회된다 | `BtnSearch_Click`, `SSP.SSP0021_GET_MES_STOCK`, `SSP.SSP0021_GET_MES_STOCK_DETAIL`, MES Stock, MES Stock Detail |
| TC-SSP0021-030 | 조회(빈 결과) | 활성 상세 시트 임의 | 결과가 없는 조건으로 btnSearch를 누른다 | txtModel2=NOTEXIST | 상세 시트에 행이 없다. 오류는 발생하지 않는다 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` |
| TC-SSP0021-031 | 이벤트 | 화면 진입 | btnMeasure를 누른다 | Measure 선택(팝업 확인 필요) | spdMain이 재구성된다 | `BtnMeasure_Click`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-032 | 이벤트 | 화면 진입 | btnItemId를 누르고 팝업에서 모델을 고른다 | 모델 1건 | txtItemId에 선택 값이 들어간다(팝업 대상 확인 필요) | `btnItemId_Click` |
| TC-SSP0021-033 | 이벤트 | 화면 진입 | btnItemID2를 누르고 모델을 고른다 | 모델 1건 | txtModel2에 선택 값이 들어간다 | `BtnItemID2_Click` |
| TC-SSP0021-034 | 이벤트 | 화면 진입 | btnRequestor를 누르고 요청자를 고른다 | 요청자 1명 | txtRequestor에 선택 값이 들어간다 | `BtnRequestor_Click` |
| TC-SSP0021-035 | 이벤트 | 조회 완료 | btnSimulation을 누른다 | — | AS-IS 실행 결과와 동일(Simulation 로직 확인 필요). 엔드포인트 호출 없음 | `BtnSimulation_Click` |
| TC-SSP0021-036 | 그리드 | 조회 완료 | spdDetail 탭 0·1·2·5를 차례로 클릭한다 | — | Shipment Plan Detail / Stock Location Detail / oWMS Detail / Shipment Result로 전환된다 | `SpdDetail_SheetTabClick`, Shipment Plan Detail, Stock Location Detail, oWMS Detail, Shipment Result |
| TC-SSP0021-037 | 그리드 | 조회 완료 | spdDetail 시트를 바꾼다 | — | 활성 시트 변경 처리(세부 확인 필요). 오류 없음 | `SpdDetail_ActiveSheetChanged` |
| TC-SSP0021-038 | 그리드 | 잠기지 않은 상세 시트, 행 ≥ 1 | 체크박스 헤더 셀을 클릭한다 | — | 헤더 체크 값이 토글되고(true↔false) 열 전체 선택/해제가 반영된다 | `SpdDetail_CellClick`, Shipment Plan Detail |
| TC-SSP0021-039 | 권한 | 잠긴 시트(IsLock=true) | 체크박스 헤더 셀을 클릭한다 | — | AS-IS 1837·1841줄 분기와 동일하게 동작한다(잠금 시 동작 확인 필요) | `SpdDetail_CellClick` |
| TC-SSP0021-040 | 그리드 | Shipment Plan Detail 편집 모드 | 콤보 셀(예: Change Reason) 값을 고른다 | 콤보 값 1개 | 선택 값이 반영된다(세부 로직 확인 필요) | `SpdDetail_ComboSelChange`, Shipment Plan Detail |
| TC-SSP0021-041 | 그리드 | 상세 조회 완료 | spdDetail 셀을 더블클릭한다 | — | AS-IS와 동일(세부 로직 확인 필요). 오류 없음 | `SpdDetail_CellDoubleClick` |
| TC-SSP0021-042 | 그리드 | Shipment Plan Detail 편집 모드 | Shipment Qty* 셀을 편집한다 | 100 | 편집 상태가 반영된다(세부 로직 확인 필요) | `SpdDetail_EditChange`, Shipment Plan Detail |
| TC-SSP0021-043 | 그리드 | Shipment Plan Detail 편집 모드 | 여러 셀을 붙여넣는다 | 코드 값 포함 클립보드 | 붙여넣은 값이 CODE 기준으로 매칭된다(1509줄. 매칭 실패 시 동작 확인 필요) | `SpdDetail_ClipboardPasted`, Shipment Plan Detail |
| TC-SSP0021-044 | 그리드 | 조회 완료(행 다수) | spdMain을 세로 스크롤한다 | — | AS-IS와 동일(동기화 여부 확인 필요). 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0021-045 | 그리드 | 상세 조회 완료(행 다수) | spdDetail을 세로 스크롤한다 | — | AS-IS와 동일. 오류 없음 | `SpdDetail_TopChange` |
| TC-SSP0021-046 | 그리드 | 조회 완료 | spdMain 날짜 셀 값을 바꾼다 | 10 | 변경 처리(세부 확인 필요) | `SpdMain_Change`, Shipment Plan |
| TC-SSP0021-047 | 그리드 | 조회 완료 | spdMain에 붙여넣는다 | 숫자 여러 셀 | 붙여넣기 처리(세부 확인 필요) | `SpdMain_ClipboardPasted`, Shipment Plan |
| TC-SSP0021-048 | 이벤트 | 화면 진입 | drpPeriod2 기간을 바꾼다 | 시작일·종료일 변경 | 값 변경 처리(세부 확인 필요) | `DrpPeriod2_ValueChanged` |
| TC-SSP0021-049 | 이벤트 | 상세 데이터 바인딩 | dsdm 데이터 변경을 일으킨다(상세 셀 수정) | — | 변경 처리(dsdm 정체 확인 필요) | `shtDetail_Change` |
| TC-SSP0021-050 | 권한 | 조회 완료, 권한 사용자 | 툴바 Edit를 누른다 | 로그인 사용자 | 사용자 정보 확인 후 편집 가능 상태가 된다 | EditButton, `SSP.SSP0002_GET_USER_INFO_LIST`, `SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0021-051 | 권한 | 조회 완료, 비대상 사용자 | 툴바 Edit를 누른다 | 권한 없는 사용자 | 편집이 허용되지 않는다(판정 기준·메시지 확인 필요) | EditButton, `SSP.SSP0002_GET_USER_INFO_LIST` |
| TC-SSP0021-052 | 저장(검증) | Shipment Plan Detail 편집, SO No 없는 행 | Shipment Qty*를 비우고 Save를 누른다 | shipment_confirm_qty=빈값 | Validation_Check에서 저장이 중단되고 메시지가 표시된다(문구 확인 필요) | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, Shipment Plan Detail |
| TC-SSP0021-053 | 저장(검증) | SO No 있는 행 | Trans Mode*를 비우고 Save를 누른다 | TRANSPORT_MODE=빈값 | SONoValidationdr 검증으로 저장이 중단된다 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, Shipment Plan Detail |
| TC-SSP0021-054 | 저장 | Shipment Plan Detail 편집, 필수값 정상 | Save를 누른다 | Shipment Qty=100, Shipment Date=유효일, Trans Mode=유효값 | SSP_ANL_SHIP_CONFIRM 등에 저장되고 SSP_ANL_SHIP_CONFIRM_H 이력이 남는다. 호출 조건은 확인 필요 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0021-055 | 저장 | 저장 대상 행 존재 | Save → GetERPInterface 단계 확인 | — | 확정 변경 시각 확인 SP가 호출된다 | SaveButton, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SCM_SSP_CHECK_CONFIRM_CHANGETIME` |
| TC-SSP0021-056 | 저장 | SO No 있는 행 | Save → GetErpSoNoCnt 단계 확인 | — | 결과 CNT를 확인한다(판정 기준 확인 필요) | SaveButton, `SSP.SSP0021_GET_ERP_SO_NO_CNT`, `SSP0021_GET_ERP_SO_NO_CNT` |
| TC-SSP0021-057 | 저장 | 저장 대상 행 존재 | Save → GetShipmentStatusChk 단계 확인 | — | 결과 Tables[0]·[1]·[2]의 CONFIRM_ID를 확인한다 | SaveButton, `SSP.SSP0021_GET_SHIPMENT_STATUS`, `SSP0021_GET_SHIPMENT_STATUS` |
| TC-SSP0021-058 | 저장 | ERP 오류 확인 대상 행(조건 확인 필요) | Save | — | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ/CHG_REQ_DE UPDATE | SaveButton, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| TC-SSP0021-059 | 저장 | 확정 삭제 대상 행(조건 확인 필요) | Save | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | SaveButton, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0021-060 | 저장 | SO No 없는 변경 행 | Save → NonSoNo | — | SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE에 변경요청이 INSERT되고 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN에 기록된다 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0021-061 | 저장 | SO No 있는 변경 행 | Save → SoNo → GetErpIFCheckNew | — | DRAFTING 저장 뒤 DELETE_BY_CONFIRM과 CHG_BATCH(2회: 4045·4075줄)가 호출된다. 호출 조건은 확인 필요 | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| TC-SSP0021-062 | 저장 | 저장 성공 | 저장 후 화면 상태를 확인한다 | — | spdMain, Shipment Plan Detail, Hold stock이 다시 조회된다 | SaveButton, `SSP.SSP0021_GET_SHIPMENT_PLAN`, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0021_GET_HOLD_STOCK`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0021-063 | 저장(오류) | Hold stock 시트 편집 | Amend Qty*·End Date*를 입력하고 Save를 누른다 | Amend Qty=10, End Date=유효일 | ⚠ DB에 SP가 없어 판정 보류. To-Be는 원본 SP 확보 전 오류 메시지 표시 + 데이터 무변경을 확인한다 | SaveButton, `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`, `SSP0021_SAVE_HOLD_STOCK_DATA`, Hold stock |
| TC-SSP0021-064 | 저장(오류) | 저장 SP에서 DB 오류가 나도록 설정(시험 DB) | Save를 누른다 | 제약 위반 값 | 오류 메시지가 표시되고 부분 저장이 남지 않는다(트랜잭션 처리 확인 필요) | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0021-065 | 저장(검증) | ERP I/F 차단(BLOCK_YN=Y) 설정 | Save를 누른다 | — | chkERPIFBlockYn의 BLOCK_YN·PERIOD에 따라 처리된다(차단 동작 확인 필요) | SaveButton, `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0021-066 | 저장(정적 확인) | 소스 정적 분석 | 화면의 모든 진입점(이벤트·툴바)에서 호출 경로를 추적한다 | — | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`은 진입점 미연결 메서드(GetErpIFCheck, GetErpIFCheckNew_)에서만 호출된다. 화면 조작으로는 호출되지 않는다 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0021-067 | 그리드 | 조회 완료 | spdMain 컬럼 표시를 확인한다 | Division=40 | 표시 8: Div, From Site, Model, Nick Name, PSI, BOH_TYPE, BOH_QTY, Measure(MEASURE_NAME). 숨김: Back Color, Confrim Day, Site, Lot_YN, MEASURE | Shipment Plan |
| TC-SSP0021-068 | 그리드 | Shipment Plan Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 42 / 메타 69. 필수 표기 Shipment Qty*, Shipment Date*, Trans Mode* | Shipment Plan Detail, `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` |
| TC-SSP0021-069 | 그리드 | Stock Location Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 20 (Available Date ~ Wiphold Yn) | Stock Location Detail, `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` |
| TC-SSP0021-070 | 그리드 | oWMS Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 25 (Allocation Qty ~ Undecided Qty) | oWMS Detail, `SSP.SSP0021_GET_OWMS_DETAIL` |
| TC-SSP0021-071 | 그리드 | Hold stock 조회 | 컬럼 표시를 확인한다 | — | 표시 10. 숨김 Site(FROM_SITE)·HOLD_ID. 필수 표기 Amend Qty*, End Date* | Hold stock, `SSP.SSP0021_GET_HOLD_STOCK` |
| TC-SSP0021-072 | 그리드 | Hold stock Detail 진입(진입 경로 확인 필요) | 컬럼 표시를 확인한다 | — | 표시 10. `*` 표기 없음(Amend Qty, End Date) | Hold stock Detail |
| TC-SSP0021-073 | 그리드 | MES Stock 조회 | 컬럼 표시를 확인한다 | — | 표시 9 (Available Stock ~ Total) | MES Stock, `SSP.SSP0021_GET_MES_STOCK` |
| TC-SSP0021-074 | 그리드 | MES Stock Detail 조회 | 컬럼 표시를 확인한다 | — | 표시 13 (Available stock YN ~ QMS Unhold Sched Date) | MES Stock Detail, `SSP.SSP0021_GET_MES_STOCK_DETAIL` |
| TC-SSP0021-075 | 그리드 | Shipment Result 조회 | 컬럼 표시를 확인한다 | — | 표시 18 (Shipment Pack Qty ~ Shipment Date) | Shipment Result, `SSP.SSP0021_GET_SHIPMENT_RESULT` |
| TC-SSP0021-076 | division | Division=82 | Shipment Result를 조회하고 CHILD_QTY 너비를 확인한다 | Division=82 | CHILD_QTY(Shipment Pack Qty) Width=75 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, Shipment Result |
| TC-SSP0021-077 | division | Division=81 | Shipment Result를 조회하고 CHILD_QTY 너비를 확인한다 | Division=81 | Width=75 코드가 적용되지 않고 메타 COLUMN_WIDTH를 따른다 | `BtnSearch_Click`, `SSP.SSP0021_GET_SHIPMENT_RESULT`, Shipment Result |
| TC-SSP0021-078 | division | Division=40 / EE 각각 | 9개 시트 표시 컬럼 수를 확인한다 | Division=40, Division=EE | 두 division 모두 Hold stock 10, Hold stock Detail 10, MES Stock 9, MES Stock Detail 13, oWMS Detail 25, Shipment Plan 8, Shipment Plan Detail 42, Shipment Result 18, Stock Location Detail 20 (14 division 동일) | Hold stock, Hold stock Detail, MES Stock, MES Stock Detail, oWMS Detail, Shipment Plan, Shipment Plan Detail, Shipment Result, Stock Location Detail |

## 2. 커버리지 대조

### 2.1 이벤트 핸들러 (26/26)
| 핸들러 | TC |
|---|---|
| `Form_Load` | 001~005 |
| `SpdMain_TopChange` | 044 |
| `SpdDetail_TopChange` | 045 |
| `cboBucketType_SelectedIndexChanged` | 010~012 |
| `chkSum_CheckedChanged` | 013 |
| `BtnMeasure_Click` | 031 |
| `btnItemId_Click` | 032 |
| `BtnItemID2_Click` | 033 |
| `BtnSearch_Click` | 025~030, 076, 077 |
| `BtnRequestor_Click` | 034 |
| `BtnSimulation_Click` | 035 |
| `SpdDetail_SheetTabClick` | 036 |
| `SpdDetail_ActiveSheetChanged` | 037 |
| `SpdDetail_CellClick` | 038, 039 |
| `SpdDetail_ComboSelChange` | 040 |
| `SpdDetail_CellDoubleClick` | 041 |
| `SpdDetail_EditChange` | 042 |
| `SpdDetail_ClipboardPasted` | 043 |
| `SpdMain_CellDoubleClick` | 019~024 |
| `SpdMain_Change` | 046 |
| `DrpPeriod2_ValueChanged` | 048 |
| `SpdMain_ClipboardPasted` | 047 |
| `clbDivision_ID_SelectedIndexChanged` | 006 |
| `clbCompanyID_SelectedIndexChanged` | 007, 008 |
| `cboPlanDate_SelectedIndexChanged` | 005, 009 |
| `shtDetail_Change` | 049 |

### 2.2 엔드포인트 (23/23)
| 엔드포인트 | TC |
|---|---|
| `SSP.SSP0021_GET_SHIPMENT_DIVISION` | 001 |
| `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | 052, 054, 064 |
| `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | 063 |
| `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 058 |
| `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 059, 061 |
| `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | 053, 060, 061, 065 |
| `SSP.SSP0021_GET_ERP_SO_NO_CNT` | 056 |
| `SSP.SSP0021_GET_SHIPMENT_STATUS` | 057 |
| `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | 066 |
| `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | 061 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | 002 |
| `SSP.SSP0021_GET_SHIPMENT_PLAN` | 014, 015, 016, 062 |
| `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | 019, 025, 030, 062, 068 |
| `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` | 020, 026, 069 |
| `SSP.SSP0021_GET_OWMS_DETAIL` | 021, 027, 070 |
| `SSP.SSP0021_GET_SHIPMENT_RESULT` | 028, 075, 076, 077 |
| `SSP.SSP0021_GET_HOLD_STOCK` | 022, 062, 071 |
| `SSP.SSP0021_GET_MES_STOCK` | 023, 029, 073 |
| `SSP.SSP0021_GET_MES_STOCK_DETAIL` | 023, 029, 074 |
| `SSP.SSP0002_GET_USER_INFO_LIST` | 050, 051 |
| `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | 007, 008 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 003, 007, 009, 017, 028, 031, 062 |
| `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | 055 |

### 2.3 시트 (9/9)
| 시트 | TC |
|---|---|
| Shipment Plan | 003, 010~014, 017, 018, 046, 047, 067 |
| Shipment Plan Detail | 004, 019, 025, 036, 038, 040, 042, 043, 052, 053, 068 |
| Stock Location Detail | 020, 026, 036, 069 |
| oWMS Detail | 021, 027, 036, 070 |
| Hold stock | 022, 063, 071 |
| Hold stock Detail | 072 |
| MES Stock | 023, 029, 073 |
| MES Stock Detail | 023, 029, 074 |
| Shipment Result | 028, 036, 075, 076, 077 |

### 2.4 Division 변형
- 코드 분기 1건(82 CHILD_QTY Width=75): TC-076(82), TC-077(비 82).
- 메타 표시 수는 14개 division이 같다: TC-078(40, EE 표본). 나머지 12개 division도 같은 절차로 확인한다.

## 3. 판정 보류 항목 (확인 필요 의존)
| TC | 보류 사유 |
|---|---|
| 010 | DAILY일 때 W_ 열 최종 표시값(4469·4474줄 실행 순서) |
| 035 | Simulation 로직과 핸들러 연결 |
| 039, 041, 044~049 | 핸들러 세부 로직 Fact Pack 미포함 |
| 054~061, 065 | 저장 체인 분기 조건과 메시지 |
| 063 | `SSP0021_SAVE_HOLD_STOCK_DATA` DB 미존재 |
| 072 | Hold stock Detail 진입 경로 |
