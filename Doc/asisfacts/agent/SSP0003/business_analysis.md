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
