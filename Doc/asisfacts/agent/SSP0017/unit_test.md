# SSP0017 단위테스트 — Inventory Raw(Small)

> 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5, 화면설계서 §5와 같은 원문입니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과 중 Fact Pack으로 확정할 수 없는 부분은 "(확인 필요)"로 표기했습니다. 주석 처리된 호출은 테스트 대상이 아닙니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0017-001 | 초기화 | 권한 있는 계정으로 로그인 | 메뉴에서 SSP0017 화면을 엽니다 | — | 화면 제목 `Inventory Raw(Small)`이 표시되고, `usrConditionPanel1`·`usrLayoutControl2`·`spdMain`이 렌더링됩니다 | `Form_Load` |
| TC-SSP0017-002 | 초기화 | TC-001 | 화면을 연 직후 공통코드 호출을 확인합니다(네트워크/로그) | code=LookupCommon | 공통코드 조회가 1회 수행되고 조회조건 콤보가 채워집니다(대상 컨트롤은 확인 필요) | `Form_Load` > `InitControls`, `biz:CommonData.CommonDataList` [LookupCommon] |
| TC-SSP0017-003 | 초기화 | TC-001 | 화면을 연 직후 `cboPlanDate` 목록을 펼칩니다 | code=PlanDateShip | Plan-date 목록이 표시됩니다(원천: `SSP_ANL_SHIP_PLAN_P`, `SSP_PLAN_VERSION_V`) | `Form_Load` > `SetChangedControl`, `biz:CommonData.CommonDataList` [PlanDateShip] |
| TC-SSP0017-004 | 초기화 | TC-001 | `clbDivision`을 클릭해 선택을 바꿔 봅니다 | — | `clbDivision`이 비활성(Enabled=false)이라 선택을 바꿀 수 없습니다 | `Form_Load` > `InitControls`:176 |
| TC-SSP0017-005 | 초기화 | TC-001 | `usrConditionPanel1` 접기/펼치기를 실행합니다 | — | 조회조건 패널이 접히고 펼쳐집니다(HidePanel) | `Form_Load` (props `UsrPanelType=HidePanel`) |
| TC-SSP0017-006 | 이벤트 | TC-001. Division 값이 프로그램적으로 바뀌는 경로 확보(확인 필요) | `clbDivision`의 선택값을 바꿉니다 | Division 다른 값 | `SetChangedControl`이 실행되고 `cboPlanDate` 목록이 다시 조회됩니다 | `clbDivision_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [PlanDateShip] |
| TC-SSP0017-007 | 이벤트 | TC-001 | `btnItemId`를 클릭하고 값을 선택합니다(선택 UI는 확인 필요) | 임의 Model 값(`sItemId`) | `txtItemId`에 선택한 값이 입력됩니다 | `btnItemId_Click` (:301 `txtItemId.Text = sItemId`) |
| TC-SSP0017-008 | 이벤트 | TC-001 | `btnMeasure`를 클릭합니다 | — | 핸들러가 오류 없이 실행됩니다. 구체 결과는 확인 필요입니다 | `btnMeasure_Click` |
| TC-SSP0017-009 | 이벤트 | TC-010으로 다건 조회 완료 | `spdMain`을 세로로 스크롤합니다 | — | 핸들러가 오류 없이 실행되고 Grid 표시가 유지됩니다. 구체 동작은 확인 필요입니다 | `SpdMain_TopChange` |
| TC-SSP0017-010 | 조회 | TC-001 | `cboPlanDate`를 선택하고 `clbPlantSite`·`cboInventoryType`·`txtItemId`를 지정한 뒤 조회(FindButton)를 누릅니다 | 데이터가 있는 Plan-date / Plant Site / Inventory Type / Model | 조회 1회가 수행되고 `spdMain`에 결과 행이 표시됩니다 | `FindData_Main`, `SSP.SSP0017_GET_INVENTORY_RAW`, SP `SSP0017_GET_INVENTORY_RAW` |
| TC-SSP0017-011 | 조회 | TC-001 | `clbPlantSite`에서 여러 항목을 체크한 뒤 조회합니다 | Plant Site 2개 이상 | 선택한 Plant Site 전부가 결과에 반영됩니다(CODE 다중 전달, 파라미터 매핑은 확인 필요) | `FindData_Main` (`GetCheckedListValue`), `SSP.SSP0017_GET_INVENTORY_RAW` |
| TC-SSP0017-012 | 조회 | TC-001 | `txtItemId`에 여러 줄로 Model을 입력하고 조회합니다 | Model 2건 이상(줄바꿈) | 입력한 Model 전부가 결과에 반영됩니다(구분 처리는 확인 필요) | `SSP.SSP0017_GET_INVENTORY_RAW` (REF `UF_FX_STRING_SPLIT`) |
| TC-SSP0017-013 | 조회 | TC-001 | 결과가 없는 조건으로 조회합니다 | 존재하지 않는 Model 값 | `spdMain`이 0행으로 표시되고 오류가 없습니다(안내 메시지는 확인 필요) | `SSP.SSP0017_GET_INVENTORY_RAW` (빈 결과) |
| TC-SSP0017-014 | 조회 | TC-001 | `cboPlanDate`를 비운 채 조회합니다 | Plan-date 미선택 | 필수값 안내가 나오거나 조회가 차단됩니다(메시지 문구는 확인 필요) | `FindData_Main`, `SSP.SSP0017_GET_INVENTORY_RAW` (`Plan-date*` 필수 표시) |
| TC-SSP0017-015 | 조회 | 서버/DB 오류 유발 환경(예: SP 실행 실패) | 조회를 누릅니다 | 정상 조건 | 오류 메시지가 표시되고 화면은 그대로 유지됩니다. 기존 Grid 처리 방식은 확인 필요입니다 | `SSP.SSP0017_GET_INVENTORY_RAW` (오류 응답) |
| TC-SSP0017-016 | 조회 | 공통코드 조회 오류 유발 환경 | 화면을 엽니다 | code=PlanDateShip | 오류 메시지가 표시되고 `cboPlanDate`가 빈 상태가 됩니다. 처리 방식은 확인 필요입니다 | `Form_Load`, `biz:CommonData.CommonDataList` [PlanDateShip] (오류 응답) |
| TC-SSP0017-017 | 그리드 | TC-010 | `spdMain` 시트명과 컬럼 헤더를 확인합니다 | — | 시트 `Inventory Raw(Mobility & IT)`, 컬럼헤더 1행, 표시 컬럼 27개(Available Qty … Valtage) | 시트 `Inventory Raw(Mobility & IT)`, `SetSheetHeaderColumn`(InitSpread:202) |
| TC-SSP0017-018 | 그리드 | TC-010 | 숨김 컬럼이 노출되는지 확인합니다 | — | `LONG_QTY`(Long-Term Qty), `OPERATION_NAME`(Operation Name), `ROUTE_NAME`(Route Name), `ROUTE_TYPE`(Route Type)이 표시되지 않습니다 | 시트 `Inventory Raw(Mobility & IT)` (grid_effective 숨김 4) |
| TC-SSP0017-019 | 그리드 | TC-010 | Grid 하단 푸터를 확인합니다 | — | 컬럼 푸터(합계 행)가 표시됩니다. 합계 대상 컬럼은 확인 필요입니다 | 시트 `Inventory Raw(Mobility & IT)` (`InitSpreadFooterSum`:217) |
| TC-SSP0017-020 | 그리드 | TC-001 | 화면에 생성된 시트 목록을 확인합니다 | — | 시트 `Inventory Raw(IT & Mobile)`은 생성되지 않습니다(메타 정의만 있고 코드에서 참조하지 않음). 메타 31개(표시 27·숨김 4)가 현행 시트와 같은지 DB에서 대조합니다 | 시트 `Inventory Raw(IT & Mobile)` |
| TC-SSP0017-021 | division | Division 40 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=40 | 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (Division 40 = 27/0) |
| TC-SSP0017-022 | division | Division 81 계열(81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC) 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=81 계열 | 각 Division 모두 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (81 계열 = 27/0) |
| TC-SSP0017-023 | division | Division 82 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=82 | 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (82 = 27/0) |
| TC-SSP0017-024 | division | Division EE 계열(EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 사용자 | TC-010을 수행하고 표시 컬럼 수를 셉니다 | Division=EE 계열 | 각 Division 모두 표시 27개 | 시트 `Inventory Raw(Mobility & IT)` (EE 계열 = 27/0) |
| TC-SSP0017-025 | division | 서로 다른 그룹(NowGroupID) 사용자 2명 | 각각 화면을 열어 `clbDivision`의 기본 선택값을 확인합니다 | 사용자 A / B | 사용자 그룹에 맞는 Division이 기본 선택됩니다(반영 방식은 확인 필요) | `Form_Load` (`dtMyDivision` ← `NowGroupID`) |
| TC-SSP0017-026 | 권한 | 조회 권한만 있는 그룹 사용자 | 화면을 열고 조회합니다 | — | 조회가 가능하고 저장·삭제 기능은 없습니다. 그룹별 C/R/U/D 플래그 값은 확인 필요입니다 | `SSP.SSP0017_GET_INVENTORY_RAW` (`TB_FX_GroupMenuAuth` 14행) |
| TC-SSP0017-027 | 초기화 | 소스 또는 실행 추적 환경 | 화면 진입부터 조회까지 수행하면서 Division 조회 호출이 일어나는지 추적합니다 | — | 진입점 미연결이므로 호출이 없어야 합니다. 호출이 확인되면 실사용으로 분류하고 Division 목록이 `SCM_MST_DIVISION` 기준과 일치하는지 검증합니다 | `GetDivision`, `SCM.SCM0001_GET_DIVISION`, SP `SCM0001_GET_DIVISION` |
| TC-SSP0017-028 | 초기화 | 소스 또는 실행 추적 환경 | 화면 진입부터 조회까지 수행하면서 기간 조회 호출이 일어나는지 추적합니다 | — | 진입점 미연결이므로 호출이 없어야 합니다. 호출이 확인되면 실사용으로 분류하고 `SCM_SYS_CALENDAR_M` 기준 기간이 반환되는지 검증합니다 | `GetDayRange`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0017-029 | 초기화 | 실행 추적 환경 | 화면 클래스 생성 시 재고상태 공통코드 호출이 일어나는지 추적합니다 | code=OWMS_STOCK_STATUS | 호출 여부를 기록합니다. 호출되는 경우 결과가 바인딩되는 대상을 확인합니다(확인 필요) | `<field:dtInventoryStatus>`, `biz:CommonData.CommonDataList` [OWMS_STOCK_STATUS] |

### 근거 커버리지

| 구분 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003, 004, 005, 016, 025 |
| | `SpdMain_TopChange` | 009 |
| | `btnItemId_Click` | 007 |
| | `btnMeasure_Click` | 008 |
| | `clbDivision_SelectedIndexChanged` | 006 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 002, 003, 006, 016, 029 |
| | `SSP.SSP0017_GET_INVENTORY_RAW` | 010~015, 026 |
| | `SCM.SCM0001_GET_DIVISION` | 027 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 028 |
| 시트 | `Inventory Raw(Mobility & IT)` | 017, 018, 019, 021~024 |
| | `Inventory Raw(IT & Mobile)` | 020 |
| division | 40 / 81 계열 / 82 / EE 계열 | 021 / 022 / 023 / 024 |
| 빈 결과·오류 | 빈 결과 013, 필수 미입력 014, 오류 응답 015·016 | |
