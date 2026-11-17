=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SSP0200 소스 링크 표

**파일 약어**
| 약어 | 경로 |
|---|---|
| M | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\SSP0200_ShipmentChangeRequest.cs` |
| D | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\SSP0200_ShipmentChangeRequest.Designer.cs` |
| P | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0200_ShipmentChangeRequestInsertPopup.cs` |
| PD | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0200_ShipmentChangeRequestInsertPopup.Designer.cs` |

## 1. 엔드포인트 호출 지점 (현행 25건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | SaveButton | 862 | `SSP.SSP0200_GET_CHANGE_REQ_NO` |
| M | SaveButton | 1056 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW` |
| M | FindData_Main | 1529 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` |
| M | FindData_Main_Nonasync | 1650 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` |
| M | FindData_Sub_Draft | 2029 | `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` |
| M | SaveDataDrafting | 2463 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| M | DeleteDataDrafting | 2620 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetDayRange | 3129 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| M | GetERPInterface | 3950 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| M | GetERPInterface | 3989 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetShipmentStatusChk | 4096 | `SSP.SSP0200_GET_SHIPMENT_STATUS` |
| M | GetErpSoNoCnt | 4161 | `SSP.SSP0200_GET_ERP_SO_NO_CNT` |
| M | NewNonSoNo | 4297 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| M | NonSoNo | 4491 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| M | SoNo | 4771 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetErpIFCheck | 4928 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetErpIFCheckNew | 5009 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| M | GetErpIFSeqMerge | 5067 | `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` |
| M | SpdMain_CellClick | 5466 | `biz:CommonData.CommonDataList` [code=TransMode] (Data.Common → Data.CallBizCommonData) |
| M | FindData_BOD | 6711 | `SSP.SSP0026_GET_BOD_ITEM` |
| M | FindData_BOD | 6731 | `biz:CommonData.CommonDataList` [code=TransMode] |
| M | GetItemFromBOD | 6756 | `SSP.SSP0200_GET_ITEM_FROM_BOD` |
| M | GetDivision | 6781 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` |
| M | GetShipmentPlanPlantSite | 6798 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` (NOT_IN_FOXQUERY) |
| M | GetPlantSiteByDivisionEEOperation | 6812 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` (NOT_IN_FOXQUERY) |

## 2. 주석 처리된 호출 (참고용, 현행 아님)
| 파일 | 줄 | 내용 |
|---|---:|---|
| M | 1343 | SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW — 주석 처리됨 |
| M | 1486 | SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST — 주석 처리됨 |
| M | 1794 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING — 주석 처리됨 |
| M | 2170 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING — 주석 처리됨 |
| M | 3128 | SCP.GET_DATE_RANGE_1MONTH — 주석 처리됨 |
| M | 6826 | SSP.SSP0200_GET_SHIPMENT_PLAN_TO_SITE — 주석 처리됨 |

## 3. 이벤트 배선
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| D | InitializeComponent | 322 | btnInsertMultiple.Click += btnInsertMultiple_Click |
| M | .ctor | 310 | this.Load += Form_Load |
| M | InitEvent | 383 | clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged |
| M | InitEvent | 384 | spdMain.TopChange += SpdMain_TopChange |
| M | InitEvent | 385 | btnApprovalUser.Click += BtnApprovalUser_Click |
| M | InitEvent | 388 | dsdm.Changed += shtMain_Change |
| M | InitEvent | 393 | btnSave.Click += BtnSave_Click |
| M | InitEvent | 395 | btnChangeRe2.Click += BtnChangeRe_Click |
| M | InitEvent | 398 | btnCancel.Click += BtnCancel_Click |
| M | InitEvent | 399 | btnNew.Click += BtnNew_Click |
| M | InitEvent | 401 | spdMain.CellClick += SpdMain_CellClick |
| M | InitEvent | 402 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| M | InitEvent | 403 | spdMain.EditChange += SpdMain_EditChange |
| M | InitEvent | 404 | spdMain.ClipboardPasted += SpdMain_ClipboardPasted |
| M | InitEvent | 405 | spdMain.ComboSelChange += SpdMain_ComboSelChange |
| M | InitEvent | 406 | btnItemId.Click += btnItemId_Click |
| M | InitEvent | 408 | cboChangeType.SelectedIndexChanged += CboChangeType_SelectedIndexChanged |
| M | InitEvent | 410 | spdMain.CursorChanged += SpdMain_CursorChanged |
| PD | InitializeComponent | 228 | btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected |
| P | .ctor | 49 | this.Load += Form_Load |

## 4. Grid 구성 코드
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | CreateSpread | 573 | AddSheet(spdMain, "Shipment Change Request", 1, 1, 30) |
| M | CreateSpread | 577 | AddSheet(spdSub, "Change Request", 2, 1, 30) |
| M | CreateSpread | 587 | ChangeSheet |
| M | InitSpread | 598 | SetSheetHeaderColumn(spreadInfo, 1) — Shipment Change Request |
| M | InitSpread | 607–608 / 618–619 | ChangeType "P" ↔ 그 외: ERP_SO_NO·CONFIRM_ID Width 0 / 100·120 |
| M | InitSpread | 630–648 | Division 40/EE 분기: END_CUSTOMER·ERP_ATTR1~3 ↔ PROJECT_CODE·PROJECT_NAME |
| M | InitSpread | 659 | SetSheetHeaderColumn(spreadInfo, 2) — Change Request |
| M | InitSpread | 672–674 | CHK CellType=CheckBox, Value=false, Border |
| M | InitSpread | 696 | REMARKS Width=0 |
| M | InitSpread | 701–718 | "P": ERP_SO_NO 숨김, Header Span "Plan"/"Confirm" + 하위 라벨 |
| M | InitSpread | 723–740 | 그 외: ERP_SO_NO 표시, Header Span "Confirmed"/"Change" + 하위 라벨 |
| M | SetChangeRequestSOGrid | 2268 / 2275 / 2294 | spdSub 행 루프: 숨김 처리, CHK 숨김(sSearchType=="Exist") |
| M | InsertRow | 2728 / 2729 / 2765 | 콤보: FROM_SITE_DESCRIPTION / TO_SITE_DESCRIPTION / DIVISION_ID |
| M | InsertRowMultiple | 2854 / 2855 / 2891 | 위와 동일 (다건) |
| M | BtnNew_Click | 3381 / 3415 / 3416 / 3422 | DIVISION_ID / FROM_SITE / TO_SITE 콤보 |
| M | SpdMain_CellClick | 5468 | TRANSPORT_MODE 콤보 = Data.Common(TransMode) |
| M | SpdMain_CellClick | 5505 / 5540 / 5544 | 헤더 CheckBox 전체 선택/해제 |
| M | SpdMain_ComboSelChange | 5668–5679 | 행 Division 40/EE: END_CUSTOMER ↔ PROJECT_CODE/NAME |

## 5. 메타·데이터 컬럼 읽기 (주요)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | SetChangeControl | 334–335 | Filter GROUP_ID(NowGroupID), USER_ID |
| M | SetChangeControl | 341–372 | DataService.GetSSPInnerTable (7회) |
| M | InitControls | 442 / 451 | DataService.FP_Log2 |
| M | InitControls | 481 / 530–533 | CODE / dtShipmentInputPeriod VALUE·Diff_VALUE |
| M | SetChangedControl | 545 / 554 / 562 | GetCheckedListValue, ATTRIBUTE1, NowGroupID |
| M | SaveButton | 877 / 1138–1158 | GetCheckedListValue / reason_id·division_id·to_site |
| M | FindData_Main | 1466–1473 / 1562–1563 | GetCheckedListValue / ITEM_ID·OPERATION_GROUP |
| M | FindData_Main_Nonasync | 1627 | GetCheckedListValue |
| M | FindData_Sub_Draft | 2074–2084 | USER_ID·DEPT_ID·USER_NAME·DEPT_NAME_KO·USER_NAME_EN·DEPT_NAME_EN |
| M | SetChangeRequestInfo | 2219–2230 | CHANGE_REQ_NO … APPROVAL_DEPT_NAME (12컬럼) |
| M | SaveDataDrafting | 2521 | NowGroupID |
| M | chkERPIFBlockYn | 2950 / 2959 | BLOCK_YN / PERIOD |
| M | SSP_Main_Validation | 3609–3617 / 3659–3664 / 3734–3739 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks |
| M | GetShipmentStatusChk | 4110 / 4124 / 4139 | Tables[0..2] CONFIRM_ID |
| M | GetErpSoNoCnt | 4171 | CNT |
| M | NonSoNo | 4567–4587 | reason_id·division_id·to_site |
| M | SoNo | 4846–4853 | reason_id·division_id·to_site |

=== FILE: web_components.md ===
# SSP0200 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. 원문이 추출되지 않은 라벨은 "미추출(확인 필요)"로 적었습니다.

### 1-1. 조회조건 영역 (usrConditionPanel1 / usrLayoutControl1)
| AS-IS 컨트롤 | 유형 | 라벨(원문) | TO-BE 컴포넌트 후보 |
|---|---|---|---|
| clbDivision_ID | UsrCombo | "Div" (layoutControlItem8) | Wijmo ComboBox (단일) |
| clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | Wijmo MultiSelect |
| clbToSite | UsrCheckedList | "To Site" (layoutControlItem3) | Wijmo MultiSelect |
| cboStatus | UsrCombo | "Status" (PlanType) | Wijmo ComboBox |
| drpPeriod | UsrDateRangePicker | "Shipment Date" (layoutControlItem1) | 기간 DateRange (InputDate ×2) |
| cboChangeType | UsrCombo | "Change Type" (PlanType1) | Wijmo ComboBox |
| txtSoNo | UsrMultiLineEditor | "SO No" (lblSONo) | 멀티라인 입력(다건 붙여넣기) |
| txtConfirmId | UsrMultiLineEditor | "Confirm Id" (layoutControlItem11) | 멀티라인 입력 |
| txtRequest | UsrMultiLineEditor | 미추출 (LayoutItem 이름 "Model") — 확인 필요 | 멀티라인 입력 |
| btnItemId | UsrButton | 미추출 (layoutControlItem2) | 팝업 호출 버튼 |
| chkSingleProcess | CheckEdit | 미추출 (CheckSingleProcess) | CheckBox |
| btnNew | UsrButton | Text "New" (LayoutItem Text "layoutControlItem5") | Button |
| btnInsertMultiple | UsrButton | Text "Insert(Multi)" (layoutControlItem13) | Button → 수량 입력 팝업 |
| txtItemId | UsrMultiLineEditor | parent 없음 — 배치 확인 필요 | — |

### 1-2. 하단 액션 영역 (panel3 / usrLayoutControl2)
| AS-IS 컨트롤 | 유형 | 라벨(원문) | Visible | TO-BE |
|---|---|---|---|---|
| btnChangeRe2 | SimpleButton | "Request Complete" | (기본) | Button |
| btnSave | SimpleButton | "Save Draft" | **false** | Button (기본 숨김) |
| btnCancel | SimpleButton | "Cancel" | (기본) | Button |
| btnDel | SimpleButton | "Delete" | (기본) | Button (이벤트 배선 없음 — 확인 필요) |
| btnAdd | SimpleButton | "Add Date" | **false** | Button (기본 숨김) |
| dtDate | UsrDatePicker | — | **false** | InputDate (기본 숨김) |

### 1-3. 변경요청 정보 영역 (panel1 / usrLayoutControl3)
| AS-IS 컨트롤 | 유형 | 바인딩 컬럼 (SetChangeRequestInfo) | 라벨 |
|---|---|---|---|
| txtRequestNo | TextBox | CHANGE_REQ_NO | 미추출 — 확인 필요 |
| txtTitle | TextBox | REQUEST_TITLE | lcTitle Text 미추출 |
| txtRequestor | TextBox | REQUEST_USER(_NAME) | 미추출 |
| txtRequestDeptName | TextBox | REQUEST_DEPT(_NAME) | 미추출 |
| txtApproval | TextBox | APPROVAL_USER(_NAME) | lcApproval Text 미추출 |
| btnApprovalUser | UsrButton | — (BtnApprovalUser_Click) | 승인자 선택 팝업 |
| txtAppDeptName | TextBox | APPROVAL_DEPT(_NAME) | lcAppDept Text 미추출 |
| cboChangeReason | UsrComboBox | CHANGE_REASON_CODE | lcChangeReason Text 미추출 |
| txtReasonDetail | TextBox | CHANGE_REASON_DETAIL | lcReasonDetail Text 미추출 |
| usrLabel2 | UsrLabel | — | 미추출 |

- 바인딩 컬럼은 `SetChangeRequestInfo:2219~2230`에서 텍스트박스 이름과 컬럼명을 대응시킨 것입니다. 컨트롤↔컬럼 1:1 대입 코드는 **확인 필요**입니다.

### 1-4. Grid
| AS-IS | 시트 | TO-BE |
|---|---|---|
| spdMain | `Shipment Change Request` | Wijmo FlexGrid (메인, 편집) |
| spdSub | `Change Request` | Wijmo FlexGrid (2단 헤더, 체크박스) |

### 1-5. Insert(Multi) 팝업 (SSP0200_ShipmentChangeRequestInsertPopup, shared)
| 컨트롤 | 유형 | TO-BE |
|---|---|---|
| usrLabel1 | UsrLabel | Label (Text 확인 필요) |
| txtCurrentInsert_Qty | UsrTextBox | InputNumber (추가 행 수) |
| btnButtonList | UsrButtonList | 확인/취소 버튼 그룹 |

## 2. 화면 배치

- `splitContainer1`: Dock=Fill, **Orientation=Horizontal → 상/하 분할**, Size=1192×649, SplitterDistance=253
  - 상단 Panel1: 253/649 ≈ **39.0%**
  - 하단 Panel2: 나머지 ≈ 61%(스플리터 폭 미추출이라 정확값은 확인 필요)
- **상단 Panel1**
  - `usrConditionPanel1`: Dock=Top, 1192×73, UsrPanelType=HidePanel → 조회조건(접이식)
  - `spdMain`: Dock=Fill, 1192×180 → Shipment Change Request
- **하단 Panel2**
  - `panel3`: Dock=Top, 1192×179
    - `usrLayoutControl2`: Dock=Fill, 432×179 → 버튼 영역
    - `panel1` → `usrLayoutControl3` 변경요청 정보 영역 (panel1의 Dock과 좌/우 배치는 truncated라 확인 필요)
  - `spdSub`: Dock=Fill, 1192×213 → Change Request

## 3. 시트별 Grid 컬럼

### 3-1. `Shipment Change Request` (spdMain, 헤더 1행, 메타 36/0)

| 컬럼 | 라벨(메타) | 40 / EE | 그 외 division | 비고 |
|---|---|---|---|---|
| ATTRIBUTE10 | ATTRIBUTE10 | 표시 | 표시 | |
| CHANGE_REASON_CODE | Change Reason | 표시 | 표시 | |
| CHANGE_REASON_DETAIL | Reason Detail | 표시 | 표시 | |
| CONFIRM_ID | Confirm/Plan ID | 표시 | 표시 | ChangeType "P" → Width 0, 그 외 120 |
| DIVISION_ID | Div | 표시 | 표시 | 콤보 = MyDivision(EE 제외) |
| EDIT_MAIN | EDIT_MAIN | 표시 | 표시 | |
| END_CUSTOMER | End Customer* | **표시** | **숨김** | 코드 InitSpread:630/641, ComboSelChange:5668/5677 |
| ERP_ATTR1 | Consignee Name | **표시** | **숨김** | InitSpread:635/646 |
| ERP_ATTR2 | Contact Point | **표시** | **숨김** | |
| ERP_ATTR3 | Lot | **표시** | **숨김** | |
| ERP_SO_NO | SO No | 표시 | 표시 | ChangeType "P" → Width 0, 그 외 100 |
| ETA / ETD | ETA / ETD | 표시 | 표시 | |
| FCST_TYPE | FCST Type* | 표시 | 표시 | |
| FROM_SITE | From Site ID | 표시 | 표시 | |
| FROM_SITE_DESCRIPTION | From Site* | 표시 | 표시 | 콤보 = GetPlantSiteByDivisionEEOperation |
| INCOTERMS | Incoterms* | 표시 | 표시 | |
| ITEM_ID | Model* | 표시 | 표시 | |
| LT_DAY | L/T(Day) | 표시 | 표시 | |
| MTK_OWNER | MKT Owner | 표시 | 표시 | |
| NICK_NAME | Nick Name | 표시 | 표시 | |
| PROJECT_CODE | Project Code* | **숨김** | **표시** | InitSpread:631/642 |
| PROJECT_NAME | Project Name | **숨김** | **표시** | InitSpread:632/643 |
| REMARKS / REMARKS2 / REMARKS3 | Remarks / Building / Customer Requirement | 표시 | 표시 | |
| REQUEST_DATE | Request Date | 표시 | 표시 | |
| REQUESTOR | Shipment Requestor | 표시 | 표시 | |
| SHIPMENT_CONFIRM_QTY | Shipment Qty* | 표시 | 표시 | |
| SHIPMENT_DATE | Shipment Date* | 표시 | 표시 | |
| SHIPMENT_STATUS | Status | 표시 | 표시 | |
| TO_SITE | To Site ID | 표시 | 표시 | |
| TO_SITE_DESCRIPTION | To Site* | 표시 | 표시 | 콤보 = Data_SCP.Common(…) |
| TO_SITE_SHIPTO_CODE / TO_SITE_SOLDTO_CODE | Ship to / Sold to | 표시 | 표시 | |
| TRANSPORT_MODE | Trans Mode* | 표시 | 표시 | 콤보 = CommonDataList[TransMode] |

- 메타 숨김 컬럼(정의만 있음): BOD_ID, CHANGE_REQ_NO, CHANGE_TYPE, CHECK_NEED_YN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, Expected_Shipping_Date, MODEL_USER, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, TEAM, UPDATED_BY, UPDATED_DATE
- 최종 표시 컬럼 수: **40/EE 34개, 그 외 32개**
- CHK 컬럼은 grid_effective에서 이 시트에 귀속돼 있지만, 근거 코드(SetChangeRequestSOGrid:2294)는 siSub 대상입니다. **확인 필요**

### 3-2. `Change Request` (spdSub, 헤더 2행, 메타 26/0)

| 컬럼 | 라벨(메타) | 표시 | 비고 |
|---|---|---|---|
| CHK | ALL | 표시 | CheckBox(672~674), 헤더 클릭 전체 선택(5505~5544), sSearchType=="Exist" 시 숨김(2294) |
| CHANGE_REQ_NO | Change Req.No | 표시 | |
| CONFIRM_ID | Confirm id | 표시 | |
| ERP_SO_NO | SO No | ChangeType "P" → 숨김, 그 외 → 표시 | 701/723 |
| ITEM_ID / NICK_NAME | Model / Nick Name | 표시 | |
| FCST_TYPE | FCST Type | 표시 | |
| FROM_SITE_DESCRIPTION / TO_SITE_DESCRIPTION | From Site / To Site | 표시 | |
| INCOTERMS | Incoterms | 표시 | |
| PROJECT_NAME | Project Name | 40/EE 숨김(?) · 그 외 표시(?) | 귀속 추정 — 확인 필요 |
| PROJECT_CODE | Project Code | 메타 숨김 → 그 외 division 표시(?) | 귀속 추정 — 확인 필요 |
| END_CUSTOMER | — | CODE_ONLY_CHANGE, 40/EE 표시(?) | 메타 미정의, 귀속 추정 — 확인 필요 |
| (기존) LT_DAY, ETD, ETA, TRANSPORT_MODE, SHIPMENT_DATE, SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty | 표시 | 상위 Span "Plan"("P") / "Confirmed"(그 외), 6열 |
| (변경) NEW_LT_DAY, NEW_ETD, NEW_ETA, NEW_TRANSPORT_MODE, NEW_SHIPMENT_DATE, NEW_SHIPMENT_CONFIRM_QTY | L/T(Day), ETD, ETA, Trans Mode, Shipment Date*, Qty* | 표시 | 상위 Span "Confirm"("P") / "Change"(그 외), 6열 |
| REMARKS | Remarks | Width=0 (696) | 사실상 숨김 |
| REMARKS2 / REMARKS3 | Building / Customer requirement | 표시 | |

- 메타 숨김 컬럼: A_COUNTRY, A_PORT_CODE, BOD_ID, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, ELECTRODE_TYPE, ELECTRODE_YN, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE_ID, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PLAN_CONFIRM_ID, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE
- 최종 표시 컬럼 수(grid_effective): **40/EE 25개(?5), 그 외 26개(?5)**

## 4. 시트 연결 규칙
- 두 시트 모두 `META+코드연결`입니다. 메타 시트명을 코드가 `AddSheet`/`ChangeSheet`에서 그대로 사용합니다.
- 상단 `Shipment Change Request`는 `SSP0200_GET_SHIPMENT_CHANGE_REQUEST`로, 하단 `Change Request`는 `SSP0200_GET_SHIPMENT_REQUEST_DRAFTING`으로 조회합니다. 두 조회는 FindButton 한 번에 함께 호출됩니다.
- 상단 행 선택이 하단을 필터링하는 마스터-디테일 구조인지는 Fact Pack에 근거가 없습니다(SpdMain_CursorChanged 내부 미추출). **확인 필요**
- 하단 `SetChangeRequestSOGrid`(2268~2294)는 spdSub 행 루프에서 Ship Status("R")와 sSearchType("Exist")로 CHK 표시를 제어합니다.

=== FILE: oracle_migration.md ===
# SSP0200 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (17개 + FoxQuery 미등록 2개 + Biz 1개)

| # | SP | 호출 수 | EXEC 체인 (하위 SP) | 쓰기 대상 | 읽기 대상 (주요) |
|---:|---|---:|---|---|---|
| 1 | `SSP0200_GET_CHANGE_REQ_NO` | 1 | — | 미추출 | 미추출 — 확인 필요 |
| 2 | `SSP0200_SAVE_SHIPMENT_CONFIRM_NEW` | 1 | PR_SCM_SYS_LOG_BATCH, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_ROUTE | INSERT SSP_ANL_SHIP_CONFIRM, INSERT DM_PLN_MKT_FCST_CONFIRM, MERGE DM_PLN_MKT_FCST, INSERT SCM_SYS_LOG_BATCH, DELETE/UPDATE A(별칭) | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE(_ITEM), SCM_MST_DIVISION, SCM_MST_ITEM_SN, SCM_MST_PROJECT, SSP_PLAN_VERSION_V, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT, XIF_ERP_SHIP_DOC_R_SN, SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_CUSTOMER |
| 3 | `SSP0200_GET_SHIPMENT_CHANGE_REQUEST` | 1 | — | — | DYNAMIC SQL, FN_GET_IN_STR, FN_SCM_SPLIT |
| 4 | `SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` | 1 | — | — | DYNAMIC SQL, FN_GET_IN_STR, FN_SCM_SPLIT |
| 5 | `SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` | 1 | — | INSERT #TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_MST_MODEL_USER, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER |
| 6 | `SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` | 1 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SCM_SSP_MAIL_SEND, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, **SP_SEND_DBMAIL** | UPDATE SSP_ANL_SHIP_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SCM_SYS_LOG_BATCH, INSERT #TBLSSPAPPROVEDMAILSEND, INSERT SCM_ADM_SMS_MAIL_SEND_LOG | TB_FX_USER, SSP_MST_MODEL_USER, SCM_ADM_RECIPIENT_LIST/MESSAGE/ASSIGN, SSP_MST_DELEGATE, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN, SCM_MST_SITE |
| 7 | `SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` | 3 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW, PR_SCP_SYS_LOG_BATCH | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH | NERP_CONV_MASTER, SCM_MST_DIVISION, SCM_MST_SITE(_CUSTOMER), DM_PLN_MKT_FCST, SCM_ADM_LOOKUP_MASTER_DETAIL |
| 8 | `SCM0001_GET_SCP_DAY_PERIOD` | 1 | — | — | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE(CTE), FN_MULTY_TIME, FN_WEEKOFDAY_DATE |
| 9 | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 1 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 10 | `SSP0200_GET_SHIPMENT_STATUS` | 1 | — | — | SSP_ANL_SHIP_CONFIRM, STRING_SPLIT |
| 11 | `SSP0200_GET_ERP_SO_NO_CNT` | 1 | — | — | SSP_ANL_SHIP_CONFIRM |
| 12 | `SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` | 3 | PR_SCM_SYS_LOG_BATCH, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SCP_SYS_LOG_BATCH | MERGE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE SSP_ANL_SHIP_CONFIRM, INSERT/MERGE DM_PLN_MKT_FCST, INSERT DM_PLN_MKT_FCST_CONFIRM, INSERT SCM_SYS_LOG_BATCH | SSP_MST_SITE_ITEM_EE_V, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT, XIF_ERP_SHIP_DOC_R_SN |
| 13 | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 1 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, CREATE/INSERT #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_DIVISION, SCM_MST_SITE(_CUSTOMER), DM_PLN_MKT_FCST |
| 14 | `PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` | 1 | — | UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_ARR_SPL_CNT |
| 15 | `SSP0026_GET_BOD_ITEM` | 1 | — | — | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, STRING_SPLIT |
| 16 | `SSP0200_GET_ITEM_FROM_BOD` | 1 | — | — | DYNAMIC SQL — 대상 미추출 |
| 17 | `SSP0200_GET_SHIPMENT_DIVISION` | 1 | — | — | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE |

공통 함수 참조는 다음과 같습니다. SP별 상세 목록은 Fact Pack §3에 있습니다.
- 배열 분해: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL
- 사이트·인코텀즈·VMI: FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS
- ETA/ETD: FN_GET_SSP_ETA_DATE, FN_GET_SSP_ETD_DATE
- 문자열 분해: FN_SPLITSTRING, UF_FX_STRING_SPLIT
- 날짜: FN_NEXT_DAY
- 기타: FN_GET_ITEM_NICKNAME 등

## 2. 공통코드 분기
| 호출 | code | 경로 | 실제 조회 테이블 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (SpdMain_CellClick:5466, FindData_BOD:6731) | `TransMode` | Data.Common[case Type.TransMode] → Data.CallBizCommonData → UP_FX_GetCommonDataList | SELECT SCP_MST_BOD_V |

- 프레임워크 메타 소비 메서드는 다음과 같습니다.
  - `DataService.GetSSPInnerTable`: SetChangeControl:341~372, 7회. 컬럼은 CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID입니다. 키 "MyDivision"은 InsertRow/BtnNew 콤보 소스입니다.
  - `DataService.FP_Log2`: InitControls:442/451. 컬럼은 LOGTYPE, NOTE, USER_ID입니다.
  - `SpreadInfo.SetSheetHeaderColumn`: SCM_MST_SHEET_COLUMNS 메타입니다.
- `GetSSPInnerTable`의 키별 실제 SQL은 Fact Pack에 없습니다. **확인 필요**
- `Data_SCP.Common(ShipmentPlanToSite / ToSiteByDivisionEEForSSP)`는 TO_SITE 콤보 소스입니다. 대응 SP가 Fact Pack에 없습니다. **확인 필요**

## 3. FoxQuery 미등록 / 직접 호출 SP
| SP | 호출 위치 | DB 상태 | 참조 |
|---|---|---|---|
| `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | GetShipmentPlanPlantSite:6798 (Form_Load, clbDivision_ID 변경) | DB 객체 존재(P), FoxQuery 미등록 | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, STRING_SPLIT, TB_FX_USERGROUPAUTHEXTENTION |
| `SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` | GetPlantSiteByDivisionEEOperation:6812 (InsertRow, InsertRowMultiple, BtnNew, ComboSelChange) | DB 객체 존재(P), FoxQuery 미등록 | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION |

- 주석 처리된 `SSP.SSP0200_GET_SHIPMENT_PLAN_TO_SITE`(6826)는 현행 호출이 아니므로 전환 대상에서 뺐습니다.
- 주석 처리된 SSP0002_* 2건(1794, 2170)과 SCP.GET_DATE_RANGE_1MONTH(3128)도 같은 이유로 뺐습니다.

## 4. Oracle 전환 시 확인 포인트 (추출 사실 기준)

| 항목 | 대상 SP | 근거 |
|---|---|---|
| `STRING_SPLIT` (MSSQL 전용) | SSP0026_GET_BOD_ITEM, SSP0200_GET_SHIPMENT_STATUS, SSP0200_SAVE_SHIPMENT_CONFIRM_NEW, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | REF:STRING_SPLIT |
| 동적 SQL | SSP0200_GET_SHIPMENT_CHANGE_REQUEST, SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N, SSP0200_GET_ITEM_FROM_BOD | DYNAMIC@ |
| 로컬 임시테이블(#) | SSP0200_SAVE_SHIPMENT_CONFIRM_NEW / SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING (#T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TEMP_SHIP_RESULT, #TEMP_CONFRIM_MKT_FCST), SSP0200_GET_SHIPMENT_REQUEST_DRAFTING (#TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE), SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE (#TBLSSPAPPROVEDMAILSEND), SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106) | CREATE/INSERT:# |
| GTT 사용 시 세션 상태 | 위 임시테이블 대체 GTT 전부 | 시작 시 비우기와 다중 조회 시나리오 대조 필요 |
| DB 메일 | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE → SCM_ADM_MAIL_SEND → `SP_SEND_DBMAIL` | EXEC:SP_SEND_DBMAIL (Oracle 대체 수단 확인 필요) |
| MERGE | SSP0200_SAVE_SHIPMENT_CONFIRM_NEW, SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING, SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE | MERGE:DM_PLN_MKT_FCST, MERGE:SSP_ANL_SHIP_CONFIRM_CHG_REQ |
| 별칭 기반 DELETE/UPDATE | SSP0200_SAVE_SHIPMENT_CONFIRM_NEW, SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING | DELETE:A, UPDATE:A (MSSQL `DELETE A FROM …` 형태 추정 — 원문 확인 필요) |
| CTE | SCM0001_GET_SCP_DAY_PERIOD | SELECT:CTE_DATE |
| ERP I/F 테이블 쓰기 | SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT/UPDATE |
| 권한 테이블 | SSP0200_GET_SHIPMENT_DIVISION, 미등록 SP 2개 | TB_FX_USERGROUPAUTHEXTENTION |
| 트랜잭션 로그 래퍼 | DELETE_DRAFTING, ERP_ERROR_CONFIRM, REQUEST_COMPLETE, DELETE_BY_CONFIRM | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |

### 4-1. 규모 (사실 기준)
- 참조 객체 수가 가장 많은 SP는 `SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING`과 `SSP0200_SAVE_SHIPMENT_CONFIRM_NEW`입니다. 두 SP 모두 하위 EXEC가 있고 임시테이블 6종 이상을 만듭니다.
- 단순 조회 SP는 `SSP0200_GET_ERP_SO_NO_CNT`(단일 테이블)와 `SSP0200_GET_SHIPMENT_STATUS`(단일 테이블 + STRING_SPLIT)입니다.
- `SSP0200_GET_CHANGE_REQ_NO`는 내부 참조가 추출되지 않아 규모를 판단할 수 없습니다. **확인 필요**

=== FILE: tobe_design.md ===
# SSP0200 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)
| 순서 | 라벨(원문) | AS-IS 컨트롤 | 유형 | 비고 |
|---:|---|---|---|---|
| 1 | Div | clbDivision_ID | 단일 콤보 | 소스 `SSP0200_GET_SHIPMENT_DIVISION`. 변경 시 From Site 재조회(`SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`) |
| 2 | From Site | clbFromSite | 체크리스트(다중) | GetCheckedListValue 사용 |
| 3 | To Site | clbToSite | 체크리스트(다중) | 소스 확인 필요 |
| 4 | Status | cboStatus | 콤보 | 소스 확인 필요 |
| 5 | Shipment Date | drpPeriod | 기간 | 초기값 = `SCM0001_GET_SCP_DAY_PERIOD` |
| 6 | Change Type | cboChangeType | 콤보 | 값 "P" 분기 존재. 변경 시 기간 재계산 + Grid 컬럼 변경 |
| 7 | SO No | txtSoNo | 멀티라인 | |
| 8 | Confirm Id | txtConfirmId | 멀티라인 | |
| 9 | (Model — Text 미추출) | txtRequest + btnItemId | 멀티라인 + 팝업 | btnItemId_Click 내부 확인 필요 |
| 10 | (Text 미추출) | chkSingleProcess | 체크박스 | 용도 확인 필요 |

- 위 순서는 Designer 선언 순서가 아니라 정리용입니다. 실제 배치 순서는 LayoutControl 위치값으로 확인해야 합니다.
- usrConditionPanel1은 `HidePanel` 타입(접이식)입니다.

## 2. 액션별 호출 API 후보
| 액션 | 트리거 | 호출 SP (순서는 정적 경로 기준) |
|---|---|---|
| 화면 초기화 | Form_Load | SCM0001_GET_SCP_DAY_PERIOD → SSP0200_GET_SHIPMENT_DIVISION → SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| Division 변경 | clbDivision_ID_SelectedIndexChanged | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| Change Type 변경 | CboChangeType_SelectedIndexChanged | SCM0001_GET_SCP_DAY_PERIOD |
| 조회 | FindButton | SSP0200_GET_SHIPMENT_CHANGE_REQUEST (상단) + SSP0200_GET_SHIPMENT_REQUEST_DRAFTING (하단) |
| 행 추가 | InsertButton / BtnNew_Click ("New") | SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION (From Site 콤보) |
| 다건 행 추가 | btnInsertMultiple_Click ("Insert(Multi)", 수량 팝업) | SSP0200_GET_ITEM_FROM_BOD, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION |
| 셀 값 변경 | shtMain_Change | SSP0200_GET_ITEM_FROM_BOD |
| 셀 콤보 선택 | SpdMain_ComboSelChange | SSP0026_GET_BOD_ITEM, CommonDataList[TransMode], SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION |
| Trans Mode 셀 클릭 | SpdMain_CellClick | CommonDataList[TransMode] |
| 저장 | SaveButton | SSP0200_GET_CHANGE_REQ_NO → SSP0200_SAVE_SHIPMENT_CONFIRM_NEW → (ERP I/F 분기) SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM / SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING / SSP0200_GET_SHIPMENT_STATUS / SSP0200_GET_ERP_SO_NO_CNT / SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING (SoNo·NonSoNo·NewNonSoNo) / SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM / PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE → SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N + 재조회 |
| Request Complete | BtnChangeRe_Click | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE (메일 발송 체인 포함) → 재조회 |
| Save Draft (기본 숨김) | BtnSave_Click | SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE → 재조회 |
| Cancel | BtnCancel_Click | SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING (DeleteDataDrafting, GetErpIFCheck) → 재조회 |
| 승인자 선택 | BtnApprovalUser_Click | 엔드포인트 미추출 — 확인 필요 |
| Delete | btnDel | 이벤트 배선 없음 — 확인 필요 |

**저장 전 클라이언트 검증 근거**
- `SSP_Main_Validation`이 다음 값을 확인합니다.
  - 일반: shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks
  - SO 건: INCOTERMS를 제외한 같은 항목
- `chkERPIFBlockYn`이 BLOCK_YN과 PERIOD를 확인합니다.
- 메시지 문구와 조건식은 Fact Pack에 없습니다. **확인 필요**

## 3. division별 Grid 변형 요약
| 시트 | 40 / EE | 그 외 (81 계열, 82, EE_*) |
|---|---|---|
| Shipment Change Request | END_CUSTOMER, ERP_ATTR1(Consignee Name), ERP_ATTR2(Contact Point), ERP_ATTR3(Lot) 표시 / PROJECT_CODE, PROJECT_NAME 숨김 → 34열 | 반대 → 32열 |
| Change Request | 25열(?5) | 26열(?5) |

- 판정 기준은 조회조건 Div 값(InitSpread)과 행별 DIVISION_ID 콤보 값(SpdMain_ComboSelChange) 두 가지입니다.
- Change Type "P"이면 ERP_SO_NO와 CONFIRM_ID를 숨기거나 폭을 0으로 하고, Change Request 2단 헤더를 "Plan/Confirm"으로 둡니다. 그 외에는 "Confirmed/Change"입니다.
- DIVISION_ID 셀 콤보는 MyDivision에서 `CODE != "EE"`인 값만 씁니다(InsertRow:2765, BtnNew_Click:3381/3422).

## 4. 권한(C/R/U/D) 관련 사실
- 메타 테이블에 `TB_FX_GroupMenuAuth` 16행, `TB_FX_MenuItemInfo` 4행, `TB_FX_ProgramInfo` 4행이 있습니다. 행 내용(버튼별 C/R/U/D 값)은 Fact Pack 본문에 없습니다. **확인 필요**
- Division과 Site 목록 SP 3개(SSP0200_GET_SHIPMENT_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE, SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION)가 `TB_FX_USERGROUPAUTHEXTENTION`을 참조합니다. 즉 사용자 그룹 권한에 따라 목록이 필터링됩니다.
- `UserInfoContext.Current["NowGroupID"]`를 읽는 위치: SetChangeControl:334, SetChangedControl:562, SaveDataDrafting:2521, GetDivision, GetShipmentPlanPlantSite, GetPlantSiteByDivisionEEOperation
- 편집 가능 여부는 `siMain.IsLock(SheetName)`으로 판정합니다(InsertRow, BtnNew_Click, SpdMain_CellClick 조건).
- 승인 흐름 관련 컬럼: APPROVAL_USER, APPROVAL_DEPT. 승인자 선택 버튼은 btnApprovalUser입니다.

## 5. 미확정 사항
1. FoxQuery 미등록 SP 2개를 TO-BE에서 어떻게 호출할지(MyBatis 직접 매핑 여부)
2. TO_SITE 콤보 소스(`Data_SCP.Common`)와 Status·Change Type·Change Reason 콤보 소스 SP
3. 상단↔하단 그리드 연동 방식(SpdMain_CursorChanged 내부 미추출)
4. ERP I/F 분기 조건 3종(SoNo / NonSoNo / NewNonSoNo)을 결정하는 조건식
5. `SP_SEND_DBMAIL` 메일 발송의 TO-BE 대체 방식
6. 동적 SQL 3개 SP의 실제 조회 대상 테이블
7. LayoutControlItem Text 중 미추출 라벨(Model, Single Process, 변경요청 정보 영역 전부)
8. grid_effective 판단불가(?) 140건, 시트 귀속 추정 건(CHK, END_CUSTOMER/PROJECT_* on Change Request)
9. btnDel·btnAdd·dtDate의 실사용 여부(btnAdd·dtDate는 Visible=false, btnDel은 배선 없음)
