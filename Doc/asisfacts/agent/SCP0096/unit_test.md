# SCP0096 — Shipment Working Day OSP 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과에 "확인 필요"가 있는 케이스는 As-Is 동작을 확정한 뒤 기대값을 채워야 합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0096-001 | 초기화 | 메뉴 권한 보유 | 화면을 엽니다 | — | Bucket Type 코드 조회가 1회 호출되고 오류가 없습니다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-002 | 초기화 | 메뉴 권한 보유 | 화면을 열고 spdMain을 확인합니다 | — | 시트 `Shipment Working Day OSP`가 만들어지고 헤더가 3행이며, 달력 헤더 조회가 호출됩니다 | `Form_Load`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-003 | 초기화 | 화면 로드 완료 | chkSum 상태를 확인합니다 | — | chkSum Checked=false. Designer Visible=false(런타임 표시 여부 확인 필요) | `Form_Load`, `chkSum_CheckedChanged` |
| TC-SCP0096-004 | 그리드 | 화면 로드 완료 | spdMain_Sheet1의 고정 컬럼 헤더를 확인합니다 | — | Division, Plant Site ID, Plant Site, Measure, Working Time Default, Last Input Date 6개 메타 컬럼이 표시됩니다 | `Shipment Working Day OSP` (SetSheetHeaderColumn) |
| TC-SCP0096-005 | 그리드 | 날짜 컬럼 생성 | MEASURE 다음 날짜 컬럼 중 COLUMN_NAME에 `B_`가 들어 있는 컬럼을 확인합니다 | Period 임의 | 해당 컬럼은 너비 0으로 숨김 처리됩니다 | `Shipment Working Day OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-006 | 그리드 | 날짜 컬럼 생성 | `B_`가 아닌 날짜 셀을 클릭해 콤보 목록을 엽니다 | — | YesOrNo 콤보, 너비 50, 가운데 정렬로 표시됩니다 | `Shipment Working Day OSP`, `biz:CommonData.YesOrNo` |
| TC-SCP0096-007 | 그리드 | Period에 토·일 포함 | 날짜 컬럼 글자색을 확인합니다 | 주말 포함 기간 | DAY_CODE SAT = 파랑, SUN = 빨강입니다 | `Shipment Working Day OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-008 | 그리드 | Period 지정 | 헤더 병합을 확인합니다 | — | 0행 LARGE_CLASS_LABEL_NAME 병합, 1행 SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더가 표시됩니다 | `Shipment Working Day OSP`, `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-009 | 조회 | 데이터 있는 조건 | cboDivision, clbPlantSite, dCalendar를 넣고 조회(FindButton)합니다 | Division=데이터 있는 값, Plant Site 1개 이상 체크, Period=유효 기간 | 결과가 바인딩되고 GetMaxRowIndex() > 0이면 SetSpreadColumn으로 D_/W_ 컬럼이 표시됩니다 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-010 | 조회 | 데이터 없는 조건 | 조회(FindButton)합니다 | 데이터가 없는 Plant Site/Period | 그리드가 비고 SetSpreadColumn은 호출되지 않습니다(:484). 안내 메시지는 확인 필요 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-011 | 조회 | SP 오류 유발(DB 연결 불가 등) | 조회(FindButton)합니다 | — | 오류 메시지가 표시되고 화면이 유지됩니다(메시지 문구 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-012 | 조회 | — | cboDivision 또는 dCalendar를 비우고 조회합니다 | Division 빈값 / Period 빈값 | 필수값 검증 메시지가 표시됩니다(검증 코드·문구 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-013 | 조회 | 조회 완료 | Period를 바꿔 다시 조회합니다 | 기간 변경 | 날짜 컬럼이 새 기간 기준으로 다시 만들어집니다 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-014 | 저장 | 조회 완료 | 날짜 셀 값을 Y↔N으로 바꾸고 저장(SaveButton)합니다 | 셀 1건 변경 | 변경행만 저장 대상이 되고, 저장한 뒤 재조회가 실행되어 변경값이 반영됩니다(저장 엔드포인트 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-015 | 저장 | 조회 완료, 변경 없음 | 저장(SaveButton)합니다 | — | 저장 대상 0건 처리(메시지·동작 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-016 | 이벤트 | 조회 완료 | chkSum을 체크합니다 | Checked=true | 태그가 M_/W_로 시작하는 컬럼이 표시됩니다 | `chkSum_CheckedChanged`, `Shipment Working Day OSP` |
| TC-SCP0096-017 | 이벤트 | TC-016 이후 | chkSum 체크를 풉니다 | Checked=false | M_ 컬럼이 숨겨집니다(W_ 최종 결과 확인 필요) | `chkSum_CheckedChanged`, `Shipment Working Day OSP` |
| TC-SCP0096-018 | 이벤트 | 화면 로드 완료 | cboDayWeek 값을 바꿉니다 | 선택값 변경 | 선택에 따라 cboInputValue.Enabled가 false 또는 true로 바뀝니다(분기 조건 확인 필요) | `CboDayWeek_SelectedIndexChanged` |
| TC-SCP0096-019 | 이벤트 | 조회 완료, cboInputValue 활성 | cboDayWeek, cboInputValue를 고르고 btnInput을 클릭합니다 | 요일·입력값 선택 | 그리드에 일괄 입력됩니다(대상 범위 확인 필요) | `BtnInput_Click`, `Shipment Working Day OSP` |
| TC-SCP0096-020 | 이벤트 | 화면 로드 완료 | cboDivision 값을 바꿉니다 | 다른 Division | 연쇄 동작 확인 필요(clbPlantSite 목록 갱신 여부 등) | `CboDivision_SelectedIndexChanged` |
| TC-SCP0096-021 | 이벤트 | 화면 로드 완료 | clbPlantSite 항목을 체크하거나 해제합니다 | 항목 변경 | 동작 확인 필요 | `ClbPlantSite_SelectedIndexChanged` |
| TC-SCP0096-022 | 이벤트 | 조회 완료 | spdMain 셀을 더블클릭합니다 | 임의 셀 | 동작 확인 필요(팝업 여부 포함) | `SpdMain_CellDoubleClick` |
| TC-SCP0096-023 | 이벤트 | 조회 완료(행 다수) | spdMain을 세로로 스크롤합니다 | — | 동작 확인 필요 | `SpdMain_TopChange` |
| TC-SCP0096-024 | division | 데이터 존재 | cboDivision을 40, 81, EE로 각각 조회해 고정 컬럼을 비교합니다 | 40 / 81 / EE | 세 division 모두 메타 6컬럼이 같습니다(division 변형 없음) | `Shipment Working Day OSP`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-025 | 초기화 | 화면 로드 완료 | cboDayWeek 목록을 확인합니다 | — | LookupCommon 공통코드 목록 바인딩 여부를 확인합니다(코드값·바인딩 확인 필요) | `biz:CommonData.CommonDataList` |
| TC-SCP0096-026 | 권한 | 조회 전용 그룹 계정 | 화면을 열고 저장(SaveButton)을 시도합니다 | — | 권한 값(TB_FX_GroupMenuAuth)에 따라 저장 버튼이 제어됩니다(값 확인 필요) | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |

### 커버리지 점검

| 대상 | TC |
|---|---|
| `Form_Load` | 001, 002, 003 |
| `SpdMain_CellDoubleClick` | 022 |
| `SpdMain_TopChange` | 023 |
| `CboDivision_SelectedIndexChanged` | 020 |
| `ClbPlantSite_SelectedIndexChanged` | 021 |
| `CboDayWeek_SelectedIndexChanged` | 018 |
| `BtnInput_Click` | 019 |
| `chkSum_CheckedChanged` | 003, 016, 017 |
| `biz:CommonData.CommonDataList` | 025 |
| `biz:CommonData.YesOrNo` | 006 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | 001 |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | 009~012, 014, 015, 024, 026 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 002, 005, 007, 008, 009, 013, 014 |
| 시트 `Shipment Working Day OSP` | 002, 004~008, 013, 016, 017, 019, 024 |
| 빈 결과 / 오류 응답 | 010 / 011 |
