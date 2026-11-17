=== FILE: business_analysis.md ===
# SSP0060 업무분석서 — Shipment Plan

> **근거 범위**: 이 문서는 AsisFacts 정적 추출 Fact Pack(SSP0060)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)에 있는 사실만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> 정적 추출 결과이므로 런타임 분기가 실제로 실행되는지는 별도로 검증해야 합니다.
> 이 문서의 엔드포인트 이름은 화면설계서 §5(액션 명세)와 단위테스트 '근거' 열에서 같은 이름으로 씁니다.

---

## 1. 업무 목적·범위

### 1-1. 목적 (사실 기반)
- 메인 Form `SSP0060_ShipmentPlan`은 Shipment Plan(PSI 형태의 출하계획)을 조회하고 저장합니다. 이때 쓰는 SP는 `SSP0060_GET_SHIPMENT_PLAN`과 `SSP0060_SAVE_SHIPMENT_PLAN`입니다.
- 같은 화면에서 출하 확정/변경 요청(Shipment Plan Detail)을 저장하고 ERP 인터페이스를 반영합니다. 이 경로는 `SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM`에서 시작해 ERP 인터페이스 SP 체인으로 이어집니다.
- 보조 조회는 7종입니다: 재고 위치, oWMS, 출하 실적, Hold 재고, MES 재고, MES 재고 상세, Shipment Plan Detail.
- 팝업은 2개입니다.
  - `SSP0060_ShipmentPlanRequestPopup`(Form Text `"Shipment Request Popup"`): 변경 요청을 조회하고 저장(확정)합니다.
  - `SSP0060_ShipmentPlanConfirmDetailPopup`(Form Text `"Request Info Popup"`): 변경 요청 확정 상세를 조회만 합니다.
- 업무 용어의 정의(예: PSI, BOH, Frozen)는 Fact Pack에 설명이 없어 **확인 필요**입니다. 테이블명과 컬럼명만 사실로 인용합니다.

### 1-2. 범위
| 구분 | 대상 |
|---|---|
| 화면 | SSP0060 (도메인 SSP, 프로젝트 `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj`) |
| 소스 파일 | `SSP0060_ShipmentPlan.cs`(8037줄) / `.Designer.cs`(1766), `Popup\SSP0060_ShipmentPlanRequestPopup.cs`(2029) / `.Designer.cs`(388), `Popup\SSP0060_ShipmentPlanConfirmDetailPopup.cs`(365) / `.Designer.cs`(556). 모두 variant `only`(현행) |
| 엔드포인트 | 31종 (§5) |
| SP | 29종 (§5). 엔드포인트 31종 중 2종은 SP가 없습니다: `biz:CommonData.CommonDataList`(BIZ 공통)와 `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`(NOT_IN_FOXQUERY) |
| 메뉴 메타 | TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행, TB_FX_GroupMenuAuth 13행, TB_FX_Favorite 1행. 행의 값은 **확인 필요** |
| 범위 외 | 주석 처리된 호출 `SSP.SSP0046_GET_BUCKET_TYPE_CODE`(`SSP0060_ShipmentPlan.cs:341`)는 현행 기능이 아니므로 제외합니다 |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드 > 엔드포인트) | 결과 |
|---|---|---|---|
| S1 | 메뉴에서 화면을 엶 | `Form_Load` > InitControls > SetChangedControl > `SSP.SSP0060_GET_SHIPMENT_DIVISION`; InitControls > GetBucketType > `DM.DM0003_GET_BUCKET_TYPE_CODE`; CreateSpread > InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`. InitControls가 dtShipmentInputPeriod 0·1행의 VALUE와 Diff_VALUE를 읽고, FP_Log2로 로그를 남깁니다(429, 440) | Division/Site 콤보, Bucket 콤보, 날짜 헤더가 구성됩니다 |
| S2 | Company 변경 | `clbCompanyID_SelectedIndexChanged`가 cboPlanDate 이벤트를 해제(7196)한 뒤 InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`을 실행하고 이벤트를 다시 연결(7200)합니다 | 시트 날짜 헤더가 재구성됩니다 |
| S3 | Division 변경 | `clbDivision_ID_SelectedIndexChanged` > GetNERPCode > `SSP.SSP0002_GET_NERP_CODE` (SEGMENT2) | NERP 코드(SEGMENT2)를 보관합니다. 화면 반영 위치는 **확인 필요** |
| S4 | Plan Date 변경 | `cboPlanDate_SelectedIndexChanged`가 row CODE와 dr FROM_DATE, TO_DATE1을 읽고 GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, InitSpreadDateColumn을 실행합니다 | 날짜 컬럼이 재구성됩니다 |
| S5 | 조회(FindButton) | FindButton > FindData_Main > `SSP.SSP0060_GET_SHIPMENT_PLAN` (+InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | spdMain에 Shipment Plan 시트가 표시됩니다 |
| S6 | Tot PSI 체크 변경 | `chkTotPSI_CheckedChanged` > FindData_Main > `SSP.SSP0060_GET_SHIPMENT_PLAN` | 메인을 즉시 재조회합니다 |
| S7 | Measure 선택 | `BtnMeasure_Click` > InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Shipment Plan 시트를 재구성합니다 |
| S8 | 메인 셀 더블클릭 | `SpdMain_CellDoubleClick` > FindData_Detail / FindData_Stock_Detail / FindData_oWMS_Detail / FindData_Shipment_Result / FindData_hold_stock / FindData_MES_stock / FindData_MES_stock_Detail | spdDetail의 각 시트가 조회됩니다. 어느 셀이 어느 조회를 실행하는지는 **확인 필요** |
| S9 | Detail 조회 버튼 | `BtnSearch_Click` > S8과 같은 조회(FindData_hold_stock 제외) | spdDetail 시트가 조회됩니다 |
| S10 | Detail 셀 편집(Trans Mode) | `SpdDetail_EditChange`(1380/1389), `SpdDetail_CellClick`(1987) > `biz:CommonData.CommonDataList` [code=TransMode] | TRANSPORT_MODE 콤보 값을 다시 구합니다 |
| S11 | 저장(SaveButton) — 메인 | SaveButton > SaveData_Main > `SSP.SSP0060_SAVE_SHIPMENT_PLAN` | SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE에 INSERT합니다 |
| S12 | 저장(SaveButton) — Detail | SaveButton > SaveData_Detail: Validation_Check, chkERPIFBlockYn → `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` → GetERPInterface 체인(§3 F4) → `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`(3460) → 재조회 FindData_Main / FindData_Detail / FindData_hold_stock | 확정, ERP IF 기록, 재조회. Hold stock 저장은 **확인 필요**(엔드포인트 없음) |
| S13 | 수정(EditButton) | EditButton > GetSSPUserCheck > `SSP.SSP0002_GET_USER_INFO_LIST` | 사용자 권한을 확인합니다. 이후 동작은 **확인 필요** |
| S14 | 변경요청 팝업 열기 | RequestPopup `Form_Load` > FindData_Main > `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | Request Info 시트가 표시됩니다. 메인에서 팝업을 여는 지점은 **확인 필요** |
| S15 | 변경요청 팝업 저장 | SaveButton 또는 `usrButtonList1_UsrButtonList_Click_Detected` > SaveData: ChkEngProcessing(`SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`) → `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` → GetERPInterface 체인(§3 F6) | 확정과 ERP IF 반영 |
| S16 | 확정상세 팝업 열기 | ConfirmDetailPopup `Form_Load`/FindButton > FindDataMain > `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 요청 정보(txtRequestNo 등)와 Request Info 시트를 조회만 합니다 |
| S17 | Simulation / New / Requestor / 품목 팝업 | `BtnSimulation_Click`(Simulation: Container_Qty), `BtnNew_Click`, `BtnRequestor_Click`, `btnItemId_Click`, `BtnItemID2_Click` | 엔드포인트 없음(클라이언트 로직). 처리 내용은 **확인 필요** |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[F1 화면 초기화]
Form_Load
 ├─ InitControls
 │   ├─ SetChangedControl ─▶ SSP.SSP0060_GET_SHIPMENT_DIVISION   (Division/Site, 권한 필터)
 │   ├─ GetBucketType     ─▶ DM.DM0003_GET_BUCKET_TYPE_CODE     (Bucket 콤보)
 │   ├─ dtShipmentInputPeriod.Rows[0..1] VALUE/Diff_VALUE  (입력 기간)
 │   └─ FP_Log2 (429, 440)
 └─ CreateSpread > InitSpread
     ├─ SetSheetHeaderColumn × 7 (META: SCM_MST_SHEET_COLUMNS)
     └─ GetSpdTitle ─▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (날짜 헤더) + InitSpreadDateColumn

[F2 메인 조회]
FindButton / chkTotPSI_CheckedChanged
 └─ FindData_Main ─▶ SSP.SSP0060_GET_SHIPMENT_PLAN ─▶ (InitSpread > GetSpdTitle ─▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN)
    ※ SP 내부 EXEC SSP0060_GET_SHIPMENT_PSI_COMMENTS

[F3 Detail 조회]
SpdMain_CellDoubleClick / BtnSearch_Click
 ├─ FindData_Detail            ─▶ SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL
 ├─ FindData_Stock_Detail      ─▶ SSP.SSP0060_GET_STOCK_LOCATION_DETAIL
 ├─ FindData_oWMS_Detail       ─▶ SSP.SSP0060_GET_OWMS_DETAIL
 ├─ FindData_Shipment_Result   ─▶ SSP.SSP0060_GET_SHIPMENT_RESULT (5977, 6117) ─▶ InitSpread > GetSpdTitle
 ├─ FindData_hold_stock        ─▶ SSP.SSP0060_GET_HOLD_STOCK   (SpdMain_CellDoubleClick 전용)
 ├─ FindData_MES_stock         ─▶ SSP.SSP0060_GET_MES_STOCK
 └─ FindData_MES_stock_Detail  ─▶ SSP.SSP0060_GET_MES_STOCK_DETAIL

[F4 메인 저장 — SaveButton]
SaveButton
 ├─ SaveData_Main   ─▶ SSP.SSP0060_SAVE_SHIPMENT_PLAN
 └─ SaveData_Detail
     ├─ Validation_Check (confirm_id 단위 비교) / chkERPIFBlockYn (BLOCK_YN, PERIOD)
     ├─ ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM
     ├─ GetERPInterface
     │   ├─ ─▶ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
     │   ├─ ─▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
     │   ├─ GetErpSoNoCnt        ─▶ SSP.SSP0060_GET_ERP_SO_NO_CNT  (CNT)
     │   ├─ GetShipmentStatusChk ─▶ SSP.SSP0060_GET_SHIPMENT_STATUS (Tables[0..2].CONFIRM_ID)
     │   ├─ ChkConfirmChangeTime ─▶ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME
     │   ├─ NonSoNo ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING (4159)
     │   └─ SoNo    ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING (4380)
     │        └─ GetErpIFCheckNew ─▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (4657)
     │                            ─▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH (4683, 4713)
     ├─ ─▶ SSP.SSP0060_SAVE_HOLD_STOCK_DATA (3460, NOT_IN_FOXQUERY — 확인 필요)
     └─ 재조회: FindData_Main / FindData_Detail / FindData_hold_stock (> InitSpread > GetSpdTitle)

[F5 권한 확인]
EditButton > GetSSPUserCheck ─▶ SSP.SSP0002_GET_USER_INFO_LIST

[F6 변경요청 팝업 저장 — RequestPopup SaveButton / usrButtonList1_UsrButtonList_Click_Detected]
SaveData
 ├─ ChkEngProcessing ─▶ SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK
 ├─ ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM
 └─ GetERPInterface
     ├─ ─▶ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM (1044)
     ├─ ─▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (1072)
     ├─ ChkConfirmChangeTime ─▶ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE
     ├─ GetErpSoNoCnt ─▶ SSP.SSP0060_GET_ERP_SO_NO_CNT
     ├─ GetShipmentStatusChk ─▶ SSP.SSP0060_GET_SHIPMENT_STATUS
     ├─ SoNo    ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN (1181) ─▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH (1253)
     │   └─ GetErpIFCheckNew ─▶ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (1525, 1642)
     │                       ─▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C (1551, 1582)
     │                       ─▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH (1668, 1699)
     └─ NonSoNo ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN (1385) ─▶ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C (1408)

[F7 진입점 미연결(unreached) — 주석 아님, 이관 여부 확인 필요]
RequestPopup.GetErpIFCheck(842)  ─▶ SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
Main.GetErpIFCheck(4579), GetErpIFCheckNew_(5042) ─▶ SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING
Main.NewNonSoNo(4928) ─▶ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING
<field:dtFcstType>(37, 41) ─▶ biz:CommonData.CommonDataList [code=LookupCommon]  (Request Info FCST Type 콤보 소스)
```

---

## 4. 업무 규칙 (사실 근거만)

### 4-1. 저장 분기 조건
| # | 규칙 | 근거 | 미확정 부분 |
|---|---|---|---|
| R1 | ERP SO 번호 건수(CNT)에 따라 `SoNo` 또는 `NonSoNo` 분기를 탑니다 | GetErpSoNoCnt가 `ds.Tables[0].Rows[0]["CNT"]`를 읽음. flow의 SoNo/NonSoNo 경로 | CNT 임계값(>0 등)은 **확인 필요** |
| R2 | 메인 SoNo 분기에서 GetErpIFCheckNew가 `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`과 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`를 호출합니다 | flow 4657 / 4683 / 4713 | 2회 호출 조건은 **확인 필요** |
| R3 | 팝업 SoNo 분기 GetErpIFCheckNew는 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C`(1551, 1582)와 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`(1668, 1699)를 나누어 호출합니다 | flow | 둘 중 무엇을 고르는 조건은 **확인 필요** |
| R4 | 팝업 NonSoNo 분기는 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C`를, 팝업 SoNo 분기는 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`를 호출합니다 | flow 1408 / 1253 | — |
| R5 | 출하 상태 확인은 결과 테이블 3개(Tables[0..2])의 CONFIRM_ID를 확인합니다 | GetShipmentStatusChk | 각 테이블의 의미와 차단 여부는 **확인 필요** |
| R6 | ERP IF Block 여부는 `dtERPBlockYnIF.Rows[0]`의 BLOCK_YN과 PERIOD로 확인합니다. 메인은 chkERPIFBlockYn(3568/3577), 팝업은 ChkERPIFBlockYn(756/765)입니다 | meta_reads | 데이터 소스와 차단 시 메시지는 **확인 필요** |
| R7 | 팝업 저장 전에 계획 처리 중 여부를 확인합니다 | ChkEngProcessing > `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` (SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL) | 차단 조건 값은 **확인 필요** |
| R8 | 확정 변경 시각을 확인합니다. 메인은 `SCM_SSP_CHECK_CONFIRM_CHANGETIME`(SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 조회), 팝업은 `SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE`(SSP_ANL_SHIP_CONFIRM 조회)입니다 | endpoints | 비교 기준은 **확인 필요** |
| R9 | 팝업 SaveData는 `dsMain.Tables[1].Rows[0]["DIVISION_ID"]`를 사용합니다 | meta_reads | 용도는 **확인 필요** |

### 4-2. 필수값·검증
| # | 규칙 | 근거 |
|---|---|---|
| V1 | Validation_Check(3644~3786)는 confirm_id 단위로 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks를 비교합니다(Validationdr, SONoValidationdr) | meta_reads |
| V2 | Shipment Plan Detail 시트에서 라벨에 `*`가 붙은 컬럼(필수 표시)은 CHANGE_REASON_CODE "Change Reason*", CHANGE_REASON_DETAIL "Reason Detail*", FCST_TYPE "FCST Type*", FROM_SITE_DESCRIPTION "From Site*", INCOTERMS "Incoterms*", ITEM_ID "Model*", SHIPMENT_CONFIRM_QTY "Shipment Qty*", SHIPMENT_DATE "Shipment Date*", TO_SITE_DESCRIPTION "To Site*", TRANSPORT_MODE "Trans Mode*"입니다 | SCM_MST_SHEET_COLUMNS 라벨 |
| V3 | Hold stock 시트의 필수 표시는 HOLD_QTY "Amend Qty*", RELEASE_YYYYMMDD "End Date*"입니다 | 메타 라벨 |
| V4 | RequestPopup의 필수 표시는 cboChangeReason "Change Reason*", txtReasonDetail "Reason Detail*"입니다 | Designer 라벨 |
| V5 | 라벨의 `*`를 실제 코드에서 강제하는지, 그리고 그때의 메시지 문구는 **확인 필요**입니다 | — |

### 4-3. 날짜·버킷 규칙
| # | 규칙 | 근거 |
|---|---|---|
| D1 | Bucket Type 콤보는 `DM0003_GET_BUCKET_TYPE_CODE`(SCM_ADM_LOOKUP_MASTER_DETAIL)로 구성합니다 | GetBucketType:5206 |
| D2 | 날짜 헤더는 `SCP0009_GET_SHEET_CALENDAR_3SPAN`(SCM_SYS_CALENDAR_M) 결과로 만들고 InitSpreadDateColumn이 컬럼을 추가합니다 | GetSpdTitle:7449 |
| D3 | Plan Date 콤보 변경 시 row CODE와 dr FROM_DATE, TO_DATE1을 읽어 헤더를 재구성합니다 | cboPlanDate_SelectedIndexChanged |
| D4 | Plan_Current_Check는 Tmp_dtPlanDate.Rows[0]의 CODE, NAME, FROM_DATE, TO_DATE1을 사용합니다 | meta_reads (판정 규칙은 **확인 필요**) |
| D5 | 날짜 컬럼마다 `EDIT_YN_{sColumnName.Replace("D_","")}` 컬럼(헤더 `E{COLUMN_LABEL_NAME}`)을 코드 루프로 추가합니다 | SetSpreadColumn |
| D6 | 입력 기간은 dtShipmentInputPeriod.Rows[0]와 Rows[1]의 VALUE, Diff_VALUE입니다 | InitControls (컨트롤 기본값으로 쓰이는지는 **확인 필요**) |
| D7 | SP `SSP0060_GET_SHIPMENT_PLAN`은 FN_GET_ANL_SHIP_FROZEN_DAY_CNT와 SSP_DNM_FP_PLAN_FROZEN을 참조합니다 | endpoints (Frozen 규칙의 세부는 **확인 필요**) |

### 4-4. 클라이언트 계산 규칙 (엔드포인트 없음)
- CalcPlanQty: dRow DIVISION_ID, FROM_SITE, ITEM_ID, BOH_TYPE, MEASURE / dr BOH_QTY
- CalculateSum, Set_SumValues: measure 컬럼 기준 합계(chkSum 연동은 **확인 필요**)
- EditByChange: QTY, NOEDIT_QTY / SetNote_Display: NOTE
- Simulation: row DIVISION_ID, FROM_SITE, ITEM_ID / dr Container_Qty
- GetFilteredDs: SEQ, DIVISION_ID, FROM_SITE, PRODUCT_LEVEL1, ORD_SEQ, ITEM_ID, TO_SITE, TRANSPORT_MODE, INCOTERMS, FCST_TYPE
- 계산식 자체는 Fact Pack에 없어 **확인 필요**입니다.

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

> 읽기와 쓰기 구분은 endpoints.csv의 objects 접두어(SELECT / INSERT / UPDATE / DELETE / EXEC)를 그대로 옮긴 것입니다. `#` 테이블은 SP 내부 임시 테이블입니다.

| # | 엔드포인트 | SP | 호출 수 | 읽기(SELECT) | 쓰기(INSERT/UPDATE/DELETE) · 하위 EXEC | 진입 |
|---:|---|---|---:|---|---|---|
| 1 | `biz:CommonData.CommonDataList` [code=LookupCommon] | (SP 없음 · UP_FX_GetCommonDataList 코드분기) | 2 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — | `<field:dtFcstType>` (두 팝업, unreached로 표시되나 Request Info FCST Type 콤보 소스) |
| 1' | `biz:CommonData.CommonDataList` [code=TransMode] | (SP 없음 · UP_FX_GetCommonDataList 코드분기) | 3 | SCP_MST_BOD_V | — | SpdDetail_EditChange, SpdDetail_CellClick |
| 2 | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 2 | SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCP_MST_FINAL_ITEM, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | — | 두 팝업 Form_Load / FindButton |
| 3 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | 2 | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_MST_SEND_MAIL_REQ, SSP_PLAN_VERSION_V, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_SYS_CALENDAR_M, SCM_MST_PROJECT, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER_EE, SCM_MST_SITE_CUSTOMER | INSERT SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_H, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SSP_MST_SEND_MAIL_REQ, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM, SSP_MST_SEND_MAIL_REQ / EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_MAIL_SEND_ADJUST_SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SCM_SYS_LOG_BATCH, PR_SCP_SYS_LOG_BATCH | 메인 SaveData_Detail(3286), 팝업 SaveData(584) |
| 4 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 1 | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | — | 팝업 ChkEngProcessing(716) |
| 5 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 1 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_SYS_LOG_BATCH | **unreached** 팝업 GetErpIFCheck(842) |
| 6 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 2 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | GetERPInterface(3990, 1044) |
| 7 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 5 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM / DELETE SSP_ANL_SHIP_CONFIRM / INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | GetERPInterface(4031, 1072), GetErpIFCheckNew(4657, 1525, 1642) |
| 8 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` | SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN | 2 | — | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH | 팝업 SoNo(1181), NonSoNo(1385) |
| 9 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 5 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SCP_SYS_LOG_BATCH | 메인 GetErpIFCheckNew(4683, 4713), 팝업 SoNo(1253), GetErpIFCheckNew(1668, 1699) |
| 10 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C | 3 | 9번과 같음 | 9번과 같음 | 팝업 NonSoNo(1408), GetErpIFCheckNew(1551, 1582) |
| 11 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` | SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE | 1 | SSP_ANL_SHIP_CONFIRM | INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH | 팝업 ChkConfirmChangeTime(1731) |
| 12 | `SSP.SSP0060_GET_ERP_SO_NO_CNT` | SSP0060_GET_ERP_SO_NO_CNT | 2 | SSP_ANL_SHIP_CONFIRM | — | GetErpSoNoCnt(4481, 1759) |
| 13 | `SSP.SSP0060_GET_SHIPMENT_STATUS` | SSP0060_GET_SHIPMENT_STATUS | 2 | SSP_ANL_SHIP_CONFIRM (REF STRING_SPLIT) | — | GetShipmentStatusChk(4506, 1784) |
| 14 | `SSP.SSP0060_GET_SHIPMENT_DIVISION` | SSP0060_GET_SHIPMENT_DIVISION | 1 | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE | INSERT #RETURNTABLE(임시) | SetChangedControl(514) |
| 15 | `SSP.SSP0060_SAVE_SHIPMENT_PLAN` | SSP0060_SAVE_SHIPMENT_PLAN | 1 | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_MST_SITE_ITEM, SSP_MST_SITE_ITEM_EE_V, SCP_MST_SHIPMENT_LOT_SIZE, SSP_MST_PARTIAL_SEQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SCM_MST_SITE_CUSTOMER | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH | SaveData_Main(3029) |
| 16 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` | **없음** (NOT_IN_FOXQUERY, DB에도 없음) | 1 | — | — (**확인 필요**) | SaveData_Detail(3460) |
| 17 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 3 | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCM_SYS_LOG_BATCH, PR_SCP_SYS_LOG_BATCH | NonSoNo(4159), SoNo(4380), unreached NewNonSoNo(4928) |
| 18 | `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 2 | — | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | **unreached** GetErpIFCheck(4579), GetErpIFCheckNew_(5042) |
| 19 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DM0003_GET_BUCKET_TYPE_CODE | 1 | SCM_ADM_LOOKUP_MASTER_DETAIL | — | GetBucketType(5206) |
| 20 | `SSP.SSP0060_GET_SHIPMENT_PLAN` | SSP0060_GET_SHIPMENT_PLAN | 1 | SCM_MST_TITLESET_USER, SSP_DNM_GMES_STOCK_81_82, SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, MST_STOCK, MST_LOCATION, PACKER_STOCK(파서 추출명, 실제 객체인지 CTE 별칭인지 **확인 필요**), SCM_MST_SITE, SCM_MST_ITEM_SN, SCP_MST_FINAL_ITEM, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SSP_MST_LOCATION_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SCP_PLAN_VERSION_V, SSP_DNM_FP_AMEND_SHIPAVAL, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCP_MST_SHIPMENT_LOT_SIZE, SSP_ANL_SHIP_PLAN_C, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCP_MST_BOD_N_V | 임시 테이블만(#TBLDYNAMICTITLEST_SSP0060, #TMP_RESULT_TABLE, #TMP_RESULT_DETAIL_TABLE, #TMP_BOHDATA_STORAGE, #TMP_BOHDATA, #TMP_SHIPMENT_RESULT, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE(_OLD)) / 동적 SQL / EXEC SSP0060_GET_SHIPMENT_PSI_COMMENTS | FindData_Main(5287) |
| 21 | `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` | SSP0060_GET_SHIPMENT_PLAN_DETAIL | 1 | 동적 SQL. 대상 테이블은 **확인 필요** (REF FN_GET_IN_STR, FN_SCM_SPLIT) | — | FindData_Detail(5656) |
| 22 | `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` | SSP0060_GET_STOCK_LOCATION_DETAIL | 1 | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_DNM_STOCK_C, SCP_MST_FINAL_ITEM, SSP_DNM_ESS_PACKER_STOCK_V, SCM_MST_ITEM_SN | — | FindData_Stock_Detail(5781) |
| 23 | `SSP.SSP0060_GET_OWMS_DETAIL` | SSP0060_GET_OWMS_DETAIL | 1 | SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_MST_MODEL_USER, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN | — | FindData_oWMS_Detail(5882) |
| 24 | `SSP.SSP0060_GET_SHIPMENT_RESULT` | SSP0060_GET_SHIPMENT_RESULT | 2 | RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS(파서 추출명, **확인 필요**), SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCP_MST_FINAL_ITEM, SSP_MST_DELEGATE, SCM_DNM_EXFACTORY_RESULT, SCM_MST_ITEM_SN, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS | — | FindData_Shipment_Result(5977, 6117) |
| 25 | `SSP.SSP0060_GET_HOLD_STOCK` | SSP0060_GET_HOLD_STOCK | 1 | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SCP_MST_FINAL_ITEM, SCM_MST_SITE, SCM_MST_ITEM_SN | — | FindData_hold_stock(6225) |
| 26 | `SSP.SSP0060_GET_MES_STOCK` | SSP0060_GET_MES_STOCK | 1 | SSP_DNM_GMES_STOCK_81_82, SCP_MST_FINAL_ITEM | — | FindData_MES_stock(6328) |
| 27 | `SSP.SSP0060_GET_MES_STOCK_DETAIL` | SSP0060_GET_MES_STOCK_DETAIL | 1 | SSP_DNM_GMES_STOCK_81_82, SCP_MST_FINAL_ITEM | — | FindData_MES_stock_Detail(6432) |
| 28 | `SSP.SSP0002_GET_NERP_CODE` | SSP0002_GET_NERP_CODE | 1 | SCM_CODE_LOOKUP_VALUE | — | GetNERPCode(7149) |
| 29 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP0009_GET_SHEET_CALENDAR_3SPAN | 1 | SCM_SYS_CALENDAR_M | — | GetSpdTitle(7449) |
| 30 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | SCM_SSP_CHECK_CONFIRM_CHANGETIME | 1 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH | 메인 ChkConfirmChangeTime(7962) |
| 31 | `SSP.SSP0002_GET_USER_INFO_LIST` | SSP0002_GET_USER_INFO_LIST | 1 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — | GetSSPUserCheck(8017) |

**SP 29종 대조**: SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING, SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM, SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C, SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE, SSP0060_GET_ERP_SO_NO_CNT, SSP0060_GET_SHIPMENT_STATUS, SSP0060_GET_SHIPMENT_DIVISION, SSP0060_SAVE_SHIPMENT_PLAN, SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING, SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING, DM0003_GET_BUCKET_TYPE_CODE, SSP0060_GET_SHIPMENT_PLAN, SSP0060_GET_SHIPMENT_PLAN_DETAIL, SSP0060_GET_STOCK_LOCATION_DETAIL, SSP0060_GET_OWMS_DETAIL, SSP0060_GET_SHIPMENT_RESULT, SSP0060_GET_HOLD_STOCK, SSP0060_GET_MES_STOCK, SSP0060_GET_MES_STOCK_DETAIL, SSP0002_GET_NERP_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN, SCM_SSP_CHECK_CONFIRM_CHANGETIME, SSP0002_GET_USER_INFO_LIST (29/29)

---

## 6. Division·권한별 변형

### 6-1. Division
| 항목 | 사실 |
|---|---|
| Grid 컬럼 | grid_rule 기준 14개 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모든 시트에서 같습니다. Hold stock 10/0, Hold stock Detail 10/0, MES Stock 9/0, MES Stock Detail 13/0, oWMS Detail 25/0, Shipment Plan 13/0, Shipment Plan Detail 44/0, Shipment Result 16/0, Stock Location Detail 20/0, Shipment Plan MEASURE 14/6. 메타에 DIVISION_ID별 행이 없습니다 |
| Division 콤보 | `SSP0060_GET_SHIPMENT_DIVISION`이 TB_FX_USERGROUPAUTHEXTENTION 기준으로 Division과 Site를 정합니다 |
| Division 변경 | `SSP0002_GET_NERP_CODE`(SEGMENT2)를 조회합니다. clbDivision_ID_SelectedIndexChanged는 c.DIVISION_ID, CODE와 dtDiv_Company_ID.Rows[0].NAME을 읽습니다 |
| SetChangedControl | DIVISION_ID 필터와 dtMyCompany.Rows[0].NAME을 사용합니다 |
| 코드 내 Division별 컬럼 표시 분기 | grid_code가 잘려 **확인 필요** |
| 테이블명 SSP_DNM_GMES_STOCK_81_82 | 이름에 81/82가 있으나 Division 제한 여부는 **확인 필요**(추정 금지) |

### 6-2. 권한
| 항목 | 사실 |
|---|---|
| 메뉴 권한 | TB_FX_GroupMenuAuth 13행. 그룹별 C/R/U/D 값은 **확인 필요** |
| 그룹 컨텍스트 | UserInfoContext.Current.NowGroupID를 InitControls, SetChangedControl, SetChangeControl, InitSpread, clbCompanyID_SelectedIndexChanged에서 사용합니다 |
| 개인 필터 | InitSpread와 SetChangeControl이 Filter의 GROUP_ID, USER_ID를 사용합니다 |
| 사용자 확인 | EditButton > GetSSPUserCheck > `SSP0002_GET_USER_INFO_LIST` |
| 프레임워크 버튼 | FindButton(R), SaveButton(C/U), EditButton. 삭제(D) 전용 진입점은 없고, `SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`은 unreached입니다 |

---

## 7. 외부 인터페이스 (사실에 있는 객체만)

| 방향 | 객체 | 기록 SP | 비고 |
|---|---|---|---|
| → ERP | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN (INSERT) | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C, SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 수신 측 처리와 주기는 **확인 필요** |
| → SCS | XIF_SCS_PACK_SHIP_PLAN_S_SN (INSERT) | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM, SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK(unreached) | — |
| → ERP(Pack) | XIF_ERP_PACK_SHIP_PLAN_S_SN (INSERT) | SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK (unreached) | 이관 여부 **확인 필요** |
| ERP 오류 확인 | SSP_ANL_SHIP_ERP_ERROR_CONFIRM (INSERT) | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | — |
| 메일 | SSP_MST_SEND_MAIL_REQ (INSERT/UPDATE), EXEC PR_SSP_MAIL_SEND_ADJUST_MST/SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | 발송 채널은 **확인 필요** |
| DM 동기화 | EXEC PR_DM_SSP_CONFIRM_SYNC | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | — |
| NERP 변환 | SELECT NERP_CONV_MASTER | 확정·배치 SP | — |
| MES / oWMS 재고 (읽기) | SSP_DNM_GMES_STOCK_81_82, SSP_ANL_OWMS_STOCK_C2, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS | 조회 SP | 적재 경로(배치/IF)는 **확인 필요** |

---

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`가 FoxQuery와 DB 모두에 없습니다(SaveData_Detail:3460). 실제로 실패하는 경로인지, TO-BE에서 Hold stock 저장을 어떻게 처리할지 결정이 필요합니다 | NOT_IN_FOXQUERY |
| 2 | unreached 호출(`SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` ×2, NewNonSoNo의 `SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING`)을 이관할지 | 정적 분석상 진입점 없음 |
| 3 | 메인에서 두 팝업을 여는 지점과 전달 파라미터 | Fact Pack 미기재 |
| 4 | SoNo/NonSoNo 분기 임계값, GetErpIFCheckNew 내부 분기 조건 | 조건식 미추출 |
| 5 | BLOCK_YN/PERIOD 데이터 소스와 차단 메시지 | 미추출 |
| 6 | 더블클릭 셀(Measure/컬럼)별 Detail 조회 분기 | 미추출 |
| 7 | 저장 체인(확정 → ERP IF → 메일)의 트랜잭션 경계 | SP별 로그 EXEC만 확인됨 |
| 8 | TB_FX_GroupMenuAuth 13행 값, 메뉴 위치 | 행 수만 있음 |
| 9 | SCM_MST_SHEET_MEASURE 20행(필수+기본 14 / 선택 6)의 MEASURE 코드 | 건수만 있음 |
| 10 | Request Info 하드코딩 컬럼의 헤더/필드 교차(헤더 `NEW_TO_CITY`↔필드 ELECTRODE_YN, 헤더 `ELECTRODE_YN`↔필드 NEW_TO_CITY. ConfirmDetailPopup 215/216, RequestPopup 240/241) | 원문 결함 가능 |
| 11 | 주석 처리된 `SSP.SSP0046_GET_BUCKET_TYPE_CODE`(:341)는 현행 기능이 아니므로 제외했습니다 | commented:MATCH |
| 12 | 4-2 표의 `SaveData`→`PersonalSettingPopup.SaveData` 매핑은 같은 이름 때문에 파서가 오매칭했을 수 있습니다 | 파서 한계 |
| 13 | SP 내부 MSSQL 구문(STRING_SPLIT 참조, # 임시 테이블, 동적 SQL)을 Oracle 19c로 어떻게 전환할지 | endpoints objects |

=== FILE: screen_design.md ===
# SSP0060 화면설계서 — Shipment Plan

> **근거**: Fact Pack(SSP0060)과 1차 분석서만 사용했습니다. 없는 값은 **확인 필요**로 표기했습니다.
> §5 액션 명세의 엔드포인트는 업무분석서 §5와 같은 이름을 씁니다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0060 |
| 화면명 | Shipment Plan (메인 Form `SSP0060_ShipmentPlan`) |
| 팝업 1 | `SSP0060_ShipmentPlanRequestPopup`: Form Text `"Shipment Request Popup"` |
| 팝업 2 | `SSP0060_ShipmentPlanConfirmDetailPopup`: Form Text `"Request Info Popup"` |
| 도메인 | SSP |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, 값 미포함) |
| Grid 구성 방식 | HYBRID: META(SCM_MST_SHEET_COLUMNS 196행) + DB 루프(날짜 / EDIT_YN_*) + HARDCODED(Request Info) |
| 시트 | Hold stock, Hold stock Detail, MES Stock, MES Stock Detail, oWMS Detail, Request Info, Shipment Plan, Shipment Plan Detail, Shipment Result, Stock Location Detail (10개) |

---

## 2. 화면 레이아웃 (텍스트 와이어프레임)

### 2-1. 메인 `SSP0060_ShipmentPlan`
> splitContainer1의 **Orientation / SplitterDistance / Size는 props.csv가 잘려 확인 필요**입니다. 따라서 Panel1과 Panel2가 상/하인지 좌/우인지, 비율이 얼마인지 확정할 수 없습니다. 아래는 parent 체인(1차 분석서 web_components §2)만 반영한 트리입니다.

```
SSP0060_ShipmentPlan (Form)
├─ [프레임워크 공통 버튼바]  FindButton · SaveButton · EditButton          (menu-button-dynamic-fetch)
├─ usrConditionPanel1  ── 조회조건 영역
│   └─ usrLayoutControl2
│       ├─ clbCompany_ID      ├─ clbDivision_ID     ├─ clbPlantSite
│       ├─ cboPlanDate        ├─ cboBucketType      ├─ drpPeriod
│       ├─ txtItemId + btnItemId                     ├─ clbProductLevel11
│       ├─ chkSum             ├─ chkTotPSI          ├─ btnMeasure
│       └─ btnSimulation
├─ splitContainer1  (Orientation=확인 필요 · SplitterDistance=확인 필요 · 비율 %=확인 필요)
│   ├─ Panel1 ── 메인 그리드 영역
│   │   └─ spdMain  (spdMain_Sheet1 → 시트 "Shipment Plan")
│   └─ Panel2 ── Detail 영역
│       ├─ usrLayoutControl3  ── Detail 조회조건
│       │   ├─ txtRequestor + btnRequestor   ├─ txtModel2 + btnItemID2
│       │   ├─ drpPeriod2      ├─ drpPeriod3      ├─ clbResultType
│       │   ├─ txtBoxID        ├─ clbProductLevel12
│       │   └─ btnSearch       └─ btnNew
│       └─ spdDetail (spdDetail_Sheet1 → 시트 Shipment Plan Detail / Stock Location Detail /
│                      oWMS Detail / Shipment Result / Hold stock / Hold stock Detail /
│                      MES Stock / MES Stock Detail — 시트별 귀속은 확인 필요)
├─ usrButton1   (parent 없음 — 배치 위치 확인 필요)
├─ usrLayoutControl1 (메인/팝업 중 어느 Form의 어느 parent인지 controls.csv 원문 미수록 → 확인 필요)
└─ imageList1 (비시각)
```

### 2-2. 팝업 `SSP0060_ShipmentPlanRequestPopup` (Dock 기반 상/하 분할)
| 순서 | 컨트롤 | Dock | Size(W×H) | 높이 비율(전체 343) |
|---:|---|---|---|---:|
| 1 | usrConditionPanel1 | Top | 1764×52 | 15.2% |
| 2 | splitter1 | Top | 1764×3 | 0.9% |
| 3 | spdMain (spdMain_Sheet1 → "Request Info") | Fill | 1764×288 | 84.0% |

```
SSP0060_ShipmentPlanRequestPopup  "Shipment Request Popup"
┌───────────────────────────────────────────────────────── 1764 ─┐
│ usrConditionPanel1 (Top, 52)                                    │
│   usrButtonList1 · cboChangeReason "Change Reason*"             │
│   txtReasonDetail "Reason Detail*" · btnAutoSet "Auto Set"      │
│   (내부 LayoutControl 귀속: lcChangeReason/lcReasonDetail 존재, │
│    usrLayoutControl 이름은 확인 필요)                            │
├─ splitter1 (Top, 3) ────────────────────────────────────────────┤
│ spdMain (Fill, 288)  ── Request Info (49컬럼, 2단 헤더)          │
└─────────────────────────────────────────────────────────────────┘
```

### 2-3. 팝업 `SSP0060_ShipmentPlanConfirmDetailPopup` (Dock 기반 상/하 3단)
| 순서 | 컨트롤 | Dock | Size | 높이 비율(전체 370) |
|---:|---|---|---|---:|
| 1 | usrConditionPanel1 | Top | 1764×52 | 14.1% |
| 2 | panel1 (요청 정보, ReadOnly) | Top | 1764×158 | 42.7% |
| 3 | splitter1 | Top | 1764×3 | 0.8% |
| 4 | spdMain (spdMain_Sheet1 → "Request Info") | Fill | 1764×157 | 42.4% |

```
SSP0060_ShipmentPlanConfirmDetailPopup  "Request Info Popup"
┌──────────────────────────────────────────────── 1764 ─┐
│ usrConditionPanel1 (52)  btnButtonList                 │
├────────────────────────────────────────────────────────┤
│ panel1 (158)  usrLabel2 "Request Confirm Detail"        │
│   txtRequestNo "Request No" · txtRequestor "Requestor"  │
│   txtRequestDeptName "Dept Name" · txtApproval "Approval"│
│   txtAppDeptName "Dept Name"   (모두 ReadOnly)          │
├─ splitter1 (3) ────────────────────────────────────────┤
│ spdMain (157)  Request Info (48컬럼, 2단 헤더)           │
└────────────────────────────────────────────────────────┘
```

---

## 3. 컨트롤 명세 (43개)

> 라벨은 props.csv Text 원문입니다. 메인 화면의 LayoutControlItem Text는 props.csv가 잘려 **확인 필요**이며, 이 경우 LayoutItem 이름만 표기했습니다.

| # | 컨트롤명 | Form | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 / 핸들러 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|---|
| 1 | usrLayoutControl1 | 확인 필요 | UsrLayoutControl | – | – | – | – | 레이아웃 컨테이너 |
| 2 | usrConditionPanel1 | 메인/두 팝업 | UsrConditionPanel | – | – | – | – | 조회조건 패널 (공용) |
| 3 | usrLayoutControl2 | 메인(usrConditionPanel1 하위) 외 | UsrLayoutControl | – | – | – | – | 조회조건 Grid 레이아웃 |
| 4 | btnButtonList | ConfirmDetailPopup | UsrButtonList | – | – | – | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼바 |
| 5 | spdMain | 메인/두 팝업 | FpSpread | – | – | – | 메인: KeyDown→`spdMain_KeyDown`, KeyUp→`spdMain_KeyUp`, TopChange→`SpdMain_TopChange`, CellDoubleClick→`SpdMain_CellDoubleClick`, Change→`SpdMain_Change`, ClipboardPasted→`SpdMain_ClipboardPasted` / RequestPopup: ClipboardPasted→`spdMain_ClipboardPasted`, Change→`spdMain_Change`, KeyDown→`spdMain_KeyDown` | Wijmo FlexGrid |
| 6 | spdMain_Sheet1 | 메인/두 팝업 | SheetView | 메인: Shipment Plan / 팝업: Request Info | – | – | – | FlexGrid 컬럼 정의 |
| 7 | usrLayoutControl3 | 메인(splitContainer1.Panel2) | UsrLayoutControl | – | – | – | – | Detail 조회조건 레이아웃 |
| 8 | txtRequestNo | ConfirmDetailPopup | TextBox(ReadOnly) | `Request No` | 조회값(CHANGE_REQ_NO, 확인 필요) | – | – | readonly Input |
| 9 | txtRequestor | ConfirmDetailPopup(TextBox ReadOnly) / 메인(UsrTextBox) | TextBox / UsrTextBox | 팝업 `Requestor` / 메인 LayoutItem `Requestor`(Text 확인 필요) | – | – | 메인: btnRequestor 연동 | readonly Input / 입력+사용자 팝업 |
| 10 | txtRequestDeptName | ConfirmDetailPopup | TextBox(ReadOnly) | `Dept Name` | – | – | – | readonly Input |
| 11 | txtApproval | ConfirmDetailPopup | TextBox(ReadOnly) | `Approval` | – | – | – | readonly Input |
| 12 | txtAppDeptName | ConfirmDetailPopup | TextBox(ReadOnly) | `Dept Name` | – | – | – | readonly Input |
| 13 | usrLabel2 | ConfirmDetailPopup | UsrLabel | `Request Confirm Detail` | – | – | – | 섹션 타이틀 |
| 14 | usrButtonList1 | RequestPopup | UsrButtonList | – | – | – | UsrButtonList_Click_Detected → `usrButtonList1_UsrButtonList_Click_Detected` | 팝업 버튼바 |
| 15 | cboChangeReason | RequestPopup | UsrComboBox | `Change Reason*` | 확인 필요 | Y(라벨 *) | – | ComboBox (필수) |
| 16 | txtReasonDetail | RequestPopup | TextBox | `Reason Detail*` | – | Y(라벨 *) | – | Input (필수) |
| 17 | btnAutoSet | RequestPopup | SimpleButton | `Auto Set` | – | – | Click → `btnAutoSet_Click` | Button |
| 18 | usrButton1 | 메인(parent 없음) | UsrButton | 확인 필요 | – | – | 확인 필요 | 확인 필요 |
| 19 | btnSimulation | 메인 | UsrButton | LayoutItem `lcbtnSimulation`(Text 확인 필요) | – | – | Click → `BtnSimulation_Click` | Button |
| 20 | clbCompany_ID | 메인 | UsrCombo | 확인 필요 | GetSSPInnerTable(InitControls) | 확인 필요 | SelectedIndexChanged → `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox |
| 21 | chkSum | 메인 | UsrCheckBox | 확인 필요 | 확인 필요 | – | CheckedChanged → `chkSum_CheckedChanged` | Checkbox |
| 22 | btnMeasure | 메인 | UsrButton | 확인 필요 | – | – | Click → `BtnMeasure_Click` | Measure 선택 버튼 |
| 23 | btnItemId | 메인 | UsrButton | 확인 필요 | – | – | Click → `btnItemId_Click` | 품목 팝업 버튼 |
| 24 | clbPlantSite | 메인 | UsrCheckedList | 확인 필요 | 확인 필요 | 확인 필요 | – | Wijmo MultiSelect |
| 25 | drpPeriod | 메인 | UsrDateRangePicker | 확인 필요 | dtShipmentInputPeriod VALUE/Diff_VALUE 연관 여부는 확인 필요 | 확인 필요 | – | InputDate 쌍 |
| 26 | txtItemId | 메인 | UsrMultiLineEditor | LayoutItem `lblItemId` | – | – | btnItemId 연동 | 다건 입력 |
| 27 | clbDivision_ID | 메인 | UsrCombo | 확인 필요 | `SSP.SSP0060_GET_SHIPMENT_DIVISION` | 확인 필요 | SelectedIndexChanged → `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox |
| 28 | cboPlanDate | 메인 | UsrCombo | LayoutItem `PlanDate` | 확인 필요 (CODE/FROM_DATE/TO_DATE1) | 확인 필요 | SelectedIndexChanged → `cboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| 29 | cboBucketType | 메인 | UsrCombo | LayoutItem `lblBucket` | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 확인 필요 | SelectedIndexChanged → `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| 30 | chkTotPSI | 메인 | UsrCheckBox | 확인 필요 | 확인 필요 | – | CheckedChanged → `chkTotPSI_CheckedChanged` | Checkbox(변경 시 재조회) |
| 31 | clbProductLevel11 | 메인 | UsrCheckedList | LayoutItem `lcProductLevel11` | 확인 필요 | – | – | MultiSelect |
| 32 | spdDetail | 메인 | FpSpread | – | – | – | TopChange→`SpdDetail_TopChange`, SheetTabClick→`SpdDetail_SheetTabClick`, ActiveSheetChanged→`SpdDetail_ActiveSheetChanged`, CellClick→`SpdDetail_CellClick`, ComboSelChange→`SpdDetail_ComboSelChange`, CellDoubleClick→`SpdDetail_CellDoubleClick`, EditChange→`SpdDetail_EditChange`, ClipboardPasted→`SpdDetail_ClipboardPasted` | Wijmo FlexGrid + 시트 탭 |
| 33 | spdDetail_Sheet1 | 메인 | SheetView | Detail 시트들 | – | – | (dsdm Changed → `shtDetail_Change`, 데이터셋 이벤트) | FlexGrid 컬럼 정의 |
| 34 | btnRequestor | 메인 | UsrButton | 확인 필요 | – | – | Click → `BtnRequestor_Click` | 사용자 팝업 버튼 |
| 35 | btnSearch | 메인 | SimpleButton | 확인 필요 | – | – | Click → `BtnSearch_Click` | Detail 조회 버튼 |
| 36 | txtModel2 | 메인 | UsrMultiLineEditor | 확인 필요 | – | – | btnItemID2 연동 | 다건 입력 |
| 37 | btnItemID2 | 메인 | UsrButton | 확인 필요 | – | – | Click → `BtnItemID2_Click` | 품목 팝업 버튼 |
| 38 | drpPeriod2 | 메인 | UsrDateRangePicker | 확인 필요 | 확인 필요 | – | ValueChanged → `DrpPeriod2_ValueChanged` | InputDate 쌍 |
| 39 | drpPeriod3 | 메인 | UsrDateRangePicker | 확인 필요 | 확인 필요 | – | – | InputDate 쌍 |
| 40 | clbResultType | 메인 | UsrCheckedList | 확인 필요 | 확인 필요 | – | – | MultiSelect |
| 41 | txtBoxID | 메인 | UsrMultiLineEditor | 확인 필요 | – | – | – | 다건 입력 |
| 42 | btnNew | 메인 | UsrButton | LayoutItem `lcbtnNew` | – | – | Click → `BtnNew_Click` | Button |
| 43 | clbProductLevel12 | 메인 | UsrCheckedList | LayoutItem `lcProductLevel12` | 확인 필요 | – | – | MultiSelect |

- Form 이벤트: 메인 `Form_Load`(.ctor:306), `SSP0060_ShipmentPlan_Shown`(.ctor:307) / RequestPopup `Form_Load`(.ctor:140), `SSP0060_ShipmentPlanRequestPopup_Shown`(.ctor:141), `SSP0060_ShipmentPlanRequestPopup_FormClosing`(Designer:341) / ConfirmDetailPopup `Form_Load`(.ctor:123).
- `spdMain_KeyDown`/`spdMain_KeyUp`(소문자, Designer 배선)와 `SpdMain_*`(대문자, InitEvent 배선)은 서로 다른 핸들러입니다.

---

## 4. 그리드 명세

> 공통: META 시트는 14개 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 표시가 같습니다. 그래서 'division별 표시' 열은 모두 "14 Div 동일"입니다. 컬럼 순서는 grid_effective가 알파벳 정렬이어서 SCM_MST_SHEET_COLUMNS 원문 순서로 **확인 필요**입니다. 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE) 값은 Fact Pack에 없어 "META(확인 필요)"로 표기했습니다.

### 4-1. Shipment Plan (spdMain · META 13 표시 / 5 숨김 + DB 루프 · MEASURE 14/6)
| 컬럼 | 헤더 | 타입 | 출처 | division별 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | META(확인 필요) | META | 14 Div 동일 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | META | META | 동일 | 확인 필요 |
| TO_SITE | To Site | META | META | 동일 | 확인 필요 |
| PRODUCT_LEVEL1 | Product Level1 | META | META | 동일 | 확인 필요 |
| ITEM_ID | Model | META | META | 동일 | 확인 필요 |
| NICK_NAME | Nick Name | META | META | 동일 | 확인 필요 |
| FCST_TYPE | FCST Type | META | META | 동일 | 확인 필요 |
| INCOTERMS | Incoterms | META | META | 동일 | 확인 필요 |
| TRANSPORT_MODE | Transmode | META | META | 동일 | 확인 필요 |
| BOH_TYPE | BOH_TYPE | META | META | 동일 | 확인 필요 |
| BOH_QTY | BOH_QTY | META | META | 동일 | 확인 필요 |
| PSI | PSI | META | META | 동일 | 확인 필요 |
| MEASURE_NAME | Measure | META | META | 동일 | 확인 필요 |
| FROM_SITE / MEASURE / BACK_COLOR / CONFIRM_DAY / LOT_YN | Site / Measure / Back Color / Confrim Day(원문) / Lot_YN | META | META | 동일 | 숨김 |
| (날짜 컬럼) | SCP0009_GET_SHEET_CALENDAR_3SPAN 결과 | 동적 | DB 루프(InitSpreadDateColumn) | 동일 | EDIT_YN_* 및 EditByChange(QTY/NOEDIT_QTY) 연관. 규칙은 확인 필요 |
| EDIT_YN_{날짜} | E{COLUMN_LABEL_NAME} | 동적 | DB 루프(SetSpreadColumn) | 동일 | 표시 여부 확인 필요 |

### 4-2. Shipment Plan Detail (spdDetail · 44 표시 / 27 숨김)
| 컬럼 | 헤더 | 타입 | 출처 | division별 | 편집 |
|---|---|---|---|---|---|
| CHANGE_REASON_CODE | Change Reason* | META | META | 동일 | 필수 표시(편집 추정 금지 → 확인 필요) |
| CHANGE_REASON_DETAIL | Reason Detail* | META | META | 동일 | 필수 표시 |
| CHANGE_REQ_NO | Change Request No | META | META | 동일 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | META | META | 동일 | 확인 필요 |
| DIVISION_ID | Div | META | META | 동일 | 확인 필요 |
| ERP_DO_NO / ERP_SO_NO | DO No / SO No | META | META | 동일 | 확인 필요 |
| FCST_TYPE | FCST Type* | META | META | 동일 | 필수 표시 |
| FROM_SITE_DESCRIPTION | From Site* | META | META | 동일 | 필수 표시 |
| TO_SITE_DESCRIPTION | To Site* | META | META | 동일 | 필수 표시 |
| INCOTERMS | Incoterms* | META | META | 동일 | 필수 표시 |
| ITEM_ID | Model* | META | META | 동일 | 필수 표시 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | META | META | 동일 | 필수 표시 · Validation_Check 비교 대상 |
| SHIPMENT_DATE | Shipment Date* | META | META | 동일 | 필수 표시 · Validation_Check 비교 대상 |
| TRANSPORT_MODE | Trans Mode* | META(콤보) | META + `biz:CommonData.CommonDataList`[TransMode] | 동일 | 편집(SpdDetail_EditChange / CellClick / ComboSelChange) |
| REMARKS / REMARKS2 / REMARKS3 | Remarks / Building / Customer Requirement | META | META | 동일 | REMARKS·REMARKS2는 Validation_Check 비교 대상 |
| SHIPMENT_STATUS | Status | META | META | 동일 | 확인 필요 |
| REQUESTOR | Shipment Requestor | META | META | 동일 | 확인 필요 |
| MODEL_USER | Model PIC | META | META | 동일 | 확인 필요 |
| LT_DAY | L/T(Day) | META | META | 동일 | 확인 필요 |
| A_COUNTRY / A_PORT_CODE / A_PORT_NAME | A Contry(원문) / A Port Code / A Port Name | META | META | 동일 | 확인 필요 |
| SHIPTO_DESCRIPTION / SOLDTO_DESCRIPTION | Ship To Party / Sold To Party | META | META | 동일 | 확인 필요 |
| ATTRIBUTE10, CITY_NAME, COUNTRY_NAME, END_CUSTOMER, ETA, ETD, Expected_Shipping_Date, MKT_OWNER, NICK_NAME, PRODUCT_LEVEL1, PROJECT_CODE, PROJECT_NAME, SHIPTO_CITY_NAME, SHIPTO_REGION_NAME, TEAM, UPDATED_BY, UPDATED_DATE | 컬럼명과 같음(라벨 원문은 메타 참조) | META | META | 동일 | 확인 필요 |
| 숨김 27: BOD_ID, CHANGE_TYPE, CHECK_NEED_YN "Checked", EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE "From Site ID", TO_SITE "To Site ID", ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE | — | META | META | 동일 | 숨김 |

### 4-3. Stock Location Detail (20 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| AVAILABLE_DATE, AVAILABLE_QTY, CUTOFF_DATE, FROM_SITE, HOLDING_DATE, MOVING_QTY, NICK_NAME, OUTSOURCING_FACTORY, OUTSOURCING_FLAG, STOCK_TYPE, TOTAL_QTY | 컬럼명과 같음 | META | 동일 | 조회 전용 여부 확인 필요 |
| COMPANY_ID / DEFECT_QTY / DIVISION_ID / ITEM_ID / PLANT_ID / QTY_UOM / STORAGE_DESCRIPTION / STORAGE_ID / WIPHOLD_YN | Company / Deffect Qty(원문) / Div / Model / Plant / Qty Uom / Storage / Storage ID / Wiphold Yn | META | 동일 | 확인 필요 |
| EDIT_YN_* | E{라벨} | DB 루프 | 동일 | 확인 필요 |

### 4-4. oWMS Detail (25 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| ALLOCATION_QTY, AVAILABLE_QTY, CUSTOMER_CODE, CUSTOMER_NAME, EXPIRATION_QTY, GRADE, HOLD_QTY, LOT_ID, LOT_ISSUE_DATE, MOVING_QTY, NICK_NAME, PACKING_QTY, PACKING_STATUS, PALLET_ID, PLANT_ID, SOC, STOCK_QTY, UNDECIDED_QTY | 컬럼명과 같음 | META | 동일 | 확인 필요 |
| CAPA_GRADE / DIVISION_ID / ITEM_ID / LONG_TERM_QTY / RECEIVING_QTY / STOCK_STATUS / STORAGE_ID | Capa. Grade / Div / Model / Long-term Qty / Reciving Qty(원문 오타) / Inventory Status / Storage | META | 동일 | 확인 필요 |
| EDIT_YN_* | E{라벨} | DB 루프 | 동일 | 확인 필요 |

### 4-5. Hold stock (10 표시 / 2 숨김)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 동일 | 확인 필요 |
| FROM_SITE_NM | From Site | META | 동일 | 확인 필요 |
| ITEM_ID | Model | META | 동일 | 확인 필요 |
| NICK_NAME | NICK_NAME | META | 동일 | 확인 필요 |
| HOLD_QTY | Amend Qty* | META | 동일 | 필수 표시. 저장 엔드포인트 `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` 없음(확인 필요) |
| HOLD_YYYYMMDD | Start Date | META | 동일 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date* | META | 동일 | 필수 표시 |
| REMARKS / LAST_UPDATED_BY / LAST_UPDATE_DATE | 같음 | META | 동일 | 확인 필요 |
| FROM_SITE "Site", HOLD_ID | — | META | 동일 | 숨김 |

### 4-6. Hold stock Detail (10 표시 / 2 숨김)
Hold stock과 컬럼이 같습니다. 라벨에 `*`가 없습니다(HOLD_QTY "Amend Qty", RELEASE_YYYYMMDD "End Date"). 숨김 컬럼은 FROM_SITE, HOLD_ID입니다. 출처는 META, 14 Div 동일입니다. 이 시트를 생성하는 코드 위치와 데이터 소스는 **확인 필요**입니다(코드 생성 시트 목록에 없음).

### 4-7. MES Stock (9 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| ITEM_ID, NICK_NAME, TOTAL, AVAILABLE_STOCK, BEFORE_OQC, OQC_INSP_REQUEST, OQC_COMPLETE, OQC_NG | Model 외 컬럼명과 같음 | META | 동일 | 확인 필요 |
| QMS_MES_HOLD | QMS/MES Hold | META | 동일 | 확인 필요 |

### 4-8. MES Stock Detail (13 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| PRODID / PRJT_NAME / LOTID / BOXID | Model / Nick Name / Lot ID / Box ID | META | 동일 | 확인 필요 |
| LOT_QTY, OQC_INSP_RESULT, PROD_VALID_DATE, MES_HOLD_YN, MES_UNHOLD_SCHD_DATE, QMS_HOLD_YN, QMS_UNHOLD_SCHD_DATE | 같음 | META | 동일 | 확인 필요 |
| AVAILABLE_YN / EXP_INSP_VALID_DATE | Available stock YN / Exp Insp Vaild Date(원문 오타) | META | 동일 | 확인 필요 |

### 4-9. Shipment Result (16 표시 + EDIT_YN_*)
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| CONFIRM_ID / DIVISION_ID / ERP_SO_NO / ETA_DATE / ETD_DATE / ITEM_ID / QTY / TRANSPORT_MODE / TYPE / YYYYMMDD | Confirm/Plan ID / Div / SO No / ETA / ETD / Model / Shipment Qty / Trans Mode / Status / Shipment Date | META | 동일 | 확인 필요 |
| END_CUSTOMER, FROM_SITE, TO_SITE, INCOTERMS, NICK_NAME, SHIP_TYPE | 같음 | META | 동일 | 확인 필요 |

### 4-10. Request Info (두 팝업 · HARDCODED · 2단 헤더 `Confirmed` / `Change`)
| 필드 | 헤더 | 타입 | 폭 | 출처 | ConfirmDetail 표시 | RequestPopup 표시 |
|---|---|---|---:|---|---|---|
| (CAppSetting.StringAction) | A | Text | 10 | HARDCODED | 숨김 | 확인 필요 |
| CHANGE_REQ_NO | change_req_no | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| DIVISION_ID | Division ID | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| NEW_YN | New YN | Text | 10 | HARDCODED(RequestPopup만, :205) | – | 숨김 |
| CONFIRM_ID | Confirm/Plan ID | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| ERP_SO_NO | SO No | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| PROJECT_NAME | Project Name | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| FCST_TYPE | FCST Type | Combo (`biz:CommonData.CommonDataList`[LookupCommon] `SALES_TYPE_CODE`) | 100 | HARDCODED | 표시 | 확인 필요 |
| ITEM_ID / FROM_SITE / TO_SITE / INCOTERMS | Model / From Site / To Site / Incoterms | Text | 80/60/100/65 | HARDCODED | 표시 | 확인 필요 |
| [Confirmed] LT_DAY / ETD / ETA / TRANSPORT_MODE / SHIPMENT_DATE / SHIPMENT_CONFIRM_QTY | L/T(Day) / ETD / ETA / Trans Mode / Shipment Date / Qty | Text/Date/Date/Text/Date/Num | 60/70/70/45/70/60 | HARDCODED | 표시 | 확인 필요 |
| [Change] NEW_LT_DAY / NEW_ETD / NEW_ETA / NEW_TRANSPORT_MODE / NEW_SHIPMENT_DATE / NEW_SHIPMENT_CONFIRM_QTY | 같은 헤더 | 같은 타입 | 같은 폭 | HARDCODED | 표시 | 확인 필요 |
| DIFF_QTY | Diff Qty | Num | 60 | HARDCODED | 표시 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | Combo (`GetSSPInnerTable("CHANGE_REASON_CODE_ALL")`) | 100 | HARDCODED | 표시 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | Text | 100 | HARDCODED | 표시 | 확인 필요 |
| NEW_BOD_ID, NEW_ROUTE_ID, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_TO_COUNTRY | 같은 이름 | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| **ELECTRODE_YN** | **NEW_TO_CITY** (원문 그대로, 교차) | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| **NEW_TO_CITY** | **ELECTRODE_YN** (원문 그대로, 교차) | Text | 100 | HARDCODED | 숨김 | 확인 필요 |
| ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, EDIT_REMARKS, EDIT_MAIN, REMARKS, REMARKS2, REMARKS3, PRODUCT_LEVEL1, NICK_NAME, FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, PROJECT_CODE | 같은 이름 | Text | 100 | HARDCODED | 숨김 | 확인 필요 |

- 컬럼 수: ConfirmDetailPopup 48, RequestPopup 49(NEW_YN 포함). 두 팝업 모두 division에 따른 분기가 없습니다(HARDCODED, 조건은 `SheetName == "Request Info"`만 있음).
- 헤더 스타일: HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced, VerticalAlignment=General.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 메인 Load | `Form_Load` | InitControls > SetChangedControl / GetBucketType, CreateSpread > InitSpread > GetSpdTitle | `SSP.SSP0060_GET_SHIPMENT_DIVISION`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | clbDivision_ID, clbPlantSite(확인 필요), cboBucketType, spdMain 헤더 |
| A2 | 메인 Shown | `SSP0060_ShipmentPlan_Shown` | 확인 필요 | — | 확인 필요 |
| A3 | FindButton(메인) | FindButton | FindData_Main (> InitSpread > GetSpdTitle) | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain "Shipment Plan" |
| A4 | SaveButton(메인) | SaveButton | SaveData_Main | `SSP.SSP0060_SAVE_SHIPMENT_PLAN` | 저장 후 처리 확인 필요 |
| A5 | SaveButton(메인) | SaveButton | SaveData_Detail: Validation_Check, chkERPIFBlockYn | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | — |
| A6 | 〃 | 〃 | GetERPInterface | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0060_GET_ERP_SO_NO_CNT`, `SSP.SSP0060_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | 분기 판정 |
| A7 | 〃 | 〃 | SoNo / NonSoNo, GetErpIFCheckNew | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | ERP IF 기록 |
| A8 | 〃 | 〃 | Hold stock 저장(3460) | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` (NOT_IN_FOXQUERY) | **확인 필요** |
| A9 | 〃 | 〃 | 재조회 FindData_Main / Detail / hold_stock | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0060_GET_HOLD_STOCK`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain, spdDetail |
| A10 | EditButton | EditButton | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 권한 판정 후 처리 확인 필요 |
| A11 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | GetNERPCode | `SSP.SSP0002_GET_NERP_CODE` | SEGMENT2 보관 |
| A12 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | cboPlanDate 이벤트 해제(7196) → InitSpread > GetSpdTitle → 재연결(7200) | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더 |
| A13 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | GetSpdTitle, InitSpreadDateColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 날짜 컬럼 |
| A14 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | 확인 필요 | — | 확인 필요 |
| A15 | chkSum 변경 | `chkSum_CheckedChanged` | 합계 표시(CalculateSum / Set_SumValues 연관은 확인 필요) | — | spdMain |
| A16 | chkTotPSI 변경 | `chkTotPSI_CheckedChanged` | FindData_Main | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재조회 |
| A17 | btnMeasure | `BtnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재구성 |
| A18 | btnItemId | `btnItemId_Click` | 품목 팝업(확인 필요) | — | txtItemId |
| A19 | btnItemID2 | `BtnItemID2_Click` | 품목 팝업(확인 필요) | — | txtModel2 |
| A20 | btnSearch | `BtnSearch_Click` | FindData_Detail / Stock_Detail / oWMS_Detail / Shipment_Result / MES_stock / MES_stock_Detail | `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0060_GET_OWMS_DETAIL`, `SSP.SSP0060_GET_SHIPMENT_RESULT`, `SSP.SSP0060_GET_MES_STOCK`, `SSP.SSP0060_GET_MES_STOCK_DETAIL`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 시트 |
| A21 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | A20과 같은 조회 + FindData_hold_stock | A20의 엔드포인트 + `SSP.SSP0060_GET_HOLD_STOCK` | spdDetail (Hold stock 포함) |
| A22 | btnNew | `BtnNew_Click` | 확인 필요 | — | 확인 필요 |
| A23 | btnRequestor | `BtnRequestor_Click` | 사용자 팝업(확인 필요) | — | txtRequestor |
| A24 | btnSimulation | `BtnSimulation_Click` | Simulation (Container_Qty) | — | spdMain 값 |
| A25 | spdMain 스크롤 | `SpdMain_TopChange` | 스크롤 동기화(대상 확인 필요) | — | — |
| A26 | spdDetail 스크롤 | `SpdDetail_TopChange` | 〃 | — | — |
| A27 | spdMain 키 | `spdMain_KeyDown`, `spdMain_KeyUp` | 확인 필요 | — | — |
| A28 | spdMain 변경/붙여넣기 | `SpdMain_Change`, `SpdMain_ClipboardPasted` | EditByChange / SetNote_Display 연관은 확인 필요 | — | spdMain |
| A29 | spdDetail 탭 | `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged` | 시트 전환 처리(확인 필요) | — | spdDetail |
| A30 | spdDetail 셀 클릭 | `SpdDetail_CellClick` | Trans Mode 콤보 재조회 | `biz:CommonData.CommonDataList` [TransMode] | TRANSPORT_MODE 콤보 |
| A31 | spdDetail 편집 | `SpdDetail_EditChange` | 〃 (1380, 1389) | `biz:CommonData.CommonDataList` [TransMode] | 〃 |
| A32 | spdDetail 콤보 선택 | `SpdDetail_ComboSelChange` | 확인 필요 | — | — |
| A33 | spdDetail 더블클릭 | `SpdDetail_CellDoubleClick` | 확인 필요(팝업 호출 여부 확인 필요) | — | — |
| A34 | spdDetail 붙여넣기 | `SpdDetail_ClipboardPasted` | c.CODE 사용 | — | spdDetail |
| A35 | dsdm Changed | `shtDetail_Change` | 확인 필요 | — | — |
| A36 | drpPeriod2 변경 | `DrpPeriod2_ValueChanged` | 확인 필요 | — | drpPeriod3 연동 여부 확인 필요 |
| A37 | RequestPopup Load | `Form_Load` | FindData_Main | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | spdMain "Request Info" |
| A38 | RequestPopup Shown / FormClosing | `SSP0060_ShipmentPlanRequestPopup_Shown`, `SSP0060_ShipmentPlanRequestPopup_FormClosing` | 확인 필요 | — | — |
| A39 | RequestPopup 저장 | SaveButton / `usrButtonList1_UsrButtonList_Click_Detected` | SaveData > ChkEngProcessing | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | — |
| A40 | 〃 | 〃 | GetERPInterface | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE`, `SSP.SSP0060_GET_ERP_SO_NO_CNT`, `SSP.SSP0060_GET_SHIPMENT_STATUS` | 분기 판정 |
| A41 | 〃 | 〃 | SoNo / NonSoNo / GetErpIFCheckNew | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` | ERP IF 기록 |
| A42 | RequestPopup Auto Set | `btnAutoSet_Click` | 클라이언트 로직(확인 필요) | — | spdMain |
| A43 | RequestPopup spdMain | `spdMain_ClipboardPasted`, `spdMain_Change`, `spdMain_KeyDown` | 확인 필요 | — | spdMain |
| A44 | ConfirmDetailPopup Load / Find | `Form_Load`, FindButton | FindDataMain | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | txtRequestNo 외, spdMain |
| A45 | ConfirmDetailPopup 버튼바 | `btnButtonList_UsrButtonList_Click_Detected` | 확인 필요 | — | — |
| A46 | Request Info FCST Type 콤보 | 필드 초기화식 `<field:dtFcstType>` | LookupCommon SALES_TYPE_CODE | `biz:CommonData.CommonDataList` [LookupCommon] | FCST_TYPE 콤보 |
| A47 | (unreached) RequestPopup GetErpIFCheck | — | 진입점 없음 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 이관 여부 확인 필요 |
| A48 | (unreached) 메인 GetErpIFCheck / GetErpIFCheckNew_ / NewNonSoNo | — | 진입점 없음 | `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | 이관 여부 확인 필요 |

---

## 6. 검증·메시지

| # | 검증 | 위치 | 메시지 원문 |
|---|---|---|---|
| M1 | confirm_id 단위 비교: shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks | Validation_Check(3644~3786) | 확인 필요 |
| M2 | ERP IF Block: BLOCK_YN, PERIOD | chkERPIFBlockYn(3568/3577), 팝업 ChkERPIFBlockYn(756/765) | 확인 필요 |
| M3 | 계획 처리 중 확인 | ChkEngProcessing → `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 확인 필요 |
| M4 | 확정 변경 시각 확인 | ChkConfirmChangeTime → `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` / `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` | 확인 필요 |
| M5 | 출하 상태 확인 (Tables[0..2] CONFIRM_ID) | GetShipmentStatusChk → `SSP.SSP0060_GET_SHIPMENT_STATUS` | 확인 필요 |
| M6 | 필수 표시 `*`: Change Reason*, Reason Detail*(팝업과 Detail 시트), FCST Type*, From Site*, To Site*, Incoterms*, Model*, Shipment Qty*, Shipment Date*, Trans Mode*, Amend Qty*, End Date* | 라벨 | 코드 강제 여부와 메시지는 확인 필요 |
| M7 | ERP 결과 코드 result_code | GetErpIFCheck(unreached) | 확인 필요 |

---

## 7. 권한 (C/R/U/D 사실)

| 권한 | 사실 |
|---|---|
| R | FindButton(메인과 두 팝업). Detail 조회는 btnSearch와 spdMain 더블클릭 |
| C/U | SaveButton(메인: SaveData_Main/SaveData_Detail, RequestPopup: SaveData), usrButtonList1 |
| D | 전용 진입점 없음. `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`은 unreached. 저장 체인 안에서 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`이 DELETE SSP_ANL_SHIP_CONFIRM을 수행 |
| Edit | EditButton > `SSP.SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 외) |
| 데이터 범위 | `SSP.SSP0060_GET_SHIPMENT_DIVISION`이 TB_FX_USERGROUPAUTHEXTENTION 기준으로 Division/Site를 필터. NowGroupID와 Filter GROUP_ID/USER_ID 사용 |
| 메뉴 권한 값 | TB_FX_GroupMenuAuth 13행. 값은 **확인 필요** |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle 관점)

| # | 항목 | 전환 메모 |
|---|---|---|
| T1 | FpSpread → Wijmo FlexGrid | spdMain과 spdDetail(다중 시트 탭)은 FlexGrid + 탭 구성으로 바꿉니다. spdDetail 8개 시트(Hold stock Detail 귀속은 확인 필요)를 탭으로 전환합니다 |
| T2 | 동적 컬럼 | 날짜 컬럼(`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`)과 `EDIT_YN_*` 컬럼은 FE 동적 생성이 필요합니다. Plan Date와 Bucket이 바뀌면 재생성합니다 |
| T3 | 메타 컬럼 | SetSheetHeaderColumn이 읽는 메타(COLUMN_LABEL_NAME, VISIBLE_FLAG, VALID_YN, COLUMN_WIDTH, FIXED_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE 등)는 `ui-category-setup-column-meta` 기준으로 매핑합니다 |
| T4 | 버튼 | FindButton/SaveButton/EditButton → `menu-button-dynamic-fetch`. 화면 속성은 `ui-dynamic-property-management` |
| T5 | Request Info | HARDCODED 2단 헤더(Confirmed/Change)는 FlexGrid columnGroups로 옮깁니다. ELECTRODE_YN↔NEW_TO_CITY 헤더/필드 교차를 유지할지는 결정이 필요합니다 |
| T6 | 이벤트 일시 해제 | clbCompanyID → cboPlanDate 이벤트 해제와 재연결(7196/7200)은 React 상태 갱신 순서 제어(연쇄 호출 방지)로 바꿉니다 |
| T7 | Oracle 전환 | SP 내부의 STRING_SPLIT 참조(`SSP0060_GET_SHIPMENT_STATUS`, `SSP0060_GET_SHIPMENT_PLAN` 등), `#` 임시 테이블, 동적 SQL(`SSP0060_GET_SHIPMENT_PLAN`, `SSP0060_GET_SHIPMENT_PLAN_DETAIL`)은 Oracle 19c 문법으로 바꿔야 합니다(MSSQL 키워드 잔존 금지) |
| T8 | 미존재 엔드포인트 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`를 어떻게 대체할지 결정이 필요합니다 |
| T9 | 트랜잭션 | 저장 체인(확정 → ERP IF → 메일 → DM 동기화)을 하나의 트랜잭션으로 묶을지, 단계별 커밋을 유지할지 결정이 필요합니다 |
| T10 | 공통 콤보 | `biz:CommonData.CommonDataList`(LookupCommon / TransMode)를 공용 콤보 API로 바꿉니다 |

---

## 9. 미확정

1. splitContainer1의 Orientation, SplitterDistance, Size와 메인 영역 비율 %
2. 메인 LayoutControlItem Text(조회조건 라벨) 전체
3. usrLayoutControl1과 usrButton1의 parent와 배치
4. 시트별 Spread 귀속(특히 Hold stock Detail)과 더블클릭 셀별 조회 분기
5. RequestPopup Request Info 컬럼의 표시 여부, 폭, 정렬
6. 두 팝업을 메인에서 여는 지점과 파라미터
7. 각 핸들러 내부 처리(확인 필요로 표기한 액션 A2, A14, A22, A27, A32, A33, A35, A36, A38, A42, A43, A45)
8. 검증 메시지 원문 전체
9. TB_FX_GroupMenuAuth 권한 값과 메뉴 위치

=== FILE: unit_test.md ===
# SSP0060 단위테스트 — Shipment Plan

> **근거**: Fact Pack(SSP0060)과 업무분석서·화면설계서입니다. '근거' 열의 엔드포인트, SP, 핸들러, 시트 이름은 원문 그대로입니다.
> 절차 열의 컨트롤명은 화면설계서 §3과 같습니다. 주석 처리된 호출은 테스트 대상에서 제외했습니다.
> 기대결과의 구체 값이나 메시지가 Fact Pack에 없으면 "확인 필요"로 적었습니다. 이런 케이스는 AS-IS 실행 결과를 기준값으로 삼아 판정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0060-001 | 초기화 | 권한 있는 계정으로 로그인 | 메뉴에서 SSP0060을 엶 | – | clbDivision_ID에 권한 Division 목록이 채워짐(TB_FX_USERGROUPAUTHEXTENTION 필터) | `Form_Load` > SetChangedControl · `SSP.SSP0060_GET_SHIPMENT_DIVISION` · SP SSP0060_GET_SHIPMENT_DIVISION |
| TC-SSP0060-002 | 초기화 | 001과 같음 | 화면을 연 직후 cboBucketType 목록 확인 | – | Bucket Type 코드 목록 표시(SCM_ADM_LOOKUP_MASTER_DETAIL) | `Form_Load` > GetBucketType · `DM.DM0003_GET_BUCKET_TYPE_CODE` · SP DM0003_GET_BUCKET_TYPE_CODE |
| TC-SSP0060-003 | 초기화 | 001과 같음 | 화면을 연 직후 spdMain 헤더 확인 | – | 날짜 컬럼 헤더가 달력(SCM_SYS_CALENDAR_M) 기준으로 생성됨 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-004 | 초기화 | 001과 같음 | 화면을 연 직후 drpPeriod 값 확인 | – | dtShipmentInputPeriod 0·1행 VALUE/Diff_VALUE와의 연관 여부 확인(값은 확인 필요). FP_Log2 로그 기록 | `Form_Load` > InitControls |
| TC-SSP0060-005 | 초기화 | 001과 같음 | 화면 표시 완료 시점 확인 | – | Shown 처리 수행(내용 확인 필요) | `SSP0060_ShipmentPlan_Shown` |
| TC-SSP0060-006 | 조회 | 001 완료, clbCompany_ID·clbDivision_ID·cboPlanDate·cboBucketType 선택 | FindButton 클릭 | Division=권한 Division, Plan Date=현재 | spdMain에 Shipment Plan 13개 표시 컬럼(Div, From Site, To Site, Product Level1, Model, Nick Name, FCST Type, Incoterms, Transmode, BOH_TYPE, BOH_QTY, PSI, Measure)과 날짜 컬럼 표시. 숨김 5(FROM_SITE, MEASURE, BACK_COLOR, CONFIRM_DAY, LOT_YN) 비표시 | FindButton > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_PLAN` · SP SSP0060_GET_SHIPMENT_PLAN · 시트 Shipment Plan |
| TC-SSP0060-007 | 조회 | 006과 같음 | 데이터가 없는 조건으로 FindButton 클릭 | 존재하지 않는 txtItemId | 0행 표시, 오류 없음(빈 결과 메시지는 확인 필요) | `SSP.SSP0060_GET_SHIPMENT_PLAN` · 시트 Shipment Plan |
| TC-SSP0060-008 | 조회 | SP 오류를 유도할 수 있는 환경 | FindButton 클릭 | SP 예외 발생 | 오류 메시지 표시, 그리드 기존 데이터 처리 확인 필요 | `SSP.SSP0060_GET_SHIPMENT_PLAN` (오류 응답) |
| TC-SSP0060-009 | 조회 | 006 조회 완료 | btnSearch 클릭 (txtRequestor, txtModel2, drpPeriod2, drpPeriod3, clbResultType, txtBoxID, clbProductLevel12 입력) | 조회 조건 | spdDetail Shipment Plan Detail 44개 표시 / 27개 숨김 컬럼 | `BtnSearch_Click` > FindData_Detail · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` · SP SSP0060_GET_SHIPMENT_PLAN_DETAIL · 시트 Shipment Plan Detail |
| TC-SSP0060-010 | 조회 | 009와 같음 | btnSearch 후 Stock Location Detail 탭 확인 | – | 20개 컬럼(Company, Deffect Qty, Div, Model, Plant, Storage …) 표시 | `BtnSearch_Click` > FindData_Stock_Detail · `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` · SP SSP0060_GET_STOCK_LOCATION_DETAIL · 시트 Stock Location Detail |
| TC-SSP0060-011 | 조회 | 009와 같음 | btnSearch 후 oWMS Detail 탭 확인 | – | 25개 컬럼(Capa. Grade, Long-term Qty, Reciving Qty, Inventory Status …) 표시 | `BtnSearch_Click` > FindData_oWMS_Detail · `SSP.SSP0060_GET_OWMS_DETAIL` · SP SSP0060_GET_OWMS_DETAIL · 시트 oWMS Detail |
| TC-SSP0060-012 | 조회 | 009와 같음 | btnSearch 후 Shipment Result 탭 확인 | – | 16개 컬럼(Confirm/Plan ID, SO No, ETA, ETD, Shipment Qty, Status, Shipment Date …) 표시. 헤더 재구성 | `BtnSearch_Click` > FindData_Shipment_Result(5977, 6117) · `SSP.SSP0060_GET_SHIPMENT_RESULT` · SP SSP0060_GET_SHIPMENT_RESULT · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Result |
| TC-SSP0060-013 | 조회 | 009와 같음 | btnSearch 후 MES Stock 탭 확인 | – | 9개 컬럼(Model, Nick Name, TOTAL, AVAILABLE_STOCK, BEFORE_OQC, OQC_INSP_REQUEST, OQC_COMPLETE, OQC_NG, QMS/MES Hold) 표시 | `BtnSearch_Click` > FindData_MES_stock · `SSP.SSP0060_GET_MES_STOCK` · SP SSP0060_GET_MES_STOCK · 시트 MES Stock |
| TC-SSP0060-014 | 조회 | 009와 같음 | btnSearch 후 MES Stock Detail 탭 확인 | txtBoxID 입력 | 13개 컬럼(Model, Nick Name, Lot ID, Box ID, Available stock YN, Exp Insp Vaild Date …) 표시 | `BtnSearch_Click` > FindData_MES_stock_Detail · `SSP.SSP0060_GET_MES_STOCK_DETAIL` · SP SSP0060_GET_MES_STOCK_DETAIL · 시트 MES Stock Detail |
| TC-SSP0060-015 | 조회 | 006 조회 완료 | spdMain 데이터 셀 더블클릭 | 임의 행 | spdDetail 각 시트 조회. Hold stock 10개 표시 컬럼(Div, From Site, Model, NICK_NAME, Amend Qty*, Start Date, End Date*, REMARKS, LAST_UPDATED_BY, LAST_UPDATE_DATE). 더블클릭 셀별 분기는 확인 필요 | `SpdMain_CellDoubleClick` > FindData_hold_stock · `SSP.SSP0060_GET_HOLD_STOCK` · SP SSP0060_GET_HOLD_STOCK · 시트 Hold stock |
| TC-SSP0060-016 | 조회 | 015와 같음 | spdMain 더블클릭 후 Detail 조회 7종 호출 확인 | – | PLAN_DETAIL, STOCK_LOCATION_DETAIL, OWMS_DETAIL, SHIPMENT_RESULT, HOLD_STOCK, MES_STOCK, MES_STOCK_DETAIL 호출 | `SpdMain_CellDoubleClick` · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` · `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` · `SSP.SSP0060_GET_OWMS_DETAIL` · `SSP.SSP0060_GET_SHIPMENT_RESULT` · `SSP.SSP0060_GET_MES_STOCK` · `SSP.SSP0060_GET_MES_STOCK_DETAIL` |
| TC-SSP0060-017 | 그리드 | 015 완료 | Hold stock Detail 시트 표시 확인 | – | 10개 표시 컬럼(라벨에 `*` 없음: Amend Qty, End Date). 숨김 FROM_SITE, HOLD_ID. 생성 코드와 데이터 소스는 확인 필요 | 시트 Hold stock Detail (SCM_MST_SHEET_COLUMNS) |
| TC-SSP0060-018 | 조회 | 009와 같음 | 데이터가 없는 조건으로 btnSearch 클릭 | 존재하지 않는 txtModel2 | 모든 Detail 시트 0행, 오류 없음 | `BtnSearch_Click` · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` (빈 결과) |
| TC-SSP0060-019 | 저장 | 006 조회 완료, spdMain 수량 셀 수정 | SaveButton 클릭 | 날짜 셀 수량 변경 | SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE에 INSERT | SaveButton > SaveData_Main · `SSP.SSP0060_SAVE_SHIPMENT_PLAN` · SP SSP0060_SAVE_SHIPMENT_PLAN |
| TC-SSP0060-020 | 저장 | 009 조회 완료, Shipment Plan Detail 행 수정 | SaveButton 클릭 | Shipment Qty*, Shipment Date*, Trans Mode* 변경 | SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | SaveButton > SaveData_Detail · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` · SP SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM · 시트 Shipment Plan Detail |
| TC-SSP0060-021 | 저장 | 020과 같음 | 필수(*) 값을 비우고 SaveButton 클릭 | Shipment Qty* 빈값 | 저장 차단 여부와 메시지는 확인 필요(Validation_Check) | SaveData_Detail > Validation_Check · 시트 Shipment Plan Detail |
| TC-SSP0060-022 | 저장 | ERP IF Block 상태(BLOCK_YN) | SaveButton 클릭 | – | chkERPIFBlockYn 판정에 따라 저장 차단 여부 확인(메시지 확인 필요) | SaveData_Detail > chkERPIFBlockYn |
| TC-SSP0060-023 | 저장 | 020과 같음 | SaveButton 후 ERP 오류 확인 처리 검증 | – | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ(_DE) UPDATE | GetERPInterface(3990) · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0060-024 | 저장 | 020과 같음 | SaveButton 후 확정 기준 Drafting 삭제 처리 검증 | – | SSP_ANL_SHIP_CONFIRM DELETE/UPDATE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | GetERPInterface(4031) · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` · SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0060-025 | 저장 | SO 번호가 있는 확정 건 | SaveButton 클릭 | ERP_SO_NO 존재 행 | CNT 판정 후 SoNo 분기에서 Drafting 저장 | GetErpSoNoCnt · `SSP.SSP0060_GET_ERP_SO_NO_CNT` · SP SSP0060_GET_ERP_SO_NO_CNT · SoNo(4380) · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` · SP SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0060-026 | 저장 | SO 번호가 없는 확정 건 | SaveButton 클릭 | ERP_SO_NO 없음 | NonSoNo 분기에서 Drafting 저장(CNT 임계값은 확인 필요) | NonSoNo(4159) · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0060-027 | 저장 | 020과 같음 | SaveButton 후 출하 상태 확인 | – | Tables[0..2] CONFIRM_ID 확인. 해당 시 처리는 확인 필요 | GetShipmentStatusChk · `SSP.SSP0060_GET_SHIPMENT_STATUS` · SP SSP0060_GET_SHIPMENT_STATUS |
| TC-SSP0060-028 | 저장 | 025와 같음 | SoNo 분기 IF 체크 | – | DELETE_BY_CONFIRM(4657), CHG_BATCH(4683, 4713) 호출. XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | GetErpIFCheckNew · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` · SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| TC-SSP0060-029 | 저장 | 020과 같음 | 다른 사용자가 같은 건을 먼저 변경한 뒤 SaveButton 클릭 | 변경 시각 불일치 | 변경 시각 확인 결과에 따른 차단 여부 확인 필요 | ChkConfirmChangeTime(7962) · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` · SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| TC-SSP0060-030 | 저장 | 015 완료, Hold stock 행 수정 | SaveButton 클릭 | Amend Qty*, End Date* 변경 | 엔드포인트가 FoxQuery·DB에 없음(NOT_IN_FOXQUERY). AS-IS 실행 시 오류 여부 기록. TO-BE 처리 결정 필요 | SaveData_Detail(3460) · `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` · 시트 Hold stock |
| TC-SSP0060-031 | 저장 | 020 저장 성공 | 저장 후 화면 확인 | – | 메인, Detail, Hold stock 재조회 | SaveData_Detail > FindData_Main / FindData_Detail / FindData_hold_stock · `SSP.SSP0060_GET_SHIPMENT_PLAN` · `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` · `SSP.SSP0060_GET_HOLD_STOCK` |
| TC-SSP0060-032 | 저장 | 확정 SP 오류를 유도할 수 있는 환경 | SaveButton 클릭 | SP 예외 | 오류 메시지. 이후 ERP IF 단계 미진행 여부와 롤백 범위는 확인 필요 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` (오류 응답) |
| TC-SSP0060-033 | 초기화 | RequestPopup 호출(호출 지점 확인 필요) | 팝업을 엶 | 변경요청 대상 | spdMain에 Request Info 49개 컬럼(NEW_YN 포함) 구성 및 조회 | RequestPopup `Form_Load` > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` · SP SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING · 시트 Request Info |
| TC-SSP0060-034 | 초기화 | 033과 같음 | 팝업 표시 완료 시점 확인 | – | Shown 처리 수행(내용 확인 필요) | `SSP0060_ShipmentPlanRequestPopup_Shown` |
| TC-SSP0060-035 | 조회 | 033과 같음 | 대상이 없는 상태에서 FindButton 클릭 | 존재하지 않는 요청 | 0행, 오류 없음 | FindButton > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` (빈 결과) |
| TC-SSP0060-036 | 저장 | 033 조회 완료 | cboChangeReason, txtReasonDetail 입력 후 usrButtonList1 저장 클릭 | Change Reason*, Reason Detail* | 계획 처리 중 확인 후 확정 저장 | `usrButtonList1_UsrButtonList_Click_Detected` > SaveData > ChkEngProcessing · `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` · SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| TC-SSP0060-037 | 저장 | 036과 같음 | SaveButton 클릭 | – | 확정 저장(SSP_ANL_SHIP_CONFIRM, _H, XIF INSERT) | SaveButton > SaveData(584) · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` · 시트 Request Info |
| TC-SSP0060-038 | 저장 | 계획 처리 중 상태 | usrButtonList1 저장 클릭 | – | 저장 차단 여부와 메시지는 확인 필요 | ChkEngProcessing · `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| TC-SSP0060-039 | 저장 | 033과 같음 | cboChangeReason 미선택 상태로 저장 | Change Reason* 빈값 | 차단 여부와 메시지는 확인 필요 | RequestPopup SaveData · 시트 Request Info |
| TC-SSP0060-040 | 저장 | 037과 같음 | 저장 후 ERP 오류 확인과 삭제 처리 검증 | – | ERROR_CONFIRM(1044), DELETE_BY_CONFIRM(1072) 호출 | 팝업 GetERPInterface · `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0060-041 | 저장 | SO 번호가 있는 건 | 팝업 저장 | ERP_SO_NO 존재 | SoNo 분기: DRAFTING_MAIN(1181) 후 CHG_BATCH(1253) | 팝업 SoNo · `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` · SP SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| TC-SSP0060-042 | 저장 | SO 번호가 없는 건 | 팝업 저장 | ERP_SO_NO 없음 | NonSoNo 분기: DRAFTING_MAIN(1385) 후 CHG_BATCH_NEW_C(1408) | 팝업 NonSoNo · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` · SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C |
| TC-SSP0060-043 | 저장 | 041과 같음 | SoNo 분기 IF 체크 | – | DELETE_BY_CONFIRM(1525/1642), NEW_C(1551/1582), CHG_BATCH(1668/1699) 호출. 분기 조건은 확인 필요 | 팝업 GetErpIFCheckNew · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` · `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| TC-SSP0060-044 | 저장 | 037과 같음 | 다른 사용자가 먼저 변경한 뒤 팝업 저장 | 변경 시각 불일치 | 차단 여부 확인 필요 | 팝업 ChkConfirmChangeTime · `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` · SP SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE |
| TC-SSP0060-045 | 저장 | 037과 같음 | 팝업 저장 시 SO 건수와 상태 확인 | – | GET_ERP_SO_NO_CNT(1759), GET_SHIPMENT_STATUS(1784) 호출 | 팝업 GetErpSoNoCnt / GetShipmentStatusChk · `SSP.SSP0060_GET_ERP_SO_NO_CNT` · `SSP.SSP0060_GET_SHIPMENT_STATUS` |
| TC-SSP0060-046 | 저장 | unreached 이관이 결정된 경우에만 수행 | 정적 확인: 진입점 미연결 여부 | – | 현행 화면에서는 호출되지 않음(정적 분석). TO-BE 이관 시 별도 TC 작성 | RequestPopup GetErpIFCheck(842) · `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` · SP SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK |
| TC-SSP0060-047 | 저장 | 046과 같음 | 정적 확인: 진입점 미연결 여부 | – | 현행 화면에서는 호출되지 않음. TO-BE 이관 여부 결정 필요 | GetErpIFCheck(4579), GetErpIFCheckNew_(5042) · `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` · SP SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0060-048 | 이벤트 | 033 조회 완료 | btnAutoSet 클릭 | – | 클라이언트 자동 설정(대상 컬럼은 확인 필요), 엔드포인트 호출 없음 | `btnAutoSet_Click` |
| TC-SSP0060-049 | 이벤트 | 033 조회 완료 | 팝업 spdMain에 클립보드 붙여넣기 | 복수 셀 | 붙여넣기 처리(내용 확인 필요) | `spdMain_ClipboardPasted` (RequestPopup) |
| TC-SSP0060-050 | 이벤트 | 033 조회 완료 | 팝업 spdMain 셀 값 변경 | NEW_SHIPMENT_CONFIRM_QTY 변경 | 변경 처리(DIFF_QTY 연동 여부 확인 필요) | `spdMain_Change` (RequestPopup) · 시트 Request Info |
| TC-SSP0060-051 | 이벤트 | 033 / 006 완료 | 팝업 spdMain과 메인 spdMain에서 키 입력 | Ctrl/Delete 등 | KeyDown 처리(내용 확인 필요) | `spdMain_KeyDown` (RequestPopup Designer:280, 메인 Designer:910) |
| TC-SSP0060-052 | 이벤트 | 033과 같음 | 팝업 닫기 | – | FormClosing 처리(변경 확인 여부 확인 필요) | `SSP0060_ShipmentPlanRequestPopup_FormClosing` |
| TC-SSP0060-053 | 이벤트 | 006 완료 | 메인 spdMain에서 키를 눌렀다 뗌 | 임의 키 | KeyUp 처리(내용 확인 필요) | `spdMain_KeyUp` |
| TC-SSP0060-054 | 이벤트 | 006, 009 완료 | spdMain 세로 스크롤 | – | TopChange 처리(동기화 대상 확인 필요) | `SpdMain_TopChange` |
| TC-SSP0060-055 | 이벤트 | 009 완료 | spdDetail 세로 스크롤 | – | TopChange 처리 | `SpdDetail_TopChange` |
| TC-SSP0060-056 | 이벤트 | 001 완료 | cboBucketType 변경 | 다른 Bucket | 처리 결과 확인 필요(헤더 재구성 여부) | `cboBucketType_SelectedIndexChanged` · `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0060-057 | 이벤트 | 006 완료 | chkSum 체크/해제 | ON/OFF | 합계 표시 변화(CalculateSum/Set_SumValues 연관 확인 필요) | `chkSum_CheckedChanged` · 시트 Shipment Plan |
| TC-SSP0060-058 | 이벤트 | 006 완료 | chkTotPSI 체크/해제 | ON/OFF | 메인 즉시 재조회 | `chkTotPSI_CheckedChanged` > FindData_Main · `SSP.SSP0060_GET_SHIPMENT_PLAN` · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0060-059 | 이벤트 | 001 완료 | btnMeasure 클릭 후 Measure 선택 | 선택 Measure 6종 중 1 | Shipment Plan 시트 재구성(MEASURE 필수+기본 14 / 선택 6) | `BtnMeasure_Click` > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-060 | 이벤트 | 001 완료 | btnItemId 클릭 | – | 품목 선택 후 txtItemId 반영(팝업 종류 확인 필요) | `btnItemId_Click` |
| TC-SSP0060-061 | 이벤트 | 001 완료 | btnItemID2 클릭 | – | 품목 선택 후 txtModel2 반영 | `BtnItemID2_Click` |
| TC-SSP0060-062 | 이벤트 | 001 완료 | btnNew 클릭 | – | 처리 결과 확인 필요 | `BtnNew_Click` |
| TC-SSP0060-063 | 이벤트 | 001 완료 | btnRequestor 클릭 | – | 사용자 선택 후 txtRequestor 반영(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0060-064 | 이벤트 | 006 완료 | btnSimulation 클릭 | – | Container_Qty 기반 Simulation 결과 반영. 엔드포인트 없음 | `BtnSimulation_Click` · 시트 Shipment Plan |
| TC-SSP0060-065 | 이벤트 | 009 완료 | spdDetail 시트 탭 클릭 | Stock Location Detail 탭 | 탭 클릭 처리(재조회 여부 확인 필요) | `SpdDetail_SheetTabClick` · 시트 Stock Location Detail |
| TC-SSP0060-066 | 이벤트 | 009 완료 | 활성 시트를 oWMS Detail로 전환 | – | ActiveSheetChanged 처리 | `SpdDetail_ActiveSheetChanged` · 시트 oWMS Detail |
| TC-SSP0060-067 | 이벤트 | 009 완료 | Shipment Plan Detail에서 TRANSPORT_MODE 셀 클릭 | – | Trans Mode 콤보 목록 재조회(SCP_MST_BOD_V) | `SpdDetail_CellClick`(1987) · `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0060-068 | 이벤트 | 067과 같음 | 콤보에서 값 선택 | 다른 Trans Mode | ComboSelChange 처리(연동 컬럼 확인 필요) | `SpdDetail_ComboSelChange` · 시트 Shipment Plan Detail |
| TC-SSP0060-069 | 이벤트 | 009 완료 | spdDetail 셀 더블클릭 | 임의 셀 | 처리 결과 확인 필요(팝업 호출 여부) | `SpdDetail_CellDoubleClick` |
| TC-SSP0060-070 | 이벤트 | 009 완료 | Shipment Plan Detail 셀 편집 | From/To Site 등 | Trans Mode 목록 재조회(1380/1389) | `SpdDetail_EditChange` · `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0060-071 | 이벤트 | 009 완료 | spdDetail에 클립보드 붙여넣기 | 복수 행 | 붙여넣기 처리(c.CODE 사용) | `SpdDetail_ClipboardPasted` |
| TC-SSP0060-072 | 이벤트 | 006 완료 | spdMain 날짜 셀 값 변경 | 수량 변경 | 변경 처리(EditByChange QTY/NOEDIT_QTY 연관 확인 필요) | `SpdMain_Change` · 시트 Shipment Plan |
| TC-SSP0060-073 | 이벤트 | 006 완료 | spdMain에 클립보드 붙여넣기 | 복수 셀 | 붙여넣기 처리 | `SpdMain_ClipboardPasted` |
| TC-SSP0060-074 | 이벤트 | 001 완료 | drpPeriod2 값 변경 | 기간 변경 | ValueChanged 처리(drpPeriod3 연동 여부 확인 필요) | `DrpPeriod2_ValueChanged` |
| TC-SSP0060-075 | 이벤트 | 001 완료 | clbDivision_ID 변경 | 다른 Division | NERP 코드(SEGMENT2) 조회 | `clbDivision_ID_SelectedIndexChanged` > GetNERPCode · `SSP.SSP0002_GET_NERP_CODE` · SP SSP0002_GET_NERP_CODE |
| TC-SSP0060-076 | 이벤트 | 001 완료 | clbCompany_ID 변경 | 다른 Company | cboPlanDate 이벤트 해제 → 헤더 재구성 → 재연결. cboPlanDate 핸들러 중복 실행 없음 | `clbCompanyID_SelectedIndexChanged` > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0060-077 | 이벤트 | 001 완료 | cboPlanDate 변경 | 다른 Plan Date | FROM_DATE~TO_DATE1 기준으로 날짜 컬럼 재생성. EDIT_YN_* 컬럼 생성 | `cboPlanDate_SelectedIndexChanged` > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-078 | 이벤트 | 009 완료 | Detail 데이터셋(dsdm) 값 변경 | 셀 편집 | Changed 처리(내용 확인 필요) | `shtDetail_Change` |
| TC-SSP0060-079 | 권한 | 수정 권한이 있는 계정 / 없는 계정 | EditButton 클릭 | 계정 2종 | 사용자·그룹 권한 조회. 권한 없는 계정의 처리는 확인 필요 | EditButton > GetSSPUserCheck · `SSP.SSP0002_GET_USER_INFO_LIST` · SP SSP0002_GET_USER_INFO_LIST |
| TC-SSP0060-080 | 권한 | Division 권한이 다른 계정 2개 | 각 계정으로 화면을 엶 | 계정 A/B | clbDivision_ID 목록이 TB_FX_USERGROUPAUTHEXTENTION에 따라 다름 | `Form_Load` · `SSP.SSP0060_GET_SHIPMENT_DIVISION` |
| TC-SSP0060-081 | 권한 | TB_FX_GroupMenuAuth 13행 그룹별 계정 | FindButton / SaveButton / EditButton 노출 확인 | 그룹별 계정 | 그룹 권한값에 따라 버튼 노출(값 확인 필요) | FindButton · SaveButton · EditButton (TB_FX_GroupMenuAuth) |
| TC-SSP0060-082 | 그리드 | 033 조회 완료 | RequestPopup Request Info 헤더 확인 | – | 2단 헤더 `Confirmed`(LT_DAY~SHIPMENT_CONFIRM_QTY 6칸) / `Change`(NEW_LT_DAY~ 6칸), FCST Type 콤보(SALES_TYPE_CODE) | 시트 Request Info · `biz:CommonData.CommonDataList` [LookupCommon] (`<field:dtFcstType>`) |
| TC-SSP0060-083 | 초기화 | ConfirmDetailPopup 호출(지점 확인 필요) | 팝업을 엶 | 요청 번호 | txtRequestNo, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName(ReadOnly)과 usrLabel2 "Request Confirm Detail" 표시. spdMain Request Info 48컬럼(표시: Confirm/Plan ID, SO No, Project Name, FCST Type, Model, From/To Site, Incoterms, Confirmed 6, Change 6, Diff Qty, Change Reason, Reason Detail) | ConfirmDetailPopup `Form_Load` > FindDataMain(312) · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` · 시트 Request Info |
| TC-SSP0060-084 | 그리드 | 083과 같음 | 숨김 컬럼 ELECTRODE_YN과 NEW_TO_CITY 바인딩 확인 | – | 헤더 `NEW_TO_CITY`=필드 ELECTRODE_YN, 헤더 `ELECTRODE_YN`=필드 NEW_TO_CITY(원문 교차). TO-BE 처리 결정 필요 | 시트 Request Info (ConfirmDetailPopup 215/216, RequestPopup 240/241) |
| TC-SSP0060-085 | 이벤트 | 083과 같음 | btnButtonList 버튼 클릭 | 조회/닫기 등 | 처리 결과 확인 필요 | `btnButtonList_UsrButtonList_Click_Detected` |
| TC-SSP0060-086 | 조회 | 083과 같음 | 대상이 없는 요청 번호로 FindButton 클릭 | 없는 번호 | 텍스트박스 공백, 그리드 0행 | ConfirmDetailPopup FindButton > FindDataMain · `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` (빈 결과) |
| TC-SSP0060-087 | division | Div=40 계정 | FindButton → btnSearch → 각 Detail 탭 확인 | Div 40 | 시트별 표시 컬럼 수: Shipment Plan 13, Shipment Plan Detail 44, Stock Location Detail 20, oWMS Detail 25, Shipment Result 16, MES Stock 9, MES Stock Detail 13, Hold stock 10, Hold stock Detail 10 | `SSP.SSP0060_GET_SHIPMENT_PLAN` · 시트 Shipment Plan / Shipment Plan Detail (grid_rule 40) |
| TC-SSP0060-088 | division | Div=81 계정 | 087과 같음 | Div 81 | 087과 같은 컬럼 수(메타 차이 없음) | grid_rule 81 · `SSP.SSP0002_GET_NERP_CODE` |
| TC-SSP0060-089 | division | Div=81_HD 계정 | 087과 같음 | Div 81_HD | 087과 같음 | grid_rule 81_HD |
| TC-SSP0060-090 | division | Div=81_HG 계정 | 087과 같음 | Div 81_HG | 087과 같음 | grid_rule 81_HG |
| TC-SSP0060-091 | division | Div=81_HM 계정 | 087과 같음 | Div 81_HM | 087과 같음 | grid_rule 81_HM |
| TC-SSP0060-092 | division | Div=81_ST 계정 | 087과 같음 | Div 81_ST | 087과 같음 | grid_rule 81_ST |
| TC-SSP0060-093 | division | Div=81_UC 계정 | 087과 같음 | Div 81_UC | 087과 같음 | grid_rule 81_UC |
| TC-SSP0060-094 | division | Div=82 계정 | 087과 같음 | Div 82 | 087과 같음 | grid_rule 82 |
| TC-SSP0060-095 | division | Div=EE 계정 | 087과 같음 | Div EE | 087과 같음 | grid_rule EE |
| TC-SSP0060-096 | division | Div=EE_HD 계정 | 087과 같음 | Div EE_HD | 087과 같음 | grid_rule EE_HD |
| TC-SSP0060-097 | division | Div=EE_HG 계정 | 087과 같음 | Div EE_HG | 087과 같음 | grid_rule EE_HG |
| TC-SSP0060-098 | division | Div=EE_HM 계정 | 087과 같음 | Div EE_HM | 087과 같음 | grid_rule EE_HM |
| TC-SSP0060-099 | division | Div=EE_ST 계정 | 087과 같음 | Div EE_ST | 087과 같음 | grid_rule EE_ST |
| TC-SSP0060-100 | division | Div=EE_UC 계정 | 087과 같음 | Div EE_UC | 087과 같음 | grid_rule EE_UC |
| TC-SSP0060-101 | 그리드 | 006 완료 | Shipment Plan 날짜 컬럼과 EDIT_YN_* 컬럼 확인 | – | 날짜별 `EDIT_YN_{날짜}`(헤더 `E{라벨}`) 생성. 표시 여부 확인 필요 | SetSpreadColumn / InitSpreadDateColumn · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 Shipment Plan |
| TC-SSP0060-102 | 조회 | Detail SP 오류를 유도할 수 있는 환경 | btnSearch 클릭 | SP 예외 | 오류 메시지, 다른 시트 조회 계속 여부 확인 필요 | `BtnSearch_Click` · `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` (오류 응답) |

### 커버리지 점검
| 대상 | 총수 | 근거 열 등장 |
|---|---:|---|
| 이벤트 핸들러 | 38 | 38 (Form_Load 001/033/083, btnButtonList_UsrButtonList_Click_Detected 085, usrButtonList1_UsrButtonList_Click_Detected 036, btnAutoSet_Click 048, spdMain_ClipboardPasted 049, spdMain_Change 050, spdMain_KeyDown 051, SSP0060_ShipmentPlanRequestPopup_FormClosing 052, SSP0060_ShipmentPlanRequestPopup_Shown 034, spdMain_KeyUp 053, SSP0060_ShipmentPlan_Shown 005, SpdMain_TopChange 054, SpdDetail_TopChange 055, cboBucketType_SelectedIndexChanged 056, chkSum_CheckedChanged 057, chkTotPSI_CheckedChanged 058, BtnMeasure_Click 059, btnItemId_Click 060, BtnItemID2_Click 061, BtnSearch_Click 009, BtnNew_Click 062, BtnRequestor_Click 063, BtnSimulation_Click 064, SpdDetail_SheetTabClick 065, SpdDetail_ActiveSheetChanged 066, SpdDetail_CellClick 067, SpdDetail_ComboSelChange 068, SpdDetail_CellDoubleClick 069, SpdDetail_EditChange 070, SpdDetail_ClipboardPasted 071, SpdMain_CellDoubleClick 015, SpdMain_Change 072, DrpPeriod2_ValueChanged 074, SpdMain_ClipboardPasted 073, clbDivision_ID_SelectedIndexChanged 075, clbCompanyID_SelectedIndexChanged 076, cboPlanDate_SelectedIndexChanged 077, shtDetail_Change 078) |
| 엔드포인트 | 31 | 31 (`biz:CommonData.CommonDataList` 067/070/082, `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` 030, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` 046, `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` 047 등) |
| 시트 | 10 | 10 (Shipment Plan 006, Shipment Plan Detail 009, Stock Location Detail 010, oWMS Detail 011, Shipment Result 012, MES Stock 013, MES Stock Detail 014, Hold stock 015, Hold stock Detail 017, Request Info 033) |
| division | 14 | 14 (087~100) |
| 빈 결과 / 오류 응답 | – | 빈 결과 007, 018, 035, 086 / 오류 응답 008, 032, 102 |
