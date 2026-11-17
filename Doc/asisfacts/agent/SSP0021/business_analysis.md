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
