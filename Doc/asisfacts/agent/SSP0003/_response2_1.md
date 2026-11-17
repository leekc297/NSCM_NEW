=== FILE: business_analysis.md ===
# SSP0003 Shipment Change Request Confirm — 업무분석서

> 근거: AsisFacts Fact Pack(SSP0003)과 1차 분석서(analysis.md, web_components.md, tobe_design.md). Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> 본문은 current 파일 `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.cs`(2095줄) 기준입니다. legacy 사본은 제외했습니다.
> 주석 처리된 호출 2건(줄 1209, 줄 1863)은 현행 기능이 아니므로 이 문서에서 다루지 않습니다.
> 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 근거 열과 같은 이름을 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0003 / `SSP0003_ShipmentChangeRequestConfirm` | Fact Pack §1 |
| 도메인 | SSP (`06.UIL\GSCM.SSP.Forms.UIL\Plan\`) | Fact Pack §1 |
| 업무 목적 | 선적 변경 요청(Change Request)을 조회합니다. 요청 상세를 확인한 뒤 승인(Approval), 반려(Reject), 자가 반려(Self Reject) 중 하나로 처리합니다. | 버튼 Text 원문 "Approval", "Reject", "Self Reject"와 SP 이름 `SSP0003_SAVE_SHIPMENT_REQUEST_*`·`SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| 범위(포함) | 조회조건 초기화(Division, From Site, Request Date), 변경 요청 목록 조회, 요청 상세(Drafting)와 위임자 조회, 승인·반려·자가 반려 저장, ERP IF 검사·오류 확정, 승인 후 재조회 | Fact Pack §2 기능 흐름 |
| 범위(제외) | 주석 처리된 호출 2건(줄 1209, 1863) | Fact Pack §9 |
| 업무 용어의 정확한 정의 | 'Self Reject'와 'Reject'의 업무상 차이, Change Type 코드 'P'의 의미 | **확인 필요** |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드) | 엔드포인트 | 결과 |
|---:|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` > InitControls(줄 317) | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | Division 목록(clbDivision)을 채웁니다. 이때 `UserInfoContext.Current.NowGroupID`를 사용합니다(InitControls:321). |
| S1-a | (화면 열기 계속) | `Form_Load` > InitControls > SetChangedControl(줄 369, 386) | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | From Site 목록(clbFromSite)을 채웁니다. 두 SP 중 어느 것을 쓰는지 정하는 조건은 **확인 필요**입니다. |
| S1-b | (화면 열기 계속) | `Form_Load` > InitControls > GetDayRange(줄 1864) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값을 계산합니다. drpPeriod(Request Date)에 바인딩된다는 내용은 1차 분석서 기준이며, 실제 바인딩은 **확인 필요**입니다. |
| S2 | Division 선택을 바꿉니다 | `ClbDivision_SelectedIndexChanged` > SetChangedControl | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | 선택한 Division 기준으로 From Site 목록을 다시 채웁니다. |
| S3 | 조회(프레임워크 FindButton)를 누릅니다 | FindButton > FindData_Main(줄 696) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 상단 시트 `Shipment Change Request Confirm`에 변경 요청 목록을 표시합니다. |
| S4 | 상단 그리드 행을 더블클릭합니다 | `SpdMain_CellDoubleClick` > FindData_Sub(줄 772) | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 하단 시트 `Shipment Change Request Confirm Detail`과 요청 정보 패널을 채웁니다. 패널은 SetChangeRequestInfo가 CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME을 읽어 채웁니다. |
| S4-a | (더블클릭 계속) | `SpdMain_CellDoubleClick` > Delegate_Load(줄 1834) | `SSP.SSP0003_GET_DELEGATEE_LOAD` | 위임자 정보를 조회합니다. 화면 어디에 반영하는지는 **확인 필요**입니다. |
| S5 | Approval 버튼을 누릅니다 | `BtnApproval_Click` > GetShipmentStatusChk(줄 1656) | `SSP.SSP0200_GET_SHIPMENT_STATUS` | 선적 상태를 검사합니다. 결과의 Tables[2] CONFIRM_ID를 사용합니다. |
| S5-a | | `BtnApproval_Click` > EngProcessingChk(줄 1619) | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 계획 처리 상태를 검사합니다. 읽는 테이블은 SCM_MST_PLAN·SCM_MST_PLAN_DETAIL입니다. |
| S5-b | | `BtnApproval_Click` > SaveDraftingData(줄 970) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | 상세(DE) 확정을 저장합니다. |
| S5-c | | `BtnApproval_Click` > SaveData(줄 1207) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 요청 확정을 저장합니다. 두 SP 중 하나를 고르는 조건은 **확인 필요**입니다. |
| S5-d | | `BtnApproval_Click` > GetErpIFCheck(줄 1337) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | ERP IF 검사 결과를 `result_code`로 받습니다. |
| S5-e | | `BtnApproval_Click` > GetErpIFCheckNew(줄 1409, 1458, 1492, 1541) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 신규 ERP IF 경로입니다. IF 검사, Drafting 삭제, ERP 오류 확정을 수행하며 `result_code`로 분기합니다(줄 1426). |
| S5-f | | `BtnApproval_Click` > SaveData > FindData_Main | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 처리 후 목록을 다시 조회합니다. |
| S6 | Reject 버튼을 누릅니다 | `BtnReject_Click` > SaveDraftingData / SaveData / GetErpIFCheck / FindData_Main | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 반려를 저장하고 목록을 다시 조회합니다. SaveData 호출 위치는 BtnReject_Click:1993입니다. |
| S7 | Self Reject 버튼을 누릅니다 | `BtnSelfReject_Click` > (S6과 같은 메서드 집합) | S6과 같음 | 자가 반려를 저장하고 목록을 다시 조회합니다. SaveData 호출 위치는 BtnSelfReject_Click:1921입니다. |
| S8 | 요청자 검색 버튼(btnRequestUser)을 누릅니다 | `BtnRequestUser_Click` | 추출된 엔드포인트 없음 | 동작은 **확인 필요**입니다(팝업 여부 포함). |
| S9 | 모델 검색 버튼(btnItemId)을 누릅니다 | `btnItemId_Click` | 추출된 엔드포인트 없음 | 동작은 **확인 필요**입니다. |
| S10 | 상단 그리드를 스크롤합니다 | `SpdMain_TopChange` | 추출된 엔드포인트 없음 | 동작은 **확인 필요**입니다. |
| S11 | (진입점 미연결) | SetChangedPeriod(줄 1573) | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | FROM_VALUE와 TO_VALUE를 읽습니다. 실제로 호출되는지는 **확인 필요**입니다. |

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (Form_Load)
    ├─ SSP.SSP0200_GET_SHIPMENT_DIVISION        → clbDivision
    ├─ SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION   ┐
    ├─ SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE ┘→ clbFromSite (선택 조건 확인 필요)
    └─ SCP.SCM0001_GET_SCP_DAY_PERIOD           → 기간 기본값 (drpPeriod 바인딩 확인 필요)
        │
[2] Division 변경 (ClbDivision_SelectedIndexChanged) → From Site 재조회 (위 Site SP 2종)
        │
[3] 조회 (FindButton > FindData_Main)
    └─ SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM → 시트 "Shipment Change Request Confirm"
        │
[4] 목록 행 더블클릭 (SpdMain_CellDoubleClick)
    ├─ SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING → 시트 "Shipment Change Request Confirm Detail" + 요청정보 패널
    └─ SSP.SSP0003_GET_DELEGATEE_LOAD                    → 위임자
        │
[5] 처리 버튼
    ├─ Approval (BtnApproval_Click)
    │    ├─ GetShipmentStatusChk : SSP.SSP0200_GET_SHIPMENT_STATUS
    │    ├─ EngProcessingChk     : SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK
    │    ├─ SaveDraftingData     : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM
    │    ├─ SaveData             : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM
    │    ├─ GetErpIFCheck        : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
    │    ├─ GetErpIFCheckNew     : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
    │    │                         SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
    │    │                         SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
    │    └─ FindData_Main 재조회 : SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM
    ├─ Reject (BtnReject_Click) / Self Reject (BtnSelfReject_Click)
    │    ├─ SaveDraftingData : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM
    │    ├─ SaveData         : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM
    │    ├─ GetErpIFCheck    : SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
    │    └─ FindData_Main 재조회
    └─ (위 단계들의 호출 순서와 단계별 성공·실패 분기는 Fact Pack에 없음 → 확인 필요)
```

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거 | 상태 |
|---:|---|---|---|
| R1 | 저장 SP는 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`과 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` 중 하나로 분기합니다. 두 후보가 같은 줄(1207)에서 추출됐습니다. | endpoints.csv SaveData:1207 | 분기 조건식은 **확인 필요**. SP 이름의 `_40`으로 보아 Division 40 분기로 추정되나 확인되지 않음 |
| R2 | `_40` SP만 `SSP_ANL_SHIP_PLAN_40`을 DELETE/INSERT하고 `DM_PLN_MKT_FCST_CONFIRM`을 INSERT합니다. 일반 SP만 `XIF_SCS_PACK_SHIP_PLAN_S_SN`과 `XIF_FP_SSP_SALES_EXFACTORY_S_SN`을 INSERT합니다. | endpoints.csv objects | 사실(EXEC 전이 객체 포함) |
| R3 | 상태 검사(`SSP0200_GET_SHIPMENT_STATUS`), 계획 처리 검사(`SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`), 신규 ERP IF 경로(GetErpIFCheckNew)는 Approval에서만 도달합니다. | flow.csv | 사실 |
| R4 | ERP IF 검사 결과는 `ds.Tables[0].Rows[0]["result_code"]`로 판정합니다. | Fact Pack §4 GetErpIFCheck, GetErpIFCheckNew | 판정 값과 분기 내용은 **확인 필요** |
| R5 | ERP IF 차단 여부를 `dtERPBlockYnIF.Rows[0]`의 BLOCK_YN, PERIOD로 판정합니다(chkERPIFBlockYn). | Fact Pack §4 | 데이터 출처와 호출 위치는 **확인 필요** |
| R6 | 상태 검사는 `SSP0200_GET_SHIPMENT_STATUS` 결과의 Tables[2] CONFIRM_ID를 행 단위로 읽습니다. | Fact Pack §4 GetShipmentStatusChk | 판정 기준은 **확인 필요** |
| R7 | 상세 그리드 0번 컬럼은 `p_status`가 E·O·R·S, D·A, P 중 어느 것도 아닐 때(else 분기) 숨겨집니다(`VisibleColumns(0, false)`). | grid_code FindData_Sub:827 | 다른 분기의 처리는 **확인 필요** |
| R8 | 상세 시트 `ERP_SO_NO`는 `_sChangeType == "P"`이면 숨기고, 그 외에는 표시합니다. 0행 그룹 헤더도 P이면 "Plan"/"Confirm", 그 외에는 "Confirmed"/"Change"입니다. | grid_code InitSpread:475, 503 / 1차 분석서 §5 | `_sChangeType` 값의 출처(cboChangeType 연계 여부)는 **확인 필요** |
| R9 | 필수값: 조회조건과 처리 버튼의 필수 입력 검증은 Fact Pack에 없습니다. 상세 시트 라벨 중 "Shipment Date*"(NEW_SHIPMENT_DATE)와 "Qty*"(NEW_SHIPMENT_CONFIRM_QTY)에 '*'가 있습니다. | grid_effective | 필수 검증 여부는 **확인 필요** |
| R10 | 날짜 규칙: 기간 기본값은 `SCM0001_GET_SCP_DAY_PERIOD`로 계산합니다. 이 SP는 SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, FN_WEEKOFDAY_DATE, FN_MULTY_TIME을 참조합니다. 진입점 미연결인 SetChangedPeriod는 CommonDataList PERIOD_*의 FROM_VALUE와 TO_VALUE를 읽습니다. | endpoints.csv, Fact Pack §4 | 버킷 단위와 기간 길이는 **확인 필요** |
| R11 | Division·Site 목록은 사용자 그룹(`NowGroupID`)과 `TB_FX_USERGROUPAUTHEXTENTION`으로 제한됩니다. | SSP0200_GET_SHIPMENT_DIVISION, SSP0200_GET_PLANT_SITE_BY_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE objects / InitControls:321 | 사실 |
| R12 | `SetChangeControl`(줄 227~264)은 `DataService.GetSSPInnerTable`을 7회 호출하고 GROUP_ID와 USER_ID로 필터합니다. | Fact Pack §4, §4-2 | 바인딩 대상 컨트롤은 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기)

> 객체 목록은 SP 내부 EXEC 전이를 포함합니다. 직접 접근인지 하위 SP를 통한 전이 접근인지는 구분되어 있지 않습니다(**확인 필요**). `#` 접두 객체는 임시 테이블, `A`는 별칭입니다.

| # | 엔드포인트 | SP | 읽기 | 쓰기 | 호출 EXEC |
|---:|---|---|---|---|---|
| 1 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | `SSP0200_GET_SHIPMENT_DIVISION` | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE | — | — |
| 2 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | FoxQuery 미등록(NOT_IN_FOXQUERY). DB 객체(P) `SSP0200_GET_PLANT_SITE_BY_DIVISION`는 존재 | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (REF STRING_SPLIT) | — | — |
| 3 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | FoxQuery 미등록(NOT_IN_FOXQUERY). DB 객체(P) `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`는 존재 | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (REF STRING_SPLIT) | — | — |
| 4 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN (REF FN_GET_ITEM_NICKNAME, STRING_SPLIT) | — | — |
| 5 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | `SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER (REF FN_GET_PROJECT_NAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO) | — | — |
| 6 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE A, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 7 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SSP_ANL_SHIP_PLAN_40, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM, SSP_MST_SITE_ITEM_EE_V, SCP_MST_BOD_N_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, DM_PLN_MKT_FCST_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, DELETE/INSERT SSP_ANL_SHIP_PLAN_40, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT DM_PLN_MKT_FCST_CONFIRM, INSERT SCM_SYS_LOG_BATCH, DELETE/UPDATE A, 임시 #TBLDYNAMIC_SSP0003_40_STD, #TBLSSPAPPROVEDMAILSEND, #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TEMP_SHIP_RESULT | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, PR_DM_SSP_CONFIRM_SYNC, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 8 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM, SSP_MST_SITE_ITEM_EE_V, SSP_MST_MODEL_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_PROJECT, NERP_CONV_MASTER, SCP_PLN_INTERFACE_SEND_H, SSP_ANL_SHIP_REQ_EE, DM_PLN_SHIPMENT_REQ, SCP_MST_FINAL_ITEM | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT XIF_FP_SSP_SALES_EXFACTORY_S_SN, INSERT SCM_SYS_LOG_BATCH, 임시 #TBLSSPAPPROVEDMAILSEND, #TBLSSPAPPROVEDMAILSEND2, #TMP_XIF_FP_SSP_SALES_EXFACTROY | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, SCM_SSP_MODEL_USER_MAIL_SEND, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_DM_SSP_CONFIRM_SYNC, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SCP_SYS_LOG_BATCH |
| 9 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` (호출 3곳: 1337, 1409, 1492) | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT/UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE, PR_SCP_SYS_LOG_BATCH |
| 10 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH, 임시 #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 11 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 12 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 없음(BIZ_MATCH, Data.CallBizCommonData 경유) | **확인 필요** (결과 컬럼은 FROM_VALUE, TO_VALUE) | — | — |
| 13 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | — | — |
| 14 | `SSP.SSP0200_GET_SHIPMENT_STATUS` | `SSP0200_GET_SHIPMENT_STATUS` | SSP_ANL_SHIP_CONFIRM (REF STRING_SPLIT) | — | — |
| 15 | `SSP.SSP0003_GET_DELEGATEE_LOAD` | `SSP0003_GET_DELEGATEE_LOAD` | SSP_MST_DELEGATE, TB_FX_USER | — | — |
| 16 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `SCM0001_GET_SCP_DAY_PERIOD` | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE(CTE) (REF FN_MULTY_TIME, FN_WEEKOFDAY_DATE) | — | — |

SP 13개 대조: `SSP0200_GET_SHIPMENT_DIVISION`, `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP0200_GET_SHIPMENT_STATUS`, `SSP0003_GET_DELEGATEE_LOAD`, `SCM0001_GET_SCP_DAY_PERIOD`. FoxQuery에 매핑되지 않은 2종(`SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`)은 DB 객체로만 확인됐습니다.

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Grid(Division) | 표시 컬럼 수는 모든 Division(40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC)에서 같습니다. 상단 19개, 상세 29개입니다. 상세의 ?1은 ERP_SO_NO로, 런타임 `_sChangeType`에 따라 표시 여부가 정해집니다. | Fact Pack §10, §12 |
| 저장(Division 추정) | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`과 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`로 분기합니다. `_40` SP는 SSP_ANL_SHIP_PLAN_40과 DM_PLN_MKT_FCST_CONFIRM에 씁니다. | endpoints.csv |
| 분기 조건 | 분기가 Division 40 여부로 결정되는지는 **확인 필요**입니다. | Fact Pack에 조건식 없음 |
| 권한 — 데이터 범위 | Division·Site 목록은 `NowGroupID`와 TB_FX_USERGROUPAUTHEXTENTION으로 제한됩니다. | R11 |
| 권한 — 메뉴 | TB_FX_GroupMenuAuth 15행, TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행이 있습니다. C/R/U/D 플래그 값은 **확인 필요**입니다. | Fact Pack §8 |
| 권한 — 위임 | 위임자는 SSP_MST_DELEGATE에서 조회합니다(`SSP0003_GET_DELEGATEE_LOAD`). 목록 SP(`SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`)도 SSP_MST_DELEGATE를 참조합니다. 위임자가 승인할 수 있는지 판정하는 규칙은 **확인 필요**입니다. | endpoints.csv |
| 버튼 활성화 | Approval, Reject, Self Reject의 권한별 활성화 조건은 **확인 필요**입니다. | Fact Pack에 없음 |

## 7. 외부 인터페이스 (사실에 나타난 것만)

| 대상 객체 | 접근 | 관련 엔드포인트 | 비고 |
|---|---|---|---|
| XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | INSERT/UPDATE/SELECT | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 이름상 ERP 선적계획 확정 IF 테이블입니다. 수신 시스템과 전송 방식은 **확인 필요**입니다. |
| XIF_SCS_PACK_SHIP_PLAN_S_SN | INSERT | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 수신 시스템은 **확인 필요**입니다. |
| XIF_FP_SSP_SALES_EXFACTORY_S_SN | INSERT | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 수신 시스템은 **확인 필요**입니다. |
| NERP_CONV_MASTER | SELECT | DE_CONFIRM, CONFIRM, IF_CHECK | 변환 마스터입니다. |
| SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | ERP 오류 확정 이력입니다. |
| 메일 발송 (SCM_SSP_MAIL_SEND, SCM_ADM_MAIL_SEND, SCM_SSP_MODEL_USER_MAIL_SEND) | EXEC | CONFIRM_40, CONFIRM | 수신자는 SCM_ADM_RECIPIENT_*에서 읽습니다. 발송 조건은 **확인 필요**입니다. |

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| 1 | 줄 1207에서 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`과 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` 중 하나를 고르는 조건 | 같은 줄에서 후보 2개 추출 |
| 2 | 버튼별 메서드 호출 순서와 단계별 성공·실패 분기(`result_code`, 줄 1349·1426) | Fact Pack 미포함 |
| 3 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`과 `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`의 FoxQuery 미등록 처리 방식과 둘 중 선택 조건 | NOT_IN_FOXQUERY |
| 4 | `biz:CommonData.CommonDataList`(SetChangedPeriod)가 실제로 호출되는지 | 진입점 미연결 |
| 5 | chkERPIFBlockYn의 데이터 출처(BLOCK_YN, PERIOD) | 엔드포인트 미추출 |
| 6 | `BtnRequestUser_Click`, `btnItemId_Click`, `SpdMain_TopChange`의 동작 | 엔드포인트 미추출 |
| 7 | Fact Pack §4-2가 `SaveData`를 PersonalSettingPopup.SaveData로 매핑한 부분. 화면 자체에 SaveData(줄 1207)가 있어 파서가 잘못 매핑했을 가능성이 있습니다. | Fact Pack §4-2 |
| 8 | cboStatus·cboChangeType 항목의 출처와 `_sChangeType`과의 연계 | Fact Pack 미포함 |
| 9 | C/R/U/D 권한 플래그와 버튼 활성화 조건 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv 원문 확인 필요 |
| 10 | 데이터 흐름 표 객체의 직접·전이 접근 구분 | EXEC 전이 포함 목록 |
| 11 | 메뉴 위치 | TB_FX_MenuItemInfo 4행 원문 확인 필요 |

=== FILE: screen_design.md ===
# SSP0003 Shipment Change Request Confirm — 화면설계서

> 근거: AsisFacts Fact Pack(SSP0003)의 controls.csv, props.csv(일부 잘림), events.csv, grid_effective.csv, grid_code, 그리고 1차 분석서. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5, 단위테스트 근거 열과 같습니다. §3 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0003 |
| 화면 명칭 | Shipment Change Request Confirm (클래스 `SSP0003_ShipmentChangeRequestConfirm`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행 원문 확인) |
| 소스 | `...\SSP0003_ShipmentChangeRequestConfirm.cs`(2095줄), `.Designer.cs`(1318줄) |
| 시트 | `Shipment Change Request Confirm`(상단 마스터, 헤더 1행), `Shipment Change Request Confirm Detail`(하단 상세, 헤더 2행) |
| Grid 구성 방식 | META(프레임워크) (+코드 표시/라벨 변경). SetSheetHeaderColumn@InitSpread:431, 439 |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv의 SplitContainer와 controls.csv의 parent 체인)

| 노드 | parent | Dock | Orientation | Size | SplitterDistance | 근거 줄 |
|---|---|---|---|---|---|---|
| splitContainer1 | this | Fill | Horizontal (상/하) | 1192×649 | 259 | Designer 146·150·162·163 |
| usrConditionPanel1 | splitContainer1.Panel1 | Top | — | 1192×67 (HidePanel) | — | 220·223·225 |
| usrLayoutControl1 | usrConditionPanel1 | Fill | — | 1192×67 | — | 242·247 |
| spdMain | splitContainer1.Panel1 | Fill | — | 1192×192 | — | 169·174 |
| panel1 | splitContainer1.Panel2 | Top | — | 1192×209 | — | 877·880 |
| usrLayoutControl3 | panel1 | Fill | — | 1192×209 | — | 896·900 |
| splitter1 | splitContainer1.Panel2 | Top | — | 1192×3 | — | 867·870 |
| txtApprovalDeptName (FpSpread) | splitContainer1.Panel2 | Fill | — | 1192×174 | — | 817·822 |

비율 계산:
- splitContainer1(높이 649): Panel1은 259px로 39.9%입니다. Panel2는 649−259=390px로 60.1%이며, 여기서 분할선 폭을 뺀 값입니다. SplitterWidth 원문은 props.csv에 없습니다. Panel2 자식 높이 합(209+3+174)이 386이므로 분할선은 4px로 계산되지만, 원문 값은 **확인 필요**입니다.
- Panel1(259): usrConditionPanel1 67px(25.9%), spdMain 192px(74.1%)
- Panel2(386 기준): panel1 209px(54.1%), splitter1 3px(0.8%), txtApprovalDeptName 174px(45.1%)
- 좌/우 분할은 없습니다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────── SSP0003 (1192 × 649) ───────────────────────────────┐
│ splitContainer1 · Horizontal · SplitterDistance 259                                  │
│ ┌─ Panel1 (259px, 39.9%) ───────────────────────────────────────────────────────────┐│
│ │ [조회조건] usrConditionPanel1 (Top 67px, HidePanel) > usrLayoutControl1           ││
│ │  Division[clbDivision]  From Site[clbFromSite]  Request Date[drpPeriod]           ││
│ │  Status[cboStatus]  Change Type[cboChangeType]                                    ││
│ │  (Requestor)[txtRequest][btnRequestUser]  (Model)[txtItemID][btnItemId]           ││
│ │  [버튼] [Approval btnApproval] [Reject btnReject] [Self Reject btnSelfReject]     ││
│ │  ※ 항목별 좌표·행 배치는 props.csv 잘림 → 확인 필요 (layoutControlGroup1 1192×73) ││
│ ├───────────────────────────────────────────────────────────────────────────────────┤│
│ │ [그리드] spdMain / spdMain_Sheet1  (Fill 192px)                                   ││
│ │   시트 "Shipment Change Request Confirm" (헤더 1행, 표시 19)                      ││
│ └───────────────────────────────────────────────────────────────────────────────────┘│
│ ══════════════ 분할선 (SplitterWidth 확인 필요, 계산상 4px) ══════════════            │
│ ┌─ Panel2 (≈386px, 60.1%) ──────────────────────────────────────────────────────────┐│
│ │ [요청 정보] panel1 (Top 209px) > usrLayoutControl3                                ││
│ │  txtRequestNo · txtTitle · txtRequestor · txtRequestDeptName · txtApproval        ││
│ │  txtAppDeptName · txtChangeReason · txtReasonDetail · usrLabel2 · txtRejectReason ││
│ ├─ splitter1 (Top 3px) ─────────────────────────────────────────────────────────────┤│
│ │ [그리드] txtApprovalDeptName / txtApprovalDeptName_Sheet1 (Fill 174px)            ││
│ │   시트 "Shipment Change Request Confirm Detail" (헤더 2행, 표시 29 ?1)            ││
│ └───────────────────────────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────────────────────┘
[팝업] btnRequestUser / btnItemId의 팝업 여부는 확인 필요
```

## 3. 컨트롤 명세

> 라벨은 props.csv의 Text 원문입니다(LayoutControlItem.Text 또는 컨트롤 Text). props.csv가 잘려 원문을 볼 수 없으면 **확인 필요**로 표시했습니다.

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | — (UsrPanelType=HidePanel) | — | — | — | 조회조건 패널(접기 가능) |
| 2 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" (컨트롤 Text) | — | — | — | 조회조건 레이아웃 |
| 3 | clbDivision | UsrCheckedList | "Division" (lcDivision) | `SSP.SSP0200_GET_SHIPMENT_DIVISION` 결과. 기본 선택은 **확인 필요** | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | 다중 선택 콤보(Wijmo MultiSelect 계열) |
| 4 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | Site SP 2종 결과 | 확인 필요 | — | 다중 선택 콤보 |
| 5 | drpPeriod | UsrDateRangePicker | "Request Date" (layoutControlItem1) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 기반(바인딩 확인 필요) | 확인 필요 | — | 기간(From~To) 날짜 입력 |
| 6 | cboStatus | UsrCombo | "Status" (PlanType) | 확인 필요 | 확인 필요 | — | 단일 선택 콤보 |
| 7 | cboChangeType | UsrCombo | "Change Type" (PlanType1) | 확인 필요 | 확인 필요 | — | 단일 선택 콤보 |
| 8 | txtRequest | UsrMultiLineEditor | 확인 필요 (LayoutItem 이름은 Requestor, Text 잘림) | 확인 필요 | 확인 필요 | — | 텍스트 입력 + 검색 버튼 |
| 9 | btnRequestUser | UsrButton | "layoutControlItem2" (layoutControlItem13 Text, 표시 여부 확인 필요) | — | — | Click → `BtnRequestUser_Click` | 검색 버튼(팝업 여부 확인 필요) |
| 10 | txtItemID | UsrMultiLineEditor | 확인 필요 (LayoutItem 이름은 Model) | 확인 필요 | 확인 필요 | — | 텍스트 입력 + 검색 버튼 |
| 11 | btnItemId | UsrButton | 확인 필요 (layoutControlItem2 Text 잘림) | — | — | Click → `btnItemId_Click` | 검색 버튼(팝업 여부 확인 필요) |
| 12 | btnApproval | SimpleButton | "Approval" (LayoutItem lcBtnApproval Text "layoutControlItem10") | — | — | Click → `BtnApproval_Click` | 액션 버튼 |
| 13 | btnReject | SimpleButton | "Reject" (LayoutItem lcBtnReject Text "layoutControlItem10") | — | — | Click → `BtnReject_Click` | 액션 버튼 |
| 14 | btnSelfReject | SimpleButton | "Self Reject" (LayoutItem lcSelfReject Text "layoutControlItem10") | — | — | Click → `BtnSelfReject_Click` | 액션 버튼 |
| 15 | spdMain | FpSpread | — | 빈 그리드 | — | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid(마스터) |
| 16 | spdMain_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm` | 메타 22행 | — | — | FlexGrid 컬럼 정의 |
| 17 | usrLayoutControl3 | UsrLayoutControl | "usrLayoutControl3" (컨트롤 Text) | — | — | — | 요청 정보 폼 레이아웃 |
| 18 | txtRequestNo | TextBox | 확인 필요 | 더블클릭 시 채움(CHANGE_REQ_NO로 추정, 1:1 대응 확인 필요) | — | — | 읽기 전용 입력(ReadOnly=true) |
| 19 | txtTitle | TextBox | 확인 필요 (LayoutItem lcTitle/lcTitle1) | 위와 같음 | — | — | 읽기 전용 입력(ReadOnly=true) |
| 20 | txtRequestor | TextBox | 확인 필요 | 위와 같음 | — | — | 읽기 전용 입력(ReadOnly=true) |
| 21 | txtRequestDeptName | TextBox | 확인 필요 | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 22 | txtApproval | TextBox | 확인 필요 (LayoutItem lcApproval) | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 23 | txtAppDeptName | TextBox | 확인 필요 | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 24 | txtChangeReason | TextBox | 확인 필요 | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 25 | txtReasonDetail | TextBox | 확인 필요 (LayoutItem lcReasonDetail) | 위와 같음 | — | — | 입력(ReadOnly 확인 필요) |
| 26 | txtRejectReason | TextBox | 확인 필요 | 확인 필요 | 확인 필요 | — | 반려 사유 입력 후보(편집 여부 확인 필요) |
| 27 | usrLabel2 | UsrLabel | 확인 필요 | — | — | — | 라벨 |
| 28 | txtApprovalDeptName | FpSpread (이름은 TextBox처럼 보이지만 Spread) | — | 빈 그리드 | — | — | Wijmo FlexGrid(상세, 헤더 2행) |
| 29 | txtApprovalDeptName_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm Detail` | 메타 54행 | — | — | FlexGrid 컬럼 정의 |

## 4. 그리드 명세

> 타입(CELL_CONTROL_OBJECT_TYPE_CODE)과 편집 가능 여부는 Fact Pack에 컬럼별 값이 없어 **확인 필요**입니다. 예외는 코드로 지정된 CHK(CheckBox)입니다. 아래 표의 순서는 표시 순서가 아닙니다. 실제 순서는 메타 SCM_MST_SHEET_COLUMNS 기준으로 확인해야 합니다.

### 4-1. `Shipment Change Request Confirm` (spdMain, 메타 22행, 표시 19, 헤더 1행)

| 컬럼 | 헤더 | 타입 | 출처 | Division별 표시(40/81계열/82/EE계열) | 편집 |
|---|---|---|---|---|---|
| CHANGE_REQ_NO | Request No | 확인 필요 | META | 기본(전 Division) | 확인 필요 |
| REQUEST_TITLE | Title | 확인 필요 | META | 기본 | 확인 필요 |
| CHANGE_TYPE | Change Type | 확인 필요 | META | 기본 | 확인 필요 |
| SHIPMENT_STATUS | Status | 확인 필요 | META | 기본 | 확인 필요 |
| DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| FROM_SITE | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| TO_SITE | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 기본 | 확인 필요 |
| REJECT_REASON | Reject Reason | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_USER_NAME | Requestor | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_DEPT | Requestor Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_TIME | Request Date | 확인 필요 | META | 기본 | 확인 필요 |
| APPROVAL_USER_NAME | Approval | 확인 필요 | META | 기본 | 확인 필요 |
| APPROVAL_DEPT | Approval Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| APPROVAL_TIME | Approval Date | 확인 필요 | META | 기본 | 확인 필요 |
| DELEGATEE_USER_NAME | Delegatee | 확인 필요 | META | 기본 | 확인 필요 |
| DELEGATEE_DEPT | Delegatee Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| REQUEST_USER | Requestor | 확인 필요 | META | 숨김 | — |
| APPROVAL_USER | Approval | 확인 필요 | META | 숨김 | — |
| DELEGATEE_USER | Delegatee | 확인 필요 | META | 숨김 | — |
| ERP_SO_NO | (라벨 없음) | — | CODE_ONLY_CHANGE | 파서가 이 시트에 귀속시켰지만 코드 조건은 Detail 시트입니다(**확인 필요**). | — |

### 4-2. `Shipment Change Request Confirm Detail` (txtApprovalDeptName, 메타 54행, 표시 29 ?1, 헤더 2행)

| 컬럼 | 헤더(1행) | 0행 그룹 헤더 | 타입 | 출처 | Division별 표시 | 편집 |
|---|---|---|---|---|---|---|
| CHK | ALL | — | CheckBox(Value=true, Border=bevelbrdr) | META + 코드(InitSpread:447~449) | 기본 | 체크 가능 여부는 확인 필요 |
| CONFIRM_ID | Confirm ID | — | 확인 필요 | META | 기본 | 확인 필요 |
| ERP_SO_NO | SO No | — | 확인 필요 | META + 코드(475 숨김 / 503 표시) | `_sChangeType=="P"`이면 숨김, 그 외 표시(?) | 확인 필요 |
| FCST_TYPE | FCST Type | — | 확인 필요 | META | 기본 | 확인 필요 |
| PROJECT_NAME | Project Name | — | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | — | 확인 필요 | META | 기본 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| INCOTERMS | Incoterms | — | 확인 필요 | META | 기본 | 확인 필요 |
| LT_DAY | L/T(Day) | P: "Plan" / 그 외: "Confirmed" (6열 span 시작) | 확인 필요 | META + 코드 | 기본 | 확인 필요 |
| ETD | ETD | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| ETA | ETA | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Qty | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_LT_DAY | L/T(Day) | P: "Confirm" / 그 외: "Change" (6열 span 시작) | 확인 필요 | META + 코드 | 기본 | 확인 필요 |
| NEW_ETD | ETD | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_ETA | ETA | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요 |
| NEW_SHIPMENT_DATE | Shipment Date* | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요('*' 표기) |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 위 그룹 | 확인 필요 | META | 기본 | 확인 필요('*' 표기) |
| ERP_ATTR1 | Consignee Name | — | 확인 필요 | META | 기본 | 확인 필요 |
| ERP_ATTR2 | Contact Point | — | 확인 필요 | META | 기본 | 확인 필요 |
| ERP_ATTR3 | Lot | — | 확인 필요 | META | 기본 | 확인 필요 |
| REMARKS | Remarks | — | 확인 필요 | META | 기본 | 확인 필요 |
| REMARKS2 | Building | — | 확인 필요 | META | 기본 | 확인 필요 |
| REMARKS3 | Customer requirement | — | 확인 필요 | META | 기본 | 확인 필요 |
| STATUS_DETAIL | Status Detail | — | 확인 필요 | META | 기본 | 확인 필요 |
| REJECT_REASON | Reject Reason | — | 확인 필요 | META | 기본 | 확인 필요 |

숨김 컬럼 25개(META, 전 Division 숨김): A_COUNTRY, A_PORT_CODE, BOD_ID, CHANGE_REQ_NO, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE.

추가 코드 규칙: FindData_Sub:827에서 `p_status`가 E·O·R·S, D·A, P가 모두 아닌 경우 `VisibleColumns(0, false)`로 0번 컬럼을 숨깁니다.

Division 요약: 40, 81 계열, 82, EE 계열 모두 상단 19개, 상세 29개(?1)로 같습니다.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드 | `Form_Load` | InitControls(317) | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | clbDivision |
| A2 | 화면 로드 | `Form_Load` | InitControls > SetChangedControl(369/386) | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | clbFromSite |
| A3 | 화면 로드 | `Form_Load` | InitControls > GetDayRange(1864) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값(drpPeriod 바인딩 확인 필요) |
| A4 | clbDivision 선택 변경 | `ClbDivision_SelectedIndexChanged` | SetChangedControl(354 GetCheckedListValue, 369, 386) | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | clbFromSite 재구성 |
| A5 | 조회(프레임워크 FindButton) | FindButton | FindData_Main(675~685 조건 수집, 696 호출) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | spdMain 시트 `Shipment Change Request Confirm` |
| A6 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Sub(772), SetChangeRequestInfo | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | txtApprovalDeptName 시트 `Shipment Change Request Confirm Detail`, usrLayoutControl3의 TextBox들 |
| A7 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | Delegate_Load(1834) | `SSP.SSP0003_GET_DELEGATEE_LOAD` | 반영 위치 확인 필요 |
| A8 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A9 | btnApproval | `BtnApproval_Click` | GetShipmentStatusChk(1656) | `SSP.SSP0200_GET_SHIPMENT_STATUS` | 상태 검사(Tables[2] CONFIRM_ID) |
| A10 | btnApproval | `BtnApproval_Click` | EngProcessingChk(1619) | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 계획 처리 검사 |
| A11 | btnApproval | `BtnApproval_Click` | SaveDraftingData(970) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | 상세 확정 저장 |
| A12 | btnApproval | `BtnApproval_Click` | SaveData(1207; 호출 2029·2061·2063) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 요청 확정 저장(분기 조건 확인 필요) |
| A13 | btnApproval | `BtnApproval_Click` | GetErpIFCheck(1337) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | result_code 판정 |
| A14 | btnApproval | `BtnApproval_Click` | GetErpIFCheckNew(1409, 1492) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | result_code 판정(1426) |
| A15 | btnApproval | `BtnApproval_Click` | GetErpIFCheckNew(1458) | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | Drafting 삭제 |
| A16 | btnApproval | `BtnApproval_Click` | GetErpIFCheckNew(1541) | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | ERP 오류 확정 |
| A17 | btnApproval | `BtnApproval_Click` | SaveData > FindData_Main(696) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | spdMain 재조회 |
| A18 | btnReject | `BtnReject_Click` | SaveDraftingData → SaveData(1993) → GetErpIFCheck → FindData_Main (순서 확인 필요) | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 반려 저장 후 재조회 |
| A19 | btnSelfReject | `BtnSelfReject_Click` | SaveDraftingData → SaveData(1921) → GetErpIFCheck → FindData_Main (순서 확인 필요) | A18과 같음 | 자가 반려 저장 후 재조회 |
| A20 | btnRequestUser | `BtnRequestUser_Click` | 확인 필요 | 없음 | 확인 필요(txtRequest 반영 여부) |
| A21 | btnItemId | `btnItemId_Click` | 확인 필요 | 없음 | 확인 필요(txtItemID 반영 여부) |
| A22 | (진입점 미연결) | SetChangedPeriod(1573) | FROM_VALUE, TO_VALUE 읽음 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 실제 호출 여부 확인 필요 |

## 6. 검증·메시지

| # | 검증 | 위치 | 판정 근거 | 메시지 원문 |
|---:|---|---|---|---|
| V1 | 선적 상태 검사 | GetShipmentStatusChk | `SSP.SSP0200_GET_SHIPMENT_STATUS` Tables[2] CONFIRM_ID | 확인 필요 |
| V2 | 계획 처리 중 검사 | EngProcessingChk | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 확인 필요 |
| V3 | ERP IF 검사 | GetErpIFCheck / GetErpIFCheckNew | `result_code` (Tables[0].Rows[0]) | 확인 필요 |
| V4 | ERP IF 차단 | chkERPIFBlockYn | BLOCK_YN, PERIOD | 확인 필요 |
| V5 | 필수 입력('*' 컬럼, 조회조건) | — | Fact Pack에 검증 코드 없음 | 확인 필요 |

## 7. 권한 (C/R/U/D) 사실

| 사실 | 출처 |
|---|---|
| TB_FX_GroupMenuAuth에 SSP0003 관련 15행이 있습니다. C/R/U/D 플래그 값은 **확인 필요**입니다. | Fact Pack §8 |
| Division·Site 목록은 TB_FX_USERGROUPAUTHEXTENTION과 `NowGroupID`로 제한됩니다. | InitControls:321, SetChangedControl:376·391 |
| GetSSPInnerTable 필터에 GROUP_ID와 USER_ID를 사용합니다. | SetChangeControl:227~228 |
| btnApproval, btnReject, btnSelfReject의 권한별 활성화 조건은 **확인 필요**입니다. | Fact Pack에 없음 |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 영역 | AS-IS | To-Be 메모 |
|---|---|---|
| 상단 그리드 | FpSpread spdMain + SetSheetHeaderColumn(메타) | Wijmo FlexGrid. 컬럼 정의는 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0003) 메타로 유지합니다. |
| 상세 그리드 | FpSpread txtApprovalDeptName, ColumnHeaderSpan 2행 | FlexGrid columnHeaders 2행으로 구성하고 병합을 적용합니다. `_sChangeType`에 따라 그룹 헤더 텍스트("Plan"/"Confirm" ↔ "Confirmed"/"Change")와 ERP_SO_NO 표시를 런타임에 전환합니다. |
| CHK 컬럼 | CellType chk, Value=true | FlexGrid boolean 컬럼으로 만들고 헤더 "ALL"에 전체 선택을 둡니다(동작 확인 필요). |
| 마스터→상세 | CellDoubleClick | 더블클릭 이벤트로 연결합니다. AS-IS에서는 행 선택 변경으로 연결되지 않습니다. |
| Site 조회 SP | FoxQuery 미등록 2종 | MyBatis mapper에 명시적으로 등록해야 합니다. 등록 방식은 확인 필요입니다. |
| SQL 변환 | STRING_SPLIT, UF_FX_STRING_SPLIT, `#` 임시 테이블(#TBLDYNAMIC_SSP0003_40_STD, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 등) | Oracle 19c에는 STRING_SPLIT이 없으므로 대체 구현이 필요합니다. 임시 테이블은 GTT 등으로 전환합니다. 세션 시작 시 비우기 처리를 포함해야 합니다. |
| 저장 분기 | 줄 1207의 CONFIRM_40 / CONFIRM | 분기 조건을 확인한 뒤 BE Service에서 한 곳으로 분기합니다. |
| 주석 호출 | 줄 1209, 1863 | 전환 대상에서 제외합니다. |

## 9. 미확정

1. props.csv가 잘려 조회조건 항목 좌표, Requestor·Model 라벨, 하단 패널 TextBox 라벨과 ReadOnly 여부(txtRequestDeptName 이후)를 확인할 수 없습니다.
2. splitContainer1의 SplitterWidth 원문 값
3. 줄 1207 저장 SP 분기 조건, 버튼별 호출 순서와 실패 분기
4. `BtnRequestUser_Click`, `btnItemId_Click`, `SpdMain_TopChange`의 동작
5. cboStatus·cboChangeType 항목의 출처, `_sChangeType`과의 연계
6. 그리드 컬럼별 타입, 편집 가능 여부, 표시 순서(메타 원문 대조)
7. `biz:CommonData.CommonDataList` 실사용 여부
8. 검증 메시지 원문, C/R/U/D 플래그 값
9. ERP_SO_NO(CODE_ONLY_CHANGE)가 상단 시트에 귀속된 것이 파서 오류인지 여부

=== FILE: unit_test.md ===
# SSP0003 Shipment Change Request Confirm — 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 Fact Pack에서 확정되지 않은 부분은 '확인 필요'로 표시했습니다. 테스트 실행 전에 AS-IS 원문 동작으로 확정해야 합니다.
> 주석 처리된 호출은 테스트 대상에서 제외했습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0003-001 | 초기화 | 권한이 있는 사용자로 로그인. NowGroupID에 Division 권한(TB_FX_USERGROUPAUTHEXTENTION)이 있음 | 화면을 엽니다 | — | clbDivision에 사용자 그룹 권한 범위의 Division 목록이 표시됩니다 | `Form_Load`, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, SP `SSP0200_GET_SHIPMENT_DIVISION` |
| TC-SSP0003-002 | 초기화 | TC-001과 같음 | 화면을 연 뒤 clbFromSite 목록을 확인합니다 | — | clbFromSite가 Site 목록으로 채워집니다. 두 SP 중 어느 것이 실행되는지는 조건 확인 필요 | `Form_Load`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`, SP `SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-003 | 초기화 | TC-001과 같음. 위 SP가 선택되지 않는 조건(확인 필요) | 화면을 연 뒤 clbFromSite 목록을 확인합니다 | — | clbFromSite가 Shipment Plan Plant Site 목록으로 채워집니다 | `Form_Load`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`, SP `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0003-004 | 초기화 | SCM_SYS_CALENDAR_M에 당일 데이터가 있음 | 화면을 열고 drpPeriod 값을 확인합니다 | — | GetDayRange 결과로 기간 기본값이 설정됩니다(drpPeriod 바인딩과 값의 규칙은 확인 필요). 오류가 없어야 합니다 | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0003-005 | 초기화 | — | 화면을 열고 spdMain, txtApprovalDeptName의 헤더를 확인합니다 | — | spdMain은 시트 `Shipment Change Request Confirm`, 헤더 1행입니다. txtApprovalDeptName은 시트 `Shipment Change Request Confirm Detail`, 헤더 2행입니다. 두 그리드 모두 데이터 0행입니다 | `Form_Load` (InitSpread:431, 439), `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-006 | 이벤트 | 화면 로드 완료 | clbDivision에서 Division 하나를 체크합니다 | Division 1건 | clbFromSite가 선택한 Division 기준 Site 목록으로 다시 구성됩니다 | `ClbDivision_SelectedIndexChanged`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-007 | 이벤트 | 화면 로드 완료. Shipment Plan Site 분기 조건 충족(확인 필요) | clbDivision에서 선택을 바꿉니다 | Division 변경 | clbFromSite가 다시 구성됩니다 | `ClbDivision_SelectedIndexChanged`, `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| TC-SSP0003-008 | 이벤트(빈 결과) | 선택한 Division에 해당 사용자 권한 Site가 없음 | clbDivision에서 해당 Division만 체크합니다 | Site 없는 Division | 오류 없이 clbFromSite가 빈 목록이 됩니다 | `ClbDivision_SelectedIndexChanged`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-009 | 조회 | 변경 요청 데이터(SSP_ANL_SHIP_CONFIRM_CHG_REQ)가 있음 | clbDivision, clbFromSite, drpPeriod, cboStatus, cboChangeType을 지정하고 조회(FindButton)를 누릅니다 | 데이터가 있는 조건 | spdMain에 결과 행이 표시됩니다. 표시 컬럼은 19개입니다 | FindButton > FindData_Main, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, SP `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `Shipment Change Request Confirm` |
| TC-SSP0003-010 | 조회(빈 결과) | 조건에 맞는 데이터가 없음 | drpPeriod를 데이터가 없는 기간으로 지정하고 조회합니다 | 데이터 없는 기간 | 오류 없이 spdMain이 0행이 됩니다. 안내 메시지 여부는 확인 필요 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-011 | 조회(오류) | SP 실행 오류가 발생하도록 환경을 구성(예: 권한 제거) | 조회합니다 | — | 오류 메시지가 표시되고 spdMain 기존 데이터의 처리는 확인 필요. 화면이 비정상 종료되지 않아야 합니다 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-012 | 조회 | 조회조건 txtRequest, txtItemID에 값 입력 | txtRequest에 요청자, txtItemID에 모델을 입력하고 조회합니다 | 요청자·모델 값 | 입력값이 조회 파라미터로 반영되어 결과가 필터됩니다(파라미터 매핑 확인 필요) | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-013 | 그리드 | TC-009 결과 있음 | spdMain 컬럼을 확인합니다 | — | 표시 19개: Request No, Title, Change Type, Status, Division, From Site, To Site, Model, Nick Name, Change Reason, Reject Reason, Requestor, Requestor Dept Name, Request Date, Approval, Approval Dept Name, Approval Date, Delegatee, Delegatee Dept Name. 숨김: REQUEST_USER, APPROVAL_USER, DELEGATEE_USER | `Shipment Change Request Confirm` (SCM_MST_SHEET_COLUMNS) |
| TC-SSP0003-014 | 그리드 | 상세 조회 완료 | txtApprovalDeptName 컬럼을 확인합니다 | — | 표시 29개(CHK~REJECT_REASON), 숨김 25개(A_COUNTRY 등)가 화면설계서 §4-2와 같습니다 | `Shipment Change Request Confirm Detail` (SCM_MST_SHEET_COLUMNS) |
| TC-SSP0003-015 | 그리드 | 상세 조회 완료 | txtApprovalDeptName의 CHK 컬럼을 확인합니다 | — | CHK는 체크박스이고 헤더는 "ALL"입니다. 기본값은 true(체크)입니다 | `Shipment Change Request Confirm Detail` (InitSpread:447~449) |
| TC-SSP0003-016 | 그리드 | `_sChangeType == "P"`인 요청 | spdMain에서 해당 요청 행을 더블클릭합니다 | Change Type P 요청 | ERP_SO_NO가 숨겨집니다. 0행 그룹 헤더는 LT_DAY부터 6열이 "Plan", NEW_LT_DAY부터 6열이 "Confirm"입니다 | `Shipment Change Request Confirm Detail` (InitSpread:475), `SpdMain_CellDoubleClick` |
| TC-SSP0003-017 | 그리드 | `_sChangeType != "P"`인 요청 | spdMain에서 해당 요청 행을 더블클릭합니다 | Change Type P 외 요청 | ERP_SO_NO가 표시됩니다. 0행 그룹 헤더는 "Confirmed"와 "Change"입니다 | `Shipment Change Request Confirm Detail` (InitSpread:503), `SpdMain_CellDoubleClick` |
| TC-SSP0003-018 | 이벤트 | TC-009 결과 있음 | spdMain 행을 더블클릭합니다 | 요청 1건 | txtApprovalDeptName에 상세 행이 표시됩니다. txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtChangeReason, txtReasonDetail에 요청 정보가 채워집니다(컬럼↔TextBox 대응 확인 필요) | `SpdMain_CellDoubleClick`, `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, SP `SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| TC-SSP0003-019 | 이벤트 | 위임자(SSP_MST_DELEGATE)가 등록된 승인자의 요청 | spdMain 행을 더블클릭합니다 | 위임 등록 요청 | 위임자 정보를 조회합니다. 화면 반영 위치는 확인 필요 | `SpdMain_CellDoubleClick`, `SSP.SSP0003_GET_DELEGATEE_LOAD`, SP `SSP0003_GET_DELEGATEE_LOAD` |
| TC-SSP0003-020 | 이벤트(빈 결과) | 상세(SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE)가 없는 요청 | spdMain 행을 더블클릭합니다 | 상세 없는 요청 | 오류 없이 txtApprovalDeptName이 0행이 됩니다. 패널 처리는 확인 필요 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| TC-SSP0003-021 | 그리드 | `p_status`가 E·O·R·S·D·A·P 어느 것도 아닌 요청 | spdMain 행을 더블클릭합니다 | 해당 상태 요청 | txtApprovalDeptName의 0번 컬럼이 숨겨집니다. 다른 상태의 처리는 확인 필요 | `SpdMain_CellDoubleClick` (FindData_Sub:827), `Shipment Change Request Confirm Detail` |
| TC-SSP0003-022 | 이벤트 | spdMain에 화면 높이를 넘는 행이 있음 | spdMain을 세로로 스크롤합니다 | — | 오류 없이 스크롤됩니다. 추가 동작은 AS-IS 원문 확인 후 확정 | `SpdMain_TopChange` |
| TC-SSP0003-023 | 저장 | 상세 조회 완료. 선적 상태 검사 대상 CONFIRM_ID가 있음 | txtApprovalDeptName에서 CHK를 체크하고 btnApproval을 누릅니다 | 승인 대상 행 | 선적 상태 검사를 실행합니다. 결과 Tables[2] CONFIRM_ID에 따라 진행하거나 중단합니다(판정 기준·메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0200_GET_SHIPMENT_STATUS`, SP `SSP0200_GET_SHIPMENT_STATUS` |
| TC-SSP0003-024 | 저장 | 해당 Division 계획이 처리 중(SCM_MST_PLAN·SCM_MST_PLAN_DETAIL) | btnApproval을 누릅니다 | 계획 처리 중 상태 | 계획 처리 검사 결과에 따라 승인이 진행되거나 중단됩니다(메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, SP `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| TC-SSP0003-025 | 저장 | 검사 통과 조건 | btnApproval을 누릅니다 | 승인 대상 행 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE가 UPDATE되고 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN과 SCM_SYS_LOG_BATCH에 INSERT됩니다 | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` |
| TC-SSP0003-026 | 저장 / division | Division 40 요청(분기 조건 확인 필요) | btnApproval을 누릅니다 | Division 40 | `_40` SP가 실행됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ UPDATE, SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, SSP_ANL_SHIP_PLAN_40 DELETE/INSERT, DM_PLN_MKT_FCST_CONFIRM INSERT, SSP_ANL_SHIP_CONFIRM_H INSERT가 일어납니다 | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0003-027 | 저장 / division | Division 40 외 요청(예: 81, 82, EE) | btnApproval을 누릅니다 | Division 81 | 일반 SP가 실행됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ UPDATE, SSP_ANL_SHIP_CONFIRM INSERT/UPDATE, XIF_SCS_PACK_SHIP_PLAN_S_SN·XIF_FP_SSP_SALES_EXFACTORY_S_SN·SSP_ANL_SHIP_CONFIRM_H INSERT가 일어납니다 | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0003-028 | 저장 | 승인 저장 완료 | btnApproval 처리 후 ERP IF 검사 결과를 확인합니다 | — | `result_code`를 반환받아 분기합니다(값별 동작 확인 필요). XIF_ERP_SHIP_PLAN_CONFIRM_S_SN이 INSERT/UPDATE됩니다 | `BtnApproval_Click` > GetErpIFCheck, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, SP `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| TC-SSP0003-029 | 저장 | 신규 ERP IF 경로 조건(확인 필요) | btnApproval을 누릅니다 | — | GetErpIFCheckNew에서 IF 검사를 실행합니다(줄 1409, 1492). `result_code`로 분기합니다(줄 1426) | `BtnApproval_Click` > GetErpIFCheckNew, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| TC-SSP0003-030 | 저장 | 신규 ERP IF 경로에서 Drafting 삭제 조건(확인 필요) | btnApproval을 누릅니다 | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE UPDATE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT가 일어납니다 | `BtnApproval_Click`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SP `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| TC-SSP0003-031 | 저장(오류 응답) | ERP IF 검사가 오류 `result_code`를 반환하는 조건(확인 필요) | btnApproval을 누릅니다 | — | ERP 오류 확정이 실행됩니다. SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, SSP_ANL_SHIP_CONFIRM_CHG_REQ·SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE UPDATE가 일어납니다. 사용자 메시지는 확인 필요 | `BtnApproval_Click`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, SP `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| TC-SSP0003-032 | 저장 | 승인 성공 | btnApproval 처리 완료 후 spdMain을 확인합니다 | — | 목록이 다시 조회되어 처리한 요청의 Status, Approval, Approval Date가 갱신되어 보입니다 | `BtnApproval_Click` > SaveData > FindData_Main, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-033 | 저장(오류 응답) | 저장 SP에서 DB 오류가 발생하는 조건 | btnApproval을 누릅니다 | — | 오류 메시지가 표시되고 데이터 롤백 여부가 확인됩니다(트랜잭션 범위 확인 필요) | `BtnApproval_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0003-034 | 저장 | 상세 조회 완료 | txtRejectReason에 사유를 입력하고(편집 가능 여부 확인 필요) btnReject를 누릅니다 | 반려 사유 | 상세 확정 저장, 요청 저장, ERP IF 검사, 재조회를 거쳐 spdMain에 반려 상태가 반영됩니다 | `BtnReject_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-035 | 저장 / division | Division 40 요청 | btnReject를 누릅니다 | Division 40 | `_40` 저장 SP가 실행됩니다(분기 조건 확인 필요) | `BtnReject_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0003-036 | 저장 | 상세 조회 완료. 요청자 본인 요청(확인 필요) | btnSelfReject를 누릅니다 | — | 상세 확정 저장, 요청 저장, ERP IF 검사, 재조회를 거쳐 spdMain에 자가 반려 결과가 반영됩니다 | `BtnSelfReject_Click`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0003-037 | 이벤트 | 화면 로드 완료 | btnRequestUser를 누릅니다 | — | 요청자 선택 동작이 실행되어 txtRequest에 반영됩니다(팝업 여부와 반영 방식 확인 필요). 오류가 없어야 합니다 | `BtnRequestUser_Click` |
| TC-SSP0003-038 | 이벤트 | 화면 로드 완료 | btnItemId를 누릅니다 | — | 모델 선택 동작이 실행되어 txtItemID에 반영됩니다(팝업 여부와 반영 방식 확인 필요). 오류가 없어야 합니다 | `btnItemId_Click` |
| TC-SSP0003-039 | 초기화 | SetChangedPeriod 호출 경로 확인(진입점 미연결) | AS-IS를 실행하며 CommonDataList 호출을 추적합니다 | PERIOD_{값} 또는 PERIOD_DEFAULT | 호출되면 FROM_VALUE, TO_VALUE로 기간을 설정합니다. 호출되지 않으면 To-Be 대상에서 제외 판정합니다 | SetChangedPeriod, `biz:CommonData.CommonDataList` |
| TC-SSP0003-040 | 권한 | 사용자 A 그룹은 Division 일부만 권한이 있음(TB_FX_USERGROUPAUTHEXTENTION) | 사용자 A로 화면을 엽니다 | — | clbDivision과 clbFromSite에 권한 범위의 항목만 표시됩니다 | `Form_Load`, `SSP.SSP0200_GET_SHIPMENT_DIVISION`, `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` |
| TC-SSP0003-041 | 권한 | TB_FX_GroupMenuAuth에서 U 권한이 없는 그룹(플래그 확인 필요) | 해당 그룹 사용자로 화면을 열고 btnApproval, btnReject, btnSelfReject 상태를 확인합니다 | — | 권한에 따라 버튼이 비활성화되거나 처리가 차단됩니다(구체 동작 확인 필요) | `BtnApproval_Click`, `BtnReject_Click`, `BtnSelfReject_Click` |
| TC-SSP0003-042 | division | Division 40 사용자 | 조회 후 spdMain과 txtApprovalDeptName의 표시 컬럼 수를 확인합니다 | Division 40 | 상단 19개, 상세 29개(ERP_SO_NO는 `_sChangeType`에 따름) | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-043 | division | Division 81 계열(81, 81_HD/HG/HM/ST/UC) 사용자 | TC-042와 같습니다 | Division 81 | 상단 19개, 상세 29개 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-044 | division | Division 82 사용자 | TC-042와 같습니다 | Division 82 | 상단 19개, 상세 29개 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0003-045 | division | Division EE 계열(EE, EE_HD/HG/HM/ST/UC) 사용자 | TC-042와 같습니다 | Division EE | 상단 19개, 상세 29개 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |

### 커버리지 대조

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 9 | `Form_Load` | 001~005 |
| | `SpdMain_CellDoubleClick` | 016~021 |
| | `ClbDivision_SelectedIndexChanged` | 006~008 |
| | `SpdMain_TopChange` | 022 |
| | `BtnApproval_Click` | 023~033 |
| | `BtnReject_Click` | 034, 035 |
| | `BtnSelfReject_Click` | 036 |
| | `BtnRequestUser_Click` | 037 |
| | `btnItemId_Click` | 038 |
| 엔드포인트 16 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | 001, 040 |
| | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | 002, 006, 008 |
| | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | 003, 007 |
| | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 009~012, 032 |
| | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 018, 020 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | 025, 034 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | 026, 035 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | 027, 033 |
| | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 028, 029 |
| | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 030 |
| | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 031 |
| | `biz:CommonData.CommonDataList` | 039 |
| | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 024 |
| | `SSP.SSP0200_GET_SHIPMENT_STATUS` | 023 |
| | `SSP.SSP0003_GET_DELEGATEE_LOAD` | 019 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 004 |
| 시트 2 | `Shipment Change Request Confirm` | 005, 009, 013, 042~045 |
| | `Shipment Change Request Confirm Detail` | 005, 014~017, 021, 042~045 |
| 빈 결과 | | 008, 010, 020 |
| 오류 응답 | | 011, 031, 033 |
