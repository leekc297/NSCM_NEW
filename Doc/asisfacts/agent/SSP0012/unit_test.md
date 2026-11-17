# SSP0012 단위테스트 — Shipment Plan Confirm Detail

> **작성 근거**: Fact Pack(SSP0012), 업무분석서 §5, 화면설계서 §3·§5
> **기대결과 표기**: Fact Pack에 동작이 없는 경우 기대결과에 **확인 필요**를 적었습니다. AS-IS 실행 결과를 확인한 뒤 확정합니다.
> **범위**: 주석 처리된 호출은 테스트 대상이 아닙니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0012-001 | 초기화 | SSP0012 메뉴 권한이 있는 사용자로 로그인 | 1) 화면을 엽니다. 2) `drpPeriod` 값을 확인합니다. | 없음 | `Form_Load` > InitControls > GetDayRange 가 실행되고 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 가 1회 호출됩니다. `drpPeriod` 에 SP 결과 기간이 들어갑니다(값 매핑은 **확인 필요**). | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-002 | 초기화 | TC-001 수행 | 1) 화면을 엽니다. 2) `usrConditionPanel1`, `usrLayoutControl2` 안의 조회조건 라벨을 확인합니다. | 없음 | 라벨이 `From Site`, `Model`, `Period*`, `Division`, `Sold To Party`, `Ship To Party` 로 표시됩니다. `btnItemId`, `btnColumn` 버튼이 보입니다. `usrButton1` 의 표시 여부는 **확인 필요**입니다. | `Form_Load`, props.csv Text |
| TC-SSP0012-003 | 그리드 | 화면 열림 | 1) `spdMain` 의 시트 이름을 확인합니다. 2) `spdMain_Sheet1` 헤더 행 수를 확인합니다. | 없음 | 시트 `Shipment Plan Confirm Detail` 이 1개 있고 헤더는 2행입니다. | 시트 `Shipment Plan Confirm Detail`, `SetSheetHeaderColumn`(InitSpread:266) |
| TC-SSP0012-004 | 그리드 | 화면 열림 | 1) `spdMain` 의 표시 컬럼 수와 라벨을 메타와 대조합니다. | 없음 | 표시 컬럼 44개, 라벨은 화면설계서 §4와 같습니다. `BOD_ID`, `ORIGIN_FROM_DIVISION_ID`, `PLAN_QTY` 는 숨김입니다. | 시트 `Shipment Plan Confirm Detail`, `SCM_MST_SHEET_COLUMNS` 47행 |
| TC-SSP0012-005 | 그리드 | 조회 결과 1건 이상 | 1) `spdMain` 의 `INCOTERMS`, `CHANGE_REQ_NO` 셀을 확인합니다. | 조회 결과 데이터 | 두 컬럼이 이미지 셀(`cellTypeImage`)로 표시됩니다. 이미지 종류는 **확인 필요**입니다. | 시트 `Shipment Plan Confirm Detail`, InitSpread:270·271 |
| TC-SSP0012-006 | 조회 | 화면 열림. 기간 기본값이 들어 있음 | 1) `clbPlantSite`, `clbDivision` 에서 값을 선택합니다. 2) `drpPeriod` 를 확인합니다. 3) 툴바 조회(FindButton)를 누릅니다. | From Site·Division 각 1개 이상, Period 기본값 | `FindData_Main` 이 실행되고 `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 이 호출됩니다. 결과가 `spdMain` 시트 `Shipment Plan Confirm Detail` 에 표시됩니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-007 | 조회 | 화면 열림 | 1) `clbPlantSite`, `clbDivision` 에서 각각 여러 개를 선택합니다. 2) 조회(FindButton)를 누릅니다. 3) 전송 파라미터를 확인합니다. | 다중 선택 CODE | CheckedList 선택값(CODE)이 SP 파라미터로 전달됩니다(398·399행). 구분자 형식은 **확인 필요**입니다. 결과는 선택한 값으로 필터됩니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, `GetCheckedListValue` |
| TC-SSP0012-008 | 조회 | 화면 열림 | 1) `txtItemId`, `txtSoldToParty`, `txtShipToParty` 에 값을 넣습니다. 2) 조회(FindButton)를 누릅니다. | Model / Sold To Party / Ship To Party 텍스트 | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 이 호출됩니다. 각 조건이 결과 필터에 반영되는지는 **확인 필요**입니다(SP 파라미터 미추출). | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| TC-SSP0012-009 | 조회 (빈 결과) | 화면 열림 | 1) 데이터가 없는 조건(예: 없는 Model)을 넣습니다. 2) 조회(FindButton)를 누릅니다. | `txtItemId` = 존재하지 않는 값 | `spdMain` 시트 `Shipment Plan Confirm Detail` 이 0행이고, 헤더 2행과 44컬럼은 유지됩니다. 안내 메시지는 **확인 필요**입니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-010 | 조회 (오류 응답) | 메인 SP가 오류를 반환하도록 환경 구성(예: SP 권한 회수, 테스트 DB) | 1) 조회(FindButton)를 누릅니다. | 정상 조건 | 오류 메시지가 표시되고 그리드에 이전 데이터나 일부 데이터가 잘못 남지 않습니다. 메시지 원문은 **확인 필요**입니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` |
| TC-SSP0012-011 | 조회 (필수값) | 화면 열림 | 1) `drpPeriod` 값을 비웁니다. 2) 조회(FindButton)를 누릅니다. | Period 빈값 | 라벨 `Period*` 가 필수 표시입니다. 차단 여부와 메시지는 **확인 필요**입니다. | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, props.csv:453 |
| TC-SSP0012-012 | 조회 (큰 결과) | 기간을 넓게 설정 | 1) `drpPeriod` 를 최대 범위로 설정합니다. 2) 조회를 누릅니다. | 넓은 기간 | 동적 피벗 결과가 메타 컬럼과 맞게 표시되고 요일 컬럼 `DAYS_MON`~`DAYS_SUN` 에 값이 들어갑니다(값 의미는 **확인 필요**). | SP `SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`(#TBLDYNAMICPIVOT_SSP0012), 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-013 | 이벤트 | 화면 열림 | 1) `clbDivision` 선택을 바꿉니다. 2) `drpPeriod` 값을 확인합니다. | Division 값 변경 | `clbDivision_SelectedIndexChanged` > SetChangedControl > GetDayRange 가 실행되고 `SCP.SCM0001_GET_SCP_DAY_PERIOD` 가 다시 호출됩니다. `drpPeriod` 가 다시 설정됩니다(값은 **확인 필요**). | `clbDivision_SelectedIndexChanged`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-014 | 이벤트 (오류 응답) | 기간 SP가 오류를 반환하도록 환경 구성 | 1) 화면을 엽니다. 2) `clbDivision` 선택을 바꿉니다. | Division 값 변경 | 오류 메시지가 표시되고 화면이 멈추지 않습니다. `drpPeriod` 처리 결과는 **확인 필요**입니다. | `Form_Load`, `clbDivision_SelectedIndexChanged`, `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-015 | 이벤트 (빈 결과) | 달력 `SCM_SYS_CALENDAR_M` 에 해당 기간 데이터가 없는 테스트 환경 | 1) 화면을 엽니다. | 없음 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` 가 0행을 반환할 때 `drpPeriod` 처리 결과는 **확인 필요**입니다(빈값 또는 오류 메시지). | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0012-016 | 이벤트 | 화면 열림 | 1) `btnItemId` 를 누릅니다. 2) 값을 고르거나 받습니다. 3) `txtItemId` 를 확인합니다. | Model 1건 이상 | `btnItemId_Click` 이 실행되고 `txtItemId.Text` 에 `sItemId` 가 들어갑니다(341행). 팝업 여부는 **확인 필요**입니다. | `btnItemId_Click` |
| TC-SSP0012-017 | 이벤트 | 화면 열림 | 1) `btnColumn` 을 누릅니다. | 없음 | `BtnColumn_Click` 이 실행됩니다. 동작(컬럼 설정 등)은 **확인 필요**입니다. | `BtnColumn_Click`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-018 | 이벤트 | 조회 결과 1건 이상 | 1) `spdMain` 의 `INCOTERMS` 셀을 클릭합니다. 2) `CHANGE_REQ_NO` 셀을 클릭합니다. 3) 일반 셀을 클릭합니다. | 조회 결과 | `SpdMain_CellClick` 이 실행됩니다. 셀별 동작은 **확인 필요**입니다. | `SpdMain_CellClick`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-019 | 이벤트 | 조회 결과가 한 화면을 넘음 | 1) `spdMain` 을 세로로 스크롤합니다. | 조회 결과 다건 | `SpdMain_TopChange` 가 실행됩니다. 동작(추가 로딩·동기화 등)은 **확인 필요**입니다. | `SpdMain_TopChange`, 시트 `Shipment Plan Confirm Detail` |
| TC-SSP0012-020 | 초기화 (공통코드) | 화면 인스턴스 생성 | 1) 화면을 엽니다. 2) 공통코드 호출 로그를 확인합니다. | 없음 | 필드 초기화 `dtFcstType`·`dtBaseDay` 에서 `biz:CommonData.CommonDataList`(LookupCommon)를 호출하는지 확인합니다. 정적 분석상 진입점이 없으므로 실제 호출 여부와 사용처는 **확인 필요**입니다. | `biz:CommonData.CommonDataList` [LookupCommon], `UP_FX_GetCommonDataList` |
| TC-SSP0012-021 | 초기화 (공통코드) | `SetChangedPeriod` 의 호출 경로를 확인한 뒤 수행(정적 분석상 진입점 없음) | 1) `SetChangedPeriod` 가 호출되는 조작을 합니다(**확인 필요**). 2) 기간 값을 확인합니다. | PERIOD_{값}, 없으면 PERIOD_DEFAULT | `biz:CommonData.CommonDataList` 결과의 `FROM_VALUE`/`TO_VALUE` 로 기간이 정해집니다. 호출되지 않으면 이 TC는 "미사용 코드 확인"으로 종료합니다. | `biz:CommonData.CommonDataList` [PERIOD_*], `SetChangedPeriod` |
| TC-SSP0012-022 | division | division 40 사용자 | 1) 화면을 엽니다. 2) 조회합니다. 3) `spdMain` 컬럼을 확인합니다. | Division 40 | 표시 컬럼 44개(TC-004와 같음) | 시트 `Shipment Plan Confirm Detail`, grid_effective(40) |
| TC-SSP0012-023 | division | division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC) 사용자 | TC-022와 같음 | Division 81 계열 | 각각 표시 컬럼 44개이고 division 40과 같습니다. | 시트 `Shipment Plan Confirm Detail`, grid_effective(81*) |
| TC-SSP0012-024 | division | division 82 사용자 | TC-022와 같음 | Division 82 | 표시 컬럼 44개이고 division 40과 같습니다. | 시트 `Shipment Plan Confirm Detail`, grid_effective(82) |
| TC-SSP0012-025 | division | division EE 계열(EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 사용자 | TC-022와 같음 | Division EE 계열 | 각각 표시 컬럼 44개이고 division 40과 같습니다. | 시트 `Shipment Plan Confirm Detail`, grid_effective(EE*) |
| TC-SSP0012-026 | division | 로그인 사용자 `NowGroupID` 확인 | 1) 화면을 엽니다. 2) `clbDivision` 기본 선택을 확인합니다. | 사용자 division | 기본 선택이 사용자 `NowGroupID` 와 관련되는지 **확인 필요**입니다(48행 `dtMyDivision`). | `Form_Load`, `clbDivision_SelectedIndexChanged` |
| TC-SSP0012-027 | 권한 | `TB_FX_GroupMenuAuth` 에 조회 권한만 있는 그룹 사용자 | 1) 화면을 엽니다. 2) 조회합니다. 3) 툴바 버튼 상태를 확인합니다. | 권한 그룹 | 조회가 됩니다. 저장·삭제 기능이 없으므로 해당 툴바 버튼의 비활성/미표시 여부를 확인합니다(그룹별 값은 **확인 필요**). | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL`, `TB_FX_GroupMenuAuth` 16행 |
| TC-SSP0012-028 | 권한 | 메뉴 권한이 없는 그룹 사용자 | 1) 메뉴 목록에서 SSP0012를 찾습니다. | 권한 없음 | 메뉴가 보이지 않거나 열리지 않습니다(**확인 필요**). | `TB_FX_GroupMenuAuth`, `Form_Load` |

**커버리지 점검**

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 014, 015, 026 |
| | `SpdMain_TopChange` | 019 |
| | `btnItemId_Click` | 016 |
| | `SpdMain_CellClick` | 018 |
| | `clbDivision_SelectedIndexChanged` | 013, 014 |
| | `BtnColumn_Click` | 017 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 020, 021 |
| | `SSP.SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` | 006~012, 027 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 001, 013, 014, 015 |
| 시트 | `Shipment Plan Confirm Detail` | 003, 004, 005, 009, 022~025 |
| 빈 결과 | | 009, 015 |
| 오류 응답 | | 010, 014 |
| division | 40 / 81 계열 / 82 / EE 계열 | 022~025 |
