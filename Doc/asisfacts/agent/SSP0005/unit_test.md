# SSP0005 — Shipment Working Day 단위테스트

> 절차 열의 컨트롤명은 화면설계서 §3과 같고, 근거 열의 엔드포인트·SP 이름은 업무분석서 §5·화면설계서 §5와 같습니다.
> 기대결과가 Fact Pack으로 확정되지 않은 경우 **확인 필요**로 적었습니다.
> 주석 처리된 호출(569, 940)은 테스트 대상에서 제외했습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0005-001 | 초기화 | 로그인 완료, SSP0005 메뉴 권한 보유 | 화면을 엽니다 → `cboInputValue` 목록을 확인합니다 | - | `cboInputValue`에 YesOrNo 공통코드가 바인딩됩니다(CODE/NAME) | `Form_Load` > InitControls:168, `biz:CommonData.YesOrNo` |
| TC-SSP0005-002 | 초기화 | 위와 같음 | 화면을 엽니다 → `drpPeriod` 값을 확인합니다 | - | 기간 조회 SP가 호출됩니다. `drpPeriod`에 반영되는지는 **확인 필요** | `Form_Load` > InitControls > GetDayRange:941, `SCP.SCM0001_GET_SCP_PERIOD`, SP `SCM0001_GET_SCP_PERIOD` |
| TC-SSP0005-003 | 초기화 | 위와 같음 | 화면을 엽니다 → `spdMain` 헤더를 확인합니다 | - | 시트 `Shipment Working Day`가 생성되고 SCP0009 결과로 날짜 컬럼 헤더가 만들어집니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle:925, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Working Day` |
| TC-SSP0005-004 | 초기화 | 위와 같음 | `cboCompany` 목록을 엽니다 | - | Company 목록(`SCM_MST_COMPANY_SN` 기준)이 표시됩니다. 바인딩 경로는 unreached이므로 **확인 필요** | field dtCompany:46, `biz:CommonData.CommonDataList` [code=Company] |
| TC-SSP0005-005 | 초기화 | 사용자 그룹(NowGroupID) 확인 | `clbDivision` 목록을 엽니다 | - | 사용자 그룹에 허용된 Division만 표시됩니다(`SCM_MST_DIVISION`, `TB_FX_USERGROUPAUTHEXTENTION`). 경로는 **확인 필요** | field dtMyDivision:45, `biz:CommonData.CommonDataList` [code=MyDivision] |
| TC-SSP0005-006 | 초기화 | 위와 같음 | `cboDayWeek` 목록을 엽니다 | - | LookupCommon 요일 목록이 표시됩니다. 경로는 **확인 필요** | field dtDayWeek:47, `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SSP0005-007 | 그리드 | 화면 로드 완료 | `spdMain` 고정 컬럼을 확인합니다 | - | `COMPANY_ID`(헤더 `Company`)와 `DIVISION_ID`(헤더 `Divison`)가 표시됩니다 | 시트 `Shipment Working Day`, `SCM_MST_SHEET_COLUMNS`, SetSheetHeaderColumn:196 |
| TC-SSP0005-008 | 그리드 | 조회 완료 | `spdMain` 날짜 컬럼 셀을 클릭합니다 | - | 셀이 YesOrNo Combo입니다. 폭 70, Center 정렬이고 DIVISION 컬럼 다음부터 시작합니다 | 시트 `Shipment Working Day`, InitSpreadDateColumn:263, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0005-009 | 그리드 | 조회 기간에 토·일 포함 | 날짜 컬럼 글자색을 확인합니다 | - | DAY_CODE가 SAT인 컬럼은 Blue, SUN인 컬럼은 Red입니다 | 시트 `Shipment Working Day`, InitSpreadDateColumn:267 |
| TC-SSP0005-010 | 그리드 | 조회 완료 | 헤더 1·2행 병합을 확인합니다 | - | row 0은 LARGE_CLASS_LABEL_NAME, row 1은 SMALL_CLASS_LABEL_NAME으로 같은 값끼리 병합됩니다(높이 20) | 시트 `Shipment Working Day`, ColumnHeaderSpan 274·280·290·301·303, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0005-011 | 조회 | 데이터가 있는 조건 | `cboCompany`, `clbDivision`(1개 이상), `drpPeriod`를 지정하고 조회(FindButton)를 누릅니다 | Company/Division/Period 유효값 | 그리드가 다시 생성되고 `SSP_MST_SHIP_CALENDAR` 데이터가 날짜 컬럼에 Y/N으로 표시됩니다 | `FindData_Main`:403, `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, SP `SSP0005_GET_SHIPMENT_WORKING_DAY`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0005-012 | 조회 | 데이터가 없는 조건 | 데이터가 없는 Division·기간으로 조회합니다 | 데이터 없는 조합 | 오류 없이 0행 그리드가 표시됩니다. 메시지는 **확인 필요** | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, SP `SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-013 | 조회 | - | `drpPeriod`를 비우고 조회합니다 | Period 빈값 | 필수(`Period*`) 검증이 동작합니다. 메시지와 차단 여부는 **확인 필요** | `FindData_Main`, `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-014 | 조회 | SP 오류 유발 환경(예: DB 연결 차단) | 조회합니다 | - | 오류 응답이 표시되고 기존 그리드가 손상되지 않습니다. 메시지는 **확인 필요** | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, SP `SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-015 | 저장 | 조회 완료, 시험 대상 행의 저장 전 값 기록 | `spdMain` 날짜 셀 1개를 Y→N으로 바꾸고 저장(SaveButton)을 누릅니다 | 변경 셀 1건 | 변경 행만 전송됩니다(GetChanges/ROW_ID). `SSP_MST_SHIP_CALENDAR`가 UPDATE되고 `SCM_SYS_LOG_BATCH`에 1건 이상 INSERT된 뒤 재조회됩니다. 시험 후 원복합니다 | `SaveData_Main`:535·536·537, `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, SP `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-016 | 저장 | 조회 완료, 변경 없음 | 저장(SaveButton)을 누릅니다 | - | 변경분 0건으로 처리됩니다. SP 호출 여부와 메시지는 **확인 필요** | `SaveData_Main` GetChanges:538, `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| TC-SSP0005-017 | 저장 | SP 오류 유발 환경 | 셀을 변경하고 저장합니다 | 변경 셀 1건 | 오류 응답이 표시되고 `SSP_MST_SHIP_CALENDAR`는 바뀌지 않습니다(롤백). 메시지는 **확인 필요** | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, SP `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| TC-SSP0005-018 | 이벤트 | 조회 완료, `M_` 헤더 존재 | `spdMain`의 `M_` 컬럼 헤더를 더블클릭합니다 | - | `W_` 컬럼과 보이는 `D_` 컬럼의 Visible이 반전됩니다. 다시 더블클릭하면 원래대로 돌아옵니다 | `SpdMain_CellDoubleClick`:840·843, 시트 `Shipment Working Day` |
| TC-SSP0005-019 | 이벤트 | 조회 완료, `W_` 헤더 존재 | `W_` 컬럼 헤더를 더블클릭합니다 | - | `D_` 컬럼의 Visible이 반전됩니다 | `SpdMain_CellDoubleClick`:854 |
| TC-SSP0005-020 | 이벤트 | 조회 완료 | 데이터 셀(헤더 아님)을 더블클릭합니다 | - | 컬럼 표시가 바뀌지 않습니다(`e.ColumnHeader` 조건) | `SpdMain_CellDoubleClick` |
| TC-SSP0005-021 | 이벤트 | 화면 로드 완료 | `cboDayWeek`에서 값을 바꿉니다 | 요일 항목 각각 | `cboInputValue`가 비활성(663) 또는 활성(666)으로 바뀝니다. 항목별 기대 상태는 **확인 필요** | `CboDayWeek_SelectedIndexChanged`:660·663·666 |
| TC-SSP0005-022 | 이벤트 | 조회 완료, `cboInputValue` 활성 | `cboDayWeek`·`cboInputValue`를 선택하고 `btnInput`을 클릭합니다 | 요일, Input Value=Y | 선택 조건에 해당하는 그리드 셀에 값이 일괄 반영됩니다. 처리 중 `SpdMain_Changed`는 호출되지 않습니다(725/821). 반영 범위는 **확인 필요** | `BtnInput_Click`:682·725·821 |
| TC-SSP0005-023 | 이벤트 | 조회 완료 | `spdMain` 셀 값을 직접 변경합니다 | 셀 1건 | `SpdMain_Changed`가 1회만 수행되고 재귀 호출이 없습니다(878/902). 후속 처리는 **확인 필요** | `SpdMain_Changed`:878·902 |
| TC-SSP0005-024 | 이벤트 | 조회 완료, 다수 행 | `spdMain`을 세로 스크롤합니다 | - | 오류 없이 스크롤됩니다. 핸들러 처리 결과는 **확인 필요** | `SpdMain_TopChange` (InitEvent:312) |
| TC-SSP0005-025 | division | Division 40 사용자 | 조회 후 메타 컬럼을 확인합니다 | Division=40 | 메타 컬럼 2개(Company, Divison)가 표시됩니다 | 시트 `Shipment Working Day`, grid_effective(40=기본 2) |
| TC-SSP0005-026 | division | Division 81 / EE 계열 사용자 | 조회 후 메타 컬럼을 확인합니다 | Division=81, EE | 40과 같은 메타 컬럼 2개가 표시됩니다(division 분기 없음) | 시트 `Shipment Working Day`, grid_effective(81·EE=기본 2) |
| TC-SSP0005-027 | 권한 | 서로 다른 그룹의 사용자 2명 | 각 사용자로 `clbDivision` 목록과 조회·저장 가능 여부를 확인합니다 | - | Division 목록이 그룹별로 다릅니다. 조회·저장 허용 여부는 `TB_FX_GroupMenuAuth`(13행) 플래그를 따릅니다(값 **확인 필요**) | `biz:CommonData.CommonDataList` [code=MyDivision], `FindData_Main`, `SaveData_Main` |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003 |
| | `SpdMain_CellDoubleClick` | 018, 019, 020 |
| | `SpdMain_TopChange` | 024 |
| | `CboDayWeek_SelectedIndexChanged` | 021 |
| | `BtnInput_Click` | 022 |
| | `SpdMain_Changed` | 023 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 004, 005, 006, 027 |
| | `biz:CommonData.YesOrNo` | 001 |
| | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | 011, 012, 013, 014 |
| | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | 015, 016, 017 |
| | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 003, 008, 010, 011 |
| | `SCP.SCM0001_GET_SCP_PERIOD` | 002 |
| 시트 | `Shipment Working Day` | 003, 007, 008, 009, 010, 018, 025, 026 |
| 빈 결과 / 오류 응답 | - | 012 / 014, 017 |
