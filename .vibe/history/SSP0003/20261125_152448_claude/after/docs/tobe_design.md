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
