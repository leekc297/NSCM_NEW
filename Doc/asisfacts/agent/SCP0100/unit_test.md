# SCP0100 Global PSI Report — 단위테스트

> 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5, 화면설계서 §5와 같은 원문을 씁니다. 절차 열의 컨트롤명은 화면설계서 §3 컨트롤명 그대로입니다.
> 주석 처리된 호출(commented_calls)은 0건이라 대상이 아닙니다. 사실 묶음에서 동작을 확정할 수 없는 기대결과는 "확인 필요"로 적었습니다. AS-IS로 실측한 뒤 확정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0100-001 | 초기화 | 로그인, SCP0100 메뉴 권한 보유 | 화면을 엽니다 | - | `cboPlanDate`에 계획일자 목록이 채워집니다 | `Form_Load` > GetPlanDate, `SCP.SCP0100_GET_PLAN_DATE`, SP `SCP0100_GET_PLAN_DATE` |
| TC-SCP0100-002 | 초기화 | TC-001 | 화면을 연 뒤 `dCalendar` 범위를 확인합니다 | - | `dCalendar`에 PLAN_END_DATE 기준 기간이 설정됩니다 (계산식 확인 필요) | `Form_Load` > SetCalendar > GetDayRange > GetPlanEndDate, `biz:CommonData.CommonDataList_REPORT` |
| TC-SCP0100-003 | 초기화 | TC-001 | 화면을 연 뒤 그리드 헤더를 확인합니다 | - | 시트 3개가 생성되고, 헤더 3행(대분류 / 소분류 / "Qty") 기간 컬럼이 생성됩니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, SP `SCP0100_GET_SHEET_CALENDAR_3SPAN`, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-004 | 초기화 | 화면 표시 완료 | `clbToSite`를 펼칩니다 | - | To Site 목록이 채워집니다 | `SCP0100_Global_PSI_Report_Shown` > RefreshToSite > GetSiteList, `SCP.SCP0100_GET_SITE`, SP `SCP0100_GET_SITE` |
| TC-SCP0100-005 | 초기화 | 화면 열기 | `chkCellQty`, `chkAS`, `cboPlanType` 상태를 확인합니다 | - | `chkCellQty` Checked=true·숨김, `chkAS` 숨김, `cboPlanType`(Plan-type) 비활성 | props.csv designer 248/284/929/1159, `Form_Load` |
| TC-SCP0100-006 | 조회 | 계획 버전 데이터가 없는 환경 | 화면을 엽니다 | - | `cboPlanDate`가 빈 목록입니다. 이후 동작(오류 메시지 여부)은 확인 필요 | `SCP.SCP0100_GET_PLAN_DATE` (빈 결과) |
| TC-SCP0100-007 | 조회 | `SCP_RPT_GLOBAL_PSI_MD_MM` / `_WW`에 대상 데이터 없음 | 화면을 연 뒤 `clbToSite`를 확인합니다 | - | `clbToSite` 빈 목록, 오류 없음 (확인 필요) | `SCP.SCP0100_GET_SITE` (빈 결과), `SCP0100_Global_PSI_Report_Shown` |
| TC-SCP0100-008 | 조회 | 캘린더(`SCM_SYS_CALENDAR_M`)에 기간 데이터 없음 | `dCalendar`를 범위 밖 기간으로 바꿉니다 | 범위 밖 기간 | 기간 컬럼이 생성되지 않고 메타 고정 컬럼만 남습니다 (확인 필요) | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` (빈 결과), `DCalendar_ValueChanged` |
| TC-SCP0100-009 | 조회 | SP 오류를 유도 (권한 회수 등) | 화면을 엽니다 | - | 오류 응답을 처리하고 화면이 비정상 종료되지 않습니다. 메시지 문구는 확인 필요 | `SCP.SCP0100_GET_PLAN_DATE`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` (오류 응답) |
| TC-SCP0100-010 | 조회 | 공통 데이터 PLAN_END_DATE 미등록 | 화면을 엽니다 | - | `dCalendar` 기본 범위 처리 (확인 필요), 오류로 중단되지 않음 | `biz:CommonData.CommonDataList_REPORT` (빈 결과) |
| TC-SCP0100-011 | 이벤트 | 화면 표시 완료 | `clbDivision`에서 체크를 바꿉니다 | Division 1개 해제 | 핸들러가 실행됩니다. 후속 동작(연관 목록 갱신 등)은 확인 필요 | `ClbDivision_SelectedIndexChanged` |
| TC-SCP0100-012 | 이벤트 | 화면 표시 완료 | `cboGraphType` 값을 바꿉니다 | 다른 항목 | 핸들러가 실행됩니다. `chartMain` 반영은 확인 필요 | `CboGraphType_SelectedIndexChanged` |
| TC-SCP0100-013 | 이벤트 | 계획일자 2건 이상 | `cboPlanDate`를 다른 값으로 바꿉니다 | 두 번째 계획일자 | `dCalendar` 범위를 다시 계산하고 그리드 기간 헤더를 다시 만듭니다 | `CboPlanDate_SelectedIndexChanged`, `biz:CommonData.CommonDataList_REPORT`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-014 | 이벤트 | 그리드 생성 완료 | `cboBucketType`을 MONTHLY로 바꿉니다 | MONTHLY | `M_` 컬럼만 표시되고 `W_` 컬럼은 숨겨집니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn(1103/1107), 시트 REPORT |
| TC-SCP0100-015 | 이벤트 | 그리드 생성 완료 | `cboBucketType`을 WEEKLY로 바꿉니다 | WEEKLY | `W_` 컬럼만 표시되고 `M_` 컬럼은 숨겨집니다. 메타 고정 컬럼 유지 여부도 확인합니다 (시작 인덱스 확인 필요) | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn(1114/1118) |
| TC-SCP0100-016 | 이벤트 | 화면 표시 완료 | `cboDisplay`를 각 항목으로 차례로 바꿉니다 | 항목 3개 | `splitContainer1.SplitterDistance`가 0 / 750 / 270으로 바뀝니다. 0이면 `chartMain` 영역이 0이 됩니다 (항목↔값 대응 확인 필요) | `CboDisplay_SelectedIndexChanged` (1833/1841/1849) |
| TC-SCP0100-017 | 이벤트 | 화면 표시 완료 | `cboSearchLevel` 값을 바꿉니다 | Index 1~4 | 핸들러가 실행됩니다. PRODUCT_LEVEL 표시(SetLayout)를 이 핸들러가 호출하는지는 확인 필요 | `CboSearchLevel_SelectedIndexChanged` |
| TC-SCP0100-018 | 이벤트 | 화면 표시 완료 | `cboUnitQty` 값을 바꿉니다 | 다른 단위 | 핸들러가 실행됩니다. 수량 단위 반영은 확인 필요 | `CboUnitQty_SelectedIndexChanged` |
| TC-SCP0100-019 | 이벤트 | 화면 표시 완료 | `rgrpSearchLevel` 선택을 바꿉니다 | 다른 라디오 | 그리드 헤더를 다시 만듭니다 | `rgrpSearchLevel_SelectedIndexChanged`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-020 | 이벤트 | 화면 표시 완료 | `btnItemId`를 클릭하고 팝업에서 Model을 선택합니다 | 임의 Model | `txtItemId`에 선택값(`sItemId`)이 들어갑니다 | `BtnItemId_Click` (1947) |
| TC-SCP0100-021 | 이벤트 | TC-020 | 팝업에서 선택 없이 닫습니다 | 취소 | `txtItemId`가 바뀌지 않습니다 (확인 필요) | `BtnItemId_Click` |
| TC-SCP0100-022 | 이벤트 | 화면 표시 완료 | `btnMeasure`를 클릭합니다 | - | 그리드 헤더를 다시 만듭니다 (Measure 선택 UI는 확인 필요) | `btnMeasure_Click`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-023 | 이벤트 | 화면 표시 완료 | `btnProject`를 클릭하고 팝업에서 Project를 선택합니다 | 임의 Project | `txtProject`에 선택값(`sProjectCode`)이 들어갑니다 | `BtnProject_Click` (1981) |
| TC-SCP0100-024 | 이벤트 | 화면 표시 완료 | `cboPlanType` 조작을 시도합니다 | - | LayoutItem Enabled=false 상태라 사용자가 바꿀 수 없습니다. 코드로 값이 바뀔 때의 핸들러 동작은 확인 필요 | `CboPlanType_SelectedIndexChanged` |
| TC-SCP0100-025 | 이벤트 | 화면 표시 완료 | `btnColumn`을 클릭합니다 | - | 그리드 헤더를 다시 만듭니다 | `BtnColumn_Click`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-026 | 이벤트 | 화면 표시 완료 | `dCalendar` 기간을 바꿉니다 | 시작/종료일 변경 | 바뀐 기간으로 기간 컬럼을 다시 만듭니다 | `DCalendar_ValueChanged`, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-027 | 이벤트 | `chkCellQty` 숨김 상태 | 코드·테스트 하네스로 `chkCellQty` 체크를 바꿉니다 | Checked=false | 핸들러가 실행됩니다. 동작은 확인 필요 (사용자 화면에는 노출되지 않음) | `ChkCellQty_CheckedChanged` |
| TC-SCP0100-028 | 이벤트 | `chkAS` 숨김 상태 | 코드·테스트 하네스로 `chkAS` 체크를 바꿉니다 | Checked=true | 핸들러가 실행됩니다. 동작은 확인 필요 | `ChkAS_CheckedChanged` |
| TC-SCP0100-029 | 그리드 | `spdDetail` 표시 상태 | REPORT 시트 컬럼을 확인합니다 | Division 40 | 표시: CELL_CF, CELL_GROUP, DIVISION_ID, FROM_SITE, TO_SITE, INCOTERMS, ITEM_ID, MEASURE_GROUP, MEASURE_NAME, OPERATION_ID, VARIOUS_KEY (11) + PRODUCT_LEVEL1~3 (런타임). 숨김: MEASURE_UI, D0, D1 | 시트 REPORT, `SetSheetHeaderColumn`, grid_effective.csv |
| TC-SCP0100-030 | 그리드 | `spdSearchLevel` 표시 상태 | SEARCH_LEVEL 시트 컬럼을 확인합니다 | Division 40 | 표시: CELL_GROUP, DIVISION_ID, MEASURE_GROUP, MEASURE_NAME, OPERATION_GROUP (5) + PRODUCT_LEVEL1~3. 숨김: MEASURE_UI, D0, D1 | 시트 SEARCH_LEVEL |
| TC-SCP0100-031 | 그리드 | `spdSearchLevelDetail` 표시 상태 | SEARCH_LEVEL_DETAIL 시트 컬럼을 확인합니다 | Division 40 | SEARCH_LEVEL과 같은 5개 + PRODUCT_LEVEL1~3. 숨김: MEASURE_UI, D0, D1 | 시트 SEARCH_LEVEL_DETAIL |
| TC-SCP0100-032 | 그리드 | 기간 컬럼 생성 완료 | 기간 컬럼 속성을 확인합니다 | - | `B_`를 포함(0번째 위치 아님)한 컬럼은 Text·폭 0·숨김, 나머지는 Num·폭 70·표시. 헤더 2행은 "Qty" | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, InitSpreadDateColumn 755/760/787~816, 시트 REPORT |
| TC-SCP0100-033 | 그리드 | MONTHLY / WEEKLY 각각 헤더 생성 | 글자색을 확인합니다 | 계획 시작월 포함 | `M_` + `_plan_start_yyyymm` 포함 컬럼 = Red, `W_` + 라벨 "A" 또는 "B" 포함 컬럼 = Blue | InitSpreadDateColumn 767/774/778, `CboBucketType_SelectedIndexChanged` |
| TC-SCP0100-034 | 그리드 | `_is_detail`=false | `cboSearchLevel` Index를 1, 2, 3, 4로 바꿔 가며 PRODUCT_LEVEL 표시를 확인합니다 | 1 / 2 / 3 / 4 | 1: L1·L2 표시, L3 숨김 / 2: L1만 표시 / 3: L2만 표시 / 4: 모두 표시 | SetLayout 1498~1529, `CboSearchLevel_SelectedIndexChanged`(호출 연결은 확인 필요), 시트 SEARCH_LEVEL |
| TC-SCP0100-035 | 그리드 | `_is_detail`=false | `cboSearchLevel`을 Index 1~4 외의 값으로 둡니다 | 0 등 | PRODUCT_LEVEL1~3 모두 숨김 (case 라벨 확인 필요) | SetLayout 1536~1538 |
| TC-SCP0100-036 | 그리드 | 상세 모드 (`_is_detail`=true) | Search Level 영역과 시트 전환을 확인합니다 | - | `lciSearchLevel` 비활성. VisibleSheet로 `spdDetail` / `spdSearchLevel` / `spdSearchLevelDetail` 중 1개만 표시 (전환 조건은 확인 필요) | EnableSearchLevel 1874, VisibleSheet 1880~1896, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-037 | division | Division 40 사용자 | 화면을 열고 세 시트 컬럼 수를 확인합니다 | Division 40 | REPORT 11(+3), SEARCH_LEVEL 5(+3), SEARCH_LEVEL_DETAIL 5(+3) | grid_effective.csv, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-038 | division | Division 81 사용자 | TC-037과 같은 절차 | Division 81 | TC-037과 같음 (Division별 변형 없음) | grid_effective.csv, `ClbDivision_SelectedIndexChanged` |
| TC-SCP0100-039 | division | Division EE 사용자 | TC-037과 같은 절차 | Division EE | TC-037과 같음 | grid_effective.csv |
| TC-SCP0100-040 | 권한 | `TB_FX_GroupMenuAuth` 4행 기준 그룹 사용자 | 화면을 열고 공통 버튼 노출을 확인합니다 | 권한 그룹별 | 권한 값에 맞게 버튼이 노출됩니다 (C/R/U/D 값 확인 필요) | `SCP0100_Global_PSI_Report_Shown` (BaseForm.OnShown NowGroupID, USER_ID) |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 18 | `Form_Load` | 001~003, 005 |
| | `SCP0100_Global_PSI_Report_Shown` | 004, 007, 040 |
| | `ClbDivision_SelectedIndexChanged` | 011, 038 |
| | `CboGraphType_SelectedIndexChanged` | 012 |
| | `CboPlanDate_SelectedIndexChanged` | 013 |
| | `CboBucketType_SelectedIndexChanged` | 014, 015, 033 |
| | `CboDisplay_SelectedIndexChanged` | 016 |
| | `CboSearchLevel_SelectedIndexChanged` | 017, 034 |
| | `CboUnitQty_SelectedIndexChanged` | 018 |
| | `rgrpSearchLevel_SelectedIndexChanged` | 019 |
| | `BtnItemId_Click` | 020, 021 |
| | `btnMeasure_Click` | 022 |
| | `BtnProject_Click` | 023 |
| | `CboPlanType_SelectedIndexChanged` | 024 |
| | `BtnColumn_Click` | 025 |
| | `DCalendar_ValueChanged` | 008, 026 |
| | `ChkCellQty_CheckedChanged` | 027 |
| | `ChkAS_CheckedChanged` | 028 |
| 엔드포인트 4 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 003, 008, 009, 013, 019, 022, 025, 026, 032 |
| | `SCP.SCP0100_GET_SITE` | 004, 007 |
| | `SCP.SCP0100_GET_PLAN_DATE` | 001, 006, 009 |
| | `biz:CommonData.CommonDataList_REPORT` | 002, 010, 013 |
| 시트 3 | REPORT | 029, 032, 036, 037 |
| | SEARCH_LEVEL | 030, 034, 036, 037 |
| | SEARCH_LEVEL_DETAIL | 031, 036, 037 |
| 빈 결과 / 오류 | | 006, 007, 008, 010 / 009 |
| 미포함 | 메인 조회(Search) | 엔드포인트가 추출되지 않아 TC를 만들지 않았습니다 (확인 필요) |
