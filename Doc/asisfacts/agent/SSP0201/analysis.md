# SSP0201 Shipment Change Request — As-is 분석

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0201)만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> 본문의 줄 번호는 현행(current) 파일 `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.cs` 기준입니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0201 |
| 클래스 | `SSP0201_ShipmentChangeRequest` |
| 도메인 | SSP (프로젝트 경로 `GSCM.SSP.Forms.UIL\Plan`) |
| 메타 시트 | `Shipment Change Request`(spdMain), `Change Request`(spdSub) |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` |
| 컨트롤 수 | 80 (controls.csv) |
| 이벤트 배선 | 18건, 핸들러 17종 (`BtnChangeRe_Click`이 btnChangeRe와 btnChangeRe2 두 버튼에 연결됨) |
| 활성 엔드포인트 | 13종, 호출 지점 22곳 (endpoints.csv) |
| 주석 처리된 호출 | 4건 (활성 집계에서 제외) |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\Properties\AssemblyInfo.cs` | `SSP0201_ShipmentChangeRequest.UIL.csproj` | 37 |
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.cs` | `SSP0201_ShipmentChangeRequest.UIL.csproj` | 5879 |
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.Designer.cs` | `SSP0201_ShipmentChangeRequest.UIL.csproj` | 1732 |
| shared | (없음 — Fact Pack에 shared 구분 파일 없음) | — | — |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0201_ShipmentChangeRequest.cs` | `GSCM.SSP.Plan.UIL.csproj` | 5874 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0201_ShipmentChangeRequest.Designer.cs` | `GSCM.SSP.Plan.UIL.csproj` | 1729 |

- 이 문서는 current 파일 기준입니다. legacy 사본과 current의 차이(.cs 5줄, Designer 3줄)는 무엇이 다른지 Fact Pack에 없어 **확인 필요**입니다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 호출 줄 | 엔드포인트 | 상태 | SP |
|---:|---|---|---:|---|---|---|
| 1 | event:this.Load (`Form_Load`) | Form_Load > InitControls > GetDayRange | 2721 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | SCM0001_GET_SCP_DAY_PERIOD |
| 2 | button:FindButton (조회) | FindButton > FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| 3 | button:FindButton | FindButton > FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| 4 | button:InsertButton (행 추가) | InsertButton > InsertRow | 2455 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | (UP_FX_GetCommonDataList 코드분기) |
| 5 | button:SaveButton (저장) | SaveButton | 780 | `SSP.SSP0201_GET_CHANGE_REQ_NO` | MATCH | SSP0201_GET_CHANGE_REQ_NO |
| 6 | button:SaveButton | SaveButton | 936 | `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | MATCH | SSP0201_SAVE_SHIPMENT_CONFIRM_NEW |
| 7 | button:SaveButton | SaveButton > FindButton > FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| 8 | button:SaveButton | SaveButton > FindData_Main_Nonasync | 1417 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | MATCH | SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N |
| 9 | button:SaveButton | SaveButton > FindButton > FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| 10 | button:SaveButton | SaveButton > GetERPInterface > GetShipmentStatusChk | 3571 | `SSP.SSP0201_GET_SHIPMENT_STATUS` | MATCH | SSP0201_GET_SHIPMENT_STATUS |
| 11 | button:SaveButton | SaveButton > GetERPInterface > GetErpSoNoCnt | 3636 | `SSP.SSP0201_GET_ERP_SO_NO_CNT` | MATCH | SSP0201_GET_ERP_SO_NO_CNT |
| 12 | button:SaveButton | SaveButton > GetNewERPInterface > NewNonSoNo | 3768 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 13 | button:SaveButton | SaveButton > GetERPInterface > NonSoNo | 3939 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 14 | button:SaveButton | SaveButton > GetERPInterface > SoNo | 4163 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 15 | event:btnSave.Click (`BtnSave_Click`) | BtnSave_Click > SaveDataDrafting | 2222 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | MATCH | SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE |
| 16 | event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindButton > FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| 17 | event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindButton > FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| 18 | event:btnChangeRe.Click / btnChangeRe2.Click (`BtnChangeRe_Click`) | BtnChangeRe_Click > SaveDataDrafting | 2222 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | MATCH | SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE |
| 19 | event:btnChangeRe.Click / btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindButton > FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| 20 | event:btnChangeRe.Click / btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindButton > FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| 21 | event:btnCancel.Click (`BtnCancel_Click`) | BtnCancel_Click > DeleteDataDrafting | 2379 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING |
| 22 | event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindButton > FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| 23 | event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindButton > FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| 24 | event:btnNew.Click (`BtnNew_Click`) | BtnNew_Click | 2996 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | — |
| 25 | event:cboChangeType.SelectedIndexChanged (`CboChangeType_SelectedIndexChanged`) | CboChangeType_SelectedIndexChanged > GetDayRange | 2721 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | SCM0001_GET_SCP_DAY_PERIOD |
| 26 | event:this.spdMain.CellClick (`SpdMain_CellClick`) | SpdMain_CellClick | 4677 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH | — |
| 27 | event:this.spdMain.CellClick | SpdMain_CellClick | 4691 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | — |
| 28 | event:this.spdMain.ComboSelChange (`SpdMain_ComboSelChange`) | SpdMain_ComboSelChange | 4815 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | — |
| 29 | event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_BOD | 5840 | `SSP.SSP0026_GET_BOD_ITEM` | MATCH | SSP0026_GET_BOD_ITEM |
| 30 | event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_BOD | 5860 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH | — |
| 31 | event:this.spdMain.ClipboardPasted (`SpdMain_ClipboardPasted`) | SpdMain_ClipboardPasted | 5143 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | — |
| 32 | unreached:(진입점 미연결) | GetErpIFCheck | 4276 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING |

**흐름에서 확인된 사실**
- 이 표의 `FindButton`, `InsertButton`, `SaveButton`은 진입점 종류가 `button`으로 추출되었습니다. 이 버튼들이 프레임워크 툴바 버튼에 연결되는 방식은 Fact Pack에 없어 **확인 필요**입니다.
- 이름은 'Drafting'이지만, `btnSave`("Save Draft")와 `btnChangeRe`/`btnChangeRe2`("Request Complete")가 거치는 `SaveDataDrafting` 메서드는 `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE`를 호출합니다(2222). 반대로 `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`은 `SaveButton` → `GetERPInterface`/`GetNewERPInterface` 경로에서만 호출됩니다(3768, 3939, 4163).
- `GetErpIFCheck`(4276)는 `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING`을 호출하지만 어느 진입점에도 연결되지 않았습니다. 정적 추출 기준으로 진입점이 없으며, 실제로 호출되는지는 **확인 필요**입니다.
- 저장 후 재조회는 `FindData_Main`(비동기 추정, 1325)과 `FindData_Main_Nonasync`(1417, `_N` SP) 두 경로로 갈립니다. 어떤 조건에서 어느 경로를 타는지는 **확인 필요**입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블·객체 (SP 내부 EXEC 전이 포함) |
|---|---|---:|---|---|
| `SSP.SSP0201_GET_CHANGE_REQ_NO` | MATCH | 1 | SSP0201_GET_CHANGE_REQ_NO | EXEC:SSP0201_GET_CHANGE_REQ_NO (추가 참조 객체 추출 없음) |
| `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | MATCH | 1 | SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | INSERT: SSP_ANL_SHIP_CONFIRM, SCM_SYS_LOG_BATCH / SELECT: SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_ITEM_SN, SCM_MST_PROJECT, SSP_PLAN_VERSION_V, SCM_MST_FUTURE_PRICE, SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_CUSTOMER, CTE_DATE / EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, STRING_SPLIT, FN_MULTY_TIME, FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_NEXT_DAY, FN_GET_SSP_ETA_DATE, FN_GET_SSP_ETD_DATE, FN_WEEKOFDAY_DATE |
| `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | 1 | SSP0201_GET_SHIPMENT_CHANGE_REQUEST | DYNAMIC@SSP0201_GET_SHIPMENT_CHANGE_REQUEST (동적 SQL) / REF: FN_GET_IN_STR, FN_SCM_SPLIT |
| `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | MATCH | 1 | SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N | DYNAMIC@SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N (동적 SQL) / REF: FN_GET_IN_STR, FN_SCM_SPLIT |
| `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | 1 | SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | INSERT/SELECT: #TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / SELECT: SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / REF: FN_GET_PROJECT_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO |
| `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | MATCH | 1 | SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | UPDATE: SSP_ANL_SHIP_CONFIRM / MERGE: SSP_ANL_SHIP_CONFIRM_CHG_REQ / INSERT: SCM_SYS_LOG_BATCH, #TBLSSPAPPROVEDMAILSEND, SCM_ADM_SMS_MAIL_SEND_LOG / SELECT: TB_FX_USER, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_ITEM_SN / EXEC: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SCM_SSP_MAIL_SEND, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SP_SEND_DBMAIL / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME |
| `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 2 | SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | UPDATE: SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM / DELETE: SSP_ANL_SHIP_CONFIRM / INSERT: SCM_SYS_LOG_BATCH, XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN / SELECT: SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / EXEC: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO |
| `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | BIZ_MATCH | 5 | — | 코드분기 UP_FX_GetCommonDataList → SELECT: SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE |
| `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH | 2 | — | 코드분기 UP_FX_GetCommonDataList → SELECT: SCP_MST_BOD_V |
| `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SCM0001_GET_SCP_DAY_PERIOD | SELECT: SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE / REF: FN_MULTY_TIME, FN_WEEKOFDAY_DATE |
| `SSP.SSP0201_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0201_GET_SHIPMENT_STATUS | SELECT: SSP_ANL_SHIP_CONFIRM / REF: STRING_SPLIT |
| `SSP.SSP0201_GET_ERP_SO_NO_CNT` | MATCH | 1 | SSP0201_GET_ERP_SO_NO_CNT | SELECT: SSP_ANL_SHIP_CONFIRM |
| `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | MERGE: SSP_ANL_SHIP_CONFIRM_CHG_REQ / INSERT: SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH / UPDATE: SSP_ANL_SHIP_CONFIRM / SELECT: SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M / EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE |
| `SSP.SSP0026_GET_BOD_ITEM` | MATCH | 1 | SSP0026_GET_BOD_ITEM | SELECT: SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM / REF: STRING_SPLIT |

- 엔드포인트 13종 = FoxQuery MATCH 11종 + `biz:CommonData.CommonDataList` 1종(code 2가지: ShipToCodeByDivision, TransMode) + `SCP.SCM0001_GET_SCP_DAY_PERIOD`(SCP 모듈, FoxQuery MATCH, 위 11종에 포함).
- 상태는 MATCH와 BIZ_MATCH뿐이고, 미등록이나 판단불가 상태는 없습니다. Fact Pack §7 확인 필요 항목은 0건입니다.

### 3-1. 주석 처리된 호출 (현행 기능 아님)

| 줄 | 값 | 상태 |
|---:|---|---|
| 1179 | SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | 주석 처리됨 (활성 호출은 936줄에 따로 있음) |
| 1561 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | 주석 처리됨 |
| 1937 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | 주석 처리됨 |
| 2720 | SCP.GET_DATE_RANGE_1MONTH | 주석 처리됨 |

## 4. 이벤트 배선 표

| # | 대상 | 이벤트 | 핸들러 | 배선 위치 | Fact Pack 상 엔드포인트 도달 |
|---:|---|---|---|---|---|
| 1 | this | Load | `Form_Load` | .ctor:288 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` (InitControls > GetDayRange) |
| 2 | clbDivision_ID | SelectedIndexChanged | `clbDivision_ID_SelectedIndexChanged` | InitEvent:360 | 추출된 엔드포인트 없음 |
| 3 | spdMain | TopChange | `SpdMain_TopChange` | InitEvent:361 | 추출된 엔드포인트 없음 |
| 4 | btnApprovalUser | Click | `BtnApprovalUser_Click` | InitEvent:362 | 추출된 엔드포인트 없음 (승인자 선택 동작인지 **확인 필요**) |
| 5 | dsdm | Changed | `shtMain_Change` | InitEvent:365 | 추출된 엔드포인트 없음 (`dsdm` 객체 정체 **확인 필요**) |
| 6 | btnSave | Click | `BtnSave_Click` | InitEvent:370 | SAVE_SHIPMENT_REQUEST_COMPLETE → 재조회 2종 |
| 7 | btnChangeRe | Click | `BtnChangeRe_Click` | InitEvent:371 | SAVE_SHIPMENT_REQUEST_COMPLETE → 재조회 2종 |
| 8 | btnChangeRe2 | Click | `BtnChangeRe_Click` | InitEvent:372 | (7과 같은 핸들러) |
| 9 | btnCancel | Click | `BtnCancel_Click` | InitEvent:375 | DELETE_SHIPMENT_REQUEST_DRAFTING → 재조회 2종 |
| 10 | btnNew | Click | `BtnNew_Click` | InitEvent:376 | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] |
| 11 | this.spdMain | CellClick | `SpdMain_CellClick` | InitEvent:378 | CommonDataList [TransMode], [ShipToCodeByDivision] |
| 12 | this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:379 | 추출된 엔드포인트 없음 |
| 13 | this.spdMain | EditChange | `SpdMain_EditChange` | InitEvent:380 | 추출된 엔드포인트 없음 |
| 14 | this.spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitEvent:381 | CommonDataList [ShipToCodeByDivision] |
| 15 | this.spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:382 | CommonDataList [ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, CommonDataList [TransMode] |
| 16 | this.btnItemId | Click | `btnItemId_Click` | InitEvent:383 | 추출된 엔드포인트 없음 (품목 팝업인지 **확인 필요**) |
| 17 | cboChangeType | SelectedIndexChanged | `CboChangeType_SelectedIndexChanged` | InitEvent:385 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| 18 | spdMain | CursorChanged | `SpdMain_CursorChanged` | InitEvent:387 | 추출된 엔드포인트 없음 |

- "추출된 엔드포인트 없음"은 정적 추출 결과에 그 핸들러에서 출발하는 엔드포인트 경로가 없다는 뜻입니다. 핸들러 내부 로직(값 세팅, 팝업 등)은 Fact Pack에 없어 **확인 필요**입니다.
- `btnDel`("Delete")과 `btnAdd`("Add Date", Visible=false)는 이벤트 배선 표에 없습니다. 클릭 동작이 어디에 연결되는지 **확인 필요**입니다.

## 5. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

| 시트 | 스프레드 | 생성 | 메타 컬럼 생성 | 헤더 행 수 | 연결 규칙 |
|---|---|---|---|---:|---|
| Shipment Change Request | spdMain | `AddSheet` CreateSpread:523 (SpdSheet.shtMain) | `SetSheetHeaderColumn` InitSpread:546 | 1 | META+코드연결 |
| Change Request | spdSub | `AddSheet` CreateSpread:527 (SpdSheet.shtSub), `ChangeSheet` CreateSpread:537 | `SetSheetHeaderColumn` InitSpread:599 | 2 | META+코드연결 |

- 메타 원본은 `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SSP0201)이며 123행입니다. 시트별 메타 행을 세면 Change Request 58행 + Shipment Change Request 65행 = 123으로, §8 DB 메타 행 수와 일치합니다.
- `SetSheetHeaderColumn`이 읽는 메타 컬럼: ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG.

### 5-1. 코드로 바꾸는 표시·라벨 (요약)

| 시트 | 분기 조건 | 변경 | 줄 |
|---|---|---|---|
| Shipment Change Request | `cboChangeType.SelectedValue == "P"` | ERP_SO_NO Width=0, CONFIRM_ID Width=0 | 554, 555 |
| Shipment Change Request | 그 외(≠"P") | CONFIRM_ID Width=120 | 567 |
| Shipment Change Request | `clbDivision_ID.SelectedValue == "40" \|\| "EE"` | END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김 | 578~580 |
| Shipment Change Request | 그 외 division | END_CUSTOMER 숨김, PROJECT_CODE·PROJECT_NAME 표시 | 585~587 |
| Change Request | 무조건 | CHK 체크박스 셀(Value=false, bevel 테두리), REMARKS Width=0 | 608~610, 619 |
| Change Request | ChangeType == "P" | ERP_SO_NO 숨김, 2단 헤더 "Plan"(LT_DAY부터 7열) / "Confirm"(NEW_LT_DAY부터 7열) | 624, 626~641 |
| Change Request | ChangeType ≠ "P" | ERP_SO_NO 표시, 2단 헤더 "Confirmed" / "Change" | 646, 648~663 |
| (행 단위) SetChangeRequestSOGrid | 행 루프 | `CAppSetting.StringAction` 컬럼 숨김(2042), CHK 숨김(2061, 조건: sShipStatus≠"R" 이고 sSearchType=="Exist") | 2042, 2061 |
| spdMain 행 편집 | `SpdMain_ComboSelChange`, DIVISION_ID 컬럼 변경 시 행의 division이 "40"/"EE" | END_CUSTOMER 표시, PROJECT_CODE/NAME 숨김 (그 외 반대) | 4870~4872, 4879~4881 |

### 5-2. Division별 최종 표시 컬럼 수 (grid_effective)

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Change Request | 27 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 27 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) |
| Shipment Change Request | 31 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 31 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) |

- 메타 기본(필수+기본/선택): Change Request 28/0, Shipment Change Request 33/0입니다. 14개 division 모두 같습니다(메타에는 division별 차이가 없음).
- division별 차이는 **코드 분기에서만** 생깁니다. Shipment Change Request에서 40·EE는 END_CUSTOMER 표시, PROJECT_CODE·PROJECT_NAME 숨김(33−2=31)이고, 그 외 division은 END_CUSTOMER 숨김(33−1=32)입니다.
- 정적으로 판단하지 못한 분기는 140건입니다(컬럼 루프·태그 84, 화면 컨트롤값 28, 조회 데이터 28). 모두 런타임에 결정되는 분기입니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `GetErpIFCheck`(4276 → DELETE_SHIPMENT_REQUEST_DRAFTING)가 실제로 호출되는지 | flow.csv unreached |
| 2 | `SaveButton`의 `FindData_Main` 경로와 `FindData_Main_Nonasync` 경로가 갈리는 조건 | flow.csv에 경로 2개 공존 |
| 3 | `SaveButton`의 `GetERPInterface`(SoNo/NonSoNo)와 `GetNewERPInterface`(NewNonSoNo)가 갈리는 조건 | flow.csv |
| 4 | Change Request 시트에 END_CUSTOMER/PROJECT_* 변경이 '?'로 전개된 것이 실제로 적용되는지. 해당 코드(`SpdMain_ComboSelChange`)는 siMain(spdMain)을 대상으로 함 | grid_effective(CODE_ONLY_CHANGE) vs grid_code 4870~4881 |
| 5 | Change Request REMARKS: 메타는 '기본'이지만 코드가 Width=0(619)을 지정함 → 화면에서는 보이지 않을 수 있음 | grid_code 619 |
| 6 | Shipment Change Request ERP_SO_NO/CONFIRM_ID: ChangeType "P"일 때 Width=0 | grid_code 554, 555 |
| 7 | `Data.UserPlantSiteByDivisionOspPack`, `Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP)`, `DataService.GetSSPInnerTable("MyDivision")`이 실제로 호출하는 SP | grid_code SetCellTypeCombo 인자로만 등장하고 endpoints.csv에 없음 |
| 8 | `dtShipmentInputPeriod`(VALUE, Diff_VALUE)와 `dtERPBlockYnIF`(BLOCK_YN, PERIOD)의 데이터 출처 | meta_reads에 사용처만 있음 |
| 9 | `btnDel`/`btnAdd`의 이벤트 연결, `txtItemId`(부모 없음)의 배치 | events.csv 미존재, controls.csv parent 공란 |
| 10 | `dsdm.Changed → shtMain_Change`의 `dsdm` 객체 | events.csv |
| 11 | legacy 사본(GSCM.SSP.Plan.UIL)과 current의 차이 | 파일 줄수만 다름 |
| 12 | `SCM_ADM_LOOKUP_MASTER_DETAIL`(1행)·`_H`(4행)에서 SSP0201 값의 용도 | §8 DB 메타(행 내용 미첨부) |
