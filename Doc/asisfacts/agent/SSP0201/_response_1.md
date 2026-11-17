=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SSP0201 소스 링크 표

> 기준 경로(AS-IS 소스 루트 이하, 루트 위치는 **확인 필요**)
> - CS = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.cs`
> - DS = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.Designer.cs`
> - legacy 사본: `06.UIL\GSCM.SSP.Plan.UIL\SSP0201_ShipmentChangeRequest.cs` / `.Designer.cs` (참고용, 줄 번호는 current 기준)

## 1. 엔드포인트 호출 지점 (endpoints.csv 22건 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | CS | SaveButton | 780 | `SSP.SSP0201_GET_CHANGE_REQ_NO` (fox, MATCH) |
| 2 | CS | SaveButton | 936 | `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` (fox, MATCH) |
| 3 | CS | FindData_Main | 1325 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` (fox, MATCH) |
| 4 | CS | FindData_Main_Nonasync | 1417 | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` (fox, MATCH) |
| 5 | CS | FindData_Sub_Draft | 1796 | `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 6 | CS | SaveDataDrafting | 2222 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` (fox, MATCH) |
| 7 | CS | DeleteDataDrafting | 2379 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 8 | CS | InsertRow | 2455 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] (Data.Common → Data.CallBizCommonData) |
| 9 | CS | GetDayRange | 2721 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` (fox, MATCH) |
| 10 | CS | BtnNew_Click | 2996 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 11 | CS | GetShipmentStatusChk | 3571 | `SSP.SSP0201_GET_SHIPMENT_STATUS` (fox, MATCH) |
| 12 | CS | GetErpSoNoCnt | 3636 | `SSP.SSP0201_GET_ERP_SO_NO_CNT` (fox, MATCH) |
| 13 | CS | NewNonSoNo | 3768 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 14 | CS | NonSoNo | 3939 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 15 | CS | SoNo | 4163 | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH) |
| 16 | CS | GetErpIFCheck | 4276 | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` (fox, MATCH, 진입점 미연결) |
| 17 | CS | SpdMain_CellClick | 4677 | `biz:CommonData.CommonDataList` [code=TransMode] |
| 18 | CS | SpdMain_CellClick | 4691 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 19 | CS | SpdMain_ComboSelChange | 4815 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 20 | CS | SpdMain_ClipboardPasted | 5143 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| 21 | CS | FindData_BOD | 5840 | `SSP.SSP0026_GET_BOD_ITEM` (fox, MATCH) |
| 22 | CS | FindData_BOD | 5860 | `biz:CommonData.CommonDataList` [code=TransMode] |

## 2. 주석 처리된 호출 (주석 처리됨 — 현행 기능 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| CS | 1179 | 주석 처리됨: `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` |
| CS | 1561 | 주석 처리됨: `SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING` |
| CS | 1937 | 주석 처리됨: `SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| CS | 2720 | 주석 처리됨: `SCP.GET_DATE_RANGE_1MONTH` |

## 3. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 288 | `this.Load += Form_Load` |
| CS | InitEvent | 360 | `clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged` |
| CS | InitEvent | 361 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 362 | `btnApprovalUser.Click += BtnApprovalUser_Click` |
| CS | InitEvent | 365 | `dsdm.Changed += shtMain_Change` |
| CS | InitEvent | 370 | `btnSave.Click += BtnSave_Click` |
| CS | InitEvent | 371 | `btnChangeRe.Click += BtnChangeRe_Click` |
| CS | InitEvent | 372 | `btnChangeRe2.Click += BtnChangeRe_Click` |
| CS | InitEvent | 375 | `btnCancel.Click += BtnCancel_Click` |
| CS | InitEvent | 376 | `btnNew.Click += BtnNew_Click` |
| CS | InitEvent | 378 | `this.spdMain.CellClick += SpdMain_CellClick` |
| CS | InitEvent | 379 | `this.spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 380 | `this.spdMain.EditChange += SpdMain_EditChange` |
| CS | InitEvent | 381 | `this.spdMain.ClipboardPasted += SpdMain_ClipboardPasted` |
| CS | InitEvent | 382 | `this.spdMain.ComboSelChange += SpdMain_ComboSelChange` |
| CS | InitEvent | 383 | `this.btnItemId.Click += btnItemId_Click` |
| CS | InitEvent | 385 | `cboChangeType.SelectedIndexChanged += CboChangeType_SelectedIndexChanged` |
| CS | InitEvent | 387 | `spdMain.CursorChanged += SpdMain_CursorChanged` |

## 4. Grid 생성·메타·코드 변경 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 523 | `AddSheet` spdMain, SpdSheet.shtMain = "Shipment Change Request" (1, 1, 30) |
| CS | CreateSpread | 524 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| CS | CreateSpread | 527 | `AddSheet` spdSub, SpdSheet.shtSub = "Change Request" (2, 1, 30) |
| CS | CreateSpread | 528 | `GetSheetInfo(spdSub.Name, SpdSheet.shtSub)` |
| CS | CreateSpread | 537 | `ChangeSheet` |
| CS | InitSpread | 544 / 546 | `InitSheet`, `SetSheetHeaderColumn(spreadInfo, 1)` — Shipment Change Request |
| CS | InitSpread | 554, 555 | ChangeType "P": ERP_SO_NO, CONFIRM_ID Width=0 |
| CS | InitSpread | 567 | ChangeType ≠ "P": CONFIRM_ID Width=120 |
| CS | InitSpread | 578~580 | Div 40/EE: END_CUSTOMER 표시, PROJECT_CODE/PROJECT_NAME 숨김 |
| CS | InitSpread | 585~587 | 그 외 Div: END_CUSTOMER 숨김, PROJECT_CODE/PROJECT_NAME 표시 |
| CS | InitSpread | 596 / 599 | `InitSheet`, `SetSheetHeaderColumn(spreadInfo, 2)` — Change Request |
| CS | InitSpread | 608~610 | CHK CellType=체크박스, Value=false, Border=bevel |
| CS | InitSpread | 619 | REMARKS Width=0 |
| CS | InitSpread | 624 / 626~641 | "P": ERP_SO_NO 숨김, ColumnHeaderSpan "Plan"/"Confirm" + 2행 헤더 |
| CS | InitSpread | 646 / 648~663 | ≠"P": ERP_SO_NO 표시, ColumnHeaderSpan "Confirmed"/"Change" + 2행 헤더 |
| CS | EditButton | 701 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` (fps.Name=="spdMain" 이고 siSub 행이 0일 때) |
| CS | SetChangeRequestSOGrid | 2035 | `GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex)` |
| CS | SetChangeRequestSOGrid | 2042 | `CAppSetting.StringAction` 컬럼 Visible=false |
| CS | SetChangeRequestSOGrid | 2061 | CHK Visible=false (sShipStatus≠"R" 이고 sSearchType=="Exist") |
| CS | InsertRow | 2457 | SetCellTypeCombo TO_SITE_SHIPTO_CODE ← ShipToCodeByDivision (`clbDivision_ID.ControlValues == "40"`) |
| CS | InsertRow | 2488 | SetCellTypeCombo FROM_SITE_DESCRIPTION ← Data.UserPlantSiteByDivisionOspPack |
| CS | InsertRow | 2489 | SetCellTypeCombo TO_SITE_DESCRIPTION ← Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP) |
| CS | InsertRow | 2521 | SetCellTypeCombo DIVISION_ID ← GetSSPInnerTable("MyDivision"), CODE≠"EE" |
| CS | BtnNew_Click | 2969, 2998, 3000, 3001, 3007 | SetCellTypeCombo DIVISION_ID / TO_SITE_SHIPTO_CODE / FROM_SITE_DESCRIPTION / TO_SITE_DESCRIPTION / DIVISION_ID |
| CS | SpdMain_CellClick | 4679 | SetCellTypeCombo TRANSPORT_MODE ← Data.Common(TransMode) |
| CS | SpdMain_CellClick | 4693 | SetCellTypeCombo TO_SITE_SHIPTO_CODE ← ShipToCodeByDivision |
| CS | SpdMain_CellClick | 4705, 4740, 4744 | 헤더 체크박스 Value 토글 |
| CS | SpdMain_ComboSelChange | 4817 | SetCellTypeCombo TO_SITE_SHIPTO_CODE (TO_SITE_DESCRIPTION 변경이고 sItemId가 있을 때) |
| CS | SpdMain_ComboSelChange | 4852 | SetCellTypeCombo FROM_SITE_DESCRIPTION (DIVISION_ID 변경 시) |
| CS | SpdMain_ComboSelChange | 4870~4872, 4879~4881 | 행 Div 40/EE 여부에 따른 END_CUSTOMER / PROJECT_CODE / PROJECT_NAME 표시 전환 |

## 5. 메타·데이터 컬럼 읽기 지점 (주요)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 312, 313 | Filter GROUP_ID ← UserInfoContext NowGroupID, Filter USER_ID |
| CS | SetChangeControl | 319, 324, 329, 334, 339, 344, 349 | `DataService.GetSSPInnerTable` 호출 7회 |
| CS | InitControls | 419, 428 | `DataService.FP_Log2` |
| CS | InitControls | 445 | `c["CODE"]` |
| CS | InitControls | 490~493 | dtShipmentInputPeriod.Rows[0/1] VALUE, Diff_VALUE |
| CS | SetChangedControl | 503 / 506, 507 | GetCheckedListValue / NowGroupID |
| CS | SaveButton | 795 | GetCheckedListValue |
| CS | FindData_Main | 1303~1307 | GetCheckedListValue 5회 |
| CS | FindData_Main_Nonasync | 1395 | GetCheckedListValue |
| CS | FindData_Sub_Draft | 1841~1851 | ds.Tables[1].Rows[0] USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN |
| CS | SetChangeRequestInfo | 1986~1997 | dt.Rows[0] CHANGE_REQ_NO ~ APPROVAL_DEPT_NAME (12개 컬럼) |
| CS | SaveDataDrafting | 2280 | NowGroupID |
| CS | InsertRow | 2477 | NowGroupID |
| CS | chkERPIFBlockYn | 2542, 2551 | dtERPBlockYnIF BLOCK_YN, PERIOD |
| CS | BtnNew_Click | 2977 | NowGroupID |
| CS | SSP_Main_Validation | 3188~3195, 3238~3244, 3315~3321 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS(첫 블록만), remarks2, remarks, TO_SITE_SHIPTO_CODE |
| CS | GetShipmentStatusChk | 3585, 3599, 3614 | ds.Tables[0/1/2] CONFIRM_ID |
| CS | GetErpSoNoCnt | 3646 | ds.Tables[0].Rows[0] CNT |
| CS | SpdMain_ComboSelChange | 4840, 4992~5009 | NowGroupID, CODE, ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL |
| CS | setEndCustomer | 5788 | dtEndCustomer.Rows[0] CODE (drRow CODE, NAME — 줄 번호는 Fact Pack에서 잘림, **확인 필요**) |

## 6. Designer 주요 지점

| 파일 | 줄 | 내용 |
|---|---:|---|
| DS | 32~111 | 컨트롤 선언 80개 |
| DS | 176, 180, 191, 192 | splitContainer1 Dock=Fill, Orientation=Horizontal, Size=1192×649, SplitterDistance=253 |
| DS | 198, 203 | spdMain Dock=Fill, Size=1192×184 |
| DS | 249, 252, 254 | usrConditionPanel1 Dock=Top, Size=1192×69, UsrPanelType=HidePanel |
| DS | 474 | btnChangeRe Text="Request Complete" |
| DS | 688 | btnNew Text="NEW" |
| DS | 882, 887 | spdSub Dock=Fill, Size=1192×213 |
| DS | 934, 937 | panel3 Dock=Top, Size=1192×179 |
| DS | 1002, 1011, 1021~1022, 1032~1033, 1044 | btnDel "Delete" / btnCancel "Cancel" / btnSave "Save Draft"(Visible=false) / btnAdd "Add Date"(Visible=false) / btnChangeRe2 "Request Complete" |

=== FILE: web_components.md ===
# SSP0201 컨트롤 → React/Wijmo 매핑

> 라벨은 props.csv에 있는 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. props.csv가 일부 잘려서(28,634자 생략) 라벨을 확인하지 못한 항목은 **확인 필요**로 표시했습니다.
> 매핑 컴포넌트는 NSCM 공용 컴포넌트를 확정한 것이 아니라 Wijmo/React 계열의 후보입니다.

## 1. 화면 배치

| 컨테이너 | 속성(원문) | 해석 |
|---|---|---|
| splitContainer1 | Dock=Fill, Orientation=Horizontal, Size=1192×649, SplitterDistance=253 | **상/하 분할**. 상단 253px(253/649 ≈ 39.0%), 하단 나머지(≈ 61.0%) |
| 상단 Panel1 | usrConditionPanel1 (Dock=Top, 1192×69, HidePanel) + spdMain (Dock=Fill, 1192×184) | 조회조건 69px(상단 영역의 ≈27.3%) / 메인 그리드 184px(≈72.7%) |
| 하단 Panel2 | panel3 (Dock=Top, 1192×179) + spdSub (Dock=Fill, 1192×213) | 요청 정보·버튼 영역 179px(≈45.7%) / 하위 그리드 213px(≈54.3%) |
| panel3 내부 | usrLayoutControl2 (Dock=Fill, 432×179), panel1 → usrLayoutControl3 | 버튼 그룹(usrLayoutControl2)과 요청 정보 입력(usrLayoutControl3)이 좌우로 놓인 것으로 보이나, panel1의 Dock·Size는 잘린 props에 있어 **확인 필요** |

- 하단 높이 합(179+213=392)과 649−253=396 사이에 4px 차이가 있습니다. 이것이 스플리터 폭인지는 Fact Pack에 SplitterWidth 값이 없어 **확인 필요**입니다.

## 2. 컨트롤 매핑

### 2-1. 조회조건 (usrConditionPanel1 → usrLayoutControl1)

| 컨트롤 | AS-IS 유형 | 라벨(원문) | React/Wijmo 후보 | 비고 |
|---|---|---|---|---|
| clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | ComboBox (단일 선택) | 이름은 clb이지만 유형은 UsrCombo. `SelectedIndexChanged` 연결 |
| clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | MultiSelect | GetCheckedListValue 대상으로 추정 — **확인 필요** |
| clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | MultiSelect | 위와 같음 |
| drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | InputDate ×2 (기간) | 초기값은 GetDayRange(`SCP.SCM0001_GET_SCP_DAY_PERIOD`) |
| cboStatus | UsrCombo | "Status" (PlanType) | ComboBox | 항목 출처 **확인 필요** |
| cboChangeType | UsrCombo | "Change Type" (PlanType1) | ComboBox | 값 "P"/그 외에 따라 그리드 헤더·컬럼이 바뀜. `SelectedIndexChanged` → GetDayRange |
| txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 멀티라인 입력(팝업형 텍스트) | |
| txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 멀티라인 입력 | Designer Visible=false |
| txtRequest | UsrMultiLineEditor | 라벨 미추출 (항목명 `Model`) | 멀티라인 입력 | Text 속성이 추출되지 않음 → **확인 필요** |
| btnItemId | UsrButton | 라벨 없음 (layoutControlItem2) | Button(팝업 호출) | `btnItemId_Click` |
| txtItemId | UsrMultiLineEditor | — | — | controls.csv에서 parent 공란 → 배치 **확인 필요** |
| btnNew | UsrButton | Text "NEW" (항목 Text "layoutControlItem5") | Button | `BtnNew_Click` |
| btnChangeRe | SimpleButton | Text "Request Complete" (항목 lcChgReq, Text "layoutControlItem10") | Button | `BtnChangeRe_Click` |

### 2-2. 버튼 영역 (panel3 → usrLayoutControl2)

| 컨트롤 | AS-IS 유형 | Text(원문) | Designer Visible | React 후보 | 이벤트 |
|---|---|---|---|---|---|
| btnChangeRe2 | SimpleButton | "Request Complete" | (지정 없음) | Button | `BtnChangeRe_Click` |
| btnSave | SimpleButton | "Save Draft" | false | Button | `BtnSave_Click` |
| btnCancel | SimpleButton | "Cancel" | (지정 없음) | Button | `BtnCancel_Click` |
| btnDel | SimpleButton | "Delete" | (지정 없음) | Button | 배선 없음 — **확인 필요** |
| btnAdd | SimpleButton | "Add Date" | false | Button | 배선 없음 — **확인 필요** |
| dtDate | UsrDatePicker | — | false | InputDate | — |

- 레이아웃 항목 lcAdd, lcDel, lcCancel, lcDate, lcChgReq2, lcSave의 Text·Control 연결은 잘린 props에 있어 **확인 필요**입니다.

### 2-3. 변경 요청 정보 (panel1 → usrLayoutControl3)

| 컨트롤 | AS-IS 유형 | 바인딩 추정 근거 (SetChangeRequestInfo dt.Rows[0]) | React 후보 |
|---|---|---|---|
| txtRequestNo | TextBox | CHANGE_REQ_NO | Input(읽기전용 여부 **확인 필요**) |
| txtTitle | TextBox | REQUEST_TITLE | Input |
| txtRequestor | TextBox | REQUEST_USER / REQUEST_USER_NAME | Input |
| txtRequestDeptName | TextBox | REQUEST_DEPT / REQUEST_DEPT_NAME | Input |
| txtApproval | TextBox | APPROVAL_USER / APPROVAL_USER_NAME | Input |
| btnApprovalUser | UsrButton | — (`BtnApprovalUser_Click`) | Button(사용자 선택 팝업 — **확인 필요**) |
| txtAppDeptName | TextBox | APPROVAL_DEPT / APPROVAL_DEPT_NAME | Input |
| cboChangeReason | UsrComboBox | CHANGE_REASON_CODE | ComboBox |
| txtReasonDetail | TextBox | CHANGE_REASON_DETAIL | Input/TextArea |
| usrLabel2 | UsrLabel | — | Label |

- 컬럼과 컨트롤의 대응은 컬럼명과 컨트롤명이 비슷한 데서 나온 추정입니다. 실제 대입 코드(SetChangeRequestInfo 1986~1997)의 대상 컨트롤은 **확인 필요**입니다.
- 항목 layoutControlItem4/5/6/9/10, lcTitle, lcChangeReason, lcApproval, lcReasonDetail, lcAppDept의 Text는 잘린 props에 있어 **확인 필요**입니다.

### 2-4. 그리드

| 컨트롤 | 시트 | 위치 | React/Wijmo 후보 |
|---|---|---|---|
| spdMain (spdMain_Sheet1) | `Shipment Change Request` | 상단 Panel1 | FlexGrid (헤더 1행) |
| spdSub (spdSub_Sheet1) | `Change Request` | 하단 Panel2 | FlexGrid (헤더 2행, ColumnHeaderSpan 병합) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

규칙: 메타 `VISIBLE_FLAG·VALID_YN='Y'`에 해당하는 컬럼이 기본 표시이고, 코드 변경이 마지막에 →숨김이면 제외합니다. `?`는 런타임에 결정되는 분기입니다.

### 3-1. `Shipment Change Request` (spdMain, 메타 65행, 기본 표시 33)

**기본 표시 컬럼 (33)**

| 컬럼 | 라벨(메타) | division 차이 / 코드 변경 |
|---|---|---|
| ATTRIBUTE10 | ATTRIBUTE10 | |
| CHANGE_REASON_CODE | Change Reason | |
| CHANGE_REASON_DETAIL | Reason Detail | |
| CONFIRM_ID | Confirm/Plan ID | ChangeType "P" → Width 0, 그 외 Width 120 |
| DIVISION_ID | Div | 셀 콤보 ← GetSSPInnerTable("MyDivision"), EE 제외 |
| EDIT_MAIN | EDIT_MAIN | |
| END_CUSTOMER | End Customer* | **40·EE만 표시**, 그 외 숨김 |
| ERP_SO_NO | SO No | ChangeType "P" → Width 0 |
| ETA | ETA | |
| ETD | ETD | |
| FCST_TYPE | FCST Type* | |
| FROM_SITE | From Site ID | |
| FROM_SITE_DESCRIPTION | From Site* | 셀 콤보 ← Data.UserPlantSiteByDivisionOspPack |
| INCOTERMS | Incoterms | |
| ITEM_ID | Model* | |
| LT_DAY | L/T(Day) | |
| MTK_OWNER | MKT Owner | |
| NICK_NAME | Nick Name | |
| PROJECT_CODE | Project Code* | **40·EE 숨김**, 그 외 표시 |
| PROJECT_NAME | Project Name | **40·EE 숨김**, 그 외 표시 |
| REMARKS | Remarks | |
| REMARKS2 | Building | |
| REMARKS3 | Customer Requirement | |
| REQUEST_DATE | Request Date | |
| REQUESTOR | Shipment Requestor | |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | |
| SHIPMENT_DATE | Shipment Date* | |
| SHIPMENT_STATUS | Status | |
| TO_SITE | To Site ID | |
| TO_SITE_DESCRIPTION | To Site* | 셀 콤보 ← Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP) |
| TO_SITE_SHIPTO_CODE | Ship to | 셀 콤보 ← CommonDataList [ShipToCodeByDivision] |
| TO_SITE_SOLDTO_CODE | Sold to | |
| TRANSPORT_MODE | Trans Mode* | 셀 콤보 ← CommonDataList [TransMode] |

**숨김 컬럼 (32, 메타 숨김)**: BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE

**코드 전용 변경**: CHK (메타 행 없음, CODE_ONLY_CHANGE → 숨김?)

**division별 표시 수**: 40·EE = 31, 81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC = 32 (각 ?4)

### 3-2. `Change Request` (spdSub, 메타 58행, 기본 표시 28)

**기본 표시 컬럼 (28)**

| 컬럼 | 라벨(메타) | 코드 변경 |
|---|---|---|
| CHK | ALL | 체크박스 셀(608~610). SetChangeRequestSOGrid에서 조건부 숨김(2061) |
| CHANGE_REQ_NO | Change Req.No | |
| CONFIRM_ID | Confirm id | |
| ERP_SO_NO | SO No | ChangeType "P" → 숨김, 그 외 표시 |
| FCST_TYPE | FCST Type | |
| FROM_SITE_DESCRIPTION | From Site | |
| TO_SITE_DESCRIPTION | To Site | |
| ITEM_ID | Model | |
| NICK_NAME | Nick Name | |
| PROJECT_NAME | Project Name | grid_effective: 40·EE →숨김?, 그 외 →표시? (§5 확인 필요) |
| SHIPTO_CODE | ShipTo Code | |
| INCOTERMS | Incoterms | |
| LT_DAY | L/T(Day) | 2단 헤더 그룹 시작 ("Plan"/"Confirmed") |
| ETD | ETD | 그룹 |
| ETA | ETA | 그룹 |
| TRANSPORT_MODE | Trans Mode | 그룹 |
| SHIPMENT_DATE | Shipment Date | 그룹 |
| SHIPMENT_CONFIRM_QTY | Qty | 그룹 |
| NEW_LT_DAY | L/T(Day) | 2단 헤더 그룹 시작 ("Confirm"/"Change") |
| NEW_ETD | ETD | 그룹 |
| NEW_ETA | ETA | 그룹 |
| NEW_TRANSPORT_MODE | Trans Mode | 그룹 |
| NEW_SHIPMENT_DATE | Shipment Date* | 그룹 |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 그룹 |
| NEW_SHIPTO_CODE | ShipTo Code | |
| REMARKS | Remarks | **Width=0 (619)** — 화면에서는 안 보일 수 있음 |
| REMARKS2 | Building | |
| REMARKS3 | Customer requirement | |

(표의 컬럼 순서는 표시 순서가 아닙니다. 실제 순서는 메타 정렬 기준이며, 정렬 컬럼이 Fact Pack에 없어 **확인 필요**입니다.)

**2단 헤더(ColumnHeaderSpan) 원문**

| 0행 그룹 (시작 컬럼, 7열 병합) | ChangeType = "P" | ChangeType ≠ "P" |
|---|---|---|
| LT_DAY | "Plan" | "Confirmed" |
| NEW_LT_DAY | "Confirm" | "Change" |

1행 헤더(공통): L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty / L/T(Day), ETD, ETA, Trans Mode, Shipment Date*, Qty*

- 0행은 7열 병합이지만 1행 라벨은 각 그룹에 6개만 추출되었습니다. 남은 1열이 무엇인지 **확인 필요**입니다.

**숨김 컬럼 (30, 메타 숨김)**: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, PROJECT_CODE, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

**코드 전용 변경**: END_CUSTOMER (메타 행 없음, 40·EE →표시?, 그 외 →숨김?)

**division별 표시 수**: 40·EE = 27, 그 외 12개 division = 28 (각 ?5)

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 근거 |
|---|---|---|
| `Shipment Change Request` | META+코드연결 | AddSheet(523) + SetSheetHeaderColumn(546) |
| `Change Request` | META+코드연결 | AddSheet(527) + ChangeSheet(537) + SetSheetHeaderColumn(599) |

- 상·하 그리드 연동: 조회 시 `FindData_Main`이 상단, `FindData_Sub_Draft`가 하단을 채웁니다. `FindData_Sub_Draft`는 ds.Tables[1]에서 요청자 정보(USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN)를 읽습니다.
- 상단 행 선택이 하단에 반영되는지(마스터-디테일 여부)는 Fact Pack에 근거가 없어 **확인 필요**입니다. `SpdMain_CursorChanged`, `SpdMain_CellDoubleClick`의 동작이 미추출이기 때문입니다.

=== FILE: oracle_migration.md ===
# SSP0201 Oracle 전환 분석

> 근거: Fact Pack의 SP 내부 참조 객체(EXEC 전이 포함)만 사용했습니다. SP 본문 원문은 Fact Pack에 없으므로, 구문 수준 전환 판단은 원문을 확인한 뒤에 해야 합니다.

## 1. 호출 SP 인벤토리 (12종)

| # | SP | 모듈 | 호출처(메서드:줄) | 쓰기 대상 | 주요 읽기 대상 | EXEC 체인 |
|---:|---|---|---|---|---|---|
| 1 | `SSP0201_GET_CHANGE_REQ_NO` | SSP | SaveButton:780 | — | (추출 없음) | — |
| 2 | `SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` | SSP | SaveButton:936 | INSERT SSP_ANL_SHIP_CONFIRM, SCM_SYS_LOG_BATCH | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_MST_SITE_ITEM, SCM_MST_DIVISION, SCM_MST_ITEM_SN, SCM_MST_PROJECT, SSP_PLAN_VERSION_V, SCM_MST_FUTURE_PRICE, SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_CUSTOMER, CTE_DATE | PR_SCM_SYS_LOG_BATCH |
| 3 | `SSP0201_GET_SHIPMENT_CHANGE_REQUEST` | SSP | FindData_Main:1325 | — | 동적 SQL(DYNAMIC@) — 대상 테이블 미추출 | — |
| 4 | `SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N` | SSP | FindData_Main_Nonasync:1417 | — | 동적 SQL(DYNAMIC@) — 대상 테이블 미추출 | — |
| 5 | `SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | SSP | FindData_Sub_Draft:1796 | #TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE (임시) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | — |
| 6 | `SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` | SSP | SaveDataDrafting:2222 | UPDATE SSP_ANL_SHIP_CONFIRM / MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ / INSERT SCM_SYS_LOG_BATCH, #TBLSSPAPPROVEDMAILSEND, SCM_ADM_SMS_MAIL_SEND_LOG | TB_FX_USER, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_ITEM_SN | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SCM_SSP_MAIL_SEND, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SP_SEND_DBMAIL |
| 7 | `SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP | DeleteDataDrafting:2379, GetErpIFCheck:4276(미연결) | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM / DELETE SSP_ANL_SHIP_CONFIRM / INSERT SCM_SYS_LOG_BATCH, XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH |
| 8 | `SCM0001_GET_SCP_DAY_PERIOD` | SCP | GetDayRange:2721 | — | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE | — |
| 9 | `SSP0201_GET_SHIPMENT_STATUS` | SSP | GetShipmentStatusChk:3571 | — | SSP_ANL_SHIP_CONFIRM | — |
| 10 | `SSP0201_GET_ERP_SO_NO_CNT` | SSP | GetErpSoNoCnt:3636 | — | SSP_ANL_SHIP_CONFIRM | — |
| 11 | `SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP | NewNonSoNo:3768, NonSoNo:3939, SoNo:4163 | MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ / INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM | SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M | PR_SCM_SYS_LOG_BATCH |
| 12 | `SSP0026_GET_BOD_ITEM` | SSP (SSP0026 소유) | FindData_BOD:5840 | — | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM | — |

### 1-1. 참조 함수 (REF)

| 함수/객체 | 사용 SP |
|---|---|
| SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | SAVE_SHIPMENT_CONFIRM_NEW, SAVE_SHIPMENT_REQUEST_COMPLETE, DELETE_SHIPMENT_REQUEST_DRAFTING, SAVE_SHIPMENT_REQUEST_DRAFTING |
| STRING_SPLIT | SAVE_SHIPMENT_CONFIRM_NEW, GET_SHIPMENT_STATUS, SSP0026_GET_BOD_ITEM |
| FN_GET_IN_STR, FN_SCM_SPLIT | GET_SHIPMENT_CHANGE_REQUEST, GET_SHIPMENT_CHANGE_REQUEST_N |
| FN_MULTY_TIME, FN_WEEKOFDAY_DATE | SCM0001_GET_SCP_DAY_PERIOD, SAVE_SHIPMENT_CONFIRM_NEW |
| FN_GET_SSP_ETA_DATE | SAVE_SHIPMENT_CONFIRM_NEW, SAVE_SHIPMENT_REQUEST_DRAFTING |
| FN_GET_SSP_ETD_DATE, FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_NEXT_DAY | SAVE_SHIPMENT_CONFIRM_NEW |
| FN_GET_ITEM_NICKNAME | GET_SHIPMENT_REQUEST_DRAFTING, SAVE_SHIPMENT_REQUEST_COMPLETE, DELETE_SHIPMENT_REQUEST_DRAFTING |
| FN_GET_SCM_SITE_DESCRIPTION | GET_SHIPMENT_REQUEST_DRAFTING, SAVE_SHIPMENT_REQUEST_COMPLETE |
| FN_GET_SITE_CUSTOMER_INFO | GET_SHIPMENT_REQUEST_DRAFTING, DELETE_SHIPMENT_REQUEST_DRAFTING |
| FN_GET_PROJECT_NAME | GET_SHIPMENT_REQUEST_DRAFTING |
| FN_GET_SSP_MKT_OWNER_NAME | SAVE_SHIPMENT_REQUEST_COMPLETE, DELETE_SHIPMENT_REQUEST_DRAFTING |
| FN_GET_USER_NAME | SAVE_SHIPMENT_REQUEST_COMPLETE |
| FN_ZERO_LPAD | DELETE_SHIPMENT_REQUEST_DRAFTING |

### 1-2. 주석 처리된 호출 (전환 대상 아님)

- `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW`(1179줄)는 주석 처리됨입니다. 같은 SP의 활성 호출은 936줄에 따로 있습니다.
- `SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING`(1561), `SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING`(1937), `SCP.GET_DATE_RANGE_1MONTH`(2720)도 주석 처리됨입니다.

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)

| code | 호출 지점 | 분기 테이블 |
|---|---|---|
| ShipToCodeByDivision | InsertRow:2455, BtnNew_Click:2996, SpdMain_CellClick:4691, SpdMain_ComboSelChange:4815, SpdMain_ClipboardPasted:5143 (5곳) | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE |
| TransMode | SpdMain_CellClick:4677, FindData_BOD:5860 (2곳) | SCP_MST_BOD_V |

- 호출 인자 형태(grid_code 원문)
  - `Data.Common(Data.Type.ShipToCodeByDivision, false, <division>, <toSite 또는 "">, "", "", "")`
  - `Data.Common(Data.Type.TransMode, false, <division>, sFromSite, sToSite, sIncoterms)`

## 3. FoxQuery 미등록 / 직접호출 SP

- FoxQuery 미등록 엔드포인트는 **0건**입니다(모든 fox 호출이 MATCH, biz 호출은 BIZ_MATCH).
- 아래 데이터 소스는 endpoints.csv에 엔드포인트로 추출되지 않았습니다. 실제 SP나 쿼리는 **확인 필요**입니다.

| 데이터 소스 | 사용처 | 비고 |
|---|---|---|
| `Data.UserPlantSiteByDivisionOspPack(NowGroupID, UserId, division)` | FROM_SITE_DESCRIPTION 셀 콤보 (InsertRow:2488, BtnNew_Click:3000, SpdMain_ComboSelChange:4852) | 미추출 |
| `Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP, …)` | TO_SITE_DESCRIPTION 셀 콤보 (InsertRow:2489, BtnNew_Click:3001) | 미추출 |
| `DataService.GetSSPInnerTable("MyDivision", Filter)` 외 SetChangeControl 7회 | DIVISION_ID 셀 콤보, 조회조건 | 프레임워크 메서드. 읽는 컬럼: CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| `DataService.FP_Log2` | InitControls:419, 428 | LOGTYPE, NOTE, USER_ID |
| dtShipmentInputPeriod | InitControls:490~493 (VALUE, Diff_VALUE) | 출처 미추출 |
| dtERPBlockYnIF | chkERPIFBlockYn:2542, 2551 (BLOCK_YN, PERIOD) | 출처 미추출 |
| dtEndCustomer | setEndCustomer:5788 (CODE, NAME) | 출처 미추출 |

## 4. Oracle 전환 시 확인 포인트 (Fact Pack 사실 기반)

| # | 포인트 | 해당 SP | 근거 |
|---:|---|---|---|
| 1 | MSSQL 전용 `STRING_SPLIT` 사용 → Oracle 대체 구현 필요 | SAVE_SHIPMENT_CONFIRM_NEW, GET_SHIPMENT_STATUS, SSP0026_GET_BOD_ITEM | REF:STRING_SPLIT |
| 2 | 로컬 임시 테이블(`#`) 사용 → GTT 등으로 대체 필요 | GET_SHIPMENT_REQUEST_DRAFTING(#TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE), SAVE_SHIPMENT_REQUEST_COMPLETE(#TBLSSPAPPROVEDMAILSEND) | INSERT/SELECT:#… |
| 3 | 동적 SQL → Oracle 동적 SQL 변환. 대상 테이블은 정적 추출 불가 | GET_SHIPMENT_CHANGE_REQUEST, GET_SHIPMENT_CHANGE_REQUEST_N | DYNAMIC@ |
| 4 | `SP_SEND_DBMAIL`(SQL Server DB Mail) 호출 → Oracle 측 메일 발송 방식 결정 필요 | SAVE_SHIPMENT_REQUEST_COMPLETE (메일 체인 SCM_SSP_MAIL_SEND → SCM_ADM_MAIL_SEND → SP_SEND_DBMAIL) | EXEC:SP_SEND_DBMAIL |
| 5 | `MERGE` 문 → Oracle MERGE 구문 차이 검토 | SAVE_SHIPMENT_REQUEST_COMPLETE, SAVE_SHIPMENT_REQUEST_DRAFTING | MERGE:SSP_ANL_SHIP_CONFIRM_CHG_REQ |
| 6 | ERP/SCS 인터페이스 테이블 INSERT → 대상 테이블 존재·소유 스키마 확인 | DELETE_SHIPMENT_REQUEST_DRAFTING | INSERT:XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SELECT:NERP_CONV_MASTER |
| 7 | 배치 프로시저 체인 동반 전환 필요 | DELETE_SHIPMENT_REQUEST_DRAFTING (PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH), 다수 (PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN) | EXEC 체인 |
| 8 | `CTE_DATE`가 SELECT 대상으로 추출됨 → CTE 이름(WITH 절)으로 추정되나 원문 **확인 필요** | SCM0001_GET_SCP_DAY_PERIOD, SAVE_SHIPMENT_CONFIRM_NEW | SELECT:CTE_DATE |
| 9 | 사용자 정의 함수 다수(FN_*, SCM_ARR_SPL_*) 선행 전환 필요 | §1-1 | REF |
| 10 | SSP0026 소유 SP 공유 → SSP0026 전환본과 같은 객체를 쓸지 확인 | SSP0026_GET_BOD_ITEM | 엔드포인트 `SSP.SSP0026_GET_BOD_ITEM` |
| 11 | SCP 모듈 SP 공유 | SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| 12 | 다중 결과셋 반환 → Oracle에서 SYS_REFCURSOR 다중 OUT 등으로 대응 필요 | GET_SHIPMENT_STATUS (ds.Tables[0/1/2]), GET_SHIPMENT_REQUEST_DRAFTING (ds.Tables[1] 사용) | meta_reads |

### 4-1. 난이도 근거 (사실 기반 정량)

| SP | 쓰기 객체 수 | EXEC 체인 수 | MSSQL 전용 요소 |
|---|---:|---:|---|
| SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | 5 (UPDATE 1, MERGE 1, INSERT 3) | 6 | #임시테이블, SP_SEND_DBMAIL |
| SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | 6 (UPDATE 3, DELETE 1, INSERT 3; SSP_ANL_SHIP_CONFIRM 중복) | 3 | 인터페이스 테이블 INSERT |
| SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | 2 | 1 | STRING_SPLIT |
| SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | 4 | 1 | — (추출 기준) |
| SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | 1 (#임시) | 0 | #임시테이블 |
| SSP0201_GET_SHIPMENT_CHANGE_REQUEST / _N | 0 | 0 | 동적 SQL |
| SSP0201_GET_SHIPMENT_STATUS, SSP0026_GET_BOD_ITEM | 0 | 0 | STRING_SPLIT |
| SSP0201_GET_ERP_SO_NO_CNT, SCM0001_GET_SCP_DAY_PERIOD, SSP0201_GET_CHANGE_REQ_NO | 0 | 0 | — (추출 기준) |

- 상·중·하 등급은 매기지 않았습니다. SP 본문 줄수나 구문 원문이 Fact Pack에 없기 때문입니다. 등급은 원문을 확인한 뒤 판정해야 합니다.

## 5. DB 메타 (SSP0201 값이 들어 있는 메타 테이블)

| 메타 테이블 | 행 수 | 전환 시 의미 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 123 | 그리드 메타 (Change Request 58 + Shipment Change Request 65) |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | 용도 **확인 필요** |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | 이력 |
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 61 | 스크립트 백업 (SP 원문 이력 후보 — **확인 필요**) |
| dbo.TB_FX_ProgramInfo | 2 | 프로그램 등록 |
| dbo.TB_FX_MenuItemInfo | 2 | 메뉴 |
| dbo.TB_FX_GroupMenuAuth | 8 | 그룹 권한 |
| dbo.TB_FX_SearchCondition | 5 | 저장된 조회조건 |
| dbo.TB_FX_Favorite | 15 | 즐겨찾기 |

=== FILE: tobe_design.md ===
# SSP0201 TO-BE 설계 참고 (As-is 사실 기반)

> 이 문서는 TO-BE 결정이 아니라 As-is 사실을 TO-BE 관점에서 정리한 것입니다. 결정이 필요한 항목은 §5 미확정 사항에 모았습니다.

## 1. 조회조건 (컨트롤 기준)

| 순서(Designer 선언 순) | 컨트롤 | 라벨(원문) | 유형 | 초기/특이 사항 |
|---:|---|---|---|---|
| 1 | txtConfirmId | Confirm Id | 멀티라인 텍스트 | |
| 2 | clbDivision_ID | Div | 단일 콤보 | 값 40/EE 여부로 그리드 컬럼 표시가 바뀜. 변경 이벤트 `clbDivision_ID_SelectedIndexChanged` |
| 3 | clbFromSite | From Site | 다중 선택 | |
| 4 | txtSoNo | SO No | 멀티라인 텍스트 | Designer Visible=false. 표시 조건 **확인 필요** |
| 5 | drpPeriod | Shipment Date | 기간 | 초기값은 `SCP.SCM0001_GET_SCP_DAY_PERIOD`(GetDayRange) |
| 6 | cboStatus | Status | 콤보 | |
| 7 | txtRequest (+ btnItemId) | 라벨 미추출(항목명 Model) | 멀티라인 텍스트 + 팝업 버튼 | |
| 8 | cboChangeType | Change Type | 콤보 | "P" 여부로 그리드 헤더·컬럼이 바뀜. 변경 시 GetDayRange 재호출 |
| 9 | clbToSite | To Site | 다중 선택 | |
| — | btnNew | NEW | 버튼 | 신규 행 |
| — | btnChangeRe | Request Complete | 버튼 | |

- 위 순서는 Designer 선언 순서이며, 화면에서 보이는 배치 순서는 **확인 필요**입니다.
- `GetCheckedListValue` 호출 지점(FindData_Main:1303~1307, FindData_Main_Nonasync:1395, SaveButton:795, SetChangedControl:503)과 SP 파라미터의 대응은 **확인 필요**입니다.
- 저장된 조회조건: TB_FX_SearchCondition 5행.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 호출 순서 (엔드포인트) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` → InitControls | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 기간 기본값 조회 API |
| Change Type 변경 | `CboChangeType_SelectedIndexChanged` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 위와 같음 (+ 그리드 헤더 재구성은 FE) |
| 조회 | FindButton | `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` → `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING` | 상단 목록 조회 API, 하단 요청 상세 조회 API |
| 행 추가 | InsertButton → InsertRow | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] (+ 미추출 소스: UserPlantSiteByDivisionOspPack, Data_SCP.Common, GetSSPInnerTable("MyDivision")) | 셀 콤보용 공통코드 API |
| NEW | `BtnNew_Click` | `biz:CommonData.CommonDataList` [ShipToCodeByDivision] | 위와 같음 |
| 저장(툴바) | SaveButton | `SSP.SSP0201_GET_CHANGE_REQ_NO` → `SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW` → GetERPInterface(`SSP.SSP0201_GET_SHIPMENT_STATUS`, `SSP.SSP0201_GET_ERP_SO_NO_CNT`, `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`) / GetNewERPInterface(`SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING`) → 재조회(`SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST` 또는 `SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`, `SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING`) | 요청번호 채번 API, 신규 확정 저장 API, 상태·SO 건수 검증 API, 드래프트 저장 API |
| Save Draft | `BtnSave_Click` → SaveDataDrafting | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | 요청 완료 저장 API (이름과 호출 SP가 다르므로 §5 확인) |
| Request Complete (2개 버튼) | `BtnChangeRe_Click` → SaveDataDrafting | `SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` → 재조회 | 위와 같음 (메일 발송 체인 포함) |
| Cancel | `BtnCancel_Click` → DeleteDataDrafting | `SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` → 재조회 | 요청 취소 API (ERP/SCS 인터페이스 INSERT 포함) |
| 셀 클릭 | `SpdMain_CellClick` | TRANSPORT_MODE: CommonDataList [TransMode] / TO_SITE_SHIPTO_CODE: CommonDataList [ShipToCodeByDivision] / 헤더 체크박스 전체 토글 | 셀 콤보 지연 로딩 API |
| 셀 콤보 변경 | `SpdMain_ComboSelChange` | CommonDataList [ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`(FindData_BOD) → ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL 세팅, CommonDataList [TransMode] | BOD 조회 API (SSP0026 공유) |
| 붙여넣기 | `SpdMain_ClipboardPasted` | CommonDataList [ShipToCodeByDivision] | 셀 콤보 API |
| 승인자 선택 | `BtnApprovalUser_Click` | 엔드포인트 미추출 | **확인 필요** |
| 품목 선택 | `btnItemId_Click` | 엔드포인트 미추출 | **확인 필요** |
| 기타 그리드 이벤트 | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_EditChange`, `SpdMain_CursorChanged`, `shtMain_Change` | 엔드포인트 미추출 | FE 로직, 내용 **확인 필요** |

### 2-1. 저장 전 검증 (SSP_Main_Validation)

| 블록 | 줄 | 검사 컬럼 |
|---|---|---|
| Validationdr | 3188~3195 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks, TO_SITE_SHIPTO_CODE |
| SONoValidationdr | 3238~3244 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE (INCOTERMS 없음) |
| SONoValidationdr | 3315~3321 | 위와 같음 |

- 각 검사의 조건과 메시지는 Fact Pack에 없어 **확인 필요**입니다(`validation.md` 작성 시 원문 대조 필수).
- ERP I/F 차단 검사: `chkERPIFBlockYn`(BLOCK_YN, PERIOD).

## 3. Division별 Grid 변형 요약

| 시트 | 40 · EE | 그 외(81 계열·82·EE_* 계열) | 근거 |
|---|---|---|---|
| Shipment Change Request | END_CUSTOMER 표시 / PROJECT_CODE·PROJECT_NAME 숨김 → 31컬럼 | END_CUSTOMER 숨김 / PROJECT_CODE·PROJECT_NAME 표시 → 32컬럼 | InitSpread 578~587 (조회조건 Div 기준), SpdMain_ComboSelChange 4870~4881 (행 DIVISION_ID 기준) |
| Change Request | 27컬럼 (?5) | 28컬럼 (?5) | grid_effective (적용 여부 확인 필요) |

- 조건 비교는 정확히 `"40"`과 `"EE"`이므로 EE_HD 등 EE_* 계열은 '그 외'에 속합니다(grid_effective 결과와 일치).
- Change Type 변형(division과 무관):
  - "P": Shipment Change Request의 ERP_SO_NO·CONFIRM_ID Width 0, Change Request의 ERP_SO_NO 숨김, 헤더 "Plan"/"Confirm"
  - 그 외: CONFIRM_ID Width 120, ERP_SO_NO 표시, 헤더 "Confirmed"/"Change"
- 행 DIVISION_ID 콤보는 EE를 제외합니다(`c["CODE"] != "EE"`).
- TO_SITE_SHIPTO_CODE 콤보 세팅(InsertRow:2457)은 `clbDivision_ID.ControlValues == "40"` 조건 안에 있습니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 근거 |
|---|---|
| 메뉴 그룹 권한 8행 존재 (내용 미첨부) | dbo.TB_FX_GroupMenuAuth |
| 프로그램/메뉴 등록 각 2행 | dbo.TB_FX_ProgramInfo, dbo.TB_FX_MenuItemInfo |
| 툴바 진입점: FindButton(R), InsertButton(C), SaveButton(C/U) | flow.csv entry_kind=button |
| 화면 버튼: Save Draft·Request Complete(U), Cancel(D 성격 — DELETE SP 호출), Delete(btnDel, 배선 미확인) | events.csv, props.csv |
| 시트 잠금 검사 `siMain.IsLock(siMain.SheetName) == false`에서만 셀 콤보·행 추가·헤더 체크 동작 | grid_code (InsertRow, BtnNew_Click, SpdMain_CellClick) |
| 사용자 그룹 기반 필터: `UserInfoContext.Current["NowGroupID"]` | SetChangeControl, SetChangedControl, SaveDataDrafting, InsertRow, BtnNew_Click, SpdMain_ComboSelChange |
| Filter GROUP_ID / USER_ID 지정 후 GetSSPInnerTable 호출 | SetChangeControl:312~349 |
| 요청자·승인자·부서 정보(REQUEST_USER, APPROVAL_USER, *_DEPT) 보유 | SetChangeRequestInfo |

- 그룹별 C/R/U/D 플래그 값은 TB_FX_GroupMenuAuth 행 내용이 없어 **확인 필요**입니다.
- 요청자와 승인자에 따라 버튼 활성/비활성이 갈리는지는 SetChangeControl/SetChangedControl 본문이 없어 **확인 필요**입니다.

## 5. 미확정 사항

| # | 항목 | 필요한 확인 |
|---:|---|---|
| 1 | btnSave("Save Draft")가 COMPLETE SP를 호출하는 것이 의도된 동작인지 (btnSave는 Visible=false) | 원문 SaveDataDrafting 2222줄 앞뒤 분기 |
| 2 | SaveButton 내 GetERPInterface / GetNewERPInterface, FindData_Main / FindData_Main_Nonasync가 갈리는 조건 | 원문 SaveButton |
| 3 | GetErpIFCheck(미연결) 포함 여부 | 원문 호출처 검색 |
| 4 | btnDel, btnAdd 동작 / txtItemId, dtDate 용도 | 원문 + 런타임 |
| 5 | Change Request REMARKS Width=0 처리 (메타 '기본'과 충돌) | 런타임 확인 |
| 6 | Change Request 2단 헤더 7열 병합의 7번째 컬럼 | 메타 정렬 + 런타임 |
| 7 | 미추출 데이터 소스(UserPlantSiteByDivisionOspPack, Data_SCP.Common 2종, GetSSPInnerTable, dtShipmentInputPeriod, dtERPBlockYnIF, dtEndCustomer)의 SP | 프레임워크·BIZ 소스 추적 |
| 8 | 조회조건 라벨 미추출 항목(txtRequest/Model)과 usrLayoutControl2·3 항목 라벨 | props.csv 전체본 |
| 9 | 메일 발송 체인(SP_SEND_DBMAIL)의 TO-BE 대체 방식 | 아키텍처 결정 |
| 10 | ERP/SCS 인터페이스 테이블(XIF_*) 연동의 TO-BE 대상 | 인터페이스 담당 확인 |
| 11 | 주석 처리된 호출 4건은 TO-BE 범위 제외 대상인지 (현행 기능 아님) | — |
| 12 | 판단불가 분기 140건(런타임) | 실행 확인 |
