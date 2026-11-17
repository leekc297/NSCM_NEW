# SSP0200 Shipment Change Request — As-is 분석

> 출처: AsisFacts 정적 추출 Fact Pack (SSP0200). 이 문서는 Fact Pack에 들어 있는 사실만 적었습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0200 |
| 클래스 | `SSP0200_ShipmentChangeRequest` |
| 도메인 | SSP (`06.UIL\GSCM.SSP.Forms.UIL\Plan\`) |
| 부속 팝업 | `SSP0200_ShipmentChangeRequestInsertPopup` (shared) |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` |
| 시트 | `Shipment Change Request` (spdMain, 상단) / `Change Request` (spdSub, 하단) |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\Properties\AssemblyInfo.cs | SSP0200_ShipmentChangeRequest.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\SSP0200_ShipmentChangeRequest.cs | SSP0200_ShipmentChangeRequest.UIL.csproj | 6905 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\SSP0200_ShipmentChangeRequest.Designer.cs | SSP0200_ShipmentChangeRequest.UIL.csproj | 1781 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0200_ShipmentChangeRequestInsertPopup.cs | GSCM.SSP.Plan.UIL.csproj | 150 |
| shared | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0200_ShipmentChangeRequestInsertPopup.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 364 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0200_ShipmentChangeRequest.cs | GSCM.SSP.Plan.UIL.csproj | 6456 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0200_ShipmentChangeRequest.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 1901 |

- 이 문서는 current와 shared 파일만 근거로 씁니다. legacy 사본(6456/1901줄)은 구버전이라 현행 기능 판정에 쓰지 않습니다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| Form_Load (this.Load) | Form_Load > InitControls > GetDayRange | 3129 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH |
| Form_Load | Form_Load > InitControls > GetDivision | 6781 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | MATCH |
| Form_Load | … > GetDivision > SetChangedControl > GetShipmentPlanPlantSite | 6798 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | NOT_IN_FOXQUERY |
| clbDivision_ID_SelectedIndexChanged | > SetChangedControl > GetShipmentPlanPlantSite | 6798 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | NOT_IN_FOXQUERY |
| CboChangeType_SelectedIndexChanged | > GetDayRange | 3129 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH |
| FindButton (조회) | FindButton > FindData_Main | 1529 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` | MATCH |
| FindButton | FindButton > FindData_Sub_Draft | 2029 | `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| InsertButton (행 추가) | InsertButton > InsertRow > GetPlantSiteByDivisionEEOperation | 6812 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | NOT_IN_FOXQUERY |
| btnInsertMultiple_Click | > InsertRowMultiple > GetItemFromBOD | 6756 | `SSP.SSP0200_GET_ITEM_FROM_BOD` | MATCH |
| btnInsertMultiple_Click | > InsertRowMultiple > GetPlantSiteByDivisionEEOperation | 6812 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | NOT_IN_FOXQUERY |
| BtnNew_Click | > GetPlantSiteByDivisionEEOperation | 6812 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | NOT_IN_FOXQUERY |
| shtMain_Change (dsdm.Changed) | > GetItemFromBOD | 6756 | `SSP.SSP0200_GET_ITEM_FROM_BOD` | MATCH |
| SpdMain_CellClick | (TRANSPORT_MODE 셀 콤보) | 5466 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH |
| SpdMain_ComboSelChange | > FindData_BOD | 6711 | `SSP.SSP0026_GET_BOD_ITEM` | MATCH |
| SpdMain_ComboSelChange | > FindData_BOD | 6731 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH |
| SpdMain_ComboSelChange | > GetPlantSiteByDivisionEEOperation | 6812 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | NOT_IN_FOXQUERY |
| SaveButton (저장) | SaveButton | 862 | `SSP.SSP0200_GET_CHANGE_REQ_NO` | MATCH |
| SaveButton | SaveButton | 1056 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW` | MATCH |
| SaveButton | > FindData_Main_Nonasync | 1650 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` | MATCH |
| SaveButton | > FindButton > FindData_Main / FindData_Sub_Draft | 1529 / 2029 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` / `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| SaveButton | > GetERPInterface | 3950 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH |
| SaveButton | > GetERPInterface | 3989 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| SaveButton | > GetERPInterface > GetShipmentStatusChk | 4096 | `SSP.SSP0200_GET_SHIPMENT_STATUS` | MATCH |
| SaveButton | > GetERPInterface > GetErpSoNoCnt | 4161 | `SSP.SSP0200_GET_ERP_SO_NO_CNT` | MATCH |
| SaveButton | > GetNewERPInterface > NewNonSoNo | 4297 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| SaveButton | > GetERPInterface > NonSoNo | 4491 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| SaveButton | > GetERPInterface > SoNo | 4771 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| SaveButton | > GetERPInterface > SoNo > GetErpIFCheckNew | 5009 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| SaveButton | > GetERPInterface > SoNo > GetErpIFSeqMerge | 5067 | `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` | MATCH |
| BtnSave_Click (btnSave "Save Draft") | > SaveDataDrafting | 2463 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` | MATCH |
| BtnSave_Click | > SaveDataDrafting > FindButton > FindData_Main / FindData_Sub_Draft | 1529 / 2029 | 재조회 | MATCH |
| BtnChangeRe_Click (btnChangeRe2 "Request Complete") | > SaveDataDrafting | 2463 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` | MATCH |
| BtnChangeRe_Click | > SaveDataDrafting > FindButton > … | 1529 / 2029 | 재조회 | MATCH |
| BtnCancel_Click (btnCancel "Cancel") | > DeleteDataDrafting | 2620 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| BtnCancel_Click | > DeleteDataDrafting > GetErpIFCheck | 4928 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| BtnCancel_Click | > DeleteDataDrafting > FindButton > … | 1529 / 2029 | 재조회 | MATCH |

흐름은 크게 넷으로 나뉩니다. 정적 경로 기준이며, 분기 조건은 런타임에서 확인해야 합니다.
1. **초기화**: 기간 범위, Division, From Site 목록을 불러옵니다.
2. **조회**: 상단 Shipment Change Request(메인)와 하단 Change Request(Draft)를 동시에 조회합니다.
3. **저장(SaveButton)**: 변경요청번호를 채번하고 Confirm을 신규 저장합니다. 이어서 ERP I/F 분기(SO 있음 = SoNo, SO 없음 = NonSoNo/NewNonSoNo)에 따라 Drafting 저장, ERP 오류 확정, IFSEQ 병합을 수행합니다.
4. **Request Complete / Save Draft / Cancel**: 요청 완료 처리 또는 Draft 삭제 후 재조회합니다.

## 3. 엔드포인트 전체 표 (20개)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 주요 참조 테이블 (쓰기 위주) |
|---:|---|---|---:|---|---|
| 1 | `SSP.SSP0200_GET_CHANGE_REQ_NO` | MATCH | 1 | SSP0200_GET_CHANGE_REQ_NO | (EXEC 자기 자신만 추출 — 내부 테이블 확인 필요) |
| 2 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW` | MATCH | 1 | SSP0200_SAVE_SHIPMENT_CONFIRM_NEW | INSERT SSP_ANL_SHIP_CONFIRM, INSERT/MERGE DM_PLN_MKT_FCST(_CONFIRM), EXEC PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 3 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` | MATCH | 1 | SSP0200_GET_SHIPMENT_CHANGE_REQUEST | 동적 SQL(DYNAMIC@), FN_GET_IN_STR, FN_SCM_SPLIT |
| 4 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` | MATCH | 1 | SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N | 동적 SQL(DYNAMIC@), FN_GET_IN_STR, FN_SCM_SPLIT |
| 5 | `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | MATCH | 1 | SSP0200_GET_SHIPMENT_REQUEST_DRAFTING | SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SSO_USER_INFO 등 |
| 6 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` | MATCH | 1 | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE | UPDATE SSP_ANL_SHIP_CONFIRM / _CHG_REQ_DE, MERGE _CHG_REQ, EXEC SCM_SSP_MAIL_SEND → SP_SEND_DBMAIL |
| 7 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING | UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW |
| 8 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SCM0001_GET_SCP_DAY_PERIOD | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE |
| 9 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 1 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE _CHG_REQ / _CHG_REQ_DE |
| 10 | `SSP.SSP0200_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0200_GET_SHIPMENT_STATUS | SELECT SSP_ANL_SHIP_CONFIRM, STRING_SPLIT |
| 11 | `SSP.SSP0200_GET_ERP_SO_NO_CNT` | MATCH | 1 | SSP0200_GET_ERP_SO_NO_CNT | SELECT SSP_ANL_SHIP_CONFIRM |
| 12 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING | MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT _CHG_REQ_DE, UPDATE SSP_ANL_SHIP_CONFIRM, INSERT/MERGE DM_PLN_MKT_FCST |
| 13 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 1 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN |
| 14 | `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` | MATCH | 1 | PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE | SELECT/UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN |
| 15 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH | 2 | (UP_FX_GetCommonDataList) | SELECT SCP_MST_BOD_V |
| 16 | `SSP.SSP0026_GET_BOD_ITEM` | MATCH | 1 | SSP0026_GET_BOD_ITEM | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, STRING_SPLIT |
| 17 | `SSP.SSP0200_GET_ITEM_FROM_BOD` | MATCH | 1 | SSP0200_GET_ITEM_FROM_BOD | 동적 SQL(DYNAMIC@) — 대상 테이블 확인 필요 |
| 18 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | MATCH | 1 | SSP0200_GET_SHIPMENT_DIVISION | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE |
| 19 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | NOT_IN_FOXQUERY | 1 | (DB 객체 P 존재, FoxQuery 미등록) | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, STRING_SPLIT, TB_FX_USERGROUPAUTHEXTENTION |
| 20 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | NOT_IN_FOXQUERY | 1 | (DB 객체 P 존재, FoxQuery 미등록) | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION |

전체 참조 객체 목록은 `oracle_migration.md` §1에 있습니다.

### 3-1. 주석 처리된 호출 (현행 기능 아님)
아래 6건은 **주석 처리됨** 상태입니다. 현행 기능으로 집계하지 않았습니다.

| 줄 | 값 |
|---:|---|
| 1343 | SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW (주석 처리됨) |
| 1486 | SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST (주석 처리됨) |
| 1794 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING (주석 처리됨) |
| 2170 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING (주석 처리됨) |
| 3128 | SCP.GET_DATE_RANGE_1MONTH (주석 처리됨) |
| 6826 | SSP.SSP0200_GET_SHIPMENT_PLAN_TO_SITE (주석 처리됨, NOT_IN_FOXQUERY) |

## 4. 이벤트 배선 표 (19 핸들러)

| 대상 | 이벤트 | 핸들러 | 위치 | 파일 |
|---|---|---|---|---|
| this.btnInsertMultiple | Click | `btnInsertMultiple_Click` | InitializeComponent:322 | 본 화면 Designer.cs |
| this | Load | `Form_Load` | .ctor:310 | 본 화면 .cs |
| clbDivision_ID | SelectedIndexChanged | `clbDivision_ID_SelectedIndexChanged` | InitEvent:383 | 본 화면 .cs |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:384 | 본 화면 .cs |
| btnApprovalUser | Click | `BtnApprovalUser_Click` | InitEvent:385 | 본 화면 .cs |
| dsdm | Changed | `shtMain_Change` | InitEvent:388 | 본 화면 .cs |
| btnSave | Click | `BtnSave_Click` | InitEvent:393 | 본 화면 .cs |
| btnChangeRe2 | Click | `BtnChangeRe_Click` | InitEvent:395 | 본 화면 .cs |
| btnCancel | Click | `BtnCancel_Click` | InitEvent:398 | 본 화면 .cs |
| btnNew | Click | `BtnNew_Click` | InitEvent:399 | 본 화면 .cs |
| this.spdMain | CellClick | `SpdMain_CellClick` | InitEvent:401 | 본 화면 .cs |
| this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:402 | 본 화면 .cs |
| this.spdMain | EditChange | `SpdMain_EditChange` | InitEvent:403 | 본 화면 .cs |
| this.spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitEvent:404 | 본 화면 .cs |
| this.spdMain | ComboSelChange | `SpdMain_ComboSelChange` | InitEvent:405 | 본 화면 .cs |
| this.btnItemId | Click | `btnItemId_Click` | InitEvent:406 | 본 화면 .cs |
| cboChangeType | SelectedIndexChanged | `CboChangeType_SelectedIndexChanged` | InitEvent:408 | 본 화면 .cs |
| spdMain | CursorChanged | `SpdMain_CursorChanged` | InitEvent:410 | 본 화면 .cs |
| this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | InitializeComponent:228 | InsertPopup.Designer.cs (shared) |
| this (InsertPopup) | Load | `Form_Load` | .ctor:49 | InsertPopup.cs (shared) |

- 버튼 프레임워크 진입점인 FindButton, InsertButton, SaveButton, EditButton은 이벤트 배선이 아니라 프레임워크 오버라이드로 호출됩니다.
- `btnDel`("Delete")과 `btnAdd`("Add Date", Visible=false)는 events.csv에 배선이 없습니다. **확인 필요**
- 엔드포인트를 호출하지 않는 핸들러는 다음과 같습니다(Fact Pack 기준): `SpdMain_TopChange`, `BtnApprovalUser_Click`, `SpdMain_CellDoubleClick`, `SpdMain_EditChange`, `SpdMain_ClipboardPasted`, `btnItemId_Click`, `SpdMain_CursorChanged`, `btnButtonList_UsrButtonList_Click_Detected`. 이 핸들러들의 내부 동작은 **확인 필요**입니다.

## 5. Grid 구성 방식

구성 방식은 **`META(프레임워크) (+코드 표시/라벨 변경)`**입니다.

- 메타: `SCM_MST_SHEET_COLUMNS`(124행), PROGRAM_ID=SSP0200
  - `SetSheetHeaderColumn@InitSpread:598`: Shipment Change Request, 헤더 1행
  - `SetSheetHeaderColumn@InitSpread:659`: Change Request, 헤더 2행
- 코드:
  - CreateSpread:573 `AddSheet(spdMain, "Shipment Change Request")`
  - CreateSpread:577 `AddSheet(spdSub, "Change Request")`
  - CreateSpread:587 `ChangeSheet`

### 5-1. 메타 기준 컬럼 수 (모든 division 동일)
| 시트 | 메타 필수+기본/선택 |
|---|---|
| Change Request | 26/0 |
| Shipment Change Request | 36/0 |

### 5-2. 최종 표시 컬럼 수 (메타 + 코드, grid_effective)
| 시트 | 40 | EE | 81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC |
|---|---:|---:|---:|
| Change Request | 25 (?5) | 25 (?5) | 26 (?5) |
| Shipment Change Request | 34 (?4) | 34 (?4) | 32 (?4) |

### 5-3. division별 차이 (코드 분기)
- **Shipment Change Request** (InitSpread:630~648, 조건 `clbDivision_ID.SelectedValue == "40" || == "EE"`):
  - 40/EE: `END_CUSTOMER`, `ERP_ATTR1`, `ERP_ATTR2`, `ERP_ATTR3` 표시, `PROJECT_CODE`, `PROJECT_NAME` 숨김
  - 그 외: 반대
- 같은 규칙이 행 단위 Division 콤보 변경 시에도 다시 적용됩니다. 위치는 `SpdMain_ComboSelChange:5668~5679`이며, END_CUSTOMER와 PROJECT_CODE/NAME만 대상입니다.
- **Change Type 분기**:
  - `cboChangeType == "P"`이면 Shipment Change Request의 `ERP_SO_NO`, `CONFIRM_ID` Width=0입니다. 그 외에는 100/120입니다.
  - Change Request는 "P"이면 `ERP_SO_NO`를 숨기고 상단 헤더 Span을 "Plan"/"Confirm"으로 둡니다. 그 외에는 `ERP_SO_NO`를 표시하고 Span을 "Confirmed"/"Change"로 둡니다.
- grid_effective는 Change Request의 END_CUSTOMER/PROJECT_* 변경과 Shipment Change Request의 CHK 숨김(SetChangeRequestSOGrid:2294, siSub 대상)을 다른 시트로 귀속했습니다. 이는 파서의 시트 추정이라 귀속 시트가 실제와 다를 수 있습니다. **확인 필요**

## 6. 확인 필요 항목
1. `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`(6798)와 `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`(6812)는 FoxQuery에 등록되지 않았지만 DB 객체(P)는 있습니다. 직접 호출 경로를 확인해야 합니다.
2. TO_SITE_DESCRIPTION 콤보 소스 `Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP)`가 어떤 SP를 쓰는지 Fact Pack에 없습니다.
3. 아래 데이터의 출처 SP가 Fact Pack에 없습니다.
   - `chkERPIFBlockYn`의 `dtERPBlockYnIF`(BLOCK_YN, PERIOD)
   - `InitControls`의 `dtShipmentInputPeriod`(VALUE, Diff_VALUE)
4. `btnDel`, `btnAdd`에 이벤트 배선이 없습니다.
5. 다음 LayoutControlItem의 Text가 props.csv 추출 범위 밖에 있습니다: Model, CheckSingleProcess, layoutControlItem2/13, lcAdd~lcSave, usrLayoutControl3 항목들.
6. `SSP0200_GET_ITEM_FROM_BOD`, `SSP0200_GET_SHIPMENT_CHANGE_REQUEST(_N)`는 동적 SQL이라 내부 참조 테이블이 미추출입니다.
7. grid_effective의 판단불가(?) 140건(런타임 컬럼 루프 84, 화면 컨트롤값 28, 조회 데이터 28)은 실행해서 확인해야 합니다.
8. 실제 SP 실행 결과와 메타 시트가 매칭되지 않았습니다(grid 단계 미실행 또는 시트명 불일치).
