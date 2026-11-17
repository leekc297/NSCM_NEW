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
