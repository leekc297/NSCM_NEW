=== FILE: business_analysis.md ===
# SSP0202 Shipment Change Request Confirm — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0202, variant=only)과 1차 분석서(analysis.md / web_components.md / tobe_design.md).
> 이 문서에는 Fact Pack에 있는 사실만 적었습니다. Fact Pack으로 입증되지 않은 내용은 **확인 필요**로 표시했습니다.
> 주석 처리된 호출 2건(877줄 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, 1262줄)은 현행 기능에서 뺐습니다. 875줄의 활성 호출만 현행 기능으로 봅니다.

---

## 1. 업무 목적·범위

### 1-1. 목적
| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0202 / `SSP0202_ShipmentChangeRequestConfirm` | Fact Pack §1 |
| 화면명 | Shipment Change Request Confirm | 파일명·클래스명 |
| 업무 목적 | 출하 변경 요청(Change Request) 건을 조회하고 상세 내역을 확인한 뒤 **Approval / Reject / Self Reject**로 처리합니다. | 버튼 Text 원문 "Approval", "Reject", "Self Reject" (props.csv). 조회·저장 SP 이름 |
| 업무 정의 원문 | 사용자 매뉴얼이나 업무 정의서는 Fact Pack에 없습니다. | **확인 필요** |

### 1-2. 범위
| 구분 | 기능 | 엔드포인트 |
|---|---|---|
| 초기화 | 요청일 기간(drpPeriod) 기본값 조회 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| 조회 | 변경 요청 목록(Main) 조회 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| 상세 | 요청 상세(Detail) 조회 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| 상세 | 위임자 조회 | `SSP.SSP0202_GET_DELEGATEE_LOAD` |
| 승인 전 검사 | 계획 처리 중 여부 검사 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` |
| 승인 전 검사 | SCS Confirm ID 검사 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` |
| 처리 전 검사 | ERP I/F 검사 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| 저장(처리) | 승인·반려·자가반려 저장 (Division 40 계열로 보이는 SP) | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| 저장(처리) | 승인·반려·자가반려 저장 (일반) | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| 공통 코드 | 기간 코드 값 조회 (`SetChangedPeriod`, 진입점 미연결) | `biz:CommonData.CommonDataList` |

### 1-3. SP 목록 (9종)
| # | SP | 구분 |
|---:|---|---|
| 1 | `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 조회 |
| 2 | `SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 조회(상세) |
| 3 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | 저장 |
| 4 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | 저장 |
| 5 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 검사(이름은 SAVE이지만 내부에 쓰기가 있음, §5) |
| 6 | `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | 검사 |
| 7 | `SSP0202_GET_SCS_CONFIRM_ID_CHECK` | 검사(동적 SQL 포함) |
| 8 | `SSP0202_GET_DELEGATEE_LOAD` | 조회(위임자) |
| 9 | `SCM0001_GET_SCP_DAY_PERIOD` | 공통(기간) |

`biz:CommonData.CommonDataList`는 SP가 아니라 biz 호출(`Data.CallBizCommonData`)입니다.

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` > `InitControls` > `GetDayRange` → `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 요청일 기간(drpPeriod) 기본값이 설정됩니다. 설정 값의 규칙은 **확인 필요** | flow.csv 1263 |
| S2 | 화면을 엽니다 | `SetChangeControl`에서 `DataService.GetSSPInnerTable`을 7회 호출합니다(216~246) | 조회조건 목록이 채워진 것으로 보입니다. 어느 컨트롤에 바인딩되는지는 **확인 필요** | Fact Pack §4-2 |
| S3 | 조회조건(Division, Request Date, From Site, Status, Change Type, Requestor, Model)을 입력하고 조회합니다 | `FindButton` > `FindData_Main` → `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | Main 그리드(`Shipment Change Request Confirm`)에 요청 목록이 표시됩니다 | flow.csv 611 |
| S4 | Main 행을 더블클릭합니다 | `SpdMain_CellDoubleClick` > `FindData_Sub` → `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `Delegate_Load` → `SSP.SSP0202_GET_DELEGATEE_LOAD` | Detail 그리드(`Shipment Change Request Confirm Detail`)와 상세 폼이 채워집니다(`SetChangeRequestInfo` 723~730) | flow.csv 687, 1233 / meta_reads.csv |
| S5 | Approval을 누릅니다 | `BtnApproval_Click` → `EngProcessingChk`(`SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`) · `chkSaveYN`(`SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`) · `GetErpIFCheck`(`SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`) · `SaveData`(`_40` 또는 일반 SAVE) → `FindData_Main` 재조회 | 요청이 승인 처리되고 목록이 다시 조회됩니다 | flow.csv |
| S6 | Reject를 누릅니다 | `BtnReject_Click` → `GetErpIFCheck` · `SaveData` → `FindData_Main` 재조회 | 요청이 반려 처리되고 목록이 다시 조회됩니다 | flow.csv |
| S7 | Self Reject를 누릅니다 | `BtnSelfReject_Click` → `GetErpIFCheck` · `SaveData` → `FindData_Main` 재조회 | 요청이 자가반려 처리되고 목록이 다시 조회됩니다 | flow.csv |
| S8 | Requestor 옆 버튼을 누릅니다 | `BtnRequestUser_Click` (엔드포인트 호출 없음) | 동작은 **확인 필요** (사용자 검색 팝업으로 보이지만 입증되지 않음) | events.csv 263 |
| S9 | Model 옆 버튼을 누릅니다 | `btnItemId_Click` (엔드포인트 호출 없음) | 동작은 **확인 필요** | events.csv 264 |
| S10 | Division 선택을 바꿉니다 | `ClbDivision_SelectedIndexChanged` (엔드포인트 호출 없음) | 연쇄 동작은 **확인 필요** | events.csv 257 |
| S11 | Main 그리드를 스크롤합니다 | `SpdMain_TopChange` (엔드포인트 호출 없음) | 동작은 **확인 필요** | events.csv 258 |

---

## 3. 업무 흐름도 (텍스트)

```
[1] 화면 진입 (Form_Load)
     └─ InitControls ─ GetDayRange ─▶ SCP.SCM0001_GET_SCP_DAY_PERIOD ─▶ drpPeriod 기본 기간
     └─ SetChangeControl ─ GetSSPInnerTable ×7 (216~246) ─▶ 조회조건 목록 (바인딩 대상 확인 필요)
     └─ InitControls ─ FP_Log2 (275, 283) ─▶ 로그 기록(LOGTYPE, NOTE, USER_ID)
            │
[2] 조회 (FindButton)
     └─ FindData_Main ─ GetCheckedListValue(593/594/598/600) ─▶ SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM
            ─▶ Main 그리드 [Shipment Change Request Confirm]
            │
[3] Main 행 더블클릭 (SpdMain_CellDoubleClick)
     ├─ FindData_Sub ─▶ SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING ─▶ Detail 그리드 [Shipment Change Request Confirm Detail]
     ├─ (SetChangeRequestInfo 723~730 ─▶ 상세 폼 TextBox. 호출 위치 확인 필요)
     └─ Delegate_Load ─▶ SSP.SSP0202_GET_DELEGATEE_LOAD
            │
[4] 처리 버튼
     ├─ Approval (BtnApproval_Click)
     │    ├─ EngProcessingChk ─▶ SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK
     │    ├─ chkSaveYN        ─▶ SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK (Tables[0], Tables[1]의 CNT)
     │    ├─ GetErpIFCheck    ─▶ SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK (result_code)
     │    └─ SaveData(875)    ─▶ SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40  또는  SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM
     │                          └─ FindData_Main 재조회
     ├─ Reject (BtnReject_Click)          : GetErpIFCheck → SaveData → FindData_Main
     └─ Self Reject (BtnSelfReject_Click) : GetErpIFCheck → SaveData → FindData_Main
```
- 검사 순서(EngProcessingChk → chkSaveYN → GetErpIFCheck → SaveData)는 flow.csv의 경로 목록을 나열한 것입니다. 실제 실행 순서와 중단 조건은 원문 1412줄 근처로 **확인 필요**합니다.
- `chkERPIFBlockYn`(BLOCK_YN, PERIOD)이 어느 단계에서 호출되는지 **확인 필요**합니다.

---

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거(원문) | 상태 |
|---:|---|---|---|
| R1 | 요청일 기본 기간은 `SCM0001_GET_SCP_DAY_PERIOD`로 정합니다. 이 SP는 `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, `CTE_DATE`를 참조합니다. | flow.csv 1263 / endpoints.csv | 기간 길이·기준일 값은 **확인 필요** |
| R2 | 1262줄의 `SCP.GET_DATE_RANGE_1MONTH`는 주석 처리되어 현행 규칙이 아닙니다. | commented_calls.csv | 확정(제외) |
| R3 | 조회조건 중 다중 선택 값은 `CString.GetCheckedListValue`로 CODE 값을 모아 전달합니다(4회). | Fact Pack §4-2 FindData_Main:593/594/598/600 | 파라미터별 대응 컨트롤은 **확인 필요** |
| R4 | 조회 SP는 `STRING_SPLIT`으로 다중 값을 분리합니다. | endpoints.csv REF:STRING_SPLIT | 확정 (Oracle 전환 대상) |
| R5 | 계획 처리 중 여부 검사(`EngProcessingChk`)와 SCS Confirm ID 검사(`chkSaveYN`)는 **Approval에서만** 수행합니다. Reject와 Self Reject 경로에는 없습니다. | flow.csv | 확정 (flow 기준) |
| R6 | 계획 처리 중 여부 검사는 `SCM_MST_PLAN`, `SCM_MST_PLAN_DETAIL`, `SCM_MST_DIVISION`을 참조합니다. | endpoints.csv | 판정 컬럼·값은 **확인 필요** |
| R7 | SCS Confirm ID 검사는 결과 두 테이블(Tables[0], Tables[1])의 `CNT`로 판정합니다(1141, 1147, 1161). 이 SP는 동적 SQL을 쓰고 `FN_GET_IN_STR`, `FN_SCM_SPLIT`, `SCM_ADM_LOOKUP_MASTER_DETAIL`을 참조합니다. | meta_reads.csv / endpoints.csv | CNT 임계값·메시지는 **확인 필요** |
| R8 | ERP I/F 검사(`GetErpIFCheck`)는 세 버튼 모두에서 호출하며, 결과 `ds.Tables[0].Rows[0]["result_code"]`로 판정합니다. | flow.csv / meta_reads.csv 998 | result_code 값별 분기는 **확인 필요** |
| R9 | ERP Block 검사(`chkERPIFBlockYn`)는 `dtERPBlockYnIF`의 `BLOCK_YN`, `PERIOD`를 읽습니다. | meta_reads.csv 1064, 1073 | 데이터 출처·호출 위치는 **확인 필요** |
| R10 | 저장은 `SaveData`(875) 한 곳에서 `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`과 `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` 중 하나를 고릅니다. | endpoints.csv 875 (같은 줄 2건) | 분기 조건(division 여부 등)은 **확인 필요** |
| R11 | 저장한 뒤에는 `FindData_Main`(611)으로 목록을 다시 조회합니다. | flow.csv `… > SaveData > FindData_Main` | 확정 |
| R12 | 세 버튼이 `SaveData`에 넘기는 처리 구분 값(승인/반려/자가반려)과 반려 사유(`txtRejectReason`) 전달 여부는 Fact Pack에 없습니다. | — | **확인 필요** |
| R13 | 상세 그리드는 `_sChangeType == "P"`이면 `ERP_SO_NO`를 숨기고 상단 헤더를 "Plan"/"Confirm"으로 표시합니다. 그 외에는 `ERP_SO_NO`를 표시하고 "Confirmed"/"Change"로 표시합니다. | grid_code.csv 405~444 | `_sChangeType` 값의 출처는 **확인 필요** |
| R14 | 필수값: 상세 그리드 메타 라벨에 `Shipment Date*`, `Qty*`(NEW_ 컬럼)가 있습니다. 화면 입력 필수 검증 로직은 Fact Pack에 없습니다. | grid_effective.csv | 필수 검증 여부는 **확인 필요** |
| R15 | 저장 SP는 이력(`PR_SSP_ANL_SHIP_CONFIRM_HIST`, `INSERT SSP_ANL_SHIP_CONFIRM_H`)과 메일 발송(`SCM_SSP_MAIL_SEND`, `SCM_ADM_MAIL_SEND`)을 포함합니다. | endpoints.csv | 확정 (EXEC 전이 포함 목록 기준) |
| R16 | ETA는 `FN_GET_SSP_ETA_DATE`를 참조합니다(두 저장 SP 모두). 일반 저장 SP는 `FN_NEXT_DAY`도 참조합니다. | endpoints.csv | 날짜 산식은 **확인 필요** |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

> 참조 객체는 파서가 SP 내부 EXEC를 따라 모은 결과입니다. 그래서 쓰기가 해당 SP에서 직접 일어나는지, 하위 PR에서 일어나는지는 구분되지 않습니다(**확인 필요**).

| 엔드포인트 | SP | 호출 메서드(줄) | 읽기(SELECT/REF) | 쓰기(INSERT/UPDATE/DELETE) | 하위 EXEC |
|---|---|---|---|---|---|
| `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | FindData_Main(611) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN / FN_GET_ITEM_NICKNAME, STRING_SPLIT | 없음 | 없음 |
| `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | `SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | FindData_Sub(687) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / FN_GET_PROJECT_NAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO | 없음 | 없음 |
| `SSP.SSP0202_GET_DELEGATEE_LOAD` | `SSP0202_GET_DELEGATEE_LOAD` | Delegate_Load(1233) | SSP_MST_DELEGATE, TB_FX_USER | 없음 | 없음 |
| `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | EngProcessingChk(1090) | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | 없음 | 없음 |
| `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | `SSP0202_GET_SCS_CONFIRM_ID_CHECK` | chkSaveYN(1130) | SCM_ADM_LOOKUP_MASTER_DETAIL / FN_GET_IN_STR, FN_SCM_SPLIT, **동적 SQL**(대상 객체 확인 필요) | 없음(동적 SQL 내용은 확인 필요) | 없음 |
| `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | GetErpIFCheck(986) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH, INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH |
| `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SaveData(875) | SSP_ANL_SHIP_CONFIRM, SSP_MST_SITE_ITEM_EE_V, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_MST_SITE_ITEM, #TBLSSPAPPROVEDMAILSEND, SSP_MST_DELEGATE, SCM_MST_SSO_USER_INFO, SCM_MST_ITEM_SN / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT SCM_SYS_LOG_BATCH, INSERT #TBLSSPAPPROVEDMAILSEND, INSERT SCM_ADM_SMS_MAIL_SEND_LOG | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SP_SEND_DBMAIL |
| `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | SaveData(875) | SSP_ANL_SHIP_CONFIRM, SSP_MST_SITE_ITEM_EE_V, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_MST_SITE_ITEM, #TBLSSPAPPROVEDMAILSEND, SSP_MST_DELEGATE, SCM_MST_PROJECT, NERP_CONV_MASTER, DM_PLN_MKT_FCST_CONFIRM, #T_CONFIRM_ID, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME, FN_ZERO_LPAD, FN_GET_SITE_CUSTOMER_INFO, UF_FX_STRING_SPLIT, FN_NEXT_DAY | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT SCM_SYS_LOG_BATCH, INSERT #TBLSSPAPPROVEDMAILSEND, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT #T_CONFIRM_ID, DELETE A(별칭, 실제 테이블 확인 필요), INSERT DM_PLN_MKT_FCST_CONFIRM / CREATE #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_DM_SSP_CONFIRM_SYNC, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SCP_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange(1263) | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE / FN_MULTY_TIME, FN_WEEKOFDAY_DATE | 없음 | 없음 |
| `biz:CommonData.CommonDataList` | (biz 호출, SP 없음) | SetChangedPeriod(1044, 진입점 미연결) | code = `PERIOD_{p:value}` 또는 `PERIOD_DEFAULT` → FROM_VALUE, TO_VALUE | 없음 | — |

### 5-1. 두 저장 SP의 객체 차이 (endpoints.csv 비교, 사실)
| 객체 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
|---|:---:|:---:|
| EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS | – | O |
| EXEC PR_DM_SSP_CONFIRM_SYNC / INSERT DM_PLN_MKT_FCST_CONFIRM | – | O |
| EXEC PR_SSP_ANL_SHIP_CONFIRM_ROUTE / SCP_MST_DISTRIBUTION_ROUTE | – | O |
| INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN / NERP_CONV_MASTER | – | O |
| EXEC SP_SEND_DBMAIL / INSERT SCM_ADM_SMS_MAIL_SEND_LOG | O | – |
| SCM_MST_SSO_USER_INFO, SCM_MST_ITEM_SN | O | – |

---

## 6. Division·권한별 변형

### 6-1. Division
| 항목 | 사실 | 근거 |
|---|---|---|
| 그리드 표시 컬럼 | 14개 division 키(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. Main 19, Detail 25(?1) | Fact Pack §10, §12 |
| 코드 분기 | division 변수 비교 분기는 추출되지 않았습니다. 상세 그리드 분기는 `_sChangeType` 하나뿐입니다. | grid_code.csv |
| 저장 SP | `_40` 접미사 SP가 따로 있습니다. Division 40 전용인지, 분기 조건이 무엇인지는 입증되지 않았습니다. | endpoints.csv 875 / **확인 필요** |
| 계획 처리 검사 | `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`가 `SCM_MST_DIVISION`을 참조합니다. | endpoints.csv |
| 조회조건 | `clbDivision`(다중 선택), `ClbDivision_SelectedIndexChanged` 이벤트가 있습니다. | controls.csv / events.csv |

### 6-2. 권한
| 항목 | 사실 | 근거 |
|---|---|---|
| 사용자 그룹 | `SetChangeControl`(209~210)이 `Filter`의 `GROUP_ID`, `USER_ID`와 `UserInfoContext.Current.NowGroupID`를 사용합니다. `SetChangedControl`(327)도 `NowGroupID`를 사용합니다. | meta_reads.csv |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 8행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행, TB_FX_Favorite 13행이 있습니다. 내용은 Fact Pack에 없습니다. | Fact Pack §8 / **확인 필요** |
| 저장 버튼 | 프레임워크 저장 버튼이 아니라 화면 전용 버튼 3종(btnApproval, btnReject, btnSelfReject)으로 처리합니다. | events.csv |
| 승인자·위임자 | Main 시트에 APPROVAL_USER(숨김), DELEGATEE_USER(숨김)가 있고 `SSP_MST_DELEGATE`를 참조합니다. 승인자 본인 또는 위임자만 처리할 수 있는지는 **확인 필요** | grid_effective.csv / endpoints.csv |

---

## 7. 외부 인터페이스 (Fact Pack에 있는 객체만)

| 대상 | 방향 | 엔드포인트 / SP | 사실 |
|---|---|---|---|
| XIF_ERP_PACK_SHIP_PLAN_S_SN | INSERT | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | ERP 인터페이스 테이블로 보입니다. 수신 측 처리는 **확인 필요** |
| XIF_SCS_PACK_SHIP_PLAN_S_SN | INSERT | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | SCS 인터페이스 테이블로 보입니다. **확인 필요** |
| NERP_CONV_MASTER | SELECT | IF_CHECK, 일반 SAVE | ERP 변환 마스터 참조 |
| DM_PLN_MKT_FCST_CONFIRM | INSERT (PR_DM_SSP_CONFIRM_SYNC 경유로 보임) | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | DM 도메인 동기화 |
| 메일 / SMS | EXEC | 두 저장 SP | SCM_SSP_MAIL_SEND, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG. `_40`은 SP_SEND_DBMAIL과 INSERT SCM_ADM_SMS_MAIL_SEND_LOG도 포함 |
| 배치 로그 | INSERT / EXEC | IF_CHECK, 두 저장 SP | SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH(_CALL_TRAN), PR_SCP_SYS_LOG_BATCH |

---

## 8. 미확정·확인 필요

| # | 항목 | 확인 방법 |
|---:|---|---|
| U1 | `SaveData`(875)에서 `_40`과 일반 SAVE를 고르는 조건과 `_40`의 division 의미 | .cs 원문 875줄 근처 |
| U2 | 세 버튼이 `SaveData`에 넘기는 처리 구분 값과 `txtRejectReason` 전달 여부 | .cs 1311 / 1369 / 1412줄 근처, SP 파라미터 |
| U3 | Fact Pack §4-2의 `SaveData` → `PersonalSettingPopup.SaveData` 매핑이 파서 오매핑인지 | 원문 호출 대상 |
| U4 | `SetChangedPeriod`(biz:CommonData.CommonDataList)가 실제로 호출되는지 | 원문 호출자 검색 |
| U5 | `chkERPIFBlockYn`의 `dtERPBlockYnIF` 데이터 출처와 호출 위치 | 원문 1060~1080줄 |
| U6 | `GetSSPInnerTable` 7회 호출과 조회조건 컨트롤의 대응 | 원문 216~246줄 |
| U7 | `EngProcessingChk`, `chkSaveYN`, `GetErpIFCheck`의 판정 값, 중단 조건, 메시지 원문 | 원문 986~1161줄 |
| U8 | `_sChangeType`의 값 출처(Main 선택 행의 CHANGE_TYPE으로 보이지만 미입증) | 원문 |
| U9 | `ClbDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `BtnRequestUser_Click`, `btnItemId_Click`의 동작 | 원문 핸들러 본문 |
| U10 | 저장 SP 참조 객체 중 직접 쓰기와 하위 PR 쓰기의 구분, `DELETE A`의 실제 테이블 | SP 원문 |
| U11 | `SSP0202_GET_SCS_CONFIRM_ID_CHECK` 동적 SQL의 대상 객체 | SP 원문 |
| U12 | 메타 행(TB_FX_GroupMenuAuth 8, SCM_ADM_LOOKUP_MASTER_DETAIL 1 등)의 내용 | dbmeta_*.csv |
| U13 | 실제 SP 실행 결과와 맞는 시트가 없습니다(grid 단계 미실행) | grid 단계 실측 |

=== FILE: screen_design.md ===
# SSP0202 Shipment Change Request Confirm — 화면설계서

> 근거: AsisFacts Fact Pack(SSP0202) controls.csv / props.csv / events.csv / grid_effective.csv / grid_code.csv / flow.csv.
> 업무 규칙 번호(R#)는 업무분석서 §4, 엔드포인트 이름은 업무분석서 §5와 같습니다.
> props.csv는 Fact Pack에서 10,890자가 잘렸습니다. 이 때문에 라벨 원문을 확인하지 못한 항목은 **확인 필요**로 표시했습니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0202 |
| 화면명 | Shipment Change Request Confirm |
| AS-IS 클래스 | `SSP0202_ShipmentChangeRequestConfirm` (06.UIL\GSCM.SSP.Plan.UIL) |
| AS-IS 파일 | SSP0202_ShipmentChangeRequestConfirm.cs (1440줄), .Designer.cs (1314줄) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용은 Fact Pack에 없음) |
| 그리드 구성 | META(프레임워크) + 코드 표시/라벨 변경. 시트 2개: `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| 화면 유형 | 조회조건 + Master 그리드 + 상세 폼 + Detail 그리드 + 처리 버튼 3종 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

```
this
└─ splitContainer1  [SplitContainer] Dock=Fill, Orientation=Horizontal(상/하), Size=1192×649, SplitterDistance=259
   ├─ Panel1 (상, 259px = 259/649 ≈ 39.9%)
   │   ├─ usrConditionPanel1 [UsrConditionPanel] Dock=Top, 1192×67 (Panel1의 25.9%), UsrPanelType=HidePanel
   │   │   └─ usrLayoutControl1 [UsrLayoutControl] Dock=Fill, 1192×67  ← 조회조건 + 버튼
   │   │       (layoutControlGroup1 1192×73)
   │   └─ spdMain [FpSpread] Dock=Fill, 1192×192 (Panel1의 74.1%)  ← Main 그리드
   │       └─ spdMain_Sheet1 [SheetView]
   └─ Panel2 (하, 649−259 = 390px ≈ 60.1%. 분할선 폭 포함. SplitterWidth는 props에 없음)
       ├─ panel1 [Panel] Dock=Top, 1192×209
       │   └─ usrLayoutControl3 [UsrLayoutControl] Dock=Fill, 1192×209  ← 요청 상세 폼
       │       (layoutControlGroup3 1192×212)
       ├─ splitter1 [Splitter] Dock=Top, 1192×3
       └─ txtApprovalDeptName [FpSpread] Dock=Fill, 1192×174  ← Detail 그리드
           └─ txtApprovalDeptName_Sheet1 [SheetView]
```
- Panel2 자식 높이의 합은 209 + 3 + 174 = 386입니다. Panel2 높이 390과 4px 차이가 나며, 분할선 폭으로 보입니다(SplitterWidth 값은 props에 없어 **확인 필요**). 비율로 보면 panel1 209/386 ≈ 54.1%, splitter1 0.8%, Detail 그리드 174/386 ≈ 45.1%입니다.
- Dock=Top 컨트롤(panel1, splitter1)이 쌓이는 순서는 z-order로 정해지며 Fact Pack에 없습니다. 크기 합으로 보아 위에서부터 panel1 → splitter1 → Detail 그리드 순서로 보이지만 **확인 필요**입니다.
- `txtApprovalDeptName`은 이름이 txt*이지만 **FpSpread(그리드)**입니다(controls.csv 66).

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────── 1192 ─┐
│ [usrConditionPanel1 / usrLayoutControl1]                        67px  │  ▲
│ Division[clbDivision ▼]  Request Date[drpPeriod ~ ]  From Site[clbFromSite ▼] │  │
│ Status[cboStatus ▼]  Change Type[cboChangeType ▼]                     │  │ Panel1
│ (Requestor)[txtRequest][btnRequestUser] (Model)[txtItemID][btnItemId] │  │ 39.9%
│                      [btnApproval Approval][btnReject Reject][btnSelfReject Self Reject] │
├───────────────────────────────────────────────────────────────────────┤  │
│ spdMain : Shipment Change Request Confirm (헤더 1행)            192px │  ▼
╞═══════════════════════ splitContainer1 분할선 ════════════════════════╡
│ [panel1 / usrLayoutControl3]                                   209px  │  ▲
│  usrLabel2 "Request Confirm Detail"                                   │  │
│  Request No [txtRequestNo                                    ]        │  │
│  (?)[txtTitle]          (?)[txtRequestor]   (?)[txtRequestDeptName]   │  │ Panel2
│  (?)[txtApproval]       (?)[txtAppDeptName] (?)[txtChangeReason]      │  │ 60.1%
│  (?)[txtReasonDetail                                         ]        │  │
│  (?)[txtRejectReason                                         ]        │  │
├──────────────────────── splitter1 (3px) ──────────────────────────────┤  │
│ txtApprovalDeptName : Shipment Change Request Confirm Detail (2단 헤더) 174px │
└───────────────────────────────────────────────────────────────────────┘  ▼
```
- 조회조건 안의 실제 행·열 배치(LayoutControlItem 위치)는 props.csv 잘림 구간에 있어 **확인 필요**입니다. 위 배치는 컨트롤 소속만 보여 줍니다.
- `(?)`는 라벨 원문을 확인하지 못한 항목입니다(§3).

### 2-3. 영역 구분
| 영역 | 컨테이너 | 구성 |
|---|---|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl1 | clbDivision, drpPeriod, clbFromSite, cboStatus, cboChangeType, txtRequest, btnRequestUser, txtItemID, btnItemId |
| 버튼 | usrLayoutControl1 | btnApproval, btnReject, btnSelfReject (+ 프레임워크 FindButton) |
| Main 그리드 | splitContainer1.Panel1 | spdMain / spdMain_Sheet1 |
| 상세 폼 | panel1 > usrLayoutControl3 | usrLabel2, txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtChangeReason, txtReasonDetail, txtRejectReason |
| Detail 그리드 | splitContainer1.Panel2 | txtApprovalDeptName / txtApprovalDeptName_Sheet1 |
| 팝업 | — | BtnRequestUser_Click, btnItemId_Click (팝업 여부와 대상 화면 **확인 필요**) |

---

## 3. 컨트롤 명세

> 라벨 = props.csv Text 원문입니다. LayoutControlItem의 Text는 대응 컨트롤의 라벨로 적었습니다.

| # | 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | splitContainer1 | SplitContainer | — | Horizontal, SplitterDistance 259 | — | — | 상/하 분할 레이아웃 |
| 2 | usrConditionPanel1 | UsrConditionPanel | — | HidePanel, 높이 67 | — | — | 공통 조회조건 패널 |
| 3 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" (컨트롤 자체 Text) | — | — | — | 조회조건 레이아웃 |
| 4 | clbDivision | UsrCheckedList | "Division" (lcDivision) | 확인 필요(GetSSPInnerTable 추정) | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | 다중 선택 콤보(공통) |
| 5 | drpPeriod | UsrDateRangePicker | "Request Date" (layoutControlItem1) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과 (Form_Load) | 확인 필요 | — | 기간(From~To) 공통 컴포넌트 |
| 6 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | 확인 필요 | 확인 필요 | — | 다중 선택 콤보 |
| 7 | cboStatus | UsrCombo | "Status" (LayoutControlItem 이름 PlanType) | 확인 필요 | 확인 필요 | — | 단일 콤보 |
| 8 | cboChangeType | UsrCombo | "Change Type" (LayoutControlItem 이름 PlanType1) | 확인 필요 | 확인 필요 | — | 단일 콤보 |
| 9 | txtRequest | UsrMultiLineEditor | 확인 필요 (LayoutControlItem 이름 `Requestor`, Text 행 미추출) | 빈 값(확인 필요) | 아님(확인 필요) | — | 다중 입력 + 검색 버튼 |
| 10 | btnRequestUser | UsrButton | "layoutControlItem2" (layoutControlItem13 Text, 표시 여부 확인 필요) | — | — | Click → `BtnRequestUser_Click` | 검색 팝업 버튼 |
| 11 | txtItemID | UsrMultiLineEditor | 확인 필요 (LayoutControlItem 이름 `Model`, Text 행 미추출) | 빈 값(확인 필요) | 아님(확인 필요) | — | 다중 입력 + 검색 버튼 |
| 12 | btnItemId | UsrButton | 확인 필요 (layoutControlItem2 Text 미추출) | — | — | Click → `btnItemId_Click` | 검색 팝업 버튼 |
| 13 | btnApproval | SimpleButton | "Approval" (lcBtnApproval Text "layoutControlItem10") | — | — | Click → `BtnApproval_Click` | 화면 버튼(menu-button 동적 조회) |
| 14 | btnReject | SimpleButton | "Reject" (lcBtnReject Text "layoutControlItem10") | — | — | Click → `BtnReject_Click` | 화면 버튼(menu-button 동적 조회) |
| 15 | btnSelfReject | SimpleButton | "Self Reject" (lcSelfReject Text "layoutControlItem10") | — | — | Click → `BtnSelfReject_Click` | 화면 버튼(menu-button 동적 조회) |
| 16 | spdMain | FpSpread | — | 빈 그리드 | — | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid (Main) |
| 17 | spdMain_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm` (CreateSpread:342) | — | — | — | FlexGrid 컬럼 정의(메타) |
| 18 | usrLayoutControl3 | UsrLayoutControl | "usrLayoutControl3" (컨트롤 자체 Text) | — | — | — | 상세 폼 레이아웃 |
| 19 | usrLabel2 | UsrLabel | "Request Confirm Detail" | — | — | — | 섹션 타이틀 |
| 20 | txtRequestNo | TextBox | "Request No" (layoutControlItem5) | CHANGE_REQ_NO (SetChangeRequestInfo 723, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 21 | txtTitle | TextBox | 확인 필요 | REQUEST_TITLE(724, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 22 | txtRequestor | TextBox | 확인 필요 (layoutControlItem4) | REQUEST_USER(725, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 23 | txtRequestDeptName | TextBox | 확인 필요 | REQUEST_DEPT(726, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 24 | txtApproval | TextBox | 확인 필요 (lcApproval) | APPROVAL_USER(727, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 25 | txtAppDeptName | TextBox | 확인 필요 | APPROVAL_DEPT_NAME(730, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 26 | txtChangeReason | TextBox | 확인 필요 | CHANGE_REASON_CODE(728, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 27 | txtReasonDetail | TextBox | 확인 필요 (lcReasonDetail) | CHANGE_REASON_DETAIL(729, 대응 확인 필요) | — | — | 읽기 전용 Input (ReadOnly=true) |
| 28 | txtRejectReason | TextBox | 확인 필요 | 빈 값(확인 필요) | 확인 필요 | — | Input. **ReadOnly 행이 없어 입력 가능 여부 확인 필요** |
| 29 | txtApprovalDeptName | FpSpread | — | 빈 그리드 | — | — | Wijmo FlexGrid (Detail) |
| 30 | txtApprovalDeptName_Sheet1 | SheetView | 시트 `Shipment Change Request Confirm Detail` (CreateSpread:346) | — | — | — | FlexGrid 컬럼 정의(메타, 2단 헤더) |

- props.csv의 크기: clbDivision 246×21, drpPeriod 210×20, clbFromSite 199×21, cboStatus 198×20, cboChangeType 141×20, txtRequest 154×21, txtItemID 136×21, btnRequestUser·btnItemId 39×24, 버튼 3종 105×22, txtRequestNo·txtReasonDetail·txtRejectReason 644×24, txtTitle·txtRequestor·txtApproval 259×24, txtRequestDeptName·txtAppDeptName·txtChangeReason 292×20, usrLabel2 733×20.
- 그 외 Designer 컨트롤: splitter1, panel1, LayoutControlItem 22개, EmptySpaceItem 5개, LayoutControlGroup 2개, imageList1.

---

## 4. 그리드 명세

공통: 컬럼은 `SpreadInfo.SetSheetHeaderColumn`이 메타(SCM_MST_SHEET_COLUMNS)를 읽어 만듭니다. 읽는 메타 컬럼은 COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG, VALID_YN, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG 등입니다.
- **타입**(CELL_CONTROL_OBJECT_TYPE_CODE), **편집 가능 여부**, **표시 순서**는 메타 행 값이 Fact Pack 본문에 없어 모두 **확인 필요**입니다(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv 72행).
- Division별 표시: 14개 division 키 모두 같습니다(아래 "division" 열은 전 division 공통).

### 4-1. `Shipment Change Request Confirm` (spdMain, 헤더 1행 — InitSpread:368)
표시 19 / 숨김 3 / 코드 전용 1

| # | 컬럼 | 헤더(메타 라벨) | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | DIVISION_ID | Division | 확인 필요 | META | 기본(전 division) | 확인 필요 |
| 2 | CHANGE_REQ_NO | Request No | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | REQUEST_TITLE | Title | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | CHANGE_TYPE | Change Type | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | SHIPMENT_STATUS | Status | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | FROM_SITE | From Site | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | TO_SITE | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 기본 | 확인 필요 |
| 11 | REJECT_REASON | Reject Reason | 확인 필요 | META | 기본 | 확인 필요 |
| 12 | REQUEST_USER_NAME | Requestor | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | REQUEST_DEPT | Requestor Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| 14 | REQUEST_TIME | Request Date | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | APPROVAL_USER_NAME | Approval | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | APPROVAL_DEPT | Approval Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | APPROVAL_TIME | Approval Date | 확인 필요 | META | 기본 | 확인 필요 |
| 18 | DELEGATEE_USER_NAME | Delegatee | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | DELEGATEE_DEPT | Delegatee Dept Name | 확인 필요 | META | 기본 | 확인 필요 |
| 20 | REQUEST_USER | Requestor | 확인 필요 | META | 숨김 | — |
| 21 | APPROVAL_USER | Approval | 확인 필요 | META | 숨김 | — |
| 22 | DELEGATEE_USER | Delegatee | 확인 필요 | META | 숨김 | — |
| 23 | ERP_SO_NO | (없음) | — | CODE_ONLY_CHANGE | 값 없음. 코드 분기는 Detail 시트 조건 안에 있어 Main 귀속은 파서 오연결로 보임(**확인 필요**) | — |

### 4-2. `Shipment Change Request Confirm Detail` (txtApprovalDeptName, 헤더 2행 인자 — InitSpread:399)
표시 25(?1) / 숨김 25

| # | 컬럼 | 헤더(메타 라벨) | 코드 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|---|
| 1 | CONFIRM_ID | Confirm ID | — | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | ERP_SO_NO | SO No | — | 확인 필요 | META + HARDCODED(Visible) | 기본 → `_sChangeType=="P"`면 숨김(405) / 그 외 표시(427) | 확인 필요 |
| 3 | FCST_TYPE | FCST Type | — | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | PROJECT_NAME | Project Name | — | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | ITEM_ID | Model | — | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | FROM_SITE_DESCRIPTION | From Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | TO_SITE_DESCRIPTION | To Site | — | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | INCOTERMS | Incoterms | — | 확인 필요 | META | 기본 | 확인 필요 |
| 10 | LT_DAY | L/T(Day) | 1행 L/T(Day) | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 11 | ETD | ETD | 1행 ETD | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 12 | ETA | ETA | 1행 ETA | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 13 | TRANSPORT_MODE | Trans Mode | 1행 Trans Mode | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 14 | SHIPMENT_DATE | Shipment Date | 1행 Shipment Date | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 15 | SHIPMENT_CONFIRM_QTY | Qty | 1행 Qty | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 16 | NEW_LT_DAY | L/T(Day) | 1행 L/T(Day) | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 17 | NEW_ETD | ETD | 1행 ETD | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 18 | NEW_ETA | ETA | 1행 ETA | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 19 | NEW_TRANSPORT_MODE | Trans Mode | 1행 Trans Mode | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요 |
| 20 | NEW_SHIPMENT_DATE | Shipment Date* | 1행 Shipment Date* | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요('*' 표기) |
| 21 | NEW_SHIPMENT_CONFIRM_QTY | Qty* | 1행 Qty* | 확인 필요 | META + HARDCODED(Span) | 기본 | 확인 필요('*' 표기) |
| 22 | NEW_SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 기본 | 확인 필요 |
| 23 | REMARKS | Remarks | — | 확인 필요 | META | 기본 | 확인 필요 |
| 24 | REMARKS2 | Building | — | 확인 필요 | META | 기본 | 확인 필요 |
| 25 | REMARKS3 | Customer requirement | — | 확인 필요 | META | 기본 | 확인 필요 |

숨김 25개(META, 전 division 숨김): A_COUNTRY(A Country), A_PORT_CODE(A Port), BOD_ID(BOD), CHANGE_REQ_NO(change_req_no), CUSTOMER_LT(Customer LT), D_COUNTRY(D Country), D_PORT_CODE(D Port), DIVISION_ID(division), FROM_SITE(From Site), NEW_A_COUNTRY(A Country), NEW_A_PORT_CODE(A Port), NEW_BASE_CONFIRM_YN(NEW_BASE_CONFIRM_YN), NEW_BOD_ID(BOD), NEW_CUSTOMER_LT(Customer LT), NEW_D_COUNTRY(D Country), NEW_D_PORT_CODE(D Port), NEW_INCOTERMS(Incoterms), NEW_ROUTE(Route), NEW_TO_CITY(To City), NEW_TO_COUNTRY(To Country), NEW_YN(new_yn), ROUTE_ID(Route), TO_CITY(To City), TO_COUNTRY(To Country), TO_SITE(To Site).

#### 상단 병합 헤더 (InitSpread, `_sChangeType` 분기)
| 조건 | 0행 Span ① | 0행 Span ② | 1행 Span (RowCount 2, 높이 30) |
|---|---|---|---|
| `_sChangeType == "P"` (405~422) | LT_DAY부터 6칸 "Plan" (높이 20, Center) | NEW_LT_DAY부터 7칸 "Confirm" | 위 표의 1행 라벨 12개 |
| 그 외 (427~444) | LT_DAY부터 7칸 "Confirmed" | NEW_LT_DAY부터 7칸 "Change" | 같은 라벨 12개 |

- AddSheet 인자가 Main은 `1 ¦ 1 ¦ 30`, Detail은 `2 ¦ 1 ¦ 30`입니다. 1행 Span은 RowCount 2입니다. 이 둘로 실제 헤더 행 수가 몇 개인지는 **확인 필요**입니다.
- 6칸과 7칸의 차이, 그리고 Span 범위에 들어가는 컬럼(표시 순서)은 메타 순서가 없어 **확인 필요**입니다.
- Designer에서 두 시트 모두 ColumnHeader 스타일을 지정합니다(General 정렬, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced. 189~192, 837~840).

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls > GetDayRange, FP_Log2 로그 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod 기본 기간 |
| A2 | 조회(프레임워크 FindButton) | FindButton > FindData_Main | 조회조건 수집(GetCheckedListValue ×4) | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | spdMain (`Shipment Change Request Confirm`) |
| A3 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Sub, Delegate_Load (SetChangeRequestInfo로 상세 폼 채움, 호출 위치 확인 필요) | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `SSP.SSP0202_GET_DELEGATEE_LOAD` | txtApprovalDeptName (`Shipment Change Request Confirm Detail`), usrLayoutControl3 상세 폼 |
| A4 | clbDivision 선택 변경 | `ClbDivision_SelectedIndexChanged` | 확인 필요 | 없음 | 확인 필요 |
| A5 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A6 | btnApproval | `BtnApproval_Click` | EngProcessingChk → chkSaveYN → GetErpIFCheck → SaveData → FindData_Main (순서는 flow 나열, 확인 필요) | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 승인 저장 후 spdMain 재조회 |
| A7 | btnReject | `BtnReject_Click` | GetErpIFCheck → SaveData → FindData_Main | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 반려 저장 후 spdMain 재조회 |
| A8 | btnSelfReject | `BtnSelfReject_Click` | GetErpIFCheck → SaveData → FindData_Main | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 자가반려 저장 후 spdMain 재조회 |
| A9 | btnRequestUser | `BtnRequestUser_Click` | 확인 필요(사용자 검색으로 보임) | 없음 | txtRequest(확인 필요) |
| A10 | btnItemId | `btnItemId_Click` | 확인 필요(품목 검색으로 보임) | 없음 | txtItemID(확인 필요) |
| A11 | (진입점 미연결) | SetChangedPeriod | PERIOD_{p:value} 또는 PERIOD_DEFAULT 코드의 FROM_VALUE, TO_VALUE 조회 | `biz:CommonData.CommonDataList` | 기간 값(호출 여부 확인 필요) |

---

## 6. 검증·메시지

| # | 검증 | 위치 | 판정 근거 | 메시지 원문 |
|---:|---|---|---|---|
| V1 | 계획 처리 중 여부 | EngProcessingChk(1090), Approval만 | `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` 결과 | 확인 필요 |
| V2 | SCS Confirm ID 존재 여부 | chkSaveYN(1130), Approval만 | Tables[0].CNT(1141), Tables[1].CNT(1147, 1161) | 확인 필요 |
| V3 | ERP I/F 검사 | GetErpIFCheck(986), 3버튼 공통 | Tables[0].result_code(998) | 확인 필요 |
| V4 | ERP Block | chkERPIFBlockYn(1064, 1073) | BLOCK_YN, PERIOD | 확인 필요(호출 위치도 확인 필요) |
| V5 | 처리 대상 행 선택·상세 조회 여부 | 확인 필요 | 확인 필요 | 확인 필요 |
| V6 | 반려 사유 입력 필수 여부 | 확인 필요 (txtRejectReason ReadOnly 미설정) | 확인 필요 | 확인 필요 |

---

## 7. 권한 (C/R/U/D)

| 구분 | 사실 | 근거 |
|---|---|---|
| R (조회) | FindButton 조회, 더블클릭 상세 조회 | flow.csv |
| U (처리) | btnApproval, btnReject, btnSelfReject → 저장 SP 2종 | flow.csv |
| C / D | 화면에서 직접 행을 추가하거나 삭제하는 버튼은 없습니다. 저장 SP 안에는 INSERT/DELETE SSP_ANL_SHIP_CONFIRM이 있습니다. | endpoints.csv |
| 그룹 | SetChangeControl(209~210): Filter GROUP_ID, USER_ID / NowGroupID. SetChangedControl(327): NowGroupID | meta_reads.csv |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 8행 (C/R/U/D 플래그 값은 **확인 필요**) | Fact Pack §8 |
| 버튼별 활성 제어 | 그룹에 따른 버튼 활성/비활성 여부는 **확인 필요** | — |

---

## 8. To-Be 전환 메모 (React + Wijmo + Oracle)

| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| M1 | 그리드 | FarPoint FpSpread 2개 (Detail 이름이 `txtApprovalDeptName`) | Wijmo FlexGrid 2개. 메타(SCM_MST_SHEET_COLUMNS) 기반 컬럼 생성은 그대로 유지합니다. 컴포넌트 이름은 역할에 맞게 바꾸되, AS-IS 대조표에 원래 이름을 남깁니다. |
| M2 | 2단 병합 헤더 | ColumnHeaderSpan 0행/1행 (`_sChangeType` 분기) | FlexGrid columnHeaders 병합. "P" 분기("Plan" 6칸 / "Confirm" 7칸)와 그 외 분기("Confirmed" / "Change", 각 7칸)를 둘 다 구현합니다. |
| M3 | ERP_SO_NO 표시 | `_sChangeType=="P"`면 숨김 | 상세 조회 시점에 컬럼 visible을 바꿉니다. `_sChangeType` 출처는 확인 필요 |
| M4 | 버튼 | SimpleButton 3종 | 메뉴 버튼 동적 조회(menu-button-dynamic-fetch) 대상. 라벨 원문 "Approval", "Reject", "Self Reject" |
| M5 | 분할 | SplitContainer Horizontal 259/649, 하단 panel1 209 + splitter1 3 + 그리드 174 | 상/하 분할 레이아웃(상단 약 39.9%), 하단은 상세 폼과 Detail 그리드를 나누는 2단 구성 |
| M6 | `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | `STRING_SPLIT` 사용 | Oracle 19c에는 STRING_SPLIT이 없어 대체 분리 함수나 구문이 필요합니다(MSSQL 키워드 잔존 금지 규칙). |
| M7 | 저장 SP | #임시테이블(#T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TBLSSPAPPROVEDMAILSEND) | Oracle GTT 등으로 전환합니다. 세션 안에서 다시 실행할 때 비우는 처리를 함께 검증해야 합니다. |
| M8 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | `SP_SEND_DBMAIL`(MSSQL Database Mail) | Oracle 쪽 메일 발송 수단으로 대체해야 합니다. **확인 필요** |
| M9 | `SSP0202_GET_SCS_CONFIRM_ID_CHECK` | 동적 SQL | Oracle 동적 SQL(EXECUTE IMMEDIATE / OPEN FOR)로 바꾸고 대상 객체를 확인합니다. |
| M10 | 상세 폼 | TextBox 9개(8개 ReadOnly) | 읽기 전용 Input 8개 + txtRejectReason(입력 가능 여부 확인 필요) |
| M11 | 주석 호출 | 877줄, 1262줄 | 구현하지 않습니다. |

---

## 9. 미확정

1. 조회조건 라벨 원문: txtRequest(Requestor), txtItemID(Model), btnItemId, 상세 폼 TextBox 8개(txtTitle, txtRequestor, txtRequestDeptName, txtApproval, txtAppDeptName, txtChangeReason, txtReasonDetail, txtRejectReason). 전체 props.csv로 확인해야 합니다.
2. LayoutControlItem 배치(행·열 위치)와 Dock=Top 쌓임 순서.
3. 그리드 컬럼의 타입·편집 가능 여부·표시 순서(메타 72행 원문).
4. `_sChangeType` 값 출처, Span 6칸과 7칸의 차이.
5. 핸들러 4종(`ClbDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `BtnRequestUser_Click`, `btnItemId_Click`)의 동작.
6. 검증 메시지 원문, `_40`과 일반 저장의 분기 조건, 처리 구분 값.
7. 조회조건 초기값과 GetSSPInnerTable 바인딩 대응.
8. Main 시트 ERP_SO_NO(CODE_ONLY_CHANGE) 행이 파서 오연결인지.
9. 메뉴 위치와 권한 메타 내용.

=== FILE: unit_test.md ===
# SSP0202 Shipment Change Request Confirm — 단위테스트

> 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5의 원문 그대로입니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 Fact Pack으로 값을 확정할 수 없는 부분은 **확인 필요**로 두었습니다. 원문을 확인한 뒤 기대값을 확정해야 합니다.
> 주석 처리된 호출은 테스트 대상에서 뺐습니다. 일반 저장 SP는 875줄의 활성 호출을 근거로 합니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0202-001 | 초기화 | 로그인, SSP0202 메뉴 권한 보유 | 화면을 엽니다 | 없음 | `drpPeriod`에 `SCM0001_GET_SCP_DAY_PERIOD` 결과 기간이 설정됩니다(기간 값 규칙 확인 필요). 오류가 없습니다. | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0202-002 | 초기화 | 기간 SP가 빈 결과 또는 오류를 반환하는 상태 | 화면을 엽니다 | 없음 | 화면이 중단되지 않습니다. `drpPeriod` 처리(빈 값/기본값)는 확인 필요 | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0202-003 | 초기화 | 화면 진입 | `clbDivision`, `clbFromSite`, `cboStatus`, `cboChangeType` 목록을 펼칩니다 | 없음 | 각 목록에 항목이 채워집니다(GetSSPInnerTable 216~246 바인딩 대응 확인 필요) | `Form_Load`, SetChangeControl / GetSSPInnerTable |
| TC-SSP0202-004 | 그리드 | 화면 진입 | `spdMain` 헤더를 확인합니다 | 없음 | 표시 컬럼 19개(Division, Request No, Title, Change Type, Status, From Site, To Site, Model, Nick Name, Change Reason, Reject Reason, Requestor, Requestor Dept Name, Request Date, Approval, Approval Dept Name, Approval Date, Delegatee, Delegatee Dept Name). REQUEST_USER, APPROVAL_USER, DELEGATEE_USER는 숨김. 헤더 1행 | `Shipment Change Request Confirm`, SetSheetHeaderColumn@InitSpread:368 |
| TC-SSP0202-005 | 그리드 | 화면 진입 | `txtApprovalDeptName` 헤더를 확인합니다 | 없음 | 표시 컬럼 25개(Confirm ID, SO No, FCST Type, Project Name, Model, From Site, To Site, ShipTo Code, Incoterms, L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty, NEW_ 6종, ShipTo Code, Remarks, Building, Customer requirement). 숨김 25개는 표시되지 않습니다. | `Shipment Change Request Confirm Detail`, SetSheetHeaderColumn@InitSpread:399 |
| TC-SSP0202-006 | 그리드 | CHANGE_TYPE이 "P"인 요청 존재(`_sChangeType` 출처 확인 필요) | `spdMain`에서 해당 행을 더블클릭합니다 | Change Type = P 행 | `txtApprovalDeptName`의 ERP_SO_NO가 숨김이 됩니다. 상단 헤더는 LT_DAY부터 6칸 "Plan", NEW_LT_DAY부터 7칸 "Confirm" | `Shipment Change Request Confirm Detail`, `SpdMain_CellDoubleClick`, InitSpread 405~422 |
| TC-SSP0202-007 | 그리드 | CHANGE_TYPE이 "P"가 아닌 요청 존재 | `spdMain`에서 해당 행을 더블클릭합니다 | Change Type ≠ P 행 | ERP_SO_NO가 표시됩니다. 상단 헤더는 LT_DAY부터 7칸 "Confirmed", NEW_LT_DAY부터 7칸 "Change" | `Shipment Change Request Confirm Detail`, `SpdMain_CellDoubleClick`, InitSpread 427~444 |
| TC-SSP0202-008 | 조회 | 처리 대상 요청 데이터 존재 | 조회조건을 입력하고 조회 버튼(FindButton)을 누릅니다 | `clbDivision`=보유 division, `drpPeriod`=기본 기간 | `spdMain`에 결과 행이 표시됩니다. 컬럼 값이 SP 결과 컬럼과 일치합니다. | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `Shipment Change Request Confirm` |
| TC-SSP0202-009 | 조회 | 조건에 맞는 데이터 없음 | 조회 버튼을 누릅니다 | `drpPeriod`=데이터 없는 기간 | `spdMain`이 0행입니다. 오류가 없습니다(안내 메시지 여부 확인 필요). | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-010 | 조회 | 다중 선택 가능 | `clbDivision`, `clbFromSite`에서 여러 값을 선택한 뒤 조회합니다 | 2개 이상 선택 | 선택한 값(CODE)이 모두 조건에 반영된 결과가 나옵니다(GetCheckedListValue 593/594/598/600) | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`, `SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-011 | 조회 | 조회 조건 입력 | `cboStatus`, `cboChangeType`, `txtRequest`, `txtItemID`를 각각 지정해 조회합니다 | 상태·변경유형·요청자·모델 값 | 조건별로 필터링된 결과가 나옵니다(파라미터 대응 확인 필요) | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-012 | 조회 | 조회 SP 오류 응답 상태 | 조회 버튼을 누릅니다 | — | 오류 메시지가 표시되고 `spdMain`의 기존 데이터 처리 방식은 확인 필요. 화면이 중단되지 않습니다. | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-013 | 이벤트 | `spdMain`에 조회 결과 있음 | `spdMain` 행을 더블클릭합니다 | 임의 요청 행 | `txtApprovalDeptName`에 상세 행이 표시됩니다 | `SpdMain_CellDoubleClick`, `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-014 | 이벤트 | TC-013과 같음 | 더블클릭한 뒤 상세 폼을 확인합니다 | 임의 요청 행 | `txtRequestNo`, `txtTitle`, `txtRequestor`, `txtRequestDeptName`, `txtApproval`, `txtAppDeptName`, `txtChangeReason`, `txtReasonDetail`에 CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, APPROVAL_DEPT_NAME, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL 값이 표시됩니다(대응 관계 확인 필요). 8개 모두 읽기 전용입니다. | `SpdMain_CellDoubleClick`, SetChangeRequestInfo 723~730 |
| TC-SSP0202-015 | 이벤트 | 위임자가 등록된 요청 | `spdMain` 행을 더블클릭합니다 | 위임 대상 요청 행 | 위임자 정보가 로드됩니다(표시 위치 확인 필요) | `SpdMain_CellDoubleClick`, `SSP.SSP0202_GET_DELEGATEE_LOAD`, `SSP0202_GET_DELEGATEE_LOAD` |
| TC-SSP0202-016 | 이벤트 | 위임자가 없는 요청 | `spdMain` 행을 더블클릭합니다 | 위임자 없는 요청 행 | 빈 결과여도 오류가 없습니다 | `SSP.SSP0202_GET_DELEGATEE_LOAD` |
| TC-SSP0202-017 | 이벤트 | 상세 데이터가 없는 요청(빈 결과) | `spdMain` 행을 더블클릭합니다 | 상세 없는 요청 | `txtApprovalDeptName` 0행, 오류 없음 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-018 | 이벤트 | 화면 진입 | `clbDivision` 선택을 바꿉니다 | division 변경 | 연쇄 동작(예: `clbFromSite` 갱신 여부)은 원문 확인 후 확정. 최소 기준: 오류 없음 | `ClbDivision_SelectedIndexChanged` |
| TC-SSP0202-019 | 이벤트 | `spdMain`에 스크롤이 생길 만큼 행 존재 | `spdMain`을 세로로 스크롤합니다 | — | 동작은 원문 확인 후 확정. 최소 기준: 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0202-020 | 이벤트 | 화면 진입 | `btnRequestUser`를 누릅니다 | — | 검색 동작(팝업 여부)은 확인 필요. 선택 결과가 `txtRequest`에 반영되는지 확인 | `BtnRequestUser_Click` |
| TC-SSP0202-021 | 이벤트 | 화면 진입 | `btnItemId`를 누릅니다 | — | 검색 동작(팝업 여부)은 확인 필요. 선택 결과가 `txtItemID`에 반영되는지 확인 | `btnItemId_Click` |
| TC-SSP0202-022 | 저장 | 승인 대기 요청 상세 조회 완료, 계획 처리 중 아님, ERP I/F 정상 | `btnApproval`을 누릅니다 | 선택 요청 | 검사 3종을 통과하면 저장되고 `spdMain`이 재조회됩니다. 해당 요청 상태가 바뀝니다(상태 값 확인 필요). | `BtnApproval_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-023 | 저장 | 해당 division 계획이 처리 중인 상태 | `btnApproval`을 누릅니다 | 선택 요청 | 계획 처리 중 검사로 저장이 중단되는지 확인합니다(판정 값과 메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` |
| TC-SSP0202-024 | 저장 | SCS Confirm ID 검사에서 CNT가 걸리는 데이터 | `btnApproval`을 누릅니다 | 선택 요청 | Tables[0]/[1]의 CNT 판정에 따라 저장이 중단되거나 확인 절차가 나오는지 확인합니다(임계값·메시지 확인 필요) | `BtnApproval_Click`, `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP0202_GET_SCS_CONFIRM_ID_CHECK` |
| TC-SSP0202-025 | 저장 | ERP I/F 검사에서 result_code가 오류인 데이터 | `btnApproval`을 누릅니다 | 선택 요청 | result_code 판정으로 저장이 중단되는지 확인합니다(값·메시지 확인 필요). SSP_ANL_SHIP_CONFIRM 변경 없음 | `BtnApproval_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| TC-SSP0202-026 | 저장 | `_40` SP 분기 조건을 만족하는 요청(조건 확인 필요) | `btnApproval`을 누릅니다 | 선택 요청 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`이 호출됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ 갱신, SSP_ANL_SHIP_CONFIRM_H 이력 INSERT, 메일 로그(SCM_ADM_SMS_MAIL_SEND_LOG) 생성 여부를 DB에서 확인 | `SaveData`(875), `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0202-027 | 저장 | `_40` 분기 조건을 만족하지 않는 요청 | `btnApproval`을 누릅니다 | 선택 요청 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`이 호출됩니다. SSP_ANL_SHIP_CONFIRM_CHG_REQ 갱신, SSP_ANL_SHIP_CONFIRM_H 이력, XIF_SCS_PACK_SHIP_PLAN_S_SN·DM_PLN_MKT_FCST_CONFIRM 반영 여부를 DB에서 확인 | `SaveData`(875), `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0202-028 | 저장 | 반려 대상 요청 상세 조회 완료 | `txtRejectReason`에 사유를 입력하고 `btnReject`를 누릅니다 | 반려 사유 텍스트 | ERP I/F 검사 후 저장되고 재조회됩니다. 계획 처리·SCS 검사는 호출되지 않습니다. 반려 사유 저장 여부(REJECT_REASON 컬럼)는 확인 필요 | `BtnReject_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-029 | 저장 | 반려 대상 요청, `txtRejectReason` 빈 값 | `btnReject`를 누릅니다 | 반려 사유 없음 | 필수 검증 여부는 확인 필요(차단 또는 저장) | `BtnReject_Click` |
| TC-SSP0202-030 | 저장 | 본인 요청 상세 조회 완료 | `btnSelfReject`를 누릅니다 | 선택 요청 | ERP I/F 검사 후 저장되고 재조회됩니다. 계획 처리·SCS 검사는 호출되지 않습니다. 처리 구분 값은 확인 필요 | `BtnSelfReject_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-031 | 저장 | 저장 SP가 오류를 반환하는 상태 | `btnApproval` / `btnReject` / `btnSelfReject` 중 하나를 누릅니다 | 선택 요청 | 오류 메시지가 표시되고 SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ에 부분 반영이 없는지 확인합니다(롤백 방식 확인 필요) | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0202-032 | 저장 | 처리 대상 행을 선택하지 않음(상세 미조회) | `btnApproval`을 누릅니다 | 없음 | 차단 여부와 메시지는 확인 필요 | `BtnApproval_Click` |
| TC-SSP0202-033 | 저장 | ERP Block 대상 데이터(BLOCK_YN, PERIOD) | 처리 버튼을 누릅니다 | 선택 요청 | chkERPIFBlockYn 판정에 따라 차단되는지 확인(호출 경로·데이터 출처 확인 필요) | chkERPIFBlockYn(1064, 1073) |
| TC-SSP0202-034 | 조회 | SetChangedPeriod 호출 경로 확인 완료(현재 진입점 미연결) | 경로가 확인되면 해당 동작을 수행합니다 | PERIOD_{값} 코드 / PERIOD_DEFAULT | FROM_VALUE, TO_VALUE가 기간에 반영됩니다. 호출되지 않는 코드로 확인되면 이 TC는 NA | `biz:CommonData.CommonDataList`, SetChangedPeriod(1044) |
| TC-SSP0202-035 | division | Division 40 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=40 | `Shipment Change Request Confirm` 19컬럼, `Shipment Change Request Confirm Detail` 25컬럼(ERP_SO_NO는 `_sChangeType`에 따름) | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail`, `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| TC-SSP0202-036 | division | Division 40 요청 | `btnApproval`을 누릅니다 | `clbDivision`=40 요청 | 호출되는 저장 SP가 `_40`인지 일반인지 기록합니다(분기 조건 확인 근거 수집) | `BtnApproval_Click`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| TC-SSP0202-037 | division | Division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC) 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=81 계열 | 두 시트 컬럼 수가 19 / 25로 같습니다 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-038 | division | Division 82 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=82 | 두 시트 컬럼 수가 19 / 25로 같습니다 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-039 | division | Division EE 계열(EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 사용자 | 조회 후 `spdMain` 더블클릭 | `clbDivision`=EE 계열 | 두 시트 컬럼 수가 19 / 25로 같습니다 | `Shipment Change Request Confirm`, `Shipment Change Request Confirm Detail` |
| TC-SSP0202-040 | 권한 | 서로 다른 그룹(NowGroupID) 사용자 2명 | 각 사용자로 화면을 엽니다 | 그룹 A / 그룹 B | 조회조건 목록 등 SetChangeControl 결과가 GROUP_ID, USER_ID 기준으로 달라지는지 확인(차이 내용 확인 필요) | `Form_Load`, SetChangeControl(209~210), SetChangedControl(327) |
| TC-SSP0202-041 | 권한 | TB_FX_GroupMenuAuth 권한이 다른 그룹 | 화면을 열고 `btnApproval`, `btnReject`, `btnSelfReject` 상태를 확인합니다 | 그룹별 | 메뉴 권한에 따른 버튼 표시/활성 여부(메타 8행 내용 확인 필요) | `BtnApproval_Click`, `BtnReject_Click`, `BtnSelfReject_Click` |
| TC-SSP0202-042 | 권한 | 승인자 또는 위임자가 아닌 사용자 | `btnApproval`을 누릅니다 | 타인 승인 대상 요청 | 처리 제한 여부 확인(SSP_MST_DELEGATE 참조, 판정 위치 확인 필요) | `BtnApproval_Click`, `SSP.SSP0202_GET_DELEGATEE_LOAD` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001, 002, 003, 040 |
| 핸들러 | `SpdMain_CellDoubleClick` | 006, 007, 013~017 |
| 핸들러 | `ClbDivision_SelectedIndexChanged` | 018 |
| 핸들러 | `SpdMain_TopChange` | 019 |
| 핸들러 | `BtnApproval_Click` | 022~027, 032, 036, 041, 042 |
| 핸들러 | `BtnReject_Click` | 028, 029, 041 |
| 핸들러 | `BtnSelfReject_Click` | 030, 041 |
| 핸들러 | `BtnRequestUser_Click` | 020 |
| 핸들러 | `btnItemId_Click` | 021 |
| 엔드포인트 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | 008~012, 022, 028, 030, 035 |
| 엔드포인트 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | 013, 017 |
| 엔드포인트 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | 022, 026, 028, 030, 031, 036 |
| 엔드포인트 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | 022, 027, 028, 030, 031, 036 |
| 엔드포인트 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | 025, 028, 030 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 034 |
| 엔드포인트 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | 023 |
| 엔드포인트 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | 024 |
| 엔드포인트 | `SSP.SSP0202_GET_DELEGATEE_LOAD` | 015, 016, 042 |
| 엔드포인트 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 001, 002 |
| 시트 | `Shipment Change Request Confirm` | 004, 008, 035, 037~039 |
| 시트 | `Shipment Change Request Confirm Detail` | 005~007, 013, 017, 035, 037~039 |
| 빈 결과 | — | 002, 009, 016, 017 |
| 오류 응답 | — | 002, 012, 025, 031 |
