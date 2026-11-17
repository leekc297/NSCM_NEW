=== FILE: business_analysis.md ===
# SSP0201 Shipment Change Request — 업무분석서

> **근거 범위**: AsisFacts 정적 추출 Fact Pack(SSP0201)과 1차 분석서(analysis.md / web_components.md / tobe_design.md)만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> **기준 파일**: 현행(current) `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.cs`(5,879줄). 본문의 줄 번호는 이 파일 기준입니다.
> **상호 참조**: 이 문서 §5의 엔드포인트 이름은 화면설계서 §5 액션 명세와 단위테스트 '근거' 열에서 그대로 씁니다.
> **주석 처리된 호출 4건**(1179, 1561, 1937, 2720줄)은 현행 기능이 아니므로 본문 업무 규칙과 데이터 흐름에서 뺐습니다(§8-1에 목록만 둡니다).

---

## 1. 업무 목적·범위

### 1-1. 목적
- 화면 클래스 이름 `SSP0201_ShipmentChangeRequest`, 메타 시트 이름 `Shipment Change Request`·`Change Request`, 쓰기 대상 테이블 `SSP_ANL_SHIP_CONFIRM_CHG_REQ`·`SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE`·`SSP_ANL_SHIP_CONFIRM`에서 다음을 확인할 수 있습니다. 이 화면은 **출하 확정(Shipment Confirm) 건의 변경 요청을 작성하고, 요청을 완료하거나 취소하는** 화면입니다.
- 요청 완료 SP(`SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE`)는 메일 발송 객체(`SCM_SSP_MAIL_SEND`, `SCM_ADM_MAIL_SEND`, `SP_SEND_DBMAIL`)와 수신자 테이블(`SCM_ADM_RECIPIENT_LIST/MESSAGE/ASSIGN`)을 참조합니다. 따라서 요청을 완료하면 담당자에게 메일이 나가는 흐름이 있습니다. 수신 대상과 메일 내용 규칙은 **확인 필요**입니다.
- 화면 하단의 요청 정보 영역에는 요청자·승인자·부서·변경 사유 컨트롤이 있습니다(`SetChangeRequestInfo`가 CHANGE_REQ_NO, REQUEST_USER, APPROVAL_USER, CHANGE_REASON_CODE 등을 읽음). 승인 단계가 있다는 근거입니다. 다만 승인 처리 자체를 이 화면에서 하는지는 **확인 필요**입니다(승인 처리 엔드포인트는 추출되지 않았습니다).

### 1-2. 범위

| 구분 | 내용 | 근거 |
|---|---|---|
| 조회 | 상단: 출하 변경 대상 목록 / 하단: 변경 요청(드래프트) 상세 | FindButton → FindData_Main, FindData_Sub_Draft |
| 입력 | 상단 그리드 행 추가(InsertButton, btnNew), 셀 콤보 선택, 붙여넣기 | InsertRow, BtnNew_Click, SpdMain_ComboSelChange, SpdMain_ClipboardPasted |
| 저장(툴바) | 요청번호 채번 → 신규 확정 저장 → ERP 연계 검사 → 드래프트 저장 → 재조회 | SaveButton 경로 |
| 요청 완료 | "Request Complete"(btnChangeRe, btnChangeRe2), "Save Draft"(btnSave) | BtnChangeRe_Click, BtnSave_Click → SaveDataDrafting |
| 요청 취소 | "Cancel"(btnCancel) | BtnCancel_Click → DeleteDataDrafting |
| 범위 밖(확인 필요) | btnDel("Delete"), btnAdd("Add Date", Visible=false): 이벤트 배선이 없음 / `GetErpIFCheck`: 진입점 미연결 | events.csv, flow.csv(unreached) |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---:|---|---|---|
| S1 | 화면을 연다 | `Form_Load` → InitControls → GetDayRange가 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 호출. CreateSpread/InitSpread가 메타(`SCM_MST_SHEET_COLUMNS`, PROGRAM_ID=SSP0201)로 시트 2개 생성 | drpPeriod 기간 기본값 세팅, spdMain(`Shipment Change Request`)과 spdSub(`Change Request`) 헤더 구성 |
| S2 | Change Type(cboChangeType)을 바꾼다 | `CboChangeType_SelectedIndexChanged` → GetDayRange → `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 재계산. 그리드 헤더·컬럼은 "P" 여부에 따라 바뀜(§4-2). 헤더 재구성 시점은 **확인 필요** |
| S3 | Div(clbDivision_ID)를 바꾼다 | `clbDivision_ID_SelectedIndexChanged`(추출된 서버 호출 없음) | InitSpread의 40/EE 분기가 조회조건 Div 값을 기준으로 함(578~587). 이벤트에서 재구성하는지는 **확인 필요** |
| S4 | 조회(툴바 FindButton) | FindData_Main → `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, FindData_Sub_Draft → `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 상단 목록, 하단 변경 요청 상세, 요청자 정보(ds.Tables[1]: USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN) 표시 |
| S5 | 행 추가(툴바 InsertButton) 또는 "NEW"(btnNew) | InsertRow / `BtnNew_Click` → `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | 상단 그리드에 신규 행 추가, Ship to 셀 콤보 세팅(시트 잠금이 풀린 경우만) |
| S6 | 상단 그리드 셀을 클릭한다 | `SpdMain_CellClick` → `biz:CommonData.CommonDataList` [TransMode] / [ShipToCodeByDivision], 헤더 체크박스이면 전체 토글 | 셀 콤보 목록 지연 로딩, 헤더 체크 토글 |
| S7 | 상단 그리드 콤보를 바꾼다 | `SpdMain_ComboSelChange` → `biz:CommonData.CommonDataList` [ShipToCodeByDivision], FindData_BOD → `SSP.SSP0026_GET_BOD_ITEM` → `biz:CommonData.CommonDataList` [TransMode] | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL 값 세팅. DIVISION_ID 컬럼을 바꾸면 END_CUSTOMER/PROJECT_* 표시 전환 |
| S8 | 붙여넣기 | `SpdMain_ClipboardPasted` → `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | 붙여넣은 행의 Ship to 콤보 세팅 |
| S9 | 저장(툴바 SaveButton) | SSP_Main_Validation → `SSP.SSP0201_GET_CHANGE_REQ_NO` → `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` → GetERPInterface(`SSP.SSP0201_GET_SHIPMENT_STATUS`, `SSP.SSP0201_GET_ERP_SO_NO_CNT`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`) 또는 GetNewERPInterface(`SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`) → 재조회(`SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` 또는 `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING`) | 변경 요청 번호 채번, 확정 행 INSERT, 변경 요청(드래프트) MERGE/INSERT, 화면 재조회. 호출 순서와 분기 조건은 **확인 필요**(§8) |
| S10 | "Request Complete"(btnChangeRe / btnChangeRe2) | `BtnChangeRe_Click` → SaveDataDrafting → `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → FindButton 재조회 | 변경 요청 MERGE, 확정 UPDATE, 메일 발송 체인 실행, 재조회 |
| S11 | "Save Draft"(btnSave, Designer Visible=false) | `BtnSave_Click` → SaveDataDrafting → `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | S10과 같은 SP를 호출함(이름은 Draft). 표시 조건과 의도는 **확인 필요** |
| S12 | "Cancel"(btnCancel) | `BtnCancel_Click` → DeleteDataDrafting → `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` → 재조회 | 변경 요청/상세 UPDATE, 확정 UPDATE/DELETE, ERP·SCS 인터페이스 테이블 INSERT, 재조회 |
| S13 | 승인자 선택 버튼(btnApprovalUser) | `BtnApprovalUser_Click`(추출된 서버 호출 없음) | 동작 **확인 필요** (txtApproval/txtAppDeptName 세팅 여부 미확인) |
| S14 | 품목 버튼(btnItemId) | `btnItemId_Click`(추출된 서버 호출 없음) | 동작 **확인 필요** |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입] Form_Load
   └─ InitControls ─ GetDayRange ─▶ SCP.SCM0001_GET_SCP_DAY_PERIOD ─▶ drpPeriod 기본값
   └─ CreateSpread/InitSpread ─▶ spdMain(Shipment Change Request) / spdSub(Change Request) 메타 헤더
        ├─ cboChangeType = "P" ? ERP_SO_NO·CONFIRM_ID Width 0 / 헤더 Plan·Confirm
        │                     : CONFIRM_ID Width 120 / 헤더 Confirmed·Change
        └─ clbDivision_ID = 40 또는 EE ? END_CUSTOMER 표시·PROJECT_* 숨김 : 반대
        │
[조회] FindButton
   ├─ FindData_Main ─▶ SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST ─▶ spdMain
   └─ FindData_Sub_Draft ─▶ SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING ─▶ spdSub + 요청자 정보
        └─ SetChangeRequestSOGrid: 행 루프에서 CHK 숨김(sShipStatus≠"R" 이고 sSearchType=="Exist")
        │
[입력] InsertButton/InsertRow · btnNew(BtnNew_Click) · 셀 클릭/콤보/붙여넣기
   ├─ biz:CommonData.CommonDataList [ShipToCodeByDivision | TransMode]
   └─ (콤보 변경) FindData_BOD ─▶ SSP.SSP0026_GET_BOD_ITEM ─▶ 경로·BOD·국가·항구·L/T 세팅
        │
[저장] SaveButton
   ├─ SSP_Main_Validation(필수 컬럼 검사) · chkERPIFBlockYn(BLOCK_YN, PERIOD)
   ├─ SSP.SSP0201_GET_CHANGE_REQ_NO (요청번호)
   ├─ SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW (확정 INSERT)
   ├─ GetERPInterface
   │    ├─ GetShipmentStatusChk ─▶ SSP.SSP0201_GET_SHIPMENT_STATUS
   │    ├─ GetErpSoNoCnt ─▶ SSP.SSP0201_GET_ERP_SO_NO_CNT (CNT)
   │    └─ SoNo / NonSoNo ─▶ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING
   ├─ GetNewERPInterface ─ NewNonSoNo ─▶ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING
   └─ 재조회: FindButton(…GET_SHIPMENT_CHANGE_REQUEST + …GET_SHIPMENT_REQUEST_DRAFTING)
              또는 FindData_Main_Nonasync ─▶ SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N
        │
[요청 완료] btnChangeRe / btnChangeRe2 / btnSave
   └─ SaveDataDrafting ─▶ SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE (메일 체인) ─▶ 재조회
        │
[요청 취소] btnCancel
   └─ DeleteDataDrafting ─▶ SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING (XIF_* INSERT) ─▶ 재조회
```

- SaveButton 안에서 GetERPInterface와 GetNewERPInterface가 갈리는 조건, FindButton 재조회와 FindData_Main_Nonasync가 갈리는 조건은 정적 추출에 없습니다. 위 그림은 두 경로가 **모두 존재한다**는 사실만 표시합니다(**확인 필요**).

---

## 4. 업무 규칙

### 4-1. 필수값·검증 (SSP_Main_Validation, 저장 전)

| 블록 | 줄 | 검사 컬럼(원문) | 비고 |
|---|---|---|---|
| Validationdr | 3188~3195 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks, TO_SITE_SHIPTO_CODE | |
| SONoValidationdr | 3238~3244 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE | INCOTERMS 검사 없음 |
| SONoValidationdr | 3315~3321 | 위와 같음 | |

- 각 검사의 비교 조건(빈값·0·형식)과 오류 메시지 원문은 Fact Pack에 없습니다. **확인 필요**(원문 대조 대상).
- Validationdr와 SONoValidationdr가 SO 번호 유무로 갈리는 것으로 보이지만, 분기 조건 원문이 없어 **확인 필요**입니다.
- 메타 라벨에 '*'가 붙은 컬럼: Shipment Change Request의 End Customer*, FCST Type*, From Site*, Model*, Project Code*, Shipment Qty*, Shipment Date*, To Site*, Trans Mode* / Change Request의 Shipment Date*, Qty*. 필수 표시로 보이나, 실제 검증 대상과 일치하는지는 **확인 필요**입니다.

### 4-2. Change Type 분기 (cboChangeType, division과 무관)

| 조건 | Shipment Change Request (spdMain) | Change Request (spdSub) | 근거 줄 |
|---|---|---|---|
| `cboChangeType.SelectedValue == "P"` | ERP_SO_NO Width=0, CONFIRM_ID Width=0 | ERP_SO_NO 숨김, 2단 헤더 "Plan"(LT_DAY부터 7열) / "Confirm"(NEW_LT_DAY부터 7열) | 554, 555, 624, 626~641 |
| 그 외 | CONFIRM_ID Width=120 | ERP_SO_NO 표시, 2단 헤더 "Confirmed" / "Change" | 567, 646, 648~663 |

- Change Type 콤보의 코드 목록("P" 외의 값)과 각 값의 업무 의미는 **확인 필요**입니다.

### 4-3. Division 분기
- §6 참조. 비교값은 정확히 `"40"`과 `"EE"`입니다. EE_HD 같은 EE_* 계열은 '그 외'에 속합니다.

### 4-4. 시트 잠금·체크박스 규칙
- 셀 콤보 세팅, 행 추가, 헤더 체크 토글은 `siMain != null && siMain.IsLock(siMain.SheetName) == false`일 때만 동작합니다(InsertRow, BtnNew_Click, SpdMain_CellClick). 잠금이 설정되는 조건은 **확인 필요**입니다.
- 헤더 체크박스(CheckBoxCellType)를 클릭하면, 현재 값이 true면 false로, 아니면 true로 바뀝니다(SpdMain_CellClick 4705, 4740, 4744).
- Change Request의 CHK 컬럼은 체크박스 셀(Value=false, bevel 테두리, 608~610)입니다. SetChangeRequestSOGrid 행 루프에서 `sShipStatus != "R"`이고 `sSearchType == "Exist"`이면 숨깁니다(2061). sShipStatus와 sSearchType의 값 출처는 **확인 필요**입니다.
- Change Request의 REMARKS는 메타에서 '기본' 표시이지만 코드가 Width=0(619)을 지정합니다.

### 4-5. ERP 연계 규칙
- `chkERPIFBlockYn`이 `dtERPBlockYnIF.Rows[0]`의 BLOCK_YN, PERIOD를 읽습니다. ERP I/F 차단 여부·기간 검사로 보이지만, 데이터 출처와 차단 시 동작은 **확인 필요**입니다.
- GetShipmentStatusChk는 `SSP.SSP0201_GET_SHIPMENT_STATUS` 결과 ds.Tables[0], [1], [2]의 CONFIRM_ID를 읽습니다. 세 결과셋의 의미는 **확인 필요**입니다.
- GetErpSoNoCnt는 `SSP.SSP0201_GET_ERP_SO_NO_CNT` 결과 ds.Tables[0].Rows[0]의 CNT를 읽습니다. CNT 값에 따른 분기(SoNo / NonSoNo)는 **확인 필요**입니다.

### 4-6. 날짜·기간 규칙
- 조회 기간(drpPeriod)의 기본값은 GetDayRange(2721) → `SCP.SCM0001_GET_SCP_DAY_PERIOD`로 정합니다. 이 SP는 `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `FN_WEEKOFDAY_DATE`, `FN_MULTY_TIME`을 참조합니다. SP에 넘기는 파라미터와 기간 계산식은 **확인 필요**입니다.
- InitControls가 `dtShipmentInputPeriod.Rows[0]`과 `Rows[1]`의 VALUE, Diff_VALUE를 읽습니다. 입력 가능 기간 규칙으로 보이나 출처와 적용 대상은 **확인 필요**입니다.
- ETA/ETD는 SP 내부 함수 `FN_GET_SSP_ETA_DATE`, `FN_GET_SSP_ETD_DATE`(SAVE_SHIPMENT_CONFIRM_NEW), `FN_GET_SSP_ETA_DATE`(SAVE_SHIPMENT_REQUEST_DRAFTING)로 계산하는 것으로 참조됩니다. 계산식은 **확인 필요**입니다.
- 주/월 버킷 컬럼(동적 날짜 컬럼)은 Fact Pack에서 확인되지 않습니다.

### 4-7. 사용자 그룹 기반 필터
- `UserInfoContext.Current["NowGroupID"]`를 SetChangeControl, SetChangedControl, SaveDataDrafting, InsertRow, BtnNew_Click, SpdMain_ComboSelChange에서 읽습니다.
- SetChangeControl은 Filter에 GROUP_ID, USER_ID를 지정한 뒤 `DataService.GetSSPInnerTable`을 7회 호출합니다(319~349). GetSSPInnerTable이 읽는 메타 컬럼은 CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID입니다. 어떤 그룹이 어떤 결과를 받는지는 **확인 필요**입니다.

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP | 호출 지점(줄) | 읽기(SELECT/REF) | 쓰기(INSERT/UPDATE/MERGE/DELETE) · EXEC |
|---:|---|---|---|---|---|
| 1 | `SSP.SSP0201_GET_CHANGE_REQ_NO` | `SSP0201_GET_CHANGE_REQ_NO` | SaveButton(780) | 추출된 참조 객체 없음 (**확인 필요**) | — |
| 2 | `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | `SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | SaveButton(936) | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_ITEM_SN, SCM_MST_PROJECT, SSP_PLAN_VERSION_V, SCM_MST_FUTURE_PRICE, SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_CUSTOMER, CTE_DATE / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, STRING_SPLIT, FN_MULTY_TIME, FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_NEXT_DAY, FN_GET_SSP_ETA_DATE, FN_GET_SSP_ETD_DATE, FN_WEEKOFDAY_DATE | INSERT: SSP_ANL_SHIP_CONFIRM, SCM_SYS_LOG_BATCH / EXEC: PR_SCM_SYS_LOG_BATCH |
| 3 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | `SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | FindData_Main(1325) | 동적 SQL(DYNAMIC@SSP0201_GET_SHIPMENT_CHANGE_REQUEST, 대상 테이블 **확인 필요**) / REF: FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 4 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | `SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | FindData_Main_Nonasync(1417) | 동적 SQL(DYNAMIC@SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N, 대상 테이블 **확인 필요**) / REF: FN_GET_IN_STR, FN_SCM_SPLIT | — |
| 5 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | `SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | FindData_Sub_Draft(1796) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / REF: FN_GET_PROJECT_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO | 임시 테이블 INSERT/SELECT: #TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 6 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | `SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | SaveDataDrafting(2222) | TB_FX_USER, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_ITEM_SN / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME | UPDATE: SSP_ANL_SHIP_CONFIRM / MERGE: SSP_ANL_SHIP_CONFIRM_CHG_REQ / INSERT: SCM_SYS_LOG_BATCH, #TBLSSPAPPROVEDMAILSEND, SCM_ADM_SMS_MAIL_SEND_LOG / EXEC: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SCM_SSP_MAIL_SEND, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SP_SEND_DBMAIL |
| 7 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | `SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | DeleteDataDrafting(2379) / GetErpIFCheck(4276, 진입점 미연결) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO | UPDATE: SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM / DELETE: SSP_ANL_SHIP_CONFIRM / INSERT: SCM_SYS_LOG_BATCH, XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN / EXEC: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH |
| 8 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | (SP 직접 호출 아님) 코드 분기 `UP_FX_GetCommonDataList` | InsertRow(2455), BtnNew_Click(2996), SpdMain_CellClick(4691), SpdMain_ComboSelChange(4815), SpdMain_ClipboardPasted(5143) — 5회 | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE | — |
| 8' | `biz:CommonData.CommonDataList` [code=TransMode] | (SP 직접 호출 아님) 코드 분기 `UP_FX_GetCommonDataList` | SpdMain_CellClick(4677), FindData_BOD(5860) — 2회 | SCP_MST_BOD_V | — |
| 9 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange(2721) | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE / REF: FN_MULTY_TIME, FN_WEEKOFDAY_DATE | — |
| 10 | `SSP.SSP0201_GET_SHIPMENT_STATUS` | `SSP0201_GET_SHIPMENT_STATUS` | GetShipmentStatusChk(3571) | SSP_ANL_SHIP_CONFIRM / REF: STRING_SPLIT | — |
| 11 | `SSP.SSP0201_GET_ERP_SO_NO_CNT` | `SSP0201_GET_ERP_SO_NO_CNT` | GetErpSoNoCnt(3636) | SSP_ANL_SHIP_CONFIRM | — |
| 12 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | `SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | NewNonSoNo(3768), NonSoNo(3939), SoNo(4163) — 3회 | SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE | MERGE: SSP_ANL_SHIP_CONFIRM_CHG_REQ / INSERT: SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH / UPDATE: SSP_ANL_SHIP_CONFIRM / EXEC: PR_SCM_SYS_LOG_BATCH |
| 13 | `SSP.SSP0026_GET_BOD_ITEM` | `SSP0026_GET_BOD_ITEM` | FindData_BOD(5840) | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM / REF: STRING_SPLIT | — |

- 엔드포인트는 13종입니다(FoxQuery MATCH 12종 + `biz:CommonData.CommonDataList` 1종). biz 엔드포인트는 code 값 2가지(ShipToCodeByDivision, TransMode)로 나뉘어 위 표에서 8/8' 두 행으로 적었습니다. SP는 12개입니다.
- 화면 컨트롤 콤보 소스 중 엔드포인트로 추출되지 않은 것(`Data.UserPlantSiteByDivisionOspPack`, `Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP)`, `DataService.GetSSPInnerTable("MyDivision")`, dtEndCustomer)의 실제 SP는 **확인 필요**입니다.

---

## 6. Division·권한별 변형

### 6-1. Division별 그리드 변형

| Division | Shipment Change Request (spdMain) | Change Request (spdSub) | 근거 |
|---|---|---|---|
| 40, EE | END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김 → **31컬럼(?4)** | **27컬럼(?5)** | InitSpread 578~580, grid_effective |
| 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | END_CUSTOMER 숨김, PROJECT_CODE·PROJECT_NAME 표시 → **32컬럼(?4)** | **28컬럼(?5)** | InitSpread 585~587, grid_effective |

- 메타(`SCM_MST_SHEET_COLUMNS`)에는 division별 차이가 없습니다(14개 division 모두 Change Request 28/0, Shipment Change Request 33/0). 차이는 코드 분기에서만 생깁니다.
- 판정 기준이 두 가지입니다. (1) 조회조건 `clbDivision_ID.SelectedValue`(InitSpread) (2) 행 단위 DIVISION_ID 콤보 변경(`SpdMain_ComboSelChange` 4870~4881, 행의 sDivisionID가 "40"/"EE"면 END_CUSTOMER 표시). (2)는 컬럼 전체의 표시를 바꾸므로, 한 그리드에 여러 division 행이 섞이면 마지막에 바꾼 행 기준으로 표시됩니다. 실제 동작은 **확인 필요**입니다.
- Change Request의 '?' 전개(END_CUSTOMER/PROJECT_*)는 코드가 siMain을 대상으로 하므로 spdSub에 실제로 적용되는지 **확인 필요**입니다.
- TO_SITE_SHIPTO_CODE 콤보 세팅(InsertRow:2457)은 `clbDivision_ID.ControlValues == "40"` 조건 안에 있다고 1차 분석서(tobe_design §3)에 적혀 있습니다. 원문 대조는 **확인 필요**입니다.
- 행 DIVISION_ID 셀 콤보는 `GetSSPInnerTable("MyDivision")`에서 EE를 제외한다고 1차 분석서에 적혀 있습니다(원문 대조 **확인 필요**).

### 6-2. 권한

| 사실 | 근거 |
|---|---|
| 메뉴 그룹 권한 8행 존재(행 내용 미첨부 → C/R/U/D 플래그 **확인 필요**) | dbo.TB_FX_GroupMenuAuth |
| 프로그램/메뉴 등록 각 2행 | dbo.TB_FX_ProgramInfo, dbo.TB_FX_MenuItemInfo |
| 툴바 진입점 FindButton / InsertButton / SaveButton | flow.csv entry_kind=button |
| 사용자 그룹(NowGroupID)·사용자(USER_ID) 필터로 GetSSPInnerTable 결과가 달라짐 | SetChangeControl 312~349 |
| 시트 잠금(IsLock) 시 행 추가·셀 콤보·헤더 체크 미동작 | InsertRow, BtnNew_Click, SpdMain_CellClick |

- 요청자와 승인자에 따라 버튼 활성 여부가 갈리는지는 SetChangeControl/SetChangedControl 본문이 없어 **확인 필요**입니다.

---

## 7. 외부 인터페이스 (Fact Pack에 있는 것만)

| 대상 | 방식 | 호출 경로 | 근거 |
|---|---|---|---|
| ERP | `XIF_ERP_PACK_SHIP_PLAN_S_SN` INSERT, `NERP_CONV_MASTER` SELECT | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` (btnCancel) | endpoints.csv objects |
| SCS | `XIF_SCS_PACK_SHIP_PLAN_S_SN` INSERT | 위와 같음 | endpoints.csv objects |
| 메일 | `SCM_SSP_MAIL_SEND`, `SCM_ADM_MAIL_SEND`, `SP_SEND_DBMAIL` EXEC, `SCM_ADM_SMS_MAIL_SEND_LOG` INSERT | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` (btnChangeRe/btnChangeRe2/btnSave) | endpoints.csv objects |
| 배치 패커 | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER` EXEC | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | endpoints.csv objects |
| ERP 상태 검사 | `SSP.SSP0201_GET_SHIPMENT_STATUS`, `SSP.SSP0201_GET_ERP_SO_NO_CNT` (테이블은 SSP_ANL_SHIP_CONFIRM만 참조) | SaveButton > GetERPInterface | flow.csv |

- 인터페이스 테이블 전송 주기와 수신 측 처리는 Fact Pack에 없습니다(**확인 필요**).

---

## 8. 미확정·확인 필요

| # | 항목 | 필요한 확인 |
|---:|---|---|
| 1 | SaveButton 안에서 GetERPInterface(SoNo/NonSoNo)와 GetNewERPInterface(NewNonSoNo)가 갈리는 조건 | SaveButton 원문 |
| 2 | SaveButton 재조회가 FindButton(`SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`)으로 가는지 FindData_Main_Nonasync(`SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`)로 가는지의 조건 | SaveButton 원문 |
| 3 | btnSave("Save Draft", Visible=false)가 COMPLETE SP를 호출하는 것이 의도된 동작인지, 버튼이 보이게 되는 조건 | SaveDataDrafting 2222 앞뒤, Visible 변경 코드 |
| 4 | `GetErpIFCheck`(4276 → `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`)가 실제로 호출되는지 | 호출처 검색(정적 추출상 진입점 없음) |
| 5 | btnDel("Delete"), btnAdd("Add Date") 동작 / dtDate, txtItemId 용도 | 이벤트 배선 없음, txtItemId parent 공란 |
| 6 | SSP_Main_Validation 검사 조건과 메시지 원문 | 원문 |
| 7 | `SSP.SSP0201_GET_CHANGE_REQ_NO`의 채번 규칙(참조 객체 미추출) | SP 원문 |
| 8 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` / `_N`의 동적 SQL 대상 테이블과 둘의 차이 | SP 원문 |
| 9 | dtShipmentInputPeriod(VALUE, Diff_VALUE), dtERPBlockYnIF(BLOCK_YN, PERIOD), dtEndCustomer의 출처 | 프레임워크/BIZ 추적 |
| 10 | Status(cboStatus), Change Type(cboChangeType), Change Reason(cboChangeReason) 코드 목록 | 콤보 바인딩 원문 |
| 11 | TB_FX_GroupMenuAuth 8행의 그룹별 C/R/U/D 값 | DB 메타 행 내용 |
| 12 | SCM_ADM_LOOKUP_MASTER_DETAIL(1행)·_H(4행)의 SSP0201 값 용도 | DB 메타 행 내용 |
| 13 | legacy 사본(GSCM.SSP.Plan.UIL, .cs 5,874줄 / Designer 1,729줄)과 current의 차이 | diff |
| 14 | 판단불가 분기 140건(컬럼 루프·태그 84, 화면 컨트롤값 28, 조회 데이터 28) | 실행 확인 |

### 8-1. 주석 처리된 호출 (현행 기능 아님 — 업무 규칙·테스트 대상 제외)

| 줄 | 값 |
|---:|---|
| 1179 | SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW (활성 호출은 936줄에 따로 있음) |
| 1561 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| 1937 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| 2720 | SCP.GET_DATE_RANGE_1MONTH |

=== FILE: screen_design.md ===
# SSP0201 Shipment Change Request — 화면설계서

> **근거 범위**: AsisFacts Fact Pack(SSP0201)의 controls.csv, props.csv, events.csv, endpoints.csv, flow.csv, grid_effective.csv, grid_code와 1차 분석서. props.csv가 일부 잘려서(28,634자 생략) 확인하지 못한 라벨·속성은 **확인 필요**로 표시했습니다.
> **상호 참조**: §3 컨트롤명은 단위테스트 '절차' 열에서, §5 엔드포인트는 업무분석서 §5와 단위테스트 '근거' 열에서 같은 이름으로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0201 |
| 화면 명칭 | Shipment Change Request (클래스 `SSP0201_ShipmentChangeRequest`) |
| 도메인 | SSP (`GSCM.SSP.Forms.UIL\Plan`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, 내용 미첨부) |
| 화면 크기(Designer) | splitContainer1 1192×649 |
| 그리드 | spdMain(`Shipment Change Request`, 헤더 1행), spdSub(`Change Request`, 헤더 2행) |
| 그리드 구성 방식 | META(프레임워크, `SetSheetHeaderColumn`) + 코드로 표시/라벨 변경 |
| 컨트롤 수 | 80 (controls.csv) |
| 이벤트 배선 | 18건 / 핸들러 17종 |
| 엔드포인트 | 13종 (호출 지점 22곳) |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv의 SplitContainer + controls.csv의 parent 체인)

```
SSP0201_ShipmentChangeRequest (this)
└─ splitContainer1  [SplitContainer · Dock=Fill · Orientation=Horizontal(상/하) · Size=1192×649 · SplitterDistance=253]
   ├─ Panel1 (상) 253px = 253/649 ≈ 39.0%
   │  ├─ usrConditionPanel1 [UsrConditionPanel · Dock=Top · 1192×69 · UsrPanelType=HidePanel]   69/253 ≈ 27.3%
   │  │  └─ usrLayoutControl1 [UsrLayoutControl · Dock=Fill · 1192×69]  (layoutControlGroup1 1192×72)
   │  │     ├─ txtConfirmId · clbDivision_ID · clbFromSite · txtSoNo · drpPeriod · cboStatus
   │  │     ├─ txtRequest · btnItemId · cboChangeType · clbToSite
   │  │     └─ btnNew · btnChangeRe
   │  └─ spdMain [FpSpread · Dock=Fill · 1192×184]  184/253 ≈ 72.7%
   │     └─ spdMain_Sheet1 → 시트 "Shipment Change Request"
   └─ Panel2 (하) 649−253 = 396px ≈ 61.0%  (자식 높이 합 179+213=392, 4px 차이 = 스플리터 폭인지 확인 필요)
      ├─ panel3 [Panel · Dock=Top · 1192×179]   179/392 ≈ 45.7%
      │  ├─ usrLayoutControl2 [UsrLayoutControl · Dock=Fill · 432×179]  432/1192 ≈ 36.2% (가로)
      │  │  └─ dtDate · btnDel · btnCancel · btnSave · btnAdd · btnChangeRe2   (layoutControlGroup2 432×179)
      │  └─ panel1 [Panel · Dock/Size 확인 필요(props 잘림)]  나머지 760px ≈ 63.8% (추정, 확인 필요)
      │     └─ usrLayoutControl3 [UsrLayoutControl]
      │        └─ txtRequestNo · txtTitle · txtRequestor · txtRequestDeptName · txtApproval · btnApprovalUser
      │           txtAppDeptName · cboChangeReason · txtReasonDetail · usrLabel2
      └─ spdSub [FpSpread · Dock=Fill · 1192×213]   213/392 ≈ 54.3%
         └─ spdSub_Sheet1 → 시트 "Change Request"

(parent 공란) txtItemId [UsrMultiLineEditor] — 배치 확인 필요
(parent 공란) imageList1 [ImageList] — 비가시 컴포넌트
```

- usrLayoutControl2는 Dock=Fill인데 폭이 432입니다. 이는 panel1이 panel3 안에서 좌측 또는 우측에 도킹되어 있다는 뜻으로 보입니다. panel1의 Dock과 Size는 잘린 props에 있어 좌/우 위치와 비율은 **확인 필요**입니다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────────┐ ▲
│ [조회조건 usrConditionPanel1 / usrLayoutControl1]                        69px     │ │
│ Confirm Id[txtConfirmId] Div[clbDivision_ID▼] From Site[clbFromSite☑▼]           │ │ Panel1
│ (SO No[txtSoNo] Visible=false) Shipment Date[drpPeriod ~ ] Status[cboStatus▼]     │ │ 253px
│ (Model)[txtRequest][btnItemId] Change Type[cboChangeType▼] To Site[clbToSite☑▼]  │ │ ≈39.0%
│ [NEW btnNew] [Request Complete btnChangeRe]                                       │ │
├──────────────────────────────────────────────────────────────────────────────────┤ │
│ [spdMain : Shipment Change Request]  헤더 1행                         184px       │ │
│                                                                                  │ ▼
╞══════════════════════════════ splitter (SplitterDistance=253) ══════════════════╡
│ [panel3 179px]                                                                   │ ▲
│ ┌ usrLayoutControl2 432px ─────────┐┌ panel1 / usrLayoutControl3 (위치 확인 필요) ┐│ │
│ │ [Request Complete btnChangeRe2]   ││ Request No[txtRequestNo] Title[txtTitle]   ││ │ Panel2
│ │ [Cancel btnCancel] [Delete btnDel]││ Requestor[txtRequestor] Dept[txtRequestDept││ │ 396px
│ │ (Save Draft btnSave  Vis=false)   ││ Name] Approval[txtApproval][btnApprovalUser││ │ ≈61.0%
│ │ (Add Date btnAdd     Vis=false)   ││ ] App Dept[txtAppDeptName]                 ││ │
│ │ (dtDate              Vis=false)   ││ Change Reason[cboChangeReason▼]            ││ │
│ │                                   ││ Reason Detail[txtReasonDetail] usrLabel2   ││ │
│ └───────────────────────────────────┘└────────────────────────────────────────────┘│ │
├──────────────────────────────────────────────────────────────────────────────────┤ │
│ [spdSub : Change Request]  헤더 2행 (Plan/Confirmed │ Confirm/Change 그룹)  213px │ │
└──────────────────────────────────────────────────────────────────────────────────┘ ▼
```
- 요청 정보 영역(usrLayoutControl3)의 라벨 문구(Request No, Title 등)는 **컨트롤명에서 붙인 임시 표기**입니다. 원문 Text는 잘린 props에 있어 **확인 필요**입니다.
- 조회조건의 행/열 배치는 Designer 선언 순서 기준이며, 실제 좌표 배치는 **확인 필요**입니다.

### 2-3. 영역 구분

| 영역 | 컨테이너 | 구성 |
|---|---|---|
| 조회조건 | usrConditionPanel1 → usrLayoutControl1 | 조회 컨트롤 10개 + btnNew, btnChangeRe |
| 버튼 | usrLayoutControl2 (+ usrLayoutControl1 안의 btnNew, btnChangeRe) | btnChangeRe2, btnCancel, btnDel, btnSave, btnAdd, dtDate |
| 그리드 | spdMain, spdSub | 상단 대상 목록 / 하단 변경 요청 상세 |
| 요청 정보(폼) | panel1 → usrLayoutControl3 | 요청번호, 제목, 요청자, 승인자, 부서, 변경 사유 |
| 팝업 | btnItemId, btnApprovalUser | 팝업을 띄우는지 **확인 필요**(엔드포인트 미추출) |
| 툴바(프레임워크) | FindButton, InsertButton, SaveButton | 프레임워크 툴바 버튼과 연결되는 방식 **확인 필요** |

---

## 3. 컨트롤 명세

> 라벨 = props.csv의 Text 원문(LayoutControlItem.Text 또는 컨트롤 Text). 필수 여부는 Fact Pack에 근거가 없어 모두 **확인 필요**입니다. To-Be 컴포넌트는 Wijmo/React 후보이며 NSCM 공용 컴포넌트 확정이 아닙니다.

| # | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값/속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|
| 1 | spdMain | FarPoint FpSpread | — | Dock=Fill, 1192×184 | — | TopChange→`SpdMain_TopChange`, CellClick→`SpdMain_CellClick`, CellDoubleClick→`SpdMain_CellDoubleClick`, EditChange→`SpdMain_EditChange`, ClipboardPasted→`SpdMain_ClipboardPasted`, ComboSelChange→`SpdMain_ComboSelChange`, CursorChanged→`SpdMain_CursorChanged` | Wijmo FlexGrid |
| 2 | spdMain_Sheet1 | FarPoint SheetView | (시트 `Shipment Change Request`) | AddSheet CreateSpread:523, SetSheetHeaderColumn InitSpread:546 | — | — | FlexGrid columns(메타) |
| 3 | usrConditionPanel1 | UsrConditionPanel | — | Dock=Top, 1192×69, UsrPanelType=HidePanel | — | — | 조회조건 패널(접기 가능) |
| 4 | usrLayoutControl1 | UsrLayoutControl | "usrLayoutControl1" | Dock=Fill, 1192×69 | — | — | 조회조건 레이아웃 |
| 5 | txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 100×21 | 확인 필요 | — | 멀티라인 입력 |
| 6 | clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | 223×20, 목록 출처 확인 필요 | 확인 필요 | SelectedIndexChanged→`clbDivision_ID_SelectedIndexChanged` | ComboBox(단일) |
| 7 | clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | 154×21 | 확인 필요 | — | MultiSelect |
| 8 | txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 100×21, **Visible=false** | 확인 필요 | — | 멀티라인 입력(숨김) |
| 9 | drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | 195×20, 기본값 = `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과 | 확인 필요 | — | InputDate×2(기간) |
| 10 | btnChangeRe | DevExpress SimpleButton | "Request Complete" (항목 lcChgReq, 항목 Text "layoutControlItem10") | 133×22 | — | Click→`BtnChangeRe_Click` | Button |
| 11 | cboStatus | UsrCombo | "Status" (PlanType) | 58×20, 목록 확인 필요 | 확인 필요 | — | ComboBox |
| 12 | txtRequest | UsrMultiLineEditor | 미추출 (항목 이름 `Model`, Text 확인 필요) | 109×21 | 확인 필요 | — | 멀티라인 입력 |
| 13 | btnItemId | UsrButton | 미추출 (layoutControlItem2) | 39×24 | — | Click→`btnItemId_Click` | Button(팝업 호출 후보) |
| 14 | cboChangeType | UsrCombo | "Change Type" (PlanType1) | 20×20, 목록 확인 필요("P" 값 존재) | 확인 필요 | SelectedIndexChanged→`CboChangeType_SelectedIndexChanged` | ComboBox |
| 15 | clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | 271×21 | 확인 필요 | — | MultiSelect |
| 16 | btnNew | UsrButton | "NEW" (항목 layoutControlItem12, 항목 Text "layoutControlItem5") | 98×22 | — | Click→`BtnNew_Click` | Button |
| 17 | spdSub | FarPoint FpSpread | — | Dock=Fill, 1192×213 | — | (배선 없음) | Wijmo FlexGrid |
| 18 | spdSub_Sheet1 | FarPoint SheetView | (시트 `Change Request`) | AddSheet CreateSpread:527, ChangeSheet:537, SetSheetHeaderColumn InitSpread:599 | — | — | FlexGrid columns(메타, 2단 헤더) |
| 19 | usrLayoutControl2 | UsrLayoutControl | "usrLayoutControl2" | Dock=Fill, 432×179 | — | — | 버튼 영역 레이아웃 |
| 20 | dtDate | UsrDatePicker | 미추출 (lcDate, 확인 필요) | 92×20, **Visible=false** | — | — | InputDate(숨김) |
| 21 | btnDel | DevExpress SimpleButton | "Delete" | 92×22 | — | **배선 없음(확인 필요)** | Button |
| 22 | btnCancel | DevExpress SimpleButton | "Cancel" | 93×22 | — | Click→`BtnCancel_Click` | Button |
| 23 | btnSave | DevExpress SimpleButton | "Save Draft" | 92×22, **Visible=false** | — | Click→`BtnSave_Click` | Button(숨김) |
| 24 | btnAdd | DevExpress SimpleButton | "Add Date" | 93×22, **Visible=false** | — | **배선 없음(확인 필요)** | Button(숨김) |
| 25 | btnChangeRe2 | DevExpress SimpleButton | "Request Complete" | 127×22 | — | Click→`BtnChangeRe_Click` | Button |
| 26 | usrLayoutControl3 | UsrLayoutControl | 미추출 | 확인 필요 | — | — | 요청 정보 폼 레이아웃 |
| 27 | txtRequestNo | TextBox | 미추출 (확인 필요) | 바인딩 후보 CHANGE_REQ_NO | 확인 필요 | — | Input(읽기전용 여부 확인 필요) |
| 28 | txtTitle | TextBox | 미추출 (lcTitle) | 바인딩 후보 REQUEST_TITLE | 확인 필요 | — | Input |
| 29 | txtRequestor | TextBox | 미추출 | 바인딩 후보 REQUEST_USER/REQUEST_USER_NAME, 조회 시 ds.Tables[1] USER_NAME 등 | 확인 필요 | — | Input |
| 30 | txtRequestDeptName | TextBox | 미추출 | 바인딩 후보 REQUEST_DEPT/REQUEST_DEPT_NAME | 확인 필요 | — | Input |
| 31 | txtAppDeptName | TextBox | 미추출 (lcAppDept) | 바인딩 후보 APPROVAL_DEPT/APPROVAL_DEPT_NAME | 확인 필요 | — | Input |
| 32 | cboChangeReason | UsrComboBox | 미추출 (lcChangeReason) | 바인딩 후보 CHANGE_REASON_CODE, 목록 확인 필요 | 확인 필요 | — | ComboBox |
| 33 | txtReasonDetail | TextBox | 미추출 (lcReasonDetail) | 바인딩 후보 CHANGE_REASON_DETAIL | 확인 필요 | — | Input / TextArea |
| 34 | btnApprovalUser | UsrButton | 미추출 | — | — | Click→`BtnApprovalUser_Click` | Button(사용자 선택 팝업 후보) |
| 35 | usrLabel2 | UsrLabel | 미추출 | — | — | — | Label |
| 36 | txtApproval | TextBox | 미추출 (lcApproval) | 바인딩 후보 APPROVAL_USER/APPROVAL_USER_NAME | 확인 필요 | — | Input |
| 37 | txtItemId | UsrMultiLineEditor | — | **parent 공란(배치 확인 필요)** | — | — | 확인 필요 |

- 27~36의 바인딩 후보는 `SetChangeRequestInfo`가 dt.Rows[0]에서 읽는 컬럼 이름과 컨트롤 이름이 비슷한 데서 나온 **추정**입니다. 실제 대입 대상은 **확인 필요**입니다(1986~1997).
- 그 밖의 비가시·레이아웃 객체: splitContainer1, panel1, panel3, layoutControlGroup1~3, LayoutControlItem 28개, EmptySpaceItem 8개, imageList1.
- 비컨트롤 이벤트 소스: `dsdm`(Changed→`shtMain_Change`). controls.csv에 없는 객체라 정체는 **확인 필요**입니다.

---

## 4. 그리드 명세

> 출처 META = `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SSP0201, 123행), CODE_ONLY = 메타 행 없이 코드에서만 다루는 컬럼. 컬럼 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE)과 편집 가능 여부(잠금)는 메타 행 값이 Fact Pack에 없어 **확인 필요**입니다(표에는 코드에서 확인된 콤보·체크박스만 적었습니다). 표의 컬럼 순서는 표시 순서가 아닙니다(정렬 컬럼 미첨부, **확인 필요**).

### 4-1. 시트 `Shipment Change Request` (spdMain · 헤더 1행 · 메타 65행 · 기본 표시 33)

**표시 컬럼 (메타 기본 33)**

| 컬럼 | 헤더(메타 라벨) | 타입(코드 확인분) | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| ATTRIBUTE10 | ATTRIBUTE10 | 확인 필요 | META | 전체 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 확인 필요 | META | 전체 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | 확인 필요 | META | 전체 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 확인 필요 | META | 전체 (ChangeType "P" → Width 0, 그 외 Width 120) | 확인 필요 |
| DIVISION_ID | Div | 셀 콤보(GetSSPInnerTable "MyDivision") | META | 전체 | 콤보 선택(ComboSelChange 대상) |
| EDIT_MAIN | EDIT_MAIN | 확인 필요 | META | 전체 | 확인 필요 |
| END_CUSTOMER | End Customer* | 확인 필요(setEndCustomer CODE/NAME) | META + 코드 | **40·EE만 표시** | 확인 필요 |
| ERP_SO_NO | SO No | 확인 필요 | META | 전체 (ChangeType "P" → Width 0) | 확인 필요 |
| ETA | ETA | 확인 필요 | META | 전체 | 확인 필요 |
| ETD | ETD | 확인 필요 | META | 전체 | 확인 필요 |
| FCST_TYPE | FCST Type* | 확인 필요 | META | 전체 | 확인 필요 |
| FROM_SITE | From Site ID | 확인 필요 | META | 전체 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site* | 셀 콤보(Data.UserPlantSiteByDivisionOspPack) | META | 전체 | 콤보 선택 |
| INCOTERMS | Incoterms | 확인 필요(BOD 조회로 세팅) | META | 전체 | 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 전체 | 확인 필요 |
| LT_DAY | L/T(Day) | 확인 필요 | META | 전체 | 확인 필요 |
| MTK_OWNER | MKT Owner | 확인 필요 | META | 전체 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 전체 | 확인 필요 |
| PROJECT_CODE | Project Code* | 확인 필요 | META + 코드 | **40·EE 숨김**, 그 외 표시 | 확인 필요 |
| PROJECT_NAME | Project Name | 확인 필요 | META + 코드 | **40·EE 숨김**, 그 외 표시 | 확인 필요 |
| REMARKS | Remarks | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS2 | Building | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS3 | Customer Requirement | 확인 필요 | META | 전체 | 확인 필요 |
| REQUEST_DATE | Request Date | 확인 필요 | META | 전체 | 확인 필요 |
| REQUESTOR | Shipment Requestor | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date* | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_STATUS | Status | 확인 필요 | META | 전체 | 확인 필요 |
| TO_SITE | To Site ID | 확인 필요 | META | 전체 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site* | 셀 콤보(Data_SCP.Common ShipmentPlanToSite / ToSiteByDivisionEEForSSP) | META | 전체 | 콤보 선택(BOD 조회 트리거 후보) |
| TO_SITE_SHIPTO_CODE | Ship to | 셀 콤보(`biz:CommonData.CommonDataList` [ShipToCodeByDivision]) | META | 전체 | 콤보 선택 |
| TO_SITE_SOLDTO_CODE | Sold to | 확인 필요 | META | 전체 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode* | 셀 콤보(`biz:CommonData.CommonDataList` [TransMode]) | META | 전체 | 콤보 선택 |

**메타 숨김 컬럼 (32)**: BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE

**CODE_ONLY**: CHK(메타 행 없음, grid_effective "→숨김?"). 헤더 체크박스 토글은 `SpdMain_CellClick`에서 처리합니다.

**division별 표시 수**: 40·EE = 31 / 81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC = 32 (각 판단불가 ?4)

### 4-2. 시트 `Change Request` (spdSub · 헤더 2행 · 메타 58행 · 기본 표시 28)

| 컬럼 | 헤더 1행(메타 라벨) | 헤더 0행 그룹 | 타입(코드 확인분) | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|---|
| CHK | ALL | — | 체크박스(Value=false, bevel) | META + 코드 | 전체, 단 SetChangeRequestSOGrid 조건부 숨김(2061) | 체크 가능(조건 확인 필요) |
| CHANGE_REQ_NO | Change Req.No | — | 확인 필요 | META | 전체 | 확인 필요 |
| CONFIRM_ID | Confirm id | — | 확인 필요 | META | 전체 | 확인 필요 |
| ERP_SO_NO | SO No | — | 확인 필요 | META + 코드 | ChangeType "P" → 숨김, 그 외 표시 | 확인 필요 |
| FCST_TYPE | FCST Type | — | 확인 필요 | META | 전체 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | — | 확인 필요 | META | 전체 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | — | 확인 필요 | META | 전체 | 확인 필요 |
| ITEM_ID | Model | — | 확인 필요 | META | 전체 | 확인 필요 |
| NICK_NAME | Nick Name | — | 확인 필요 | META | 전체 | 확인 필요 |
| PROJECT_NAME | Project Name | — | 확인 필요 | META (+ 코드 ?) | grid_effective: 40·EE →숨김?, 그 외 →표시? (적용 여부 확인 필요) | 확인 필요 |
| SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 전체 | 확인 필요 |
| INCOTERMS | Incoterms | — | 확인 필요 | META | 전체 | 확인 필요 |
| LT_DAY | L/T(Day) | "Plan"(P) / "Confirmed"(그 외) 7열 병합 시작 | 확인 필요 | META + 코드 | 전체 | 확인 필요 |
| ETD | ETD | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| ETA | ETA | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_DATE | Shipment Date | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Qty | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_LT_DAY | L/T(Day) | "Confirm"(P) / "Change"(그 외) 7열 병합 시작 | 확인 필요 | META + 코드 | 전체 | 확인 필요 |
| NEW_ETD | ETD | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_ETA | ETA | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_TRANSPORT_MODE | Trans Mode | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_SHIPMENT_DATE | Shipment Date* | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 위 그룹 | 확인 필요 | META | 전체 | 확인 필요 |
| NEW_SHIPTO_CODE | ShipTo Code | — | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS | Remarks | — | 확인 필요 | META + 코드 | **Width=0(619)** — 화면에서는 안 보일 수 있음 | 확인 필요 |
| REMARKS2 | Building | — | 확인 필요 | META | 전체 | 확인 필요 |
| REMARKS3 | Customer requirement | — | 확인 필요 | META | 전체 | 확인 필요 |

**메타 숨김 컬럼 (30)**: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, PROJECT_CODE(코드 →표시? 분기 있음), ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

**CODE_ONLY**: END_CUSTOMER (40·EE →표시?, 그 외 →숨김?)

**division별 표시 수**: 40·EE = 27 / 그 외 12개 = 28 (각 ?5)

- 0행 그룹은 7열 병합인데, 1행 라벨은 그룹마다 6개만 확인됩니다. 7번째 열은 **확인 필요**입니다(메타 정렬 기준 인접 숨김 컬럼일 수 있음).
- SetChangeRequestSOGrid(2042)는 행 루프에서 `CAppSetting.StringAction` 컬럼을 숨깁니다. 대상 컬럼은 **확인 필요**입니다.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드(this.Load) | `Form_Load` | InitControls → GetDayRange, CreateSpread/InitSpread | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod 기본값, 시트 2개 헤더 |
| A2 | 툴바 조회 | FindButton | FindData_Main, FindData_Sub_Draft | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | spdMain, spdSub, 요청자 정보 |
| A3 | 툴바 행 추가 | InsertButton | InsertRow (IsLock=false일 때) | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | spdMain 신규 행, Ship to 콤보 |
| A4 | 툴바 저장 | SaveButton | SSP_Main_Validation → 채번 → 확정 저장 → GetERPInterface / GetNewERPInterface → 재조회 | `SSP.SSP0201_GET_CHANGE_REQ_NO`, `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW`, `SSP.SSP0201_GET_SHIPMENT_STATUS`, `SSP.SSP0201_GET_ERP_SO_NO_CNT`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 상·하 그리드 재조회 (분기 조건 확인 필요) |
| A5 | btnChangeRe "Request Complete" | `BtnChangeRe_Click` | SaveDataDrafting → FindButton | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 요청 완료(메일 체인), 재조회 |
| A6 | btnChangeRe2 "Request Complete" | `BtnChangeRe_Click` | A5와 같음 | A5와 같음 | A5와 같음 |
| A7 | btnSave "Save Draft"(Visible=false) | `BtnSave_Click` | SaveDataDrafting → FindButton | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 2종 | A5와 같음 (의도 확인 필요) |
| A8 | btnCancel "Cancel" | `BtnCancel_Click` | DeleteDataDrafting → FindButton | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` → `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 요청 취소, ERP/SCS I/F INSERT, 재조회 |
| A9 | btnNew "NEW" | `BtnNew_Click` | 신규 행 (IsLock=false, NowGroupID 사용) | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | spdMain 신규 행 |
| A10 | btnApprovalUser | `BtnApprovalUser_Click` | 확인 필요 | 추출 없음 | 확인 필요 |
| A11 | btnItemId | `btnItemId_Click` | 확인 필요 | 추출 없음 | 확인 필요 |
| A12 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | 확인 필요 | 추출 없음 | 확인 필요(40/EE 컬럼 전환과의 관계) |
| A13 | cboChangeType 변경 | `CboChangeType_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod 재계산 |
| A14 | dsdm.Changed | `shtMain_Change` | 확인 필요 | 추출 없음 | 확인 필요 |
| A15 | spdMain TopChange | `SpdMain_TopChange` | 확인 필요 | 추출 없음 | 확인 필요 |
| A16 | spdMain CellClick | `SpdMain_CellClick` | TRANSPORT_MODE / TO_SITE_SHIPTO_CODE 콤보 로딩, 헤더 체크 토글 | `biz:CommonData.CommonDataList` [TransMode], [ShipToCodeByDivision] | 셀 콤보 목록, 체크 상태 |
| A17 | spdMain CellDoubleClick | `SpdMain_CellDoubleClick` | 확인 필요 | 추출 없음 | 확인 필요 |
| A18 | spdMain EditChange | `SpdMain_EditChange` | 확인 필요 | 추출 없음 | 확인 필요 |
| A19 | spdMain ClipboardPasted | `SpdMain_ClipboardPasted` | 붙여넣은 행 콤보 세팅 | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | Ship to 콤보 |
| A20 | spdMain ComboSelChange | `SpdMain_ComboSelChange` | Ship to 콤보, FindData_BOD, DIVISION_ID 변경 시 END_CUSTOMER/PROJECT_* 표시 전환 | `biz:CommonData.CommonDataList` [ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList` [TransMode] | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL 세팅 |
| A21 | spdMain CursorChanged | `SpdMain_CursorChanged` | 확인 필요 | 추출 없음 | 확인 필요 (상·하 연동 여부) |
| A22 | btnDel "Delete" / btnAdd "Add Date" | 배선 없음 | — | — | **확인 필요** |

- `GetErpIFCheck`(4276 → `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`)는 진입점이 없어 액션에 넣지 않았습니다(**확인 필요**).

---

## 6. 검증·메시지

| 검증 | 위치 | 대상 | 메시지 |
|---|---|---|---|
| 저장 전 필수 검사(Validationdr) | SSP_Main_Validation 3188~3195 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks, TO_SITE_SHIPTO_CODE | 확인 필요 |
| 저장 전 필수 검사(SONoValidationdr) | 3238~3244, 3315~3321 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE | 확인 필요 |
| ERP I/F 차단 | chkERPIFBlockYn | BLOCK_YN, PERIOD | 확인 필요 |
| 출하 상태 검사 | GetShipmentStatusChk (`SSP.SSP0201_GET_SHIPMENT_STATUS`) | ds.Tables[0~2] CONFIRM_ID | 확인 필요 |
| SO 건수 검사 | GetErpSoNoCnt (`SSP.SSP0201_GET_ERP_SO_NO_CNT`) | CNT | 확인 필요 |
| 시트 잠금 | InsertRow, BtnNew_Click, SpdMain_CellClick | `siMain.IsLock(siMain.SheetName) == false` | (메시지 없이 동작 생략으로 보임, 확인 필요) |

- 메시지 문구 원문은 Fact Pack에 없습니다. 전환 시 `validation.md`/`__asis-mapping__.md`에 원문을 대조해야 합니다.

---

## 7. 권한 (C/R/U/D) 사실

| 권한 | 관련 진입점 | 사실 |
|---|---|---|
| R | FindButton | 툴바 버튼(entry_kind=button) |
| C | InsertButton, btnNew | 시트 잠금 시 미동작 |
| C/U | SaveButton, btnChangeRe, btnChangeRe2, btnSave | INSERT/MERGE/UPDATE SP 호출 |
| D 성격 | btnCancel | DELETE SP(`SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`) 호출 |
| 그룹 필터 | SetChangeControl 외 | `UserInfoContext.Current["NowGroupID"]`, Filter GROUP_ID/USER_ID |
| 메뉴 권한 | — | TB_FX_GroupMenuAuth 8행(값 **확인 필요**) |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| 항목 | AS-IS | To-Be 고려점 |
|---|---|---|
| 분할 레이아웃 | SplitContainer 상/하 253:396 | 상/하 분할(≈39:61) 유지. 하단은 폼(panel3) + 그리드 |
| 그리드 | FarPoint FpSpread + 메타 SetSheetHeaderColumn | Wijmo FlexGrid + 메타 컬럼 정의(공통 메타 로딩) |
| 2단 헤더 | ColumnHeaderSpan 7열 병합, ChangeType별 문구 | FlexGrid columnHeaders 병합 / 컬럼 그룹. 문구를 ChangeType 값으로 바꿔야 함 |
| 헤더 체크박스 | CheckBoxCellType 헤더 토글 | FlexGrid 헤더 체크박스(전체 선택) |
| 셀 콤보 지연 로딩 | CellClick/ComboSelChange에서 CommonDataList 호출 | DataMap. 로딩 시점(사전/지연)은 설계 결정 필요 |
| 컬럼 Width=0 숨김 | ERP_SO_NO, CONFIRM_ID, REMARKS | Width 0이 아니라 visible=false로 바꿀지 결정 필요(결과 화면 동일성 확인) |
| division 컬럼 전환 | InitSpread·ComboSelChange에서 Visible 전환 | 상태 기반 columns visible 계산 |
| MSSQL → Oracle | STRING_SPLIT, #TMP_*/#TBL* 임시 테이블, 동적 SQL, SP_SEND_DBMAIL, FN_* 함수 | STRING_SPLIT은 Oracle 분할 함수로, 임시 테이블은 GTT 등으로 대체. 동적 SQL은 바인드 변수 전환. 메일 발송 방식은 아키텍처 결정 필요 |
| 다중 결과셋 | GET_SHIPMENT_REQUEST_DRAFTING(Tables[1] 요청자), GET_SHIPMENT_STATUS(Tables[0~2]) | Oracle SYS_REFCURSOR 다중 OUT 또는 API 분리 |
| 숨김 버튼 | btnSave, btnAdd, dtDate, txtSoNo Visible=false | 표시 조건을 확인한 뒤 구현 여부 결정 |

---

## 9. 미확정

1. usrLayoutControl3 안 컨트롤 라벨 원문, panel1의 Dock/Size (props 잘림)
2. txtRequest 라벨(항목 이름 Model), btnItemId·dtDate 라벨
3. txtItemId 배치(parent 공란), dsdm 객체 정체
4. btnDel, btnAdd 동작(배선 없음)
5. btnSave 표시 조건과 COMPLETE SP를 호출하는 의도
6. SaveButton 내부 분기 조건(GetERPInterface / GetNewERPInterface, FindData_Main / FindData_Main_Nonasync)
7. 핸들러 내부 로직 미추출: `clbDivision_ID_SelectedIndexChanged`, `SpdMain_TopChange`, `BtnApprovalUser_Click`, `shtMain_Change`, `SpdMain_CellDoubleClick`, `SpdMain_EditChange`, `btnItemId_Click`, `SpdMain_CursorChanged`
8. 그리드 컬럼 셀 타입·편집 가능 여부·표시 순서(메타 행 값 미첨부)
9. Change Request 2단 헤더 7번째 열, REMARKS Width=0 처리
10. 콤보 목록 출처(cboStatus, cboChangeType, cboChangeReason, clbDivision_ID, clbFromSite, clbToSite)

=== FILE: unit_test.md ===
# SSP0201 Shipment Change Request — 단위테스트

> **근거 범위**: Fact Pack(SSP0201)과 업무분석서·화면설계서. 절차 열의 컨트롤명은 화면설계서 §3 이름을, 근거 열의 엔드포인트·SP·핸들러·시트 이름은 원문 그대로 씁니다.
> 기대결과 중 Fact Pack에 근거가 없는 부분(메시지 문구, 코드 목록 등)은 **확인 필요**로 적었습니다. 이 부분은 AS-IS 실행 결과로 기대값을 확정해야 합니다.
> 주석 처리된 호출 4건(1179, 1561, 1937, 2720줄)과 진입점이 없는 `GetErpIFCheck`는 테스트 케이스로 만들지 않았습니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0201-001 | 초기화 | SSP0201 메뉴 접근 권한이 있는 사용자 로그인 | 화면을 연다 | — | GetDayRange가 서버를 호출하고, drpPeriod에 기간 기본값이 세팅됨 | `Form_Load` > InitControls > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD` / SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0201-002 | 초기화 | TC-001 | 화면을 연 뒤 spdMain, spdSub 헤더를 확인한다 | — | spdMain = 시트 `Shipment Change Request`(헤더 1행), spdSub = 시트 `Change Request`(헤더 2행, ColumnHeaderSpan) | `Form_Load`, CreateSpread:523/527/537, InitSpread:546/599, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-003 | 초기화 | TC-001 | 숨김 컨트롤을 확인한다 | — | txtSoNo, btnSave, btnAdd, dtDate가 보이지 않음(Designer Visible=false). btnChangeRe2, btnCancel, btnDel, btnNew, btnChangeRe는 보임 | props.csv Visible=false (txtSoNo 420, dtDate 993, btnSave 1022, btnAdd 1033), `Form_Load` |
| TC-SSP0201-004 | 초기화(오류) | `SCP.SCM0001_GET_SCP_DAY_PERIOD`가 빈 결과 또는 오류를 반환하도록 설정 | 화면을 연다 | — | 화면이 비정상 종료되지 않음. drpPeriod 값과 오류 메시지는 **확인 필요**(AS-IS 실행으로 기대값 확정) | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0201-005 | 이벤트 | TC-001 | cboChangeType 값을 바꾼다 | 바꾸기 전과 다른 Change Type 값 | GetDayRange가 다시 호출되어 drpPeriod가 재계산됨 | `CboChangeType_SelectedIndexChanged` > GetDayRange, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0201-006 | 그리드 | cboChangeType = "P" | 그리드를 구성(조회)한 뒤 헤더·컬럼을 확인한다 | cboChangeType="P" | `Shipment Change Request`: ERP_SO_NO, CONFIRM_ID Width=0 / `Change Request`: ERP_SO_NO 숨김, 0행 헤더 "Plan"(LT_DAY~7열), "Confirm"(NEW_LT_DAY~7열) | InitSpread 554, 555, 624, 626~641, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-007 | 그리드 | cboChangeType ≠ "P" | 그리드를 구성(조회)한 뒤 헤더·컬럼을 확인한다 | cboChangeType="P"가 아닌 값(목록 확인 필요) | `Shipment Change Request`: CONFIRM_ID Width=120 / `Change Request`: ERP_SO_NO 표시, 0행 헤더 "Confirmed", "Change" | InitSpread 567, 646, 648~663, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-008 | 이벤트 | TC-001 | clbDivision_ID를 다른 Div로 바꾼다 | Div=40 → 81 | 정적 추출상 서버 호출 없음. 화면 반영 내용(그리드 컬럼 재구성, 조회조건 재세팅 등)은 **확인 필요** | `clbDivision_ID_SelectedIndexChanged` (InitEvent:360) |
| TC-SSP0201-009 | 조회 | 조회 대상 출하 확정 데이터가 있음 | clbDivision_ID, clbFromSite, clbToSite, drpPeriod, cboStatus, cboChangeType을 지정하고 툴바 조회를 누른다 | Div=81, 기간=기본값 | spdMain(`Shipment Change Request`)에 목록 표시 | FindButton > FindData_Main, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` / SP `SSP0201_GET_SHIPMENT_CHANGE_REQUEST` |
| TC-SSP0201-010 | 조회 | 변경 요청(드래프트) 데이터가 있음 | 툴바 조회를 누른다 | TC-009와 같음 | spdSub(`Change Request`)에 상세 표시. ds.Tables[1]의 USER_NAME, DEPT_NAME_KO 등 요청자 정보가 txtRequestor/txtRequestDeptName에 반영(대상 컨트롤 확인 필요) | FindButton > FindData_Sub_Draft, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` / SP `SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-011 | 조회(빈 결과) | 조건에 맞는 데이터가 없음 | txtConfirmId에 없는 ID를 넣고 조회한다 | Confirm Id = 존재하지 않는 값 | spdMain, spdSub가 0행. 안내 메시지는 **확인 필요** | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING`, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-012 | 조회(오류) | 조회 SP가 오류를 반환하도록 설정 | 조회한다 | — | 오류 메시지가 표시되고 그리드가 깨지지 않음(문구 **확인 필요**) | FindButton, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` |
| TC-SSP0201-013 | 그리드 | 조회 결과에 SHIPMENT_STATUS가 "R"이 아닌 행이 있고 sSearchType = "Exist" | 조회 후 spdSub CHK 컬럼을 확인한다 | — | 해당 조건에서 CHK 컬럼 숨김(2061). "R"인 경우는 표시 유지 | SetChangeRequestSOGrid 2061, 시트 `Change Request` |
| TC-SSP0201-014 | 저장(행 추가) | spdMain 시트 잠금 해제(IsLock=false) | 툴바 행 추가를 누른다 | clbDivision_ID=40 | spdMain에 신규 행 추가, TO_SITE_SHIPTO_CODE 콤보 세팅 | InsertButton > InsertRow(2455), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-015 | 권한 | spdMain 시트 잠금(IsLock=true) | 툴바 행 추가와 btnNew를 누른다 | — | 행 추가와 콤보 세팅이 동작하지 않음 | InsertRow, `BtnNew_Click`, `siMain.IsLock(siMain.SheetName) == false` 조건 |
| TC-SSP0201-016 | 이벤트 | IsLock=false | btnNew("NEW")를 누른다 | — | spdMain에 신규 행 추가, Ship to 콤보 세팅 | `BtnNew_Click`(2996), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-017 | 저장 | spdMain에 필수 컬럼을 모두 입력한 신규 행이 있음 | 툴바 저장을 누른다 | 필수 컬럼(§업무분석서 4-1) 입력 | 변경 요청 번호가 채번됨 | SaveButton(780), `SSP.SSP0201_GET_CHANGE_REQ_NO` / SP `SSP0201_GET_CHANGE_REQ_NO` |
| TC-SSP0201-018 | 저장 | TC-017 | 저장 후 DB를 확인한다 | — | SSP_ANL_SHIP_CONFIRM에 행 INSERT, SCM_SYS_LOG_BATCH 로그 INSERT | SaveButton(936), `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` / SP `SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` |
| TC-SSP0201-019 | 저장(검증) | spdMain 행의 shipment_confirm_qty 또는 TRANSPORT_MODE 비움 | 툴바 저장을 누른다 | Shipment Qty = 빈값 | 저장이 중단되고 검증 메시지가 표시됨(문구·대상 행 표시 방식 **확인 필요**). SP 호출 없음 | SaveButton > SSP_Main_Validation 3188~3195 / 3238~3244, 시트 `Shipment Change Request` |
| TC-SSP0201-020 | 저장(검증) | Validationdr 경로의 행에서 INCOTERMS 비움 | 저장을 누른다 | INCOTERMS = 빈값 | Validationdr 경로는 INCOTERMS 검사 대상, SONoValidationdr 경로는 아님. 경로 분기 조건 **확인 필요** | SSP_Main_Validation 3188~3195 vs 3238~3244 |
| TC-SSP0201-021 | 저장 | ERP 연계 대상 행이 있음 | 툴바 저장을 누른다 | — | 출하 상태 검사 SP가 호출되고, ds.Tables[0~2]의 CONFIRM_ID로 검사함 | SaveButton > GetERPInterface > GetShipmentStatusChk(3571), `SSP.SSP0201_GET_SHIPMENT_STATUS` / SP `SSP0201_GET_SHIPMENT_STATUS` |
| TC-SSP0201-022 | 저장 | TC-021 | 저장한다 | — | SO 건수 SP가 호출되고 CNT 값을 읽음. CNT에 따른 분기(SoNo/NonSoNo)는 **확인 필요** | SaveButton > GetERPInterface > GetErpSoNoCnt(3636), `SSP.SSP0201_GET_ERP_SO_NO_CNT` / SP `SSP0201_GET_ERP_SO_NO_CNT` |
| TC-SSP0201-023 | 저장 | SO 번호가 있는 행(SoNo 경로) | 저장한다 | ERP_SO_NO 있음 | SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE INSERT, SSP_ANL_SHIP_CONFIRM UPDATE | SaveButton > GetERPInterface > SoNo(4163), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` / SP `SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-024 | 저장 | SO 번호가 없는 행(NonSoNo / NewNonSoNo 경로) | 저장한다 | ERP_SO_NO 없음 | TC-023과 같은 테이블 반영. GetERPInterface/GetNewERPInterface 분기 조건 **확인 필요** | NonSoNo(3939), GetNewERPInterface > NewNonSoNo(3768), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-025 | 저장 | 저장 완료 | 저장 후 재조회를 확인한다 | — | spdMain이 재조회됨(FindData_Main_Nonasync 경로) | SaveButton > FindData_Main_Nonasync(1417), `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` / SP `SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` |
| TC-SSP0201-026 | 저장 | 저장 완료 | FindButton 재조회 경로를 확인한다 | — | spdMain, spdSub 재조회. TC-025와 갈리는 조건은 **확인 필요** | SaveButton > FindButton > FindData_Main / FindData_Sub_Draft, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-027 | 저장(검증) | dtERPBlockYnIF BLOCK_YN이 차단 값 | 저장한다 | BLOCK_YN = 차단 값(값 **확인 필요**) | 저장이 차단되거나 경고가 표시됨(동작·문구 **확인 필요**) | chkERPIFBlockYn (BLOCK_YN, PERIOD) |
| TC-SSP0201-028 | 저장(오류) | 저장 SP가 오류를 반환하도록 설정 | 저장한다 | — | 오류 메시지가 표시되고 재조회 전 상태가 유지됨. 롤백 범위는 **확인 필요** | SaveButton, `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` |
| TC-SSP0201-029 | 이벤트 | spdSub에 드래프트 요청이 있고 usrLayoutControl3 요청 정보(txtTitle, txtApproval, cboChangeReason, txtReasonDetail)가 입력됨 | btnChangeRe("Request Complete", 조회조건 영역)를 누른다 | — | SSP_ANL_SHIP_CONFIRM_CHG_REQ MERGE, SSP_ANL_SHIP_CONFIRM UPDATE, 메일 발송 로그(SCM_ADM_SMS_MAIL_SEND_LOG) INSERT 후 재조회 | `BtnChangeRe_Click` > SaveDataDrafting(2222), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` / SP `SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-030 | 이벤트 | TC-029와 같음 | btnChangeRe2("Request Complete", 버튼 영역)를 누른다 | — | TC-029와 같은 결과 | `BtnChangeRe_Click`(btnChangeRe2.Click, InitEvent:372), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-031 | 이벤트 | TC-029 완료 | 완료 후 그리드를 확인한다 | — | spdMain, spdSub 재조회 | `BtnChangeRe_Click` > SaveDataDrafting > FindButton, `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-032 | 이벤트 | btnSave가 보이는 상태(Designer Visible=false, 표시 조건 **확인 필요**) | btnSave("Save Draft")를 누른다 | — | COMPLETE SP 호출 후 재조회(TC-029와 같은 SP) | `BtnSave_Click` > SaveDataDrafting(2222), `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-033 | 이벤트(오류) | COMPLETE SP가 오류를 반환하도록 설정 | btnChangeRe를 누른다 | — | 오류 메시지가 표시되고 메일이 발송되지 않음(문구 **확인 필요**) | `BtnChangeRe_Click`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| TC-SSP0201-034 | 이벤트 | spdSub에 드래프트 요청이 있고 CHK로 선택함 | btnCancel("Cancel")을 누른다 | CHK 선택 1건 | SSP_ANL_SHIP_CONFIRM_CHG_REQ/_DE UPDATE, SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_PACK_SHIP_PLAN_S_SN·XIF_SCS_PACK_SHIP_PLAN_S_SN INSERT 후 재조회 | `BtnCancel_Click` > DeleteDataDrafting(2379), `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` / SP `SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| TC-SSP0201-035 | 이벤트(빈 선택) | spdSub에서 아무 행도 선택하지 않음 | btnCancel을 누른다 | CHK 선택 0건 | 처리 여부와 안내 메시지는 **확인 필요** | `BtnCancel_Click`, `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`, 시트 `Change Request` |
| TC-SSP0201-036 | 이벤트 | TC-001 | btnApprovalUser를 누른다 | — | 정적 추출상 서버 호출 없음. txtApproval/txtAppDeptName 반영 여부는 **확인 필요** | `BtnApprovalUser_Click` (InitEvent:362) |
| TC-SSP0201-037 | 이벤트 | TC-001 | btnItemId를 누른다 | — | 정적 추출상 서버 호출 없음. txtRequest/txtItemId 반영 여부는 **확인 필요** | `btnItemId_Click` (InitEvent:383) |
| TC-SSP0201-038 | 이벤트 | dsdm 데이터 소스 변경 발생(dsdm 정체 **확인 필요**) | dsdm Changed가 일어나게 한다 | — | 핸들러가 오류 없이 실행됨. 처리 내용은 **확인 필요** | `shtMain_Change` (dsdm.Changed, InitEvent:365) |
| TC-SSP0201-039 | 이벤트 | 조회 결과가 화면보다 많음 | spdMain을 세로로 스크롤한다 | — | 핸들러가 오류 없이 실행됨. 처리 내용은 **확인 필요** | `SpdMain_TopChange` (InitEvent:361), 시트 `Shipment Change Request` |
| TC-SSP0201-040 | 그리드 | IsLock=false, spdMain에 행 존재 | spdMain의 TRANSPORT_MODE 셀을 클릭한다 | — | Trans Mode 콤보 목록 로딩 | `SpdMain_CellClick`(4677), `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0201-041 | 그리드 | IsLock=false | spdMain의 TO_SITE_SHIPTO_CODE 셀을 클릭한다 | — | Ship to 콤보 목록 로딩 | `SpdMain_CellClick`(4691), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-042 | 그리드 | spdMain 행 1건 이상, 헤더에 체크박스 셀 존재 | 헤더 체크박스를 두 번 클릭한다 | — | 1회: 현재 값 반전(true↔false), 2회: 원복 | `SpdMain_CellClick` 4705/4740/4744 |
| TC-SSP0201-043 | 그리드 | spdMain에 행 존재 | spdMain 셀을 더블클릭한다 | — | 핸들러가 오류 없이 실행됨. 처리 내용은 **확인 필요** | `SpdMain_CellDoubleClick` (InitEvent:379) |
| TC-SSP0201-044 | 그리드 | spdMain에 편집 가능한 행 존재 | spdMain 셀 값을 편집한다 | 임의 값 | 핸들러가 오류 없이 실행됨. 행 변경 표시 등 처리 내용은 **확인 필요** | `SpdMain_EditChange` (InitEvent:380) |
| TC-SSP0201-045 | 그리드 | IsLock=false | 엑셀에서 복사한 여러 행을 spdMain에 붙여넣는다 | 2행 | 붙여넣은 행의 Ship to 콤보가 세팅됨 | `SpdMain_ClipboardPasted`(5143), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-046 | 그리드 | spdMain에 행 존재 | 콤보 컬럼 값을 바꾼다 | To Site 변경 | Ship to 콤보 재세팅 | `SpdMain_ComboSelChange`(4815), `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0201-047 | 그리드 | BOD 마스터에 해당 경로 존재 | spdMain에서 BOD 조회를 일으키는 콤보(트리거 컬럼 **확인 필요**)를 바꾼다 | — | 행의 ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL이 채워지고 Trans Mode 콤보가 세팅됨 | `SpdMain_ComboSelChange` > FindData_BOD(5840/5860), `SSP.SSP0026_GET_BOD_ITEM` / SP `SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0201-048 | 그리드(빈 결과) | BOD 마스터에 해당 경로 없음 | TC-047과 같은 조작을 한다 | — | 행 값 세팅 없음. 오류 처리·안내는 **확인 필요** | FindData_BOD, `SSP.SSP0026_GET_BOD_ITEM` |
| TC-SSP0201-049 | 그리드 | spdMain에 행 존재 | spdMain 행의 DIVISION_ID 콤보를 40으로, 다시 81로 바꾼다 | 40 → 81 | 40: END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김 / 81: 반대 | `SpdMain_ComboSelChange` 4870~4872, 4879~4881, 시트 `Shipment Change Request` |
| TC-SSP0201-050 | 그리드 | spdMain에 행 2건 이상 | spdMain에서 다른 행으로 커서를 옮긴다 | — | 핸들러가 오류 없이 실행됨. 하단 spdSub 연동 여부는 **확인 필요** | `SpdMain_CursorChanged` (InitEvent:387) |
| TC-SSP0201-051 | 그리드 | 조회 완료(Div=81, cboChangeType≠"P") | spdMain 표시 컬럼을 메타와 대조한다 | — | 메타 기본 33컬럼 중 END_CUSTOMER 숨김 → 32컬럼. 헤더 라벨은 화면설계서 §4-1과 같음. 메타 숨김 32컬럼은 보이지 않음 | 시트 `Shipment Change Request`, SCM_MST_SHEET_COLUMNS(65행), grid_effective |
| TC-SSP0201-052 | 그리드 | 조회 완료(Div=81, cboChangeType≠"P") | spdSub 표시 컬럼과 2단 헤더를 대조한다 | — | 메타 기본 28컬럼, 0행 "Confirmed"/"Change" 7열 병합, 1행 라벨은 화면설계서 §4-2와 같음. REMARKS는 Width=0이라 보이지 않음 | 시트 `Change Request`, SCM_MST_SHEET_COLUMNS(58행), InitSpread 619 |
| TC-SSP0201-053 | division | clbDivision_ID=40 | 조회 후 두 그리드의 표시 컬럼 수를 센다 | Div=40 | `Shipment Change Request` 31컬럼(END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김), `Change Request` 27컬럼(판단불가 ?4/?5는 실행 확인) | InitSpread 578~580, grid_effective, 시트 `Shipment Change Request`, `Change Request` |
| TC-SSP0201-054 | division | clbDivision_ID=EE | TC-053과 같음 | Div=EE | `Shipment Change Request` 31, `Change Request` 27 | InitSpread 578~580, grid_effective |
| TC-SSP0201-055 | division | clbDivision_ID=81 | TC-053과 같음 | Div=81 | `Shipment Change Request` 32(END_CUSTOMER 숨김, PROJECT_* 표시), `Change Request` 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-056 | division | clbDivision_ID=81_HD | TC-053과 같음 | Div=81_HD | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-057 | division | clbDivision_ID=81_HG | TC-053과 같음 | Div=81_HG | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-058 | division | clbDivision_ID=81_HM | TC-053과 같음 | Div=81_HM | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-059 | division | clbDivision_ID=81_ST | TC-053과 같음 | Div=81_ST | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-060 | division | clbDivision_ID=81_UC | TC-053과 같음 | Div=81_UC | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-061 | division | clbDivision_ID=82 | TC-053과 같음 | Div=82 | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-062 | division | clbDivision_ID=EE_HD | TC-053과 같음 | Div=EE_HD | 32 / 28 (EE_* 계열은 "EE"와 정확히 같지 않으므로 '그 외'에 속함) | InitSpread 585~587, grid_effective |
| TC-SSP0201-063 | division | clbDivision_ID=EE_HG | TC-053과 같음 | Div=EE_HG | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-064 | division | clbDivision_ID=EE_HM | TC-053과 같음 | Div=EE_HM | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-065 | division | clbDivision_ID=EE_ST | TC-053과 같음 | Div=EE_ST | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-066 | division | clbDivision_ID=EE_UC | TC-053과 같음 | Div=EE_UC | 32 / 28 | InitSpread 585~587, grid_effective |
| TC-SSP0201-067 | 권한 | TB_FX_GroupMenuAuth에 등록된 그룹별 계정(8행, 값 **확인 필요**) | 그룹별로 로그인해 조회·행 추가·저장·Request Complete·Cancel을 시도한다 | 그룹별 계정 | 그룹 권한 플래그대로 툴바·버튼이 동작/차단됨(기대값은 행 내용 확인 후 확정) | TB_FX_GroupMenuAuth, FindButton, InsertButton, SaveButton, `BtnChangeRe_Click`, `BtnCancel_Click` |
| TC-SSP0201-068 | 권한 | 서로 다른 NowGroupID를 가진 두 사용자 | 각각 화면을 열어 조회조건 콤보 목록을 비교한다 | — | GetSSPInnerTable(GROUP_ID, USER_ID 필터) 결과에 따라 목록이 다를 수 있음(기대값 **확인 필요**) | SetChangeControl 312~349, `Form_Load` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러(17) | `Form_Load` | 001~004 |
| | `clbDivision_ID_SelectedIndexChanged` | 008 |
| | `SpdMain_TopChange` | 039 |
| | `BtnApprovalUser_Click` | 036 |
| | `shtMain_Change` | 038 |
| | `BtnSave_Click` | 032 |
| | `BtnChangeRe_Click` | 029~031, 033 |
| | `BtnCancel_Click` | 034, 035 |
| | `BtnNew_Click` | 015, 016 |
| | `SpdMain_CellClick` | 040~042 |
| | `SpdMain_CellDoubleClick` | 043 |
| | `SpdMain_EditChange` | 044 |
| | `SpdMain_ClipboardPasted` | 045 |
| | `SpdMain_ComboSelChange` | 046~049 |
| | `btnItemId_Click` | 037 |
| | `CboChangeType_SelectedIndexChanged` | 005 |
| | `SpdMain_CursorChanged` | 050 |
| 엔드포인트(13) | `SSP.SSP0201_GET_CHANGE_REQ_NO` | 017 |
| | `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | 018, 028 |
| | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | 009, 011, 012, 026, 031 |
| | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | 025 |
| | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 010, 011, 026, 031 |
| | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | 029, 030, 032, 033 |
| | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | 034, 035 |
| | `biz:CommonData.CommonDataList` | 014, 016, 040, 041, 045, 046, 047 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 001, 004, 005 |
| | `SSP.SSP0201_GET_SHIPMENT_STATUS` | 021 |
| | `SSP.SSP0201_GET_ERP_SO_NO_CNT` | 022 |
| | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | 023, 024 |
| | `SSP.SSP0026_GET_BOD_ITEM` | 047, 048 |
| 시트(2) | `Shipment Change Request` | 002, 006, 007, 049, 051, 053~066 |
| | `Change Request` | 002, 006, 007, 013, 052, 053~066 |
| division(14) | 40, EE, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | 053~066 |
| 빈 결과 / 오류 | 조회·BOD·취소 빈 결과 / 초기화·조회·저장·완료 오류 | 004, 011, 012, 028, 033, 035, 048 |

- 제외: 주석 처리된 호출 4건(1179 SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW 주석본, 1561, 1937, 2720), 진입점이 없는 `GetErpIFCheck`(4276), 배선이 없는 btnDel·btnAdd.
