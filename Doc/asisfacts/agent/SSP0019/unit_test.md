# SSP0019 Shipment Change History — 단위테스트

> 근거 열의 이름은 업무분석서 §5와 화면설계서 §5의 엔드포인트·핸들러·시트 이름 원문과 같습니다.
> 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 사실이 없는 부분은 "AS-IS 원문 확인 후 확정"으로 적었습니다.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0019-001 | 초기화 | SSP0019 메뉴 권한이 있는 사용자로 로그인 | 1) 화면을 엽니다 2) `drpPeriod` 값을 확인합니다 | 없음 | `SCP.GET_DATE_RANGE_1MONTH`가 1회 호출되고, 반환된 기간이 `drpPeriod` From~To에 설정됩니다(값은 SCM_SYS_CALENDAR_M 기준, 산출 규칙 확인 필요) | `Form_Load`, `SCP.GET_DATE_RANGE_1MONTH` |
| TC-SSP0019-002 | 초기화 | `SCP.GET_DATE_RANGE_1MONTH`가 0행을 반환하거나 오류를 반환하도록 설정 | 1) 화면을 엽니다 2) `drpPeriod` 상태와 메시지를 확인합니다 | 빈 결과 / 오류 응답 | 화면 로드가 중단되지 않습니다. `drpPeriod` 값과 메시지는 AS-IS 원문 확인 후 확정 | `Form_Load`, `SCP.GET_DATE_RANGE_1MONTH` |
| TC-SSP0019-003 | 초기화 | 화면 열기 | 1) 화면 레이아웃을 확인합니다 | 없음 | `usrConditionPanel1`(Top)과 `usrLayoutControl1` 안에 조건 컨트롤 11개(`clbDivision`, `clbFromSite`, `clbToSite`, `clbTransportMode`, `clbIncomterms`, `drpPeriod`, `txtSoNo`, `txtItemId`, `btnItemId`, `txtConfirmId`, `chkCurrent`)가 있고, 라벨은 Division / From Site / To Site / Incoterms / Shipment Date / SO No / Model / Confirm ID / Current입니다. `spdMain`은 Fill입니다 | `Form_Load`, `Shipment Change History` |
| TC-SSP0019-004 | 그리드 | 화면 열기 | 1) `spdMain` 시트 탭과 컬럼 헤더를 확인합니다 | 없음 | 시트 `Shipment Change History` 1개, 헤더 1행. 메타 47컬럼 중 46컬럼이 표시되고 LAST_SEQ는 숨김입니다. 헤더 라벨은 화면설계서 §4와 같습니다 | `Shipment Change History` (SetSheetHeaderColumn@InitSpread:332) |
| TC-SSP0019-005 | 그리드 | TC-SSP0019-007로 1건 이상 조회 | 1) `spdMain` REQUEST_NO 컬럼 셀을 확인합니다 | 없음 | REQUEST_NO 셀이 이미지 셀(cellTypeImage)로 표시됩니다 | `Shipment Change History` (InitSpread:339) |
| TC-SSP0019-006 | 그리드 | 데이터 1건 이상 조회 | 1) `spdMain` 시트 `Shipment Change History`의 표시 컬럼과 SP 결과 컬럼을 대조합니다 | 없음 | 표시 컬럼 46개가 모두 값과 바인딩됩니다. SP 결과에 없는 컬럼이 있는지는 실행으로 확인합니다(Fact Pack §10 미매칭) | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `Shipment Change History` |
| TC-SSP0019-007 | 조회 | 화면 열기, 초기 기간 설정 완료 | 1) 조건을 기본값으로 둡니다 2) 조회(FindButton)를 누릅니다 | `drpPeriod` 초기값 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` → SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY`가 1회 호출되고 결과가 `spdMain`에 표시됩니다 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-008 | 조회 | 화면 열기 | 1) `clbDivision`, `clbFromSite`, `clbToSite`, `clbTransportMode`, `clbIncomterms`에서 항목을 각각 체크합니다 2) 조회합니다 | 각 목록에서 1개 이상 선택 | 선택 항목의 CODE 값(GetCheckedListValue)이 SP 파라미터로 전달되고, 결과가 선택 조건에 맞게 필터링됩니다. 파라미터 대응은 확인 필요 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-009 | 조회 | 화면 열기 | 1) `txtSoNo`, `txtItemId`, `txtConfirmId`에 여러 줄을 입력합니다 2) 조회합니다 | SO No 2건, Model 2건, Confirm ID 2건 | 다건 값이 분리 처리(FN_SCM_SPLIT / FN_GET_IN_STR)되어 조회 조건에 반영됩니다. 구분자 규칙은 확인 필요 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-010 | 조회 | 화면 열기 | 1) `drpPeriod`를 데이터가 없는 기간으로 바꿉니다 2) 조회합니다 | 데이터 없는 기간 | `spdMain` 시트 `Shipment Change History`가 0행이 됩니다. 안내 메시지는 AS-IS 원문 확인 후 확정 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `Shipment Change History` |
| TC-SSP0019-011 | 조회 | SP가 오류를 반환하도록 설정(예: SP 실행 권한 제거) | 1) 조회합니다 | 기본 조건 | 오류 메시지가 표시되고 기존 그리드 상태 처리는 AS-IS 원문 확인 후 확정. 화면은 비정상 종료되지 않아야 합니다 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY`, `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-012 | 이벤트 | 화면 열기 | 1) `btnItemId`를 클릭합니다 2) Model을 선택합니다(팝업 여부 확인 필요) | Model 1건 | `txtItemId`에 선택값(sItemId)이 설정됩니다 | `btnItemId_Click` |
| TC-SSP0019-013 | 이벤트 | 화면 열기 | 1) `chkCurrent`를 체크합니다 2) 체크를 해제합니다 | Current = 체크/해제 | `ChkCurrent_CheckedChanged`가 실행됩니다. 조건 컨트롤과 조회 결과에 미치는 영향은 AS-IS 원문 확인 후 확정 | `ChkCurrent_CheckedChanged` |
| TC-SSP0019-014 | 이벤트 | 화면 열기 | 1) `clbDivision`의 선택을 바꿉니다 | Division 선택 변경 | `clbDivision_SelectedIndexChanged`가 실행됩니다. 다른 조건(`clbFromSite`·`clbToSite` 등)과 연동되는지는 AS-IS 원문 확인 후 확정 | `clbDivision_SelectedIndexChanged` |
| TC-SSP0019-015 | 이벤트 | 데이터 1건 이상 조회 | 1) `spdMain`의 REQUEST_NO 셀을 클릭합니다 2) 다른 컬럼 셀을 클릭합니다 | 없음 | `SpdMain_CellClick`이 실행됩니다. 셀별 동작(팝업 등)은 AS-IS 원문 확인 후 확정 | `SpdMain_CellClick`, `Shipment Change History` |
| TC-SSP0019-016 | 이벤트 | 화면 높이보다 많은 행 조회 | 1) `spdMain`을 세로로 스크롤합니다 | 없음 | `SpdMain_TopChange`가 실행됩니다. 동작은 AS-IS 원문 확인 후 확정 | `SpdMain_TopChange` |
| TC-SSP0019-017 | 이벤트 | SetChangedPeriod 진입점 확인 완료(현재 정적 분석상 미연결) | 1) 확인된 진입점 동작을 수행합니다 | `{p:value}` 값(확인 필요) | `biz:CommonData.CommonDataList`가 code=PERIOD_{p:value}로 호출되고 dt.Rows[0]의 FROM_VALUE·TO_VALUE가 기간에 반영됩니다 | `biz:CommonData.CommonDataList` |
| TC-SSP0019-018 | 이벤트 | TC-SSP0019-017과 같으며, PERIOD_{p:value} 코드 행이 없도록 설정 | 1) 같은 진입점 동작을 수행합니다 | 존재하지 않는 코드값 | 코드 표현식 `PERIOD_{p:value} \|\| PERIOD_DEFAULT`에 따른 대체 동작 또는 빈 결과 처리를 확인합니다. 기대값은 AS-IS 원문 확인 후 확정 | `biz:CommonData.CommonDataList` |
| TC-SSP0019-019 | division | Division이 각각 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC인 사용자(14개) | 1) division별로 화면을 엽니다 2) `spdMain` 표시 컬럼 수를 확인합니다 | division 14종 | 모든 division에서 시트 `Shipment Change History`가 46컬럼 표시, LAST_SEQ 숨김으로 같습니다(division 변형 없음) | `Shipment Change History` |
| TC-SSP0019-020 | 권한 | TB_FX_GroupMenuAuth에 SSP0019 권한이 있는 그룹과 없는 그룹의 사용자 | 1) 각 사용자로 화면을 열고 조회합니다 | 그룹 2종 | 권한이 있는 그룹은 조회가 가능합니다. 권한이 없는 그룹의 동작과 C/R/U/D 값은 GroupMenuAuth 16행 확인 후 확정 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` |
| TC-SSP0019-021 | 권한 | 서로 다른 NowGroupID를 가진 사용자 2명 | 1) 각 사용자로 화면을 엽니다 2) 조건 목록(`clbDivision` 등)을 비교합니다 | 그룹 2종 | 그룹에 따라 조건 구성이 달라지는지 확인합니다(SetChangeControl:163·164, SetChangedControl:298·303). 기대값은 AS-IS 원문 확인 후 확정 | `Form_Load`, `clbDivision_SelectedIndexChanged` |
| TC-SSP0019-022 | 초기화 | 화면 열기 | 1) 화면을 엽니다 2) 사용 로그를 확인합니다 | 없음 | InitControls에서 FP_Log2(LOGTYPE, NOTE, USER_ID)가 호출됩니다. 기록 테이블은 확인 필요 | `Form_Load` |

## 2. 커버리지 점검

| 대상 | 원문 이름 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003, 021, 022 |
| 이벤트 핸들러 | `SpdMain_TopChange` | 016 |
| 이벤트 핸들러 | `SpdMain_CellClick` | 015 |
| 이벤트 핸들러 | `btnItemId_Click` | 012 |
| 이벤트 핸들러 | `ChkCurrent_CheckedChanged` | 013 |
| 이벤트 핸들러 | `clbDivision_SelectedIndexChanged` | 014, 021 |
| 엔드포인트 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | 006~011, 020 |
| 엔드포인트 | `SCP.GET_DATE_RANGE_1MONTH` | 001, 002 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 017, 018 |
| SP | `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | 007~009, 011 |
| 시트 | `Shipment Change History` | 003~006, 010, 015, 019 |
| 빈 결과 | — | 002, 010, 018 |
| 오류 응답 | — | 002, 011 |
| division | 14종(변형 없음) | 019 |

- 523줄의 주석 처리 호출은 현행 기능이 아니어서 테스트 대상에서 제외했습니다.
