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
