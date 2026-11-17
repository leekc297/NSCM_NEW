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
