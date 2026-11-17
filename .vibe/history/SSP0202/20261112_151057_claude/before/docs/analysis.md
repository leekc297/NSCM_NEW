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
