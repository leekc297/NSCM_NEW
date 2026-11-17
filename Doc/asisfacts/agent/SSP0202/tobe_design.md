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
