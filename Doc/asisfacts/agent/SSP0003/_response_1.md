=== FILE: analysis.md ===
# SSP0003 Shipment Change Request Confirm — AS-IS 분석서

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0003). Fact Pack에 있는 사실만 적었습니다. Fact Pack에서 확인할 수 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0003 |
| 클래스 | `SSP0003_ShipmentChangeRequestConfirm` |
| 도메인 | SSP (프로젝트 경로 `06.UIL\GSCM.SSP.Forms.UIL\Plan\`) |
| 화면 성격 | 선적 변경 요청(Change Request)을 승인(Approval)·반려(Reject)·자가 반려(Self Reject)하는 화면. 버튼 Text 원문과 저장 SP 이름을 근거로 정리했습니다. |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` |
| 시트 | `Shipment Change Request Confirm`(상단 마스터), `Shipment Change Request Confirm Detail`(하단 상세) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.cs` | 2095 |
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.Designer.cs` | 1318 |
| current | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\Properties\AssemblyInfo.cs` | 37 |
| shared | 없음. Fact Pack에 shared 구분 파일이 없습니다. | — |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0003_ShipmentChangeRequestConfirm.cs` | 2056 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0003_ShipmentChangeRequestConfirm.Designer.cs` | 1318 |

본문은 current 파일 기준입니다. legacy 파일은 구버전 사본이므로 분석 대상에서 뺐습니다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| `Form_Load` (this.Load) | Form_Load > InitControls | 317 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | MATCH |
| `Form_Load` | Form_Load > InitControls > SetChangedControl | 369 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | NOT_IN_FOXQUERY |
| `Form_Load` | Form_Load > InitControls > SetChangedControl | 386 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | NOT_IN_FOXQUERY |
| `Form_Load` | Form_Load > InitControls > GetDayRange | 1864 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH |
| `ClbDivision_SelectedIndexChanged` | → SetChangedControl | 369 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | NOT_IN_FOXQUERY |
| `ClbDivision_SelectedIndexChanged` | → SetChangedControl | 386 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | NOT_IN_FOXQUERY |
| FindButton(프레임워크 조회 버튼) | FindButton > FindData_Main | 696 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `SpdMain_CellDoubleClick` | → FindData_Sub | 772 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | MATCH |
| `SpdMain_CellDoubleClick` | → Delegate_Load | 1834 | `SSP.SSP0003_GET_DELEGATEE_LOAD` | MATCH |
| `BtnApproval_Click` | → SaveDraftingData | 970 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | MATCH |
| `BtnApproval_Click` | → SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH |
| `BtnApproval_Click` | → SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| `BtnApproval_Click` | → SaveData > FindData_Main | 696 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `BtnApproval_Click` | → GetErpIFCheck | 1337 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `BtnApproval_Click` | → GetErpIFCheckNew | 1409 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `BtnApproval_Click` | → GetErpIFCheckNew | 1458 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| `BtnApproval_Click` | → GetErpIFCheckNew | 1492 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `BtnApproval_Click` | → GetErpIFCheckNew | 1541 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH |
| `BtnApproval_Click` | → EngProcessingChk | 1619 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH |
| `BtnApproval_Click` | → GetShipmentStatusChk | 1656 | `SSP.SSP0200_GET_SHIPMENT_STATUS` | MATCH |
| `BtnReject_Click` | → SaveDraftingData | 970 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | MATCH |
| `BtnReject_Click` | → SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| `BtnReject_Click` | → SaveData > FindData_Main | 696 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `BtnReject_Click` | → GetErpIFCheck | 1337 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `BtnSelfReject_Click` | → SaveDraftingData | 970 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | MATCH |
| `BtnSelfReject_Click` | → SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| `BtnSelfReject_Click` | → SaveData > FindData_Main | 696 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `BtnSelfReject_Click` | → GetErpIFCheck | 1337 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| (진입점 미연결) | SetChangedPeriod | 1573 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |

흐름에서 확인된 사실:
- `GetErpIFCheckNew`, `EngProcessingChk`, `GetShipmentStatusChk` 경로는 `BtnApproval_Click`에서만 도달합니다.
- `GetErpIFCheck`, `SaveDraftingData`, `SaveData`는 `BtnApproval_Click`, `BtnReject_Click`, `BtnSelfReject_Click` 세 버튼이 공통으로 도달합니다.
- `SaveData`의 줄 1207 한 지점에서 `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40`과 `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` 두 후보가 함께 추출됐습니다. SP 이름에 `_40`이 붙은 것으로 보아 Division 40 분기로 추정되지만, 실제 분기 조건식은 Fact Pack에 없습니다(**확인 필요**).
- 각 버튼 안에서 위 메서드들이 어떤 순서로, 어떤 조건에서 호출되는지는 Fact Pack에 없습니다(**확인 필요**).
- `SetChangedPeriod`는 정적 분석에서 진입점에 연결되지 않았습니다. 런타임 호출 여부는 **확인 필요**입니다.

## 3. 엔드포인트 전체 표 (16개)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 주요 참조 테이블 (SP 내부 EXEC 전이 포함) |
|---:|---|---|---:|---|---|
| 1 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` | MATCH | 1 | SSP0200_GET_SHIPMENT_DIVISION | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE |
| 2 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | NOT_IN_FOXQUERY | 1 | (FoxQuery 미등록, DB 객체 존재 P) | SCM_MST_SITE, STRING_SPLIT, TB_FX_USERGROUPAUTHEXTENTION |
| 3 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | NOT_IN_FOXQUERY | 1 | (FoxQuery 미등록, DB 객체 존재 P) | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, STRING_SPLIT, TB_FX_USERGROUPAUTHEXTENTION |
| 4 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH | 1 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN, FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| 5 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | MATCH | 1 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER |
| 6 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | MATCH | 1 | SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH 등 |
| 7 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH | 1 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, DELETE/INSERT SSP_ANL_SHIP_PLAN_40, INSERT DM_PLN_MKT_FCST_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H 등 |
| 8 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH | 1 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT XIF_FP_SSP_SALES_EXFACTORY_S_SN, INSERT SSP_ANL_SHIP_CONFIRM_H 등 |
| 9 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH | 3 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT/UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, NERP_CONV_MASTER, DM_PLN_MKT_FCST 등 |
| 10 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 1 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 |
| 11 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 1 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 12 | `biz:CommonData.CommonDataList` | BIZ_MATCH | 1 | — (code=PERIOD_{p:value} \|\| PERIOD_DEFAULT) | 확인 필요 |
| 13 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH | 1 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL |
| 14 | `SSP.SSP0200_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0200_GET_SHIPMENT_STATUS | SSP_ANL_SHIP_CONFIRM, STRING_SPLIT |
| 15 | `SSP.SSP0003_GET_DELEGATEE_LOAD` | MATCH | 1 | SSP0003_GET_DELEGATEE_LOAD | SSP_MST_DELEGATE, TB_FX_USER |
| 16 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SCM0001_GET_SCP_DAY_PERIOD | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE, FN_MULTY_TIME, FN_WEEKOFDAY_DATE |

참조 객체 전체 목록은 oracle_migration.md에 있습니다.

### 3-1. 주석 처리된 호출 (현행 기능 아님)

| 줄 | 값 | 비고 |
|---:|---|---|
| 1209 | SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | 주석 처리됨. 활성 호출은 줄 1207입니다. |
| 1863 | SCP.GET_DATE_RANGE_1MONTH | 주석 처리됨 |

## 4. 이벤트 배선 표 (9개)

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 도달 엔드포인트 |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:203 | SSP0200_GET_SHIPMENT_DIVISION, SSP0200_GET_PLANT_SITE_BY_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE, SCM0001_GET_SCP_DAY_PERIOD |
| this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | .ctor:204 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING, SSP0003_GET_DELEGATEE_LOAD |
| clbDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitEvent:275 | SSP0200_GET_PLANT_SITE_BY_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:276 | 추출된 엔드포인트 없음. 동작은 확인 필요 |
| btnApproval | Click | `BtnApproval_Click` | InitEvent:278 | 2장 참조(엔드포인트 10종) |
| btnReject | Click | `BtnReject_Click` | InitEvent:279 | DE_CONFIRM, CONFIRM_40/CONFIRM, IF_CHECK, 재조회 |
| btnSelfReject | Click | `BtnSelfReject_Click` | InitEvent:280 | DE_CONFIRM, CONFIRM_40/CONFIRM, IF_CHECK, 재조회 |
| btnRequestUser | Click | `BtnRequestUser_Click` | InitEvent:281 | 추출된 엔드포인트 없음. 팝업 여부 등 확인 필요 |
| btnItemId | Click | `btnItemId_Click` | InitEvent:282 | 추출된 엔드포인트 없음. 팝업 여부 등 확인 필요 |

## 5. Grid 구성 방식

- 구성 방식은 **`META(프레임워크) (+코드 표시/라벨 변경)`**입니다.
- 메타 컬럼은 `SpreadInfo.SetSheetHeaderColumn`으로 생성합니다.
  - InitSpread:431: `Shipment Change Request Confirm`, 헤더 1행
  - InitSpread:439: `Shipment Change Request Confirm Detail`, 헤더 2행
- 메타 출처는 `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SSP0003) 76행입니다. 상단 시트 22행, 하단 시트 54행입니다.
- 코드에서 바꾸는 부분은 다음과 같습니다.
  - Detail 시트 `CHK`: CellType=chk, Value=true, Border=bevelbrdr (InitSpread:447~449)
  - Detail 시트 `ERP_SO_NO`: `_sChangeType == "P"`이면 숨김(475), 그 외에는 표시(503)
  - Detail 시트 0행 그룹 헤더 `ColumnHeaderSpan`: `_sChangeType == "P"`이면 LT_DAY부터 6열에 "Plan", NEW_LT_DAY부터 6열에 "Confirm"을 씁니다. 그 외에는 "Confirmed"와 "Change"를 씁니다.
  - FindData_Sub:827: `p_status`가 E·O·R·S·D·A·P가 아닌 else 분기에서 `VisibleColumns(0, false)`로 0번 컬럼을 숨깁니다. 다른 분기에서의 처리는 확인 필요입니다.

### 5-1. Division별 차이

| 시트 | 40 | 81 계열(81, 81_HD/HG/HM/ST/UC) | 82 | EE 계열(EE, EE_HD/HG/HM/ST/UC) |
|---|---:|---:|---:|---:|
| Shipment Change Request Confirm | 19 | 19 | 19 | 19 |
| Shipment Change Request Confirm Detail | 29 (?1) | 29 (?1) | 29 (?1) | 29 (?1) |

- 메타상 표시 컬럼 수는 모든 Division에서 같습니다.
- `(?1)`은 `ERP_SO_NO`입니다. 이 컬럼의 표시 여부는 런타임 값 `_sChangeType`으로 정해지므로 정적 분석으로는 판단할 수 없습니다.
- Division에 따른 차이는 Grid가 아니라 저장 SP 선택(줄 1207, `_40` 여부) 쪽에서 나타날 가능성이 있습니다. 조건은 확인 필요입니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION`이 FoxQuery에 등록되어 있지 않습니다. DB 객체(P)는 존재합니다. | 줄 369, NOT_IN_FOXQUERY |
| 2 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`이 FoxQuery에 등록되어 있지 않습니다. DB 객체(P)는 존재합니다. | 줄 386, NOT_IN_FOXQUERY |
| 3 | 줄 1207에서 CONFIRM_40과 CONFIRM 중 하나를 고르는 분기 조건 | 동일 줄에서 2개 후보 추출 |
| 4 | `SetChangedPeriod`(CommonDataList PERIOD_*)의 실제 호출 경로 | 진입점 미연결 |
| 5 | `chkERPIFBlockYn`이 읽는 `dtERPBlockYnIF`(BLOCK_YN, PERIOD)의 데이터 출처 | 엔드포인트 미추출 |
| 6 | `SpdMain_TopChange`, `BtnRequestUser_Click`, `btnItemId_Click`의 동작 | 엔드포인트 미추출 |
| 7 | 4-2장에서 `SaveData`가 `PersonalSettingPopup.SaveData`로 매핑된 부분. 화면 자체에 `SaveData`(줄 1207)가 있어 파서의 오매핑일 수 있습니다. | Fact Pack 4-2 |
| 8 | grid_effective에서 상단 시트에 `ERP_SO_NO`(CODE_ONLY_CHANGE)가 귀속된 부분. 코드 조건은 Detail 시트입니다. | grid_effective |
| 9 | 버튼별 메서드 호출 순서와 각 단계의 성공·실패 분기 | Fact Pack 미포함 |

=== FILE: source_links.md ===
# SSP0003 소스 링크 표

기준 파일:
- `CS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.cs`
- `DS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0003_ShipmentChangeRequestConfirm.UIL\SSP0003_ShipmentChangeRequestConfirm.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | InitControls | 317 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` |
| CS | SetChangedControl | 369 | `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` (NOT_IN_FOXQUERY) |
| CS | SetChangedControl | 386 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` (NOT_IN_FOXQUERY) |
| CS | FindData_Main | 696 | `SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| CS | FindData_Sub | 772 | `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| CS | SaveDraftingData | 970 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` |
| CS | SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| CS | SaveData | 1207 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| CS | (주석) | 1209 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`. 주석 처리됨 |
| CS | GetErpIFCheck | 1337 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | GetErpIFCheckNew | 1409 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | GetErpIFCheckNew | 1458 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| CS | GetErpIFCheckNew | 1492 | `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | GetErpIFCheckNew | 1541 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| CS | SetChangedPeriod | 1573 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (Data.CallBizCommonData) |
| CS | EngProcessingChk | 1619 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| CS | GetShipmentStatusChk | 1656 | `SSP.SSP0200_GET_SHIPMENT_STATUS` |
| CS | Delegate_Load | 1834 | `SSP.SSP0003_GET_DELEGATEE_LOAD` |
| CS | (주석) | 1863 | `SCP.GET_DATE_RANGE_1MONTH`. 주석 처리됨 |
| CS | GetDayRange | 1864 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 203 | this.Load += `Form_Load` |
| CS | .ctor | 204 | this.spdMain.CellDoubleClick += `SpdMain_CellDoubleClick` |
| CS | InitEvent | 275 | clbDivision.SelectedIndexChanged += `ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 276 | spdMain.TopChange += `SpdMain_TopChange` |
| CS | InitEvent | 278 | btnApproval.Click += `BtnApproval_Click` |
| CS | InitEvent | 279 | btnReject.Click += `BtnReject_Click` |
| CS | InitEvent | 280 | btnSelfReject.Click += `BtnSelfReject_Click` |
| CS | InitEvent | 281 | btnRequestUser.Click += `BtnRequestUser_Click` |
| CS | InitEvent | 282 | btnItemId.Click += `btnItemId_Click` |

## 3. 프레임워크 메타 소비 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 227~228 | Filter GROUP_ID / USER_ID, UserInfoContext.NowGroupID |
| CS | SetChangeControl | 234, 239, 244, 249, 254, 259, 264 | `DataService.GetSSPInnerTable` |
| CS | InitControls | 293, 301 | `DataService.FP_Log2` |
| CS | InitControls | 321, 330 | NowGroupID, `c["CODE"]` |
| CS | SetChangedControl | 354 | `CString.GetCheckedListValue` |
| CS | SetChangedControl | 376, 391 | NowGroupID |
| CS | FindData_Main | 675, 678, 683, 685 | `CString.GetCheckedListValue` |
| CS | InitSpread | 431, 439 | `SpreadInfo.SetSheetHeaderColumn` |
| CS | SetChangeRequestInfo | 852~859 | dt.Rows[0]: CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME |
| CS | GetErpIFCheck | 1349 | ds.Tables[0].Rows[0]["result_code"] |
| CS | GetErpIFCheckNew | 1426 | ds.Tables[0].Rows[0]["result_code"] |
| CS | SetChangedPeriod | 1580, 1581 | FROM_VALUE, TO_VALUE |
| CS | chkERPIFBlockYn | 1593, 1602 | Field: BLOCK_YN, PERIOD |
| CS | GetShipmentStatusChk | 1699 | ds.Tables[2].Rows[iRow]["CONFIRM_ID"] |
| CS | BtnSelfReject_Click | 1921 | SaveData 호출 |
| CS | BtnReject_Click | 1993 | SaveData 호출 |
| CS | BtnApproval_Click | 2029, 2061, 2063 | SaveData 호출 |

## 4. Grid 코드 정의

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 405~406 | AddSheet / GetSheetInfo: spdMain, `Shipment Change Request Confirm` (SpdSheet.shtMain, 1, 1, 30) |
| CS | CreateSpread | 409~419 | AddSheet / GetSheetInfo / ChangeSheet: txtApprovalDeptName, `Shipment Change Request Confirm Detail` (SpdSheet.shtSub, 2, 1, 30) |
| CS | InitSpread | 426, 431 | InitSheet + SetSheetHeaderColumn(spreadInfo, 1): Main |
| CS | InitSpread | 437, 439 | InitSheet + SetSheetHeaderColumn(spreadInfo, 2): Detail |
| CS | InitSpread | 447~449 | CHK CellType / Value=true / Border |
| CS | InitSpread | 475 | `_sChangeType == "P"` → ERP_SO_NO Visible=false |
| CS | InitSpread | 477~492 | P 분기 ColumnHeaderSpan ("Plan", "Confirm", 2행 헤더) |
| CS | InitSpread | 503 | else 분기 → ERP_SO_NO Visible=true |
| CS | InitSpread | 505~520 | else 분기 ColumnHeaderSpan ("Confirmed", "Change", 2행 헤더) |
| CS | FindData_Sub | 827 | VisibleColumns(0, false) (p_status 조건) |
| DS | InitializeComponent | 191~194, 839~842 | 헤더 기본 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 5. 화면 배치 (Designer)

| 파일 | 줄 | 내용 |
|---|---:|---|
| DS | 146, 150, 162, 163 | splitContainer1: Dock Fill, Orientation Horizontal, Size(1192, 649), SplitterDistance 259 |
| DS | 169, 174 | spdMain: Dock Fill, Size(1192, 192) |
| DS | 220, 223, 225 | usrConditionPanel1: Dock Top, Size(1192, 67), HidePanel |
| DS | 648~652 | lcDivision → clbDivision, Text "Division" |
| DS | 682~690 | layoutControlItem1 → drpPeriod, Text "Request Date" |
| DS | 697~702 | layoutControlItem7 → clbFromSite, Text "From Site" |
| DS | 709~714 | PlanType → cboStatus, Text "Status" |
| DS | 804~809 | PlanType1 → cboChangeType, Text "Change Type" |
| DS | 379, 426, 437 | 버튼 Text "Self Reject", "Reject", "Approval" |
| DS | 817, 822 | txtApprovalDeptName(FpSpread): Dock Fill, Size(1192, 174) |
| DS | 867~880 | splitter1: Dock Top, 3px / panel1: Dock Top, 209px |
| DS | 908~925 | txtRequestNo, txtTitle, txtRequestor: ReadOnly true (이후 행은 Fact Pack에서 잘려 확인 필요) |

=== FILE: web_components.md ===
# SSP0003 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

라벨은 props.csv의 `LayoutControlItem.Text` 또는 컨트롤 `Text` 원문입니다. props.csv가 잘려 원문을 볼 수 없는 라벨은 **확인 필요**로 표시했습니다.

### 1-1. 조회조건 영역 (usrConditionPanel1 → usrLayoutControl1)

| AS-IS 컨트롤 | 유형 | LayoutItem | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCheckedList | lcDivision | "Division" | 다중 선택 콤보 (Wijmo MultiSelect 계열) |
| clbFromSite | UsrCheckedList | layoutControlItem7 | "From Site" | 다중 선택 콤보 |
| drpPeriod | UsrDateRangePicker | layoutControlItem1 | "Request Date" | 기간(From~To) 날짜 입력 |
| cboStatus | UsrCombo | PlanType | "Status" | 단일 선택 콤보 |
| cboChangeType | UsrCombo | PlanType1 | "Change Type" | 단일 선택 콤보 |
| txtRequest | UsrMultiLineEditor | Requestor | 확인 필요 (LayoutItem 이름은 Requestor) | 텍스트 입력 + 검색 버튼 |
| btnRequestUser | UsrButton | layoutControlItem13 | Text "layoutControlItem2"(TextVisible 여부 확인 필요) | 사용자 검색 팝업 버튼 후보 |
| txtItemID | UsrMultiLineEditor | Model | 확인 필요 (LayoutItem 이름은 Model) | 텍스트 입력 + 검색 버튼 |
| btnItemId | UsrButton | layoutControlItem2 | 확인 필요 | 품목 검색 팝업 버튼 후보 |
| btnApproval | SimpleButton | lcBtnApproval | "Approval" | 액션 버튼 |
| btnReject | SimpleButton | lcBtnReject | "Reject" | 액션 버튼 |
| btnSelfReject | SimpleButton | lcSelfReject | "Self Reject" | 액션 버튼 |

### 1-2. 하단 요청 정보 패널 (panel1 → usrLayoutControl3)

| AS-IS 컨트롤 | 유형 | 속성 | 라벨 | TO-BE 후보 |
|---|---|---|---|---|
| txtRequestNo | TextBox | ReadOnly | 확인 필요 | 읽기 전용 입력 |
| txtTitle | TextBox | ReadOnly | 확인 필요 (LayoutItem lcTitle/lcTitle1 존재) | 읽기 전용 입력 |
| txtRequestor | TextBox | ReadOnly | 확인 필요 | 읽기 전용 입력 |
| txtRequestDeptName | TextBox | 확인 필요 | 확인 필요 | 입력 |
| txtApproval | TextBox | 확인 필요 | 확인 필요 (LayoutItem lcApproval) | 입력 |
| txtAppDeptName | TextBox | 확인 필요 | 확인 필요 | 입력 |
| txtChangeReason | TextBox | 확인 필요 | 확인 필요 | 입력 |
| txtReasonDetail | TextBox | 확인 필요 | 확인 필요 (LayoutItem lcReasonDetail) | 입력 |
| txtRejectReason | TextBox | 확인 필요 | 확인 필요 | 반려 사유 입력 후보 |
| usrLabel2 | UsrLabel | — | 확인 필요 | 라벨 |

`SetChangeRequestInfo`(줄 852~859)가 이 패널을 채우는 것으로 보입니다. 이 메서드는 CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME을 읽습니다. 컬럼과 TextBox의 1:1 대응은 확인 필요입니다.

### 1-3. Grid

| AS-IS 컨트롤 | 시트 | TO-BE 후보 |
|---|---|---|
| spdMain (FpSpread) | `Shipment Change Request Confirm` | Wijmo FlexGrid (마스터) |
| txtApprovalDeptName (FpSpread, 이름과 달리 Spread) | `Shipment Change Request Confirm Detail` | Wijmo FlexGrid (상세, 2행 헤더) |

## 2. 화면 배치

- **splitContainer1**: Dock Fill, Orientation Horizontal(상/하 분할), Size 1192×649, SplitterDistance 259
  - 상단 Panel1은 259px입니다. 전체 649 중 약 39.9%입니다.
    - usrConditionPanel1: Dock Top, 67px, HidePanel
    - spdMain: Dock Fill, 192px
  - 하단 Panel2는 나머지 높이입니다. SplitterWidth 값이 Fact Pack에서 확인되지 않아, 649−259=390px(약 60.1%)에서 분할선 폭을 뺀 값입니다.
    - panel1(요청 정보): Dock Top, 209px
    - splitter1: Dock Top, 3px
    - txtApprovalDeptName(Detail Grid): Dock Fill, 174px
- 좌/우 분할은 없습니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

### 3-1. `Shipment Change Request Confirm` (메타 22행, 표시 19, 모든 Division 동일)

| 컬럼 | 라벨 | 표시 |
|---|---|---|
| CHANGE_REQ_NO | Request No | 기본 |
| REQUEST_TITLE | Title | 기본 |
| CHANGE_TYPE | Change Type | 기본 |
| SHIPMENT_STATUS | Status | 기본 |
| DIVISION_ID | Division | 기본 |
| FROM_SITE | From Site | 기본 |
| TO_SITE | To Site | 기본 |
| ITEM_ID | Model | 기본 |
| NICK_NAME | Nick Name | 기본 |
| CHANGE_REASON_CODE | Change Reason | 기본 |
| REJECT_REASON | Reject Reason | 기본 |
| REQUEST_USER_NAME | Requestor | 기본 |
| REQUEST_DEPT | Requestor Dept Name | 기본 |
| REQUEST_TIME | Request Date | 기본 |
| APPROVAL_USER_NAME | Approval | 기본 |
| APPROVAL_DEPT | Approval Dept Name | 기본 |
| APPROVAL_TIME | Approval Date | 기본 |
| DELEGATEE_USER_NAME | Delegatee | 기본 |
| DELEGATEE_DEPT | Delegatee Dept Name | 기본 |
| REQUEST_USER | Requestor | 숨김 |
| APPROVAL_USER | Approval | 숨김 |
| DELEGATEE_USER | Delegatee | 숨김 |
| ERP_SO_NO | (라벨 없음) | CODE_ONLY_CHANGE. 이 시트에 귀속된 근거는 확인 필요 |

- 위 표의 컬럼 순서는 표시 순서가 아닙니다. 실제 순서는 메타 `SCM_MST_SHEET_COLUMNS`를 기준으로 확인해야 합니다.

### 3-2. `Shipment Change Request Confirm Detail` (메타 54행, 표시 29, 헤더 2행)

**표시 컬럼 (29)**

| 컬럼 | 라벨 | 비고 |
|---|---|---|
| CHK | ALL | 코드: CheckBox CellType, Value=true, bevel Border |
| CONFIRM_ID | Confirm ID | |
| ERP_SO_NO | SO No | 코드: `_sChangeType=="P"`이면 숨김, 그 외 표시 (?) |
| FCST_TYPE | FCST Type | |
| PROJECT_NAME | Project Name | |
| ITEM_ID | Model | |
| FROM_SITE_DESCRIPTION | From Site | |
| TO_SITE_DESCRIPTION | To Site | |
| INCOTERMS | Incoterms | |
| LT_DAY | L/T(Day) | 그룹 헤더 "Plan" 또는 "Confirmed" 시작 열 |
| ETD | ETD | |
| ETA | ETA | |
| TRANSPORT_MODE | Trans Mode | |
| SHIPMENT_DATE | Shipment Date | |
| SHIPMENT_CONFIRM_QTY | Qty | |
| NEW_LT_DAY | L/T(Day) | 그룹 헤더 "Confirm" 또는 "Change" 시작 열 |
| NEW_ETD | ETD | |
| NEW_ETA | ETA | |
| NEW_TRANSPORT_MODE | Trans Mode | |
| NEW_SHIPMENT_DATE | Shipment Date* | |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | |
| ERP_ATTR1 | Consignee Name | |
| ERP_ATTR2 | Contact Point | |
| ERP_ATTR3 | Lot | |
| REMARKS | Remarks | |
| REMARKS2 | Building | |
| REMARKS3 | Customer requirement | |
| STATUS_DETAIL | Status Detail | |
| REJECT_REASON | Reject Reason | |

**숨김 컬럼 (25)**: A_COUNTRY, A_PORT_CODE, BOD_ID, CHANGE_REQ_NO, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE

**2행 헤더 (ColumnHeaderSpan, InitSpread 477~520)**

| 조건 | 0행 LT_DAY부터 6열 | 0행 NEW_LT_DAY부터 6열 | ERP_SO_NO |
|---|---|---|---|
| `_sChangeType == "P"` | "Plan" | "Confirm" | 숨김 |
| 그 외 | "Confirmed" | "Change" | 표시 |

- 1행 헤더는 두 경우 모두 같습니다: L/T(Day), ETD, ETA, Trans Mode, Shipment Date / Shipment Date*, Qty / Qty*. 각 헤더는 2행에 걸쳐 span됩니다.

**Division별 표시 차이**: 40, 81 계열, 82, EE 계열 모두 19개(Main)와 29개(Detail, ?1=ERP_SO_NO)로 같습니다. Division별 차이는 없습니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 연결 동작 |
|---|---|---|
| Shipment Change Request Confirm | META+코드연결 | FindButton → FindData_Main(`SSP.SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`) |
| Shipment Change Request Confirm Detail | META+코드연결 | 마스터 `SpdMain_CellDoubleClick` → FindData_Sub(`SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`) + Delegate_Load(`SSP.SSP0003_GET_DELEGATEE_LOAD`) |

- 마스터→상세 연결은 더블클릭으로 일어납니다. 행 선택 변경으로는 연결되지 않습니다.
- 상세 조회 키 파라미터는 Fact Pack에 없습니다(확인 필요).
- FindData_Sub:827에서 `p_status` 값에 따라 상세 Grid 0번 컬럼(CHK로 추정)을 숨깁니다. 그 외 분기의 처리는 확인 필요입니다.

=== FILE: oracle_migration.md ===
# SSP0003 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (13개)

| # | SP | 호출 위치 | 성격 | 참조 객체 (EXEC 체인 포함) |
|---:|---|---|---|---|
| 1 | `SSP0200_GET_SHIPMENT_DIVISION` | InitControls:317 | 조회 | SELECT SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE |
| 2 | `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | FindData_Main:696 | 조회 | SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN / REF FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| 3 | `SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | FindData_Sub:772 | 조회 | SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER / REF FN_GET_PROJECT_NAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO |
| 4 | `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM` | SaveDraftingData:970 | 저장 | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / UPDATE A(별칭), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS |
| 5 | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SaveData:1207 | 저장 | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, PR_DM_SSP_CONFIRM_SYNC, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SSP_ANL_SHIP_CONFIRM_ROUTE / 임시 #TBLDYNAMIC_SSP0003_40_STD, #TBLSSPAPPROVEDMAILSEND, #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TEMP_SHIP_RESULT / DML: UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, DELETE/INSERT SSP_ANL_SHIP_PLAN_40, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT DM_PLN_MKT_FCST_CONFIRM, DELETE A / UPDATE A(별칭), INSERT SCM_SYS_LOG_BATCH / SELECT SSP_ANL_SHIP_PLAN_40, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_MST_SITE_ITEM_EE_V, SCP_MST_BOD_N_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, TB_FX_USER, SCM_ADM_RECIPIENT_LIST/MESSAGE/ASSIGN, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, DM_PLN_MKT_FCST_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME, UF_FX_STRING_SPLIT, FN_NEXT_DAY |
| 6 | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM` | SaveData:1207 (줄 1209는 주석 처리됨) | 저장 | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, SCM_SSP_MODEL_USER_MAIL_SEND, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_DM_SSP_CONFIRM_SYNC, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SCP_SYS_LOG_BATCH / 임시 #TBLSSPAPPROVEDMAILSEND, #TBLSSPAPPROVEDMAILSEND2, #TMP_XIF_FP_SSP_SALES_EXFACTROY / DML: UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT XIF_FP_SSP_SALES_EXFACTORY_S_SN, INSERT SCM_SYS_LOG_BATCH / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_MST_SITE_ITEM_EE_V, SSP_MST_MODEL_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_SYS_CALENDAR_M, TB_FX_USER, SCM_ADM_RECIPIENT_LIST/MESSAGE/ASSIGN, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_PROJECT, NERP_CONV_MASTER, SCP_PLN_INTERFACE_SEND_H, SSP_ANL_SHIP_REQ_EE, DM_PLN_SHIPMENT_REQ, SCP_MST_FINAL_ITEM / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME, FN_ZERO_LPAD, FN_GET_SITE_CUSTOMER_INFO, FN_GET_SSP_DOM_EXP, FN_GET_SSP_ANL_SHIP_FROZEN, FN_GET_SSP_SITE_INFO, FN_GET_ANL_SHIP_FROZEN_DAY_CNT |
| 7 | `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | GetErpIFCheck:1337, GetErpIFCheckNew:1409, 1492 (3회) | 저장/IF | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE, PR_SCP_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN / INSERT SCM_SYS_LOG_BATCH, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST / REF FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS, SCM_ARR_SPL_CNT |
| 8 | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | GetErpIFCheckNew:1458 | 삭제/IF | 임시 #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM / DELETE SSP_ANL_SHIP_CONFIRM / INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_SITE_INFO, FN_GET_SSP_SITE_INFO_EXCEPTION, FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS |
| 9 | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | GetErpIFCheckNew:1541 | 저장 | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 10 | `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | EngProcessingChk:1619 | 검증 조회 | SELECT SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL |
| 11 | `SSP0200_GET_SHIPMENT_STATUS` | GetShipmentStatusChk:1656 | 검증 조회 | SELECT SSP_ANL_SHIP_CONFIRM / REF STRING_SPLIT. 화면은 결과 Tables[2]의 CONFIRM_ID를 읽음(줄 1699) |
| 12 | `SSP0003_GET_DELEGATEE_LOAD` | Delegate_Load:1834 | 조회 | SELECT SSP_MST_DELEGATE, TB_FX_USER |
| 13 | `SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange:1864 | 조회(기간 기본값) | SELECT SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE / REF FN_MULTY_TIME, FN_WEEKOFDAY_DATE |

## 2. 공통코드 분기

| 호출 | code | 대상 | 읽는 컬럼 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (SetChangedPeriod:1573) | `PERIOD_{p:value}`, 없으면 `PERIOD_DEFAULT` | 테이블은 Fact Pack에 없음(확인 필요) | FROM_VALUE, TO_VALUE (줄 1580~1581) |

- `SetChangedPeriod`는 진입점에 연결되지 않았습니다. 실사용 여부는 확인 필요입니다.
- 메타 `SCM_ADM_LOOKUP_MASTER_DETAIL`에 화면 ID SSP0003 값이 들어 있는 행이 1건, `_H`에 4건 있습니다. 행 내용은 dbmeta CSV를 참조해야 합니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

| 엔드포인트 | 줄 | DB 객체 | 내부 참조 |
|---|---:|---|---|
| `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` | 369 | 존재(P) | SELECT SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION / REF STRING_SPLIT |
| `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` | 386 | 존재(P) | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION / REF STRING_SPLIT |

두 SP 모두 FoxQuery 매핑 없이 직접 호출되거나 미등록 상태입니다. 어느 쪽인지는 DB 단계에서 확인해야 합니다. 두 호출 모두 `SetChangedControl`에서 일어나며 From Site 목록을 채우는 용도로 보입니다. 두 SP 중 어느 쪽이 쓰이는지 정하는 분기 조건은 확인 필요입니다.

## 4. 주석 처리된 호출 (전환 대상 아님)

- 줄 1209 `SSP.SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`: 주석 처리됨. 활성 호출은 줄 1207입니다.
- 줄 1863 `SCP.GET_DATE_RANGE_1MONTH`: 주석 처리됨.

## 5. Oracle 전환 확인 포인트 (Fact Pack 근거만)

| # | 포인트 | 해당 SP |
|---:|---|---|
| 1 | MSSQL `STRING_SPLIT` 참조. Oracle 대체 구현이 필요합니다. | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM, SSP0200_GET_SHIPMENT_STATUS, SSP0200_GET_PLANT_SITE_BY_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| 2 | `UF_FX_STRING_SPLIT`, `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL` 배열 분해 함수 | CONFIRM_40, CONFIRM, DE_CONFIRM, IF_CHECK, DELETE_..._BY_CONFIRM, ERP_ERROR_CONFIRM |
| 3 | `#` 임시 테이블 사용. GTT 또는 대체 구조가 필요합니다. | CONFIRM_40(#TBLDYNAMIC_SSP0003_40_STD, #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TEMP_SHIP_RESULT, #TBLSSPAPPROVEDMAILSEND), CONFIRM(#TBLSSPAPPROVEDMAILSEND, #TBLSSPAPPROVEDMAILSEND2, #TMP_XIF_FP_SSP_SALES_EXFACTROY), DELETE_..._BY_CONFIRM(#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106) |
| 4 | `#TBLDYNAMIC_SSP0003_40_STD` 이름으로 보아 동적 SQL 사용 가능성이 있습니다. | CONFIRM_40. 동적 SQL 여부는 원문 확인 필요 |
| 5 | `UPDATE A` / `DELETE A` 별칭 대상 DML. MSSQL의 UPDATE…FROM 조인 형태로 추정되며 MERGE 등으로 변환해야 할 수 있습니다. | DE_CONFIRM, CONFIRM_40 |
| 6 | `CTE_DATE` 참조. 재귀 CTE 여부는 확인 필요입니다. | SCM0001_GET_SCP_DAY_PERIOD |
| 7 | 메일 발송 체인(SCM_SSP_MAIL_SEND, SCM_SSP_MODEL_USER_MAIL_SEND, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG) | CONFIRM_40, CONFIRM |
| 8 | 외부 IF 테이블 적재(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, XIF_FP_SSP_SALES_EXFACTORY_S_SN, NERP_CONV_MASTER) | DE_CONFIRM, IF_CHECK, DELETE_..._BY_CONFIRM, CONFIRM |
| 9 | 타 도메인 동기화 EXEC(PR_DM_SSP_CONFIRM_SYNC, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(_SCS), PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE) | CONFIRM_40, CONFIRM, IF_CHECK |
| 10 | 로그·트랜잭션 래퍼 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`. 트랜잭션 경계를 어떻게 옮길지 정해야 합니다. | 저장 SP 전부 |
| 11 | 다중 결과셋. 화면이 `ds.Tables[2]`를 읽으므로 결과셋이 3개 이상입니다. Oracle에서는 SYS_REFCURSOR 여러 개로 대응해야 합니다. | SSP0200_GET_SHIPMENT_STATUS |
| 12 | `result_code` 반환값으로 분기 | IF_CHECK (GetErpIFCheck:1349, GetErpIFCheckNew:1426) |

### 난이도 (사실 근거)

| SP | 근거 | 난이도 |
|---|---|---|
| SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | EXEC 8종, 임시 테이블 9종, 별칭 DML, 메일·동기화 체인 | 높음 |
| SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC 11종, 임시 테이블 3종, IF 테이블 2종, 메일 체인 | 높음 |
| SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | ERP IF 적재, 배열 분해, 임시 테이블 또는 별칭 DML | 중~높음 |
| SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 배열 분해 + INSERT/UPDATE 3개 테이블 | 중 |
| SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM, SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING, SSP0200_GET_SHIPMENT_STATUS | 조회. STRING_SPLIT, FN 참조, 다중 결과셋 | 중 |
| SSP0200_GET_SHIPMENT_DIVISION, SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SSP0003_GET_DELEGATEE_LOAD, SCM0001_GET_SCP_DAY_PERIOD | 단순 SELECT 위주 (SCM0001은 CTE_DATE 확인 필요) | 낮음~중 |

=== FILE: tobe_design.md ===
# SSP0003 TO-BE 설계 기초

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 초기화·연동 | 조회 파라미터 반영 |
|---|---|---|---|
| Division | clbDivision (UsrCheckedList) | Form_Load > InitControls에서 `SSP.SSP0200_GET_SHIPMENT_DIVISION`으로 채움. NowGroupID 사용 | FindData_Main:675~685 GetCheckedListValue(CODE) |
| From Site | clbFromSite (UsrCheckedList) | Division 변경 시 SetChangedControl에서 `SSP.SSP0200_GET_PLANT_SITE_BY_DIVISION` 또는 `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`로 채움(선택 조건 확인 필요) | GetCheckedListValue |
| Request Date | drpPeriod (UsrDateRangePicker) | GetDayRange에서 `SCP.SCM0001_GET_SCP_DAY_PERIOD`로 기본값 설정 | 확인 필요 |
| Status | cboStatus (UsrCombo) | 데이터 소스 확인 필요 | 확인 필요 |
| Change Type | cboChangeType (UsrCombo) | 데이터 소스 확인 필요. Detail 헤더 분기 `_sChangeType == "P"`와의 관계도 확인 필요 | 확인 필요 |
| (Requestor, 라벨 확인 필요) | txtRequest + btnRequestUser | btnRequestUser_Click 동작 확인 필요 | 확인 필요 |
| (Model, 라벨 확인 필요) | txtItemID + btnItemId | btnItemId_Click 동작 확인 필요 | 확인 필요 |

- `SetChangeControl`(줄 227~264)은 `DataService.GetSSPInnerTable`을 7회 호출하고 GROUP_ID와 USER_ID로 필터합니다. 어떤 컨트롤에 바인딩되는지는 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 핸들러 | 호출 SP (순서 확인 필요) |
|---|---|---|
| 조회 | FindButton → FindData_Main | `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| 마스터 행 더블클릭(상세) | SpdMain_CellDoubleClick | `SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`, `SSP0003_GET_DELEGATEE_LOAD` |
| Division 변경 | ClbDivision_SelectedIndexChanged | `SSP0200_GET_PLANT_SITE_BY_DIVISION` / `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` |
| 화면 진입 | Form_Load | `SSP0200_GET_SHIPMENT_DIVISION`, `SCM0001_GET_SCP_DAY_PERIOD`, 위 Site SP |
| Approval | BtnApproval_Click | `SSP0200_GET_SHIPMENT_STATUS`(상태 검증), `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`(계획 처리 중 검증), `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`(GetErpIFCheck / GetErpIFCheckNew), `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, 재조회 `SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| Reject | BtnReject_Click | `SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 또는 `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, 재조회 |
| Self Reject | BtnSelfReject_Click | Reject와 같은 SP 집합 |
| SpdMain TopChange | SpdMain_TopChange | 없음(동작 확인 필요) |

- Approval만 ERP IF 신규 경로(GetErpIFCheckNew), 상태 검증, 계획 처리 중 검증을 거칩니다.
- `chkERPIFBlockYn`(BLOCK_YN, PERIOD)은 ERP IF 차단 여부를 검사하는 로직으로 보입니다. 호출 위치와 데이터 출처는 확인 필요입니다.
- `_40`과 일반 저장 SP를 고르는 조건은 확인 필요입니다. SP 이름으로 보아 Division 40 분기로 추정합니다.

## 3. Division별 Grid 변형 요약

| 시트 | 메타 행 | 표시 컬럼 | Division 차이 | 코드 변형 |
|---|---:|---:|---|---|
| Shipment Change Request Confirm | 22 | 19 | 없음 (40, 81 계열, 82, EE 계열 동일) | 없음 |
| Shipment Change Request Confirm Detail | 54 | 29 (?1) | 없음 | CHK 체크박스, ERP_SO_NO 표시 여부와 0행 그룹 헤더(Plan/Confirm vs Confirmed/Change)를 `_sChangeType`으로 결정, p_status에 따라 0번 컬럼 숨김 |

## 4. 권한 (C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| `TB_FX_GroupMenuAuth`에 SSP0003 관련 15행 | DB 메타 |
| `TB_FX_MenuItemInfo` 4행, `TB_FX_ProgramInfo` 4행 | DB 메타 |
| Division·Site 조회 SP가 `TB_FX_USERGROUPAUTHEXTENTION`을 참조(그룹 권한 확장) | SSP0200_GET_SHIPMENT_DIVISION, SSP0200_GET_PLANT_SITE_BY_DIVISION, SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE |
| `UserInfoContext.Current.NowGroupID` 사용 | InitControls:321, SetChangeControl:227, SetChangedControl:376, 391 |
| `GetSSPInnerTable` Filter에 GROUP_ID, USER_ID 사용 | SetChangeControl:227~228 |
| 위임자(Delegatee) 조회 | SSP0003_GET_DELEGATEE_LOAD (SSP_MST_DELEGATE) |
| 승인·반려 버튼 3종의 권한별 활성화 조건 | **확인 필요** (Fact Pack에 없음) |
| C/R/U/D 각 플래그 값 | **확인 필요** (dbmeta_dbo_TB_FX_GroupMenuAuth.csv 원문 확인) |

## 5. 미확정 사항

1. 줄 1207의 CONFIRM_40과 CONFIRM 분기 조건
2. 버튼별 호출 순서와 각 단계의 성공·실패 처리. `result_code`(줄 1349, 1426)에 따른 분기 포함
3. `SSP0200_GET_PLANT_SITE_BY_DIVISION`과 `SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE`의 FoxQuery 미등록 처리 방식, 둘 중 선택 조건
4. `SetChangedPeriod`(CommonDataList PERIOD_*) 실사용 여부
5. `chkERPIFBlockYn` 데이터 출처
6. cboStatus와 cboChangeType의 항목 소스, 그리고 `_sChangeType`과의 연계
7. 하단 요청 정보 패널의 TextBox 라벨 원문(props.csv 잘림)과 편집 가능 여부(txtRejectReason 등)
8. `BtnRequestUser_Click`, `btnItemId_Click`, `SpdMain_TopChange` 동작
9. FindData_Sub:827 외 p_status 분기(E/O/R/S, D/A, P)별 Grid 처리
10. `SSP0200_GET_SHIPMENT_STATUS`의 결과셋 구성(Tables[2] 사용)
11. 주석 처리된 호출(줄 1209, 1863)은 현행 기능이 아니므로 TO-BE 대상에서 제외
