# SCP0096 — Shipment Working Day OSP 단위테스트

> **작성 근거**: 업무분석서 §5 / 화면설계서 §3·§5와 같은 이름을 씁니다. 기대결과 중 사실 묶음으로 정할 수 없는 부분은 **확인 필요**로 표기했고, 실행할 때 AS-IS 동작을 확인해 확정합니다.
> 주석 처리된 호출은 현행 기능이 아니므로 테스트 대상에서 제외했습니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0096-001 | 초기화 | 화면 권한이 있는 사용자로 로그인 | 메뉴에서 SCP0096 화면을 연다 | — | `Form_Load` → InitControls → GetBucketType 이 Bucket Type 코드를 1회 호출하고 오류 없이 화면이 열림(결과 바인딩 컨트롤은 확인 필요) | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-002 | 초기화 | TC-001과 같음 | 화면을 열고 `spdMain` 의 시트를 확인한다 | — | 시트 `Shipment Working Day OSP` 1개가 생성되고 컬럼 헤더가 3행임. 달력 헤더 조회가 호출됨 | `Form_Load`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-003 | 초기화 | TC-001과 같음 | 화면을 열고 `chkSum` 의 표시·체크 상태를 확인한다 | — | `chkSum` 화면에 보이지 않음(Visible=false), Checked=false. `M_`/`W_` Tag 컬럼 숨김 | `Form_Load`, `chkSum_CheckedChanged`(SetSpreadColumn 355), `Shipment Working Day OSP` |
| TC-SCP0096-004 | 그리드 | 화면 열림 | `spdMain_Sheet1` 의 META 컬럼 헤더를 확인한다 | — | Division / Plant Site ID / Plant Site / Measure / Working Time Default / Last Input Date 6개 컬럼이 표시됨(순서는 META SORT_ORDER_NO 확인 필요) | `Shipment Working Day OSP`, SetSheetHeaderColumn(InitSpread:156) |
| TC-SCP0096-005 | 그리드 | 조회 데이터가 있는 조건 | `cboDivision`·`dCalendar` 를 입력하고 조회 후 날짜 컬럼을 확인한다 | Period = 임의 2주 | MEASURE 다음 열부터 날짜 컬럼이 SCP0009 결과 행 수만큼 생성됨. 폭 50, 가운데 정렬, Y/N 콤보 셀 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.YesOrNo`, `Shipment Working Day OSP` |
| TC-SCP0096-006 | 그리드 | TC-005 조회 완료 | 날짜 셀의 콤보 목록을 펼친다 | — | 목록이 Yes/No(YesOrNo 공통 데이터)로 구성됨 | `biz:CommonData.YesOrNo`, `Shipment Working Day OSP` |
| TC-SCP0096-007 | 그리드 | TC-005 조회 완료 | 컬럼명에 `B_` 가 위치 1 이상에 포함된 컬럼이 있는지 확인한다 | — | 해당 컬럼은 폭 0 Text, 숨김 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` (InitSpreadDateColumn 196) |
| TC-SCP0096-008 | 그리드 | 토·일요일이 들어간 기간 | 토·일 날짜 컬럼의 글자색을 확인한다 | Period에 토·일 포함 | DAY_CODE SAT 컬럼은 파랑, SUN 컬럼은 빨강, 평일은 기본색 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` (208) |
| TC-SCP0096-009 | 그리드 | 여러 Large/Small 그룹에 걸친 기간 | 헤더 0~2행을 확인한다 | Period = 그룹 경계를 넘는 기간 | 0행 LARGE_CLASS_LABEL_NAME, 1행 SMALL_CLASS_LABEL_NAME으로 Span. 각 그룹 시작 열에 `SUM` 헤더 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` (215~244) |
| TC-SCP0096-010 | 조회 | 데이터가 있는 Division / Plant Site | `cboDivision`·`clbPlantSite`·`dCalendar` 를 입력하고 조회 버튼을 누른다 | Division=유효값, Plant Site 1개 이상 체크 | 조회 SP가 호출되고, 체크한 Plant Site 행만 그리드에 표시됨. 달력 헤더 재생성. 결과 행이 있으므로 SetSpreadColumn 실행 | FindButton > `FindData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-011 | 조회 | 데이터가 없는 조건 | 데이터가 없는 조건으로 조회 버튼을 누른다 | 데이터 없는 Plant Site/기간 | 그리드 0행, 오류 없음. `GetMaxRowIndex() > 0` 이 아니므로 SetSpreadColumn 생략. 결과 없음 메시지 여부는 확인 필요 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `FindData_Main`(484) |
| TC-SCP0096-012 | 조회 | 조회 SP 오류를 유발할 수 있는 환경 | 조회 SP가 오류를 반환하는 상태에서 조회 버튼을 누른다 | (오류 응답) | 오류 메시지 표시, 그리드 이전 상태 유지 여부 확인 필요. 화면 비정상 종료 없음 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-013 | 조회 | 화면 열림 | `cboDivision` 또는 `dCalendar` 를 비우고 조회 버튼을 누른다 | Division 빈값 / Period 빈값 | 필수(`Division*`, `Period*`) 검증 동작·메시지 **확인 필요** | FindButton > `FindData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-014 | 조회 | 달력 헤더 결과가 없는 기간 | 달력 데이터가 없는 기간으로 화면을 열거나 조회한다 | Period = 달력 미등록 기간 | 날짜 컬럼 0개, META 6개 컬럼만 표시. 오류 여부 확인 필요 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-015 | 조회 | Bucket Type 코드 결과가 0건인 환경 | 화면을 연다 | — | 화면 초기화가 오류 없이 끝남(DM0003 결과 사용처 확인 필요) | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-016 | 저장 | TC-010 조회 완료 | `spdMain` 날짜 셀 1개를 Y↔N로 바꾸고 저장 버튼을 누른다 | 셀 값 변경 1건 | 변경 행(ROW_ID)만 저장 파라미터 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default` 로 구성. 저장 후 재조회 결과에 변경값이 반영됨(저장 SP 확인 필요) | SaveButton > `SaveData_Main` > `FindData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-017 | 저장 | TC-010 조회 완료 | 아무것도 바꾸지 않고 저장 버튼을 누른다 | 변경 없음 | GetChanges 결과 0건. 저장 호출 여부·메시지 확인 필요 | `SaveData_Main`(609 GetChanges), `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-018 | 저장 | 저장 오류를 유발할 수 있는 환경 | 셀을 바꾸고 저장 버튼을 누른다 | (오류 응답) | 오류 메시지 표시, 데이터 미반영. 재조회 여부 확인 필요 | `SaveData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-019 | 이벤트 | TC-010 조회 완료 | `spdMain` 셀을 더블클릭한다 | 임의 데이터 셀 | 핸들러가 실행되고 오류 없음. 동작 내용 확인 필요 | `SpdMain_CellDoubleClick`, `Shipment Working Day OSP` |
| TC-SCP0096-020 | 이벤트 | TC-010 조회 완료(행이 화면보다 많음) | `spdMain` 을 세로로 스크롤한다 | — | 핸들러가 실행되고 오류 없음. 동작 내용 확인 필요 | `SpdMain_TopChange`, `Shipment Working Day OSP` |
| TC-SCP0096-021 | 이벤트 | 화면 열림 | `cboDivision` 값을 바꾼다 | Division A → B | 핸들러가 실행되고 오류 없음. `clbPlantSite` 목록 재조회 등 연동은 확인 필요 | `CboDivision_SelectedIndexChanged` |
| TC-SCP0096-022 | 이벤트 | 화면 열림 | `clbPlantSite` 체크를 바꾼다 | Plant Site 체크/해제 | 핸들러가 실행되고 오류 없음. 연동 동작 확인 필요 | `ClbPlantSite_SelectedIndexChanged` |
| TC-SCP0096-023 | 이벤트 | 화면 열림 | `cboDayWeek` 를 서로 다른 값으로 두 번 바꾸며 `cboInputValue` 활성 상태를 본다 | 값 1 / 값 2 | 선택 조건에 따라 `cboInputValue.Enabled` 가 false(675) / true(679)로 바뀜(조건 확인 필요) | `CboDayWeek_SelectedIndexChanged` |
| TC-SCP0096-024 | 이벤트 | 화면 열림 | `cboDayWeek` 목록을 펼친다 | — | 요일 목록 표시. 원천이 Lookup 공통코드인지 확인 필요 | `biz:CommonData.CommonDataList`, `CboDayWeek_SelectedIndexChanged` |
| TC-SCP0096-025 | 이벤트 | TC-010 조회 완료 | `cboDayWeek`·`cboInputValue` 를 고르고 `btnInput` 을 누른다 | 요일 값, Input Value 값 | 지정한 요일 조건의 날짜 셀에 Input Value가 일괄 반영됨(대상 행/열 범위 확인 필요). 서버 호출 없음 | `BtnInput_Click`, `Shipment Working Day OSP` |
| TC-SCP0096-026 | 이벤트 | TC-010 조회 완료, `chkSum` 을 조작할 수 있는 테스트 환경 | `chkSum` 을 체크 → 해제한다 | Checked true → false | true: `M_`/`W_` 컬럼 표시, `D_` 표시 유지. false: `M_`/`W_` 숨김, `D_` 표시 유지 | `chkSum_CheckedChanged`, `Shipment Working Day OSP` (SetSpreadColumn 350·355) |
| TC-SCP0096-027 | division | 14개 division(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC) 데이터 | division별로 `cboDivision` 을 바꿔 조회 버튼을 누르고 META 컬럼을 비교한다 | division 14개 | 모든 division에서 META 6개 컬럼이 똑같이 표시됨(division별 변형 없음) | `CboDivision_SelectedIndexChanged`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `Shipment Working Day OSP` |
| TC-SCP0096-028 | 권한 | 조회 권한만 있는 그룹 / 저장 권한이 있는 그룹 | 각 계정으로 화면을 열고 조회·저장 버튼이 보이는지·동작하는지 확인한다 | 권한 그룹 2종 | TB_FX_GroupMenuAuth 값에 따라 버튼 노출·동작(권한 값 확인 필요) | `Form_Load`, FindButton > `FindData_Main`, SaveButton > `SaveData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003, 015, 028 |
| | `SpdMain_CellDoubleClick` | 019 |
| | `SpdMain_TopChange` | 020 |
| | `CboDivision_SelectedIndexChanged` | 021, 027 |
| | `ClbPlantSite_SelectedIndexChanged` | 022 |
| | `CboDayWeek_SelectedIndexChanged` | 023, 024 |
| | `BtnInput_Click` | 025 |
| | `chkSum_CheckedChanged` | 003, 026 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 024 |
| | `biz:CommonData.YesOrNo` | 005, 006 |
| | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 001, 015 |
| | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | 010~013, 016~018, 027, 028 |
| | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 002, 005, 007~010, 014, 016 |
| 시트 | `Shipment Working Day OSP` | 002~009, 014, 019, 020, 025~027 |
| 빈 결과 | 조회 0건 / 달력 0건 / 코드 0건 / 변경 0건 | 011, 014, 015, 017 |
| 오류 응답 | 조회 / 저장 | 012, 018 |
| division | 14개 division 동일(변형 없음) | 027 |
