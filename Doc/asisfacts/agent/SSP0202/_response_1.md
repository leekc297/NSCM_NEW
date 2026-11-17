=== FILE: analysis.md ===
# SSP0202 Shipment Change Request Confirm — As-Is 분석

> 출처: AsisFacts 정적 추출 Fact Pack(SSP0202). 이 문서에는 Fact Pack에 있는 사실만 적었습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0202 |
| 클래스 | `SSP0202_ShipmentChangeRequestConfirm` |
| 도메인 | SSP (프로젝트 `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj`) |
| 화면명(파일명 기준) | Shipment Change Request Confirm |
| Grid 구성 방식 | **META(프레임워크) (+코드 표시/라벨 변경)** |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0202_ShipmentChangeRequestConfirm.cs` | 1440 |
| current(only) | `06.UIL\GSCM.SSP.Plan.UIL\SSP0202_ShipmentChangeRequestConfirm.Designer.cs` | 1314 |
| shared | 없음 (Fact Pack에 shared 파일 없음) | - |
| legacy | 없음 (Fact Pack에 legacy 사본 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| `this.Load` → `Form_Load` | Form_Load > InitControls > GetDayRange | 1263 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH |
| 프레임워크 FindButton(조회) | FindButton > FindData_Main | 611 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `spdMain.CellDoubleClick` → `SpdMain_CellDoubleClick` | SpdMain_CellDoubleClick > FindData_Sub | 687 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | MATCH |
| `spdMain.CellDoubleClick` → `SpdMain_CellDoubleClick` | SpdMain_CellDoubleClick > Delegate_Load | 1233 | `SSP.SSP0202_GET_DELEGATEE_LOAD` | MATCH |
| `btnApproval.Click` → `BtnApproval_Click` | BtnApproval_Click > EngProcessingChk | 1090 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH |
| `btnApproval.Click` → `BtnApproval_Click` | BtnApproval_Click > chkSaveYN | 1130 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | MATCH |
| `btnApproval.Click` → `BtnApproval_Click` | BtnApproval_Click > GetErpIFCheck | 986 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `btnApproval.Click` → `BtnApproval_Click` | BtnApproval_Click > SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH |
| `btnApproval.Click` → `BtnApproval_Click` | BtnApproval_Click > SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| `btnApproval.Click` → `BtnApproval_Click` | BtnApproval_Click > SaveData > FindData_Main | 611 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `btnReject.Click` → `BtnReject_Click` | BtnReject_Click > GetErpIFCheck | 986 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `btnReject.Click` → `BtnReject_Click` | BtnReject_Click > SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH |
| `btnReject.Click` → `BtnReject_Click` | BtnReject_Click > SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| `btnReject.Click` → `BtnReject_Click` | BtnReject_Click > SaveData > FindData_Main | 611 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| `btnSelfReject.Click` → `BtnSelfReject_Click` | BtnSelfReject_Click > GetErpIFCheck | 986 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH |
| `btnSelfReject.Click` → `BtnSelfReject_Click` | BtnSelfReject_Click > SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH |
| `btnSelfReject.Click` → `BtnSelfReject_Click` | BtnSelfReject_Click > SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| `btnSelfReject.Click` → `BtnSelfReject_Click` | BtnSelfReject_Click > SaveData > FindData_Main | 611 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH |
| (진입점 미연결) | SetChangedPeriod | 1044 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |

흐름에서 확인된 사실:
- `EngProcessingChk`(1090)와 `chkSaveYN`(1130)은 **`BtnApproval_Click` 경로에만** 있습니다. `BtnReject_Click`와 `BtnSelfReject_Click`에는 이 두 검사가 없습니다.
- `GetErpIFCheck`(986)는 세 버튼(Approval / Reject / Self Reject)에서 모두 호출됩니다.
- `SaveData` 875줄에 `_40` 저장 SP와 일반 저장 SP가 **같은 줄에** 추출되었습니다. 둘 중 하나를 고르는 분기(삼항식 등)로 보이지만 분기 조건은 Fact Pack에 없습니다. 실제 조건은 **확인 필요**입니다.
- 저장 뒤에는 `FindData_Main`(611)으로 재조회합니다.
- 프레임워크 메타 소비표(4-2)에 `SaveData`가 `PersonalSettingPopup.SaveData`로 연결되어 있습니다(BtnSelfReject_Click:1311, BtnReject_Click:1369, BtnApproval_Click:1412). 화면 내부 `SaveData`(875)와 이름이 같아서 파서가 잘못 연결했을 수 있습니다. **확인 필요**.

## 3. 엔드포인트 전체 표

| # | 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 테이블·객체(SP 내부 EXEC 전이 포함, 원문) |
|---:|---|---|---:|---|---|
| 1 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` | MATCH | 1 | SP SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | FN_GET_ITEM_NICKNAME, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SSP_MST_DELEGATE, STRING_SPLIT, SCM_MST_SITE, SCM_MST_ITEM_SN |
| 2 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | MATCH | 1 | SP SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | FN_GET_PROJECT_NAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER |
| 3 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH | 1 | SP SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | UPDATE/INSERT/DELETE SSP_ANL_SHIP_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SSP_ANL_SHIP_CONFIRM_H, EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, SCM_ADM_MAIL_SEND, SP_SEND_DBMAIL, INSERT SCM_ADM_SMS_MAIL_SEND_LOG 외 (전체 목록: oracle_migration.md §1) |
| 4 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH | 1 | SP SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM | UPDATE/INSERT/DELETE SSP_ANL_SHIP_CONFIRM, EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT DM_PLN_MKT_FCST_CONFIRM 외 (전체 목록: oracle_migration.md §1) |
| 5 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH | 1 | SP SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, NERP_CONV_MASTER 외 (전체 목록: oracle_migration.md §1) |
| 6 | `biz:CommonData.CommonDataList` | BIZ_MATCH | 1 | (biz 호출, `Data.CallBizCommonData`) | code = `PERIOD_{p:value}` \|\| `PERIOD_DEFAULT` → FROM_VALUE, TO_VALUE를 읽음 |
| 7 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH | 1 | SP SSP0202_GET_SSP_PLAN_PROCESSING_CHECK | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL |
| 8 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | MATCH | 1 | SP SSP0202_GET_SCS_CONFIRM_ID_CHECK | SCM_ADM_LOOKUP_MASTER_DETAIL, FN_GET_IN_STR, FN_SCM_SPLIT, **동적 SQL**(DYNAMIC@SSP0202_GET_SCS_CONFIRM_ID_CHECK) |
| 9 | `SSP.SSP0202_GET_DELEGATEE_LOAD` | MATCH | 1 | SP SSP0202_GET_DELEGATEE_LOAD | SSP_MST_DELEGATE, TB_FX_USER |
| 10 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | FN_MULTY_TIME, SCM_SYS_CALENDAR_M, FN_WEEKOFDAY_DATE, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE |

### 3-1. 주석 처리된 호출 (현행 기능 아님)

| 줄 | 값 | 상태 |
|---:|---|---|
| 877 | SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM | **주석 처리됨** |
| 1262 | SCP.GET_DATE_RANGE_1MONTH | **주석 처리됨** |

875줄의 활성 호출과는 별개로, 877줄 호출은 주석 처리되어 있어 집계에서 뺐습니다.

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 연결 엔드포인트(flow 기준) |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:185 | SCP.SCM0001_GET_SCP_DAY_PERIOD |
| this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | .ctor:186 | SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING, SSP0202_GET_DELEGATEE_LOAD |
| clbDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitEvent:257 | 없음 (동작은 확인 필요) |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:258 | 없음 (동작은 확인 필요) |
| btnApproval | Click | `BtnApproval_Click` | InitEvent:260 | PLAN_PROCESSING_CHECK, SCS_CONFIRM_ID_CHECK, IF_CHECK, SAVE(_40/일반), 재조회 |
| btnReject | Click | `BtnReject_Click` | InitEvent:261 | IF_CHECK, SAVE(_40/일반), 재조회 |
| btnSelfReject | Click | `BtnSelfReject_Click` | InitEvent:262 | IF_CHECK, SAVE(_40/일반), 재조회 |
| btnRequestUser | Click | `BtnRequestUser_Click` | InitEvent:263 | 없음 (동작은 확인 필요) |
| btnItemId | Click | `btnItemId_Click` | InitEvent:264 | 없음 (동작은 확인 필요) |

## 5. 기타 코드 사실 (메타·데이터 컬럼 사용)

| 메서드 | 줄 | 대상 | 읽는 컬럼 / 동작 |
|---|---:|---|---|
| SetChangeControl | 209~210 | Filter / UserInfoContext.Current | GROUP_ID, USER_ID, NowGroupID |
| SetChangeControl | 216, 221, 226, 231, 236, 241, 246 | `DataService.GetSSPInnerTable` (7회) | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| InitControls | 275, 283 | `DataService.FP_Log2` | LOGTYPE, NOTE, USER_ID |
| InitControls | 295 | c | CODE |
| SetChangedControl | 319, 327 | `CString.GetCheckedListValue`, NowGroupID | CODE |
| FindData_Main | 593, 594, 598, 600 | `CString.GetCheckedListValue` | CODE |
| SetChangeRequestInfo | 723~730 | dt.Rows[0] | CHANGE_REQ_NO, REQUEST_TITLE, REQUEST_USER, REQUEST_DEPT, APPROVAL_USER, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME |
| GetErpIFCheck | 998 | ds.Tables[0].Rows[0] | result_code |
| SetChangedPeriod | 1051~1052 | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| chkERPIFBlockYn | 1064, 1073 | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD (Field<T>) |
| chkSaveYN | 1141, 1147, 1161 | ds.Tables[0]/[1].Rows[0] | CNT |

## 6. Grid 구성 방식과 Division별 차이

- 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)**
  - 메타 컬럼 생성 호출: `SetSheetHeaderColumn`@InitSpread:368(Main, 헤더 1행), `SetSheetHeaderColumn`@InitSpread:399(Detail, 헤더 2행)
  - 시트 생성(CreateSpread): `spdMain` ← `Shipment Change Request Confirm`(342), `txtApprovalDeptName`(FpSpread) ← `Shipment Change Request Confirm Detail`(346)
- 코드 분기: Detail 시트에서만 `_sChangeType == "P"` 여부로 다음 두 가지가 달라집니다.
  - `ERP_SO_NO` Visible: "P" → false(405), 그 외 → true(427)
  - 상단 헤더 Span 라벨: "P" → `Plan`(LT_DAY, 6칸) / `Confirm`(NEW_LT_DAY, 7칸). 그 외 → `Confirmed`(LT_DAY, 7칸) / `Change`(NEW_LT_DAY, 7칸)
- Division별 차이: 메타 규칙과 최종 Grid 모두 **14개 division 키(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 같습니다.**

| 시트 | 연결 규칙 | 표시 컬럼 수(전 division 동일) |
|---|---|---|
| Shipment Change Request Confirm | META+코드연결 | 19 |
| Shipment Change Request Confirm Detail | META+코드연결 | 25 (?1 — ERP_SO_NO는 런타임 `_sChangeType`에 따라 달라짐) |

- 실제 SP 실행 결과와 맞는 시트가 없습니다. grid 단계를 실행하지 않았거나 시트명이 다르기 때문이며, **확인 필요**합니다.

## 7. 확인 필요 항목

1. `SaveData`(875)에서 `_40`과 일반 저장 SP 중 하나를 고르는 조건. `_40` 접미사가 Division 40을 뜻하는지는 Fact Pack으로 입증되지 않았습니다.
2. 4-2에서 `SaveData`가 `PersonalSettingPopup.SaveData`로 연결된 것이 파서 오매핑인지.
3. `SetChangedPeriod`(1044, CommonDataList PERIOD_*)는 진입점에 연결되어 있지 않습니다. 실제로 호출되는지 확인이 필요합니다.
4. `chkERPIFBlockYn`이 쓰는 `dtERPBlockYnIF`의 데이터 출처(엔드포인트 목록에 없음).
5. `ClbDivision_SelectedIndexChanged`, `SpdMain_TopChange`, `BtnRequestUser_Click`, `btnItemId_Click`의 동작(엔드포인트 호출 없음).
6. `GetSSPInnerTable` 7회 호출(216~246)이 각각 어느 컨트롤(clbDivision, clbFromSite, cboStatus, cboChangeType 등)에 바인딩되는지.
7. Main 시트 grid_effective의 `ERP_SO_NO`(CODE_ONLY_CHANGE, 값 없음) 행. 코드 분기 조건은 Detail 시트에만 있으므로 파서가 시트를 잘못 연결했을 수 있습니다.
8. `SetChangeRequestInfo` 호출 위치와 각 컬럼을 상세 TextBox에 넣는 대응 관계.
9. 메타 행: SCM_ADM_LOOKUP_MASTER_DETAIL 1건, TB_FX_GroupMenuAuth 8건, TB_FX_ProgramInfo 2건, TB_FX_MenuItemInfo 2건. 내용은 Fact Pack 본문에 없습니다.

=== FILE: source_links.md ===
# SSP0202 소스 링크 (파일·줄 기준)

기준 경로(AS-IS GSCM 소스 루트 기준):
- CS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0202_ShipmentChangeRequestConfirm.cs`
- DS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0202_ShipmentChangeRequestConfirm.Designer.cs`

## 1. 엔드포인트 호출 지점 (전체 10건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | FindData_Main | 611 | `SSP.SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` |
| CS | FindData_Sub | 687 | `SSP.SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| CS | SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| CS | SaveData | 875 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| CS | GetErpIFCheck | 986 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| CS | SetChangedPeriod | 1044 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (via `Data.CallBizCommonData`, 진입점 미연결) |
| CS | EngProcessingChk | 1090 | `SSP.SSP0202_GET_SSP_PLAN_PROCESSING_CHECK` |
| CS | chkSaveYN | 1130 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` |
| CS | Delegate_Load | 1233 | `SSP.SSP0202_GET_DELEGATEE_LOAD` |
| CS | GetDayRange | 1263 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |

## 2. 주석 처리된 호출 (주석 처리됨, 현행 아님)

| 파일 | 줄 | 내용 |
|---|---:|---|
| CS | 877 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM` (주석 처리됨) |
| CS | 1262 | `SCP.GET_DATE_RANGE_1MONTH` (주석 처리됨) |

## 3. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 185 | `this.Load += Form_Load` |
| CS | .ctor | 186 | `this.spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 257 | `clbDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 258 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 260 | `btnApproval.Click += BtnApproval_Click` |
| CS | InitEvent | 261 | `btnReject.Click += BtnReject_Click` |
| CS | InitEvent | 262 | `btnSelfReject.Click += BtnSelfReject_Click` |
| CS | InitEvent | 263 | `btnRequestUser.Click += BtnRequestUser_Click` |
| CS | InitEvent | 264 | `btnItemId.Click += btnItemId_Click` |

## 4. 프레임워크 메타 소비 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 209, 210 | Filter GROUP_ID / USER_ID, UserInfoContext.Current.NowGroupID |
| CS | SetChangeControl | 216, 221, 226, 231, 236, 241, 246 | `DataService.GetSSPInnerTable` |
| CS | InitControls | 275, 283 | `DataService.FP_Log2` |
| CS | InitControls | 295 | `c["CODE"]` |
| CS | SetChangedControl | 319 | `CString.GetCheckedListValue` |
| CS | SetChangedControl | 327 | UserInfoContext.Current.NowGroupID |
| CS | CreateSpread | 342, 343 | AddSheet / GetSheetInfo `Shipment Change Request Confirm` (spdMain) |
| CS | CreateSpread | 346, 347, 349, 352, 356 | AddSheet / GetSheetInfo / ChangeSheet `Shipment Change Request Confirm Detail` (txtApprovalDeptName) |
| CS | InitSpread | 363, 368 | InitSheet, `SetSheetHeaderColumn(spreadInfo, 1)` — Main |
| CS | InitSpread | 397, 399 | InitSheet, `SetSheetHeaderColumn(spreadInfo, 2)` — Detail |
| CS | InitSpread | 405 | `_sChangeType == "P"` → ERP_SO_NO Visible = false |
| CS | InitSpread | 407~422 | "P" 분기 ColumnHeaderSpan (Plan / Confirm, 2행 헤더 라벨) |
| CS | InitSpread | 427 | else → ERP_SO_NO Visible = true |
| CS | InitSpread | 429~444 | else 분기 ColumnHeaderSpan (Confirmed / Change, 2행 헤더 라벨) |
| CS | FindData_Main | 593, 594, 598, 600 | `CString.GetCheckedListValue` |
| CS | SetChangeRequestInfo | 723~730 | dt.Rows[0] CHANGE_REQ_NO … APPROVAL_DEPT_NAME |
| CS | GetErpIFCheck | 998 | `ds.Tables[0].Rows[0]["result_code"]` |
| CS | SetChangedPeriod | 1051, 1052 | FROM_VALUE, TO_VALUE |
| CS | chkERPIFBlockYn | 1064, 1073 | `Field<T>("BLOCK_YN")`, `Field<T>("PERIOD")` |
| CS | chkSaveYN | 1141, 1147, 1161 | CNT |
| CS | BtnSelfReject_Click | 1311 | SaveData (4-2에서 PersonalSettingPopup.SaveData로 매핑됨, 확인 필요) |
| CS | BtnReject_Click | 1369 | SaveData (위와 같음) |
| CS | BtnApproval_Click | 1412 | SaveData (위와 같음) |

## 5. Designer 주요 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| DS | InitializeComponent | 144, 148, 160, 161 | splitContainer1 Dock Fill / Orientation Horizontal / Size(1192,649) / SplitterDistance 259 |
| DS | InitializeComponent | 167, 172 | spdMain Dock Fill / Size(1192,192) |
| DS | InitializeComponent | 189~192 | spdMain 헤더 스타일(HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General) |
| DS | InitializeComponent | 218~223 | usrConditionPanel1 Dock Top / Size(1192,67) / HidePanel |
| DS | InitializeComponent | 377, 424, 435 | 버튼 Text "Self Reject" / "Reject" / "Approval" |
| DS | InitializeComponent | 650, 688, 700, 712, 807 | 조건 라벨 "Division" / "Request Date" / "From Site" / "Status" / "Change Type" |
| DS | InitializeComponent | 815, 820 | txtApprovalDeptName(FpSpread) Dock Fill / Size(1192,174) |
| DS | InitializeComponent | 837~840 | txtApprovalDeptName 헤더 스타일(위와 같음) |
| DS | InitializeComponent | 865~878 | splitter1 Top(3) / panel1 Top(209) |
| DS | InitializeComponent | 906~1006 | 상세 TextBox ReadOnly·Size, usrLabel2 "Request Confirm Detail"(991) |
| DS | InitializeComponent | 1041 | layoutControlItem5 Text "Request No" |

=== FILE: web_components.md ===
# SSP0202 화면 구성 → React / Wijmo 매핑

## 1. 화면 배치 (props.csv)

| 컨테이너 | 속성(원문) | 해석 |
|---|---|---|
| splitContainer1 | Orientation = Horizontal, Size = (1192, 649), SplitterDistance = 259, Dock Fill | **상/하 분할**. 상단 259 / 전체 649 = **약 39.9%**, 하단 약 60.1% |
| ├ Panel1(상) usrConditionPanel1 | Dock Top, Size (1192, 67), UsrPanelType = HidePanel | 조회조건 영역 (높이 67) |
| ├ Panel1(상) spdMain | Dock Fill, Size (1192, 192) | Main Grid (67 + 192 = 259) |
| ├ Panel2(하) panel1 → usrLayoutControl3 | Dock Top, Size (1192, 209) | 요청 상세 정보 폼 (높이 209) |
| ├ Panel2(하) splitter1 | Dock Top, Size (1192, 3) | 폼과 Detail Grid 사이 스플리터 |
| └ Panel2(하) txtApprovalDeptName (FpSpread) | Dock Fill, Size (1192, 174) | Detail Grid (컨트롤 이름은 txt*이지만 FpSpread임) |

하단 패널 높이 합계는 209 + 3 + 174 = 386입니다. 전체 649 − 259 = 390과 4px 차이가 나며, 이는 SplitContainer 분할선 몫입니다(SplitterWidth는 props에 값이 없음).

## 2. 컨트롤 → 컴포넌트 매핑

### 2-1. 조회조건 영역 (usrLayoutControl1)

| AS-IS 컨트롤 | 유형 | 라벨(LayoutControlItem.Text / 컨트롤 Text 원문) | Size | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCheckedList | "Division" (lcDivision) | 246×21 | 멀티 선택 콤보 (Wijmo MultiSelect 계열 공통 컴포넌트) |
| drpPeriod | UsrDateRangePicker | "Request Date" (layoutControlItem1) | 210×20 | 기간 선택(From~To) 공통 컴포넌트 |
| clbFromSite | UsrCheckedList | "From Site" (layoutControlItem7) | 199×21 | 멀티 선택 콤보 |
| cboStatus | UsrCombo | "Status" (LayoutControlItem 이름 `PlanType`) | 198×20 | 단일 콤보 (Wijmo ComboBox 계열) |
| cboChangeType | UsrCombo | "Change Type" (LayoutControlItem 이름 `PlanType1`) | 141×20 | 단일 콤보 |
| txtRequest | UsrMultiLineEditor | LayoutControlItem 이름 `Requestor` (Text 값은 Fact Pack에서 잘려 있음, 확인 필요) | 154×21 | 멀티라인 입력 + 팝업 버튼 |
| btnRequestUser | UsrButton | layoutControlItem13 Text "layoutControlItem2" (TextVisible 여부 확인 필요) | 39×24 | 사용자 검색 팝업 버튼 |
| txtItemID | UsrMultiLineEditor | LayoutControlItem 이름 `Model` (Text 값은 잘려 있음, 확인 필요) | 136×21 | 멀티라인 입력 + 팝업 버튼 |
| btnItemId | UsrButton | layoutControlItem2 (Text 확인 필요) | 39×24 | 품목 검색 팝업 버튼 |
| btnApproval | SimpleButton | "Approval" (lcBtnApproval Text "layoutControlItem10") | 105×22 | 화면 버튼 (menu-button 동적 조회 대상) |
| btnReject | SimpleButton | "Reject" (lcBtnReject Text "layoutControlItem10") | 105×22 | 화면 버튼 |
| btnSelfReject | SimpleButton | "Self Reject" (lcSelfReject Text "layoutControlItem10") | 105×22 | 화면 버튼 |

### 2-2. 요청 상세 폼 (usrLayoutControl3, panel1 내부)

| AS-IS 컨트롤 | 유형 | 라벨 원문 | ReadOnly(props) | Size | TO-BE 후보 |
|---|---|---|---|---|---|
| usrLabel2 | UsrLabel | "Request Confirm Detail" | - | 733×20 | 섹션 타이틀 |
| txtRequestNo | TextBox | "Request No" (layoutControlItem5) | true | 644×24 | 읽기 전용 Input |
| txtTitle | TextBox | 확인 필요 (lcTitle 또는 lcTitle1 추정, Text 잘림) | true | 259×24 | 읽기 전용 Input |
| txtRequestor | TextBox | 확인 필요 (layoutControlItem4, Text 잘림) | true | 259×24 | 읽기 전용 Input |
| txtRequestDeptName | TextBox | 확인 필요 | true | 292×20 | 읽기 전용 Input |
| txtApproval | TextBox | 확인 필요 (lcApproval 추정) | true | 259×24 | 읽기 전용 Input |
| txtAppDeptName | TextBox | 확인 필요 | true | 292×20 | 읽기 전용 Input |
| txtChangeReason | TextBox | 확인 필요 | true | 292×20 | 읽기 전용 Input |
| txtReasonDetail | TextBox | 확인 필요 (lcReasonDetail 추정) | true | 644×24 | 읽기 전용 Input |
| txtRejectReason | TextBox | 확인 필요 | **ReadOnly 행 없음** (입력 가능 여부 확인 필요) | 644×24 | Input (반려 사유 입력 여부 확인 필요) |

라벨 원문이 "확인 필요"인 행이 있습니다. props.csv가 Fact Pack에서 10,890자 잘려서 layoutControlItem6, 9, 10, 3, lcApproval, lcReasonDetail, lcTitle, lcTitle1의 Text를 볼 수 없기 때문입니다. 전체 props.csv를 열어 확인해야 합니다.

### 2-3. Grid

| AS-IS | 시트 | TO-BE |
|---|---|---|
| spdMain (FpSpread) | `Shipment Change Request Confirm` | Wijmo FlexGrid — 메타(SCM_MST_SHEET_COLUMNS) 기반, 헤더 1행 |
| txtApprovalDeptName (FpSpread) | `Shipment Change Request Confirm Detail` | Wijmo FlexGrid — 메타 기반, 헤더 2행(병합 헤더) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

### 3-1. Shipment Change Request Confirm (표시 19 / 전 division 동일)

| 컬럼 | 라벨 | 출처 | 표시 |
|---|---|---|---|
| DIVISION_ID | Division | META | 기본 |
| CHANGE_REQ_NO | Request No | META | 기본 |
| REQUEST_TITLE | Title | META | 기본 |
| CHANGE_TYPE | Change Type | META | 기본 |
| SHIPMENT_STATUS | Status | META | 기본 |
| FROM_SITE | From Site | META | 기본 |
| TO_SITE | To Site | META | 기본 |
| ITEM_ID | Model | META | 기본 |
| NICK_NAME | Nick Name | META | 기본 |
| CHANGE_REASON_CODE | Change Reason | META | 기본 |
| REJECT_REASON | Reject Reason | META | 기본 |
| REQUEST_USER_NAME | Requestor | META | 기본 |
| REQUEST_DEPT | Requestor Dept Name | META | 기본 |
| REQUEST_TIME | Request Date | META | 기본 |
| APPROVAL_USER_NAME | Approval | META | 기본 |
| APPROVAL_DEPT | Approval Dept Name | META | 기본 |
| APPROVAL_TIME | Approval Date | META | 기본 |
| DELEGATEE_USER_NAME | Delegatee | META | 기본 |
| DELEGATEE_DEPT | Delegatee Dept Name | META | 기본 |
| REQUEST_USER | Requestor | META | 숨김 |
| APPROVAL_USER | Approval | META | 숨김 |
| DELEGATEE_USER | Delegatee | META | 숨김 |
| ERP_SO_NO | (없음) | CODE_ONLY_CHANGE | 값 없음. 코드 분기는 Detail 시트 조건 안에 있으므로 Main 시트 귀속은 확인 필요 |

표의 컬럼 순서는 grid_effective.csv의 행 순서(알파벳 순)와 다릅니다. 실제 표시 순서는 메타의 순서 컬럼으로 확인해야 합니다(확인 필요).

### 3-2. Shipment Change Request Confirm Detail (표시 25(?1) / 전 division 동일)

| 컬럼 | 라벨(메타) | 표시 | 코드 헤더(2행째, "P"·else 같음) |
|---|---|---|---|
| CONFIRM_ID | Confirm ID | 기본 | |
| ERP_SO_NO | SO No | 기본 → `_sChangeType=="P"`면 숨김(405) / 그 외 표시(427) | |
| FCST_TYPE | FCST Type | 기본 | |
| PROJECT_NAME | Project Name | 기본 | |
| ITEM_ID | Model | 기본 | |
| FROM_SITE_DESCRIPTION | From Site | 기본 | |
| TO_SITE_DESCRIPTION | To Site | 기본 | |
| SHIPTO_CODE | ShipTo Code | 기본 | |
| INCOTERMS | Incoterms | 기본 | |
| LT_DAY | L/T(Day) | 기본 | L/T(Day) |
| ETD | ETD | 기본 | ETD |
| ETA | ETA | 기본 | ETA |
| TRANSPORT_MODE | Trans Mode | 기본 | Trans Mode |
| SHIPMENT_DATE | Shipment Date | 기본 | Shipment Date |
| SHIPMENT_CONFIRM_QTY | Qty | 기본 | Qty |
| NEW_LT_DAY | L/T(Day) | 기본 | L/T(Day) |
| NEW_ETD | ETD | 기본 | ETD |
| NEW_ETA | ETA | 기본 | ETA |
| NEW_TRANSPORT_MODE | Trans Mode | 기본 | Trans Mode |
| NEW_SHIPMENT_DATE | Shipment Date* | 기본 | Shipment Date* |
| NEW_SHIPMENT_CONFIRM_QTY | Qty* | 기본 | Qty* |
| NEW_SHIPTO_CODE | ShipTo Code | 기본 | |
| REMARKS | Remarks | 기본 | |
| REMARKS2 | Building | 기본 | |
| REMARKS3 | Customer requirement | 기본 | |

숨김 컬럼 25개(메타 기준): A_COUNTRY, A_PORT_CODE, BOD_ID, CHANGE_REQ_NO, CUSTOMER_LT, D_COUNTRY, D_PORT_CODE, DIVISION_ID, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BASE_CONFIRM_YN, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_INCOTERMS, NEW_ROUTE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_YN, ROUTE_ID, TO_CITY, TO_COUNTRY, TO_SITE.

#### 상단 헤더 병합 (InitSpread, `_sChangeType` 분기)

| 조건 | 0행 Span 1 | 0행 Span 2 |
|---|---|---|
| `_sChangeType == "P"` (407~408) | LT_DAY부터 6칸 = **"Plan"** | NEW_LT_DAY부터 7칸 = **"Confirm"** |
| 그 외 (429~430) | LT_DAY부터 7칸 = **"Confirmed"** | NEW_LT_DAY부터 7칸 = **"Change"** |

"P" 분기에서만 기존 쪽 Span이 6칸입니다. ERP_SO_NO가 숨김이 되는 것과 관련이 있을 수 있지만, 메타의 컬럼 순서가 Fact Pack에 없어 **확인 필요**입니다. 1행(2~3행 Span, 높이 30) 라벨은 두 분기가 같습니다.

### 3-3. Division별 표시 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Change Request Confirm | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Shipment Change Request Confirm Detail | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) | 25(?1) |

Division별 차이는 없습니다. 차이는 런타임 `_sChangeType` 값 하나로만 생깁니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 근거 |
|---|---|---|
| Shipment Change Request Confirm | META+코드연결 | CreateSpread:342 AddSheet(spdMain) → InitSpread:368 SetSheetHeaderColumn(…, 1) |
| Shipment Change Request Confirm Detail | META+코드연결 | CreateSpread:346 AddSheet(txtApprovalDeptName) → 349/352/356 ChangeSheet → InitSpread:399 SetSheetHeaderColumn(…, 2) |

Master–Detail 연결:
- `spdMain` 셀을 더블클릭하면(`SpdMain_CellDoubleClick`) `FindData_Sub`가 `SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`를 호출하고, `Delegate_Load`가 `SSP0202_GET_DELEGATEE_LOAD`를 호출합니다.
- 더블클릭한 행에서 어떤 키(CHANGE_REQ_NO 등)를 넘기는지는 Fact Pack에 없습니다(**확인 필요**).

=== FILE: oracle_migration.md ===
# SSP0202 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (참조 객체 원문 · EXEC 체인)

### 1-1. SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM (Main 조회)
- 호출: FindData_Main:611 (FindButton, 저장 후 재조회)
- 참조: REF FN_GET_ITEM_NICKNAME, SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT TB_FX_USER, SELECT SSP_MST_DELEGATE, **REF STRING_SPLIT**, SELECT SCM_MST_SITE, SELECT SCM_MST_ITEM_SN

### 1-2. SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING (Detail 조회)
- 호출: FindData_Sub:687 (SpdMain_CellDoubleClick)
- 참조: REF FN_GET_PROJECT_NAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER

### 1-3. SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40 (저장)
- 호출: SaveData:875 (Approval / Reject / Self Reject)
- EXEC 체인: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, **SP_SEND_DBMAIL**
- DML: UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT SCM_SYS_LOG_BATCH, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT #TBLSSPAPPROVEDMAILSEND, INSERT SCM_ADM_SMS_MAIL_SEND_LOG
- SELECT: SSP_ANL_SHIP_CONFIRM, SSP_MST_SITE_ITEM_EE_V, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SCM_ADM_RECIPIENT_LIST, SCM_ADM_RECIPIENT_MESSAGE, SCM_ADM_RECIPIENT_ASSIGN, SCM_MST_SITE_ITEM, #TBLSSPAPPROVEDMAILSEND, SSP_MST_DELEGATE, SCM_MST_SSO_USER_INFO, SCM_MST_ITEM_SN
- REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME

### 1-4. SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM (저장)
- 호출: SaveData:875 (Approval / Reject / Self Reject). 877줄 같은 SP 호출은 **주석 처리됨**
- EXEC 체인: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, SCM_SSP_MAIL_SEND, **PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS**, **PR_DM_SSP_CONFIRM_SYNC**, PR_SCM_SYS_LOG_BATCH, SCM_ADM_MAIL_SEND, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, **PR_SCP_SYS_LOG_BATCH**, **PR_SSP_ANL_SHIP_CONFIRM_ROUTE**
- DML: UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT SCM_SYS_LOG_BATCH, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT #TBLSSPAPPROVEDMAILSEND, **INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN**, INSERT #T_CONFIRM_ID, DELETE A(별칭 DELETE), **INSERT DM_PLN_MKT_FCST_CONFIRM**
- 임시 테이블 CREATE: #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT
- SELECT: SSP_ANL_SHIP_CONFIRM, SSP_MST_SITE_ITEM_EE_V, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, TB_FX_USER, SCM_ADM_RECIPIENT_LIST/MESSAGE/ASSIGN, #TBLSSPAPPROVEDMAILSEND, SCM_MST_SITE_ITEM, SSP_MST_DELEGATE, SCM_MST_PROJECT, NERP_CONV_MASTER, DM_PLN_MKT_FCST_CONFIRM, #T_CONFIRM_ID, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V
- REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_GET_USER_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME, FN_ZERO_LPAD, FN_GET_SITE_CUSTOMER_INFO, **UF_FX_STRING_SPLIT**, FN_NEXT_DAY

#### `_40`과 일반 저장 SP의 참조 객체 차이 (objects 원문 비교)

| 구분 | 객체 |
|---|---|
| 일반 SP에만 있음 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_DM_SSP_CONFIRM_SYNC, PR_SCP_SYS_LOG_BATCH, XIF_SCS_PACK_SHIP_PLAN_S_SN, FN_ZERO_LPAD, FN_GET_SITE_CUSTOMER_INFO, SCM_MST_PROJECT, NERP_CONV_MASTER, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, UF_FX_STRING_SPLIT, FN_NEXT_DAY, #T_CONFIRM_ID·#T_SSP·#T_SSP_SUM·#T_MKT_RESULT·#T_MKT_RESULT_SUM·#TEMP_SALES_RESULT, DELETE A, DM_PLN_MKT_FCST_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V |
| `_40`에만 있음 | SCM_MST_SSO_USER_INFO, SCM_MST_ITEM_SN, SP_SEND_DBMAIL, SCM_ADM_SMS_MAIL_SEND_LOG |

### 1-5. SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK (ERP/SCS I/F 검사·적재)
- 호출: GetErpIFCheck:986 (세 버튼 공통). 결과는 `result_code`(998)로 읽습니다.
- EXEC 체인: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, **PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER**, PR_SCP_SYS_LOG_BATCH
- DML: UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH, **INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN**, **INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN**
- SELECT: SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER
- REF: FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO
- SP 이름은 `_IF_CHECK`이지만 INSERT/UPDATE가 들어 있습니다. 검사만 하는 SP가 아니라는 점에 주의해야 합니다.

### 1-6. SSP0202_GET_SSP_PLAN_PROCESSING_CHECK
- 호출: EngProcessingChk:1090 (Approval만)
- 참조: SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL

### 1-7. SSP0202_GET_SCS_CONFIRM_ID_CHECK
- 호출: chkSaveYN:1130 (Approval만). 결과는 Tables[0]/Tables[1]의 `CNT`(1141, 1147, 1161)로 읽습니다.
- 참조: SCM_ADM_LOOKUP_MASTER_DETAIL, FN_GET_IN_STR, FN_SCM_SPLIT, **동적 SQL**(DYNAMIC@SSP0202_GET_SCS_CONFIRM_ID_CHECK)
- 결과셋이 2개 이상입니다(Tables[1] 사용). Oracle에서는 SYS_REFCURSOR 2개로 받아야 합니다.

### 1-8. SSP0202_GET_DELEGATEE_LOAD
- 호출: Delegate_Load:1233 (SpdMain_CellDoubleClick)
- 참조: SSP_MST_DELEGATE, TB_FX_USER

### 1-9. SCM0001_GET_SCP_DAY_PERIOD (공용, SCP 도메인)
- 호출: GetDayRange:1263 (Form_Load > InitControls). 1262줄 `SCP.GET_DATE_RANGE_1MONTH`는 **주석 처리됨**
- 참조: FN_MULTY_TIME, SCM_SYS_CALENDAR_M, FN_WEEKOFDAY_DATE, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE(CTE)

## 2. 공통코드 분기

| 호출 | code 값 | 대상 | 읽는 컬럼 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (SetChangedPeriod:1044, 진입점 미연결) | `PERIOD_{p:value}`, 없으면 `PERIOD_DEFAULT` | 대상 테이블은 Fact Pack에 없음(**확인 필요**) | FROM_VALUE, TO_VALUE |
| `DataService.GetSSPInnerTable` ×7 (SetChangeControl:216~246) | 인자 값은 Fact Pack에 없음(**확인 필요**) | 프레임워크 내부 | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |

메타 테이블 SCM_ADM_LOOKUP_MASTER_DETAIL에는 화면 ID 값을 가진 행이 1건(이력 _H 4건) 있습니다. 행 내용은 dbmeta CSV로 확인해야 합니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 활성 FoxQuery 엔드포인트 9건이 모두 **MATCH**입니다. 미등록이나 직접 호출 SP는 Fact Pack에서 발견되지 않았습니다.
- biz 호출 1건(CommonDataList)은 BIZ_MATCH입니다.
- `chkERPIFBlockYn`이 쓰는 `dtERPBlockYnIF`(BLOCK_YN, PERIOD)의 조회 경로는 엔드포인트 목록에 없습니다(**확인 필요**).

## 4. Oracle 전환 확인 포인트 (Fact Pack 근거)

| # | 대상 SP | 사실 | 확인 포인트 |
|---:|---|---|---|
| 1 | GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | REF STRING_SPLIT | MSSQL `STRING_SPLIT`(금지 키워드)을 Oracle 분할 함수 또는 공용 split 함수로 바꿔야 함 |
| 2 | SAVE_SHIPMENT_REQUEST_CONFIRM | #T_CONFIRM_ID 외 임시 테이블 6종, #TBLSSPAPPROVEDMAILSEND | `#` 임시 테이블을 GTT로 바꿔야 함. 세션 상태 대조 시 시작할 때 비우는지 확인 |
| 3 | SAVE_SHIPMENT_REQUEST_CONFIRM_40 | #TBLSSPAPPROVEDMAILSEND | 위와 같음 |
| 4 | SAVE_SHIPMENT_REQUEST_CONFIRM | DELETE A | 별칭 DELETE(`DELETE A FROM … A JOIN …`)는 Oracle 문법으로 다시 써야 함 |
| 5 | SAVE_SHIPMENT_REQUEST_CONFIRM_40 | EXEC SP_SEND_DBMAIL | MSSQL Database Mail을 Oracle 메일 대체 수단으로 바꿔야 함 |
| 6 | GET_SCS_CONFIRM_ID_CHECK | DYNAMIC SQL | 동적 SQL 원문을 열람하고 EXECUTE IMMEDIATE 바인딩으로 바꿔야 함 |
| 7 | GET_SCS_CONFIRM_ID_CHECK | 다중 결과셋(Tables[1]) | REFCURSOR 다중 OUT |
| 8 | SAVE_* / IF_CHECK | XIF_SCS_PACK_SHIP_PLAN_S_SN, XIF_ERP_PACK_SHIP_PLAN_S_SN, NERP_CONV_MASTER | 외부 I/F 테이블이 TO-BE 스키마에 있는지, 접근 경로(시노님/DB Link)가 있는지 |
| 9 | SAVE_SHIPMENT_REQUEST_CONFIRM | PR_DM_SSP_CONFIRM_SYNC, DM_PLN_MKT_FCST_CONFIRM | DM 도메인 객체를 변경함. 연쇄 영향 범위 확인 |
| 10 | SAVE_* / IF_CHECK | PR_SCM_SYS_LOG_BATCH_CALL_TRAN 등 로그 프로시저 | 트랜잭션 경계(자율 트랜잭션 여부) |
| 11 | SAVE_* | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, UF_FX_STRING_SPLIT | 배열 문자열 분할 함수를 Oracle로 이관했는지 |
| 12 | SCM0001_GET_SCP_DAY_PERIOD | CTE_DATE | 재귀 CTE면 Oracle 재귀 WITH 구문 확인 |
| 13 | SaveData:875 | `_40`/일반 SP 선택 분기 | 화면 코드의 선택 조건(확인 필요)을 TO-BE에서 그대로 재현 |

### 난이도 (사실 근거만)

| SP | 근거 | 상대 난이도 |
|---|---|---|
| SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC 10종 + 임시 테이블 6종 생성 + 외부 I/F INSERT + DM 테이블 INSERT + 별칭 DELETE | 높음 |
| SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | EXEC 7종 + SP_SEND_DBMAIL + 임시 테이블 | 높음 |
| SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | EXEC 3종 + 외부 I/F 테이블 2종 INSERT | 중~높음 |
| SSP0202_GET_SCS_CONFIRM_ID_CHECK | 동적 SQL + 다중 결과셋 | 중 |
| SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | SELECT 11종 + 함수 3종, DML 없음 | 중 |
| SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | STRING_SPLIT 대체 필요, DML 없음 | 중 |
| SCM0001_GET_SCP_DAY_PERIOD | CTE + 함수 2종(공용, 이미 전환되었는지 확인 필요) | 낮음~중 |
| SSP0202_GET_SSP_PLAN_PROCESSING_CHECK | SELECT 3종 | 낮음 |
| SSP0202_GET_DELEGATEE_LOAD | SELECT 2종 | 낮음 |

SP 원문(행 수, 분기 구조)은 Fact Pack에 없습니다. 위 난이도는 참조 객체 구성만 보고 매긴 것이며, 실제 원문을 열람한 뒤 확정해야 합니다.

=== FILE: tobe_design.md ===
# SSP0202 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순 | 라벨(원문) | AS-IS 컨트롤 | 유형 | 데이터 출처 | 비고 |
|---:|---|---|---|---|---|
| 1 | Division | clbDivision | UsrCheckedList(멀티) | GetSSPInnerTable 추정(확인 필요) | `SelectedIndexChanged` → `ClbDivision_SelectedIndexChanged`(연쇄 동작 확인 필요) |
| 2 | Request Date | drpPeriod | UsrDateRangePicker | 기본 기간: Form_Load > InitControls > GetDayRange → `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 1262줄 GET_DATE_RANGE_1MONTH는 주석 처리됨 |
| 3 | From Site | clbFromSite | UsrCheckedList(멀티) | 확인 필요 | |
| 4 | Status | cboStatus | UsrCombo | 확인 필요 | |
| 5 | Change Type | cboChangeType | UsrCombo | 확인 필요 | |
| 6 | (Requestor, Text 확인 필요) | txtRequest + btnRequestUser | UsrMultiLineEditor + UsrButton | 팝업(`BtnRequestUser_Click`, 동작 확인 필요) | |
| 7 | (Model, Text 확인 필요) | txtItemID + btnItemId | UsrMultiLineEditor + UsrButton | 팝업(`btnItemId_Click`, 동작 확인 필요) | |

- `FindData_Main`은 593, 594, 598, 600줄에서 `GetCheckedListValue`로 멀티 선택 값을 모읍니다. 정확히 몇 개의 CheckedList가 파라미터로 들어가는지는 확인 필요입니다.
- 조회조건 순서는 CR-098에 따라 판정에서 제외됩니다. 사용 여부와 EDIT 형태는 위 표에 맞춰야 합니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 핸들러 | 호출 순서(Fact Pack flow 기준) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load | InitControls → GetDayRange(`SCM0001_GET_SCP_DAY_PERIOD`) | 공용 기간 조회 API(SCM0001 재사용 여부 확인) |
| 조회 | FindButton | FindData_Main(`SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM`) | `GET /ssp/ssp0202/main` (후보) |
| Main 더블클릭 | SpdMain_CellDoubleClick | FindData_Sub(`SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`), Delegate_Load(`SSP0202_GET_DELEGATEE_LOAD`) | `GET /ssp/ssp0202/detail`, `GET /ssp/ssp0202/delegatee` (후보) |
| Approval | BtnApproval_Click | EngProcessingChk(`SSP0202_GET_SSP_PLAN_PROCESSING_CHECK`) · chkSaveYN(`SSP0202_GET_SCS_CONFIRM_ID_CHECK`) · GetErpIFCheck(`SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`) · SaveData(`_40` 또는 일반 SAVE) → FindData_Main 재조회 | 검사 API 2종 + `POST /ssp/ssp0202/approve` (후보) |
| Reject | BtnReject_Click | GetErpIFCheck · SaveData(`_40`/일반) → 재조회 | `POST /ssp/ssp0202/reject` (후보) |
| Self Reject | BtnSelfReject_Click | GetErpIFCheck · SaveData(`_40`/일반) → 재조회 | `POST /ssp/ssp0202/self-reject` (후보) |
| Requestor 팝업 | BtnRequestUser_Click | 엔드포인트 없음 | 공용 사용자 검색 팝업(확인 필요) |
| Model 팝업 | btnItemId_Click | 엔드포인트 없음 | 공용 품목 검색 팝업(확인 필요) |
| Grid 스크롤 | SpdMain_TopChange | 엔드포인트 없음 | 동작 확인 후 결정 |

- 세 버튼 모두 같은 `SaveData`(875)를 씁니다. 어떤 버튼인지(승인/반려/자가반려) 구분하는 파라미터 값은 Fact Pack에 없습니다(**확인 필요**).
- 검사 메서드 순서(EngProcessingChk, chkSaveYN, GetErpIFCheck, SaveData)는 flow 경로 목록에서 나온 것이고 실행 순서를 보장하지 않습니다. 원문 줄 순서로 **확인 필요**합니다.
- `chkERPIFBlockYn`(BLOCK_YN, PERIOD 검사)이 어느 버튼 경로에 들어가는지 **확인 필요**합니다.
- 버튼 3종(Approval / Reject / Self Reject)은 `menu-button-dynamic-fetch` 대상입니다.

## 3. Division별 Grid 변형 요약

| 시트 | Division별 차이 | 코드 변형 |
|---|---|---|
| Shipment Change Request Confirm | 없음 (14 division 모두 19컬럼) | 없음 |
| Shipment Change Request Confirm Detail | 없음 (14 division 모두 25컬럼, ?1) | `_sChangeType == "P"`: ERP_SO_NO 숨김, 상단 헤더 "Plan"(6칸)/"Confirm"(7칸). 그 외: ERP_SO_NO 표시, "Confirmed"(7칸)/"Change"(7칸) |

- Detail 헤더는 2행이고(SetSheetHeaderColumn 2), 2행째 라벨은 "Shipment Date*", "Qty*" 등 메타 라벨과 같습니다.
- `_sChangeType` 값이 어디서 정해지는지(Main 선택 행의 CHANGE_TYPE으로 보이지만 미입증)는 **확인 필요**입니다.

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴/권한 메타 | TB_FX_GroupMenuAuth 8행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행, TB_FX_Favorite 13행 (내용은 Fact Pack에 없음) |
| 사용자 그룹 사용 | SetChangeControl:209~210에서 Filter GROUP_ID / USER_ID와 `UserInfoContext.Current.NowGroupID` 사용. SetChangedControl:327에서도 NowGroupID 사용 |
| 저장 버튼 | 프레임워크 저장 버튼이 아니라 화면 전용 버튼 3종(Approval / Reject / Self Reject)으로 저장 |
| 승인자/위임자 | Main 시트에 APPROVAL_USER(숨김)/APPROVAL_USER_NAME, DELEGATEE_USER(숨김)/DELEGATEE_USER_NAME 있음. GET_DELEGATEE_LOAD는 SSP_MST_DELEGATE 참조 |

버튼별 권한 제어(그룹에 따라 버튼 활성/비활성)가 있는지는 SetChangeControl 원문으로 **확인 필요**합니다.

## 5. 미확정 사항

1. `_40`과 일반 저장 SP를 고르는 조건, 그리고 `_40`이 Division 40 전용인지.
2. 세 버튼이 SaveData에 넘기는 상태 값과 txtRejectReason(ReadOnly 미설정) 입력값이 저장 파라미터에 들어가는지.
3. GetSSPInnerTable 7회 호출과 각 조회조건 컨트롤의 대응.
4. 조회조건 라벨 원문 중 잘린 항목(Requestor, Model, 상세 폼 라벨 8건). 전체 props.csv로 확인.
5. SetChangedPeriod(CommonDataList PERIOD_*)가 실제로 쓰이는지(진입점 미연결).
6. dtERPBlockYnIF 데이터 출처와 chkERPIFBlockYn 호출 위치.
7. Main 시트 grid_effective의 ERP_SO_NO(CODE_ONLY_CHANGE) 행이 파서가 시트를 잘못 연결한 것인지.
8. 메타의 컬럼 표시 순서. "P" 분기 Span 6칸과 else 7칸의 차이가 ERP_SO_NO 위치와 관련 있는지.
9. 실제 SP 실행 결과와 맞는 시트가 없어, grid 단계 실측이 필요함.
10. 4-2의 `PersonalSettingPopup.SaveData` 매핑이 파서 오매핑인지.
