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
