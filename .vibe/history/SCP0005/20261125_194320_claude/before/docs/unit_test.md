# SCP0005 Distribution Route — 단위테스트

> 근거 열에는 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출은 0건이라 테스트 대상이 없습니다. 기대결과 가운데 Fact Pack으로 확정하지 못한 부분은 '확인 필요'로 적었습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0005-001 | 초기화 | 메뉴 권한이 있는 사용자로 로그인 | SCP0005 화면을 엽니다 | — | 화면 Text "Distribution Route"가 보이고, usrConditionPanel1(HidePanel)과 spdMain이 표시됩니다 | `Form_Load`(.ctor:144), 시트 `Distribution Route` |
| TC-SCP0005-002 | 초기화 | 이전에 저장한 조회조건이 있음(TB_FX_SearchCondition) | 화면을 엽니다 | — | 조회조건 컨트롤(cboValidYN, clbTransMode, txtFromCountry 등)에 저장값이 복원됩니다(ControlName/ControlValue) | `Form_Load` → InitControls:208/210 |
| TC-SCP0005-003 | 초기화 | 화면 열림 | cboValidYN 목록을 펼칩니다 | — | YesOrNo 목록이 표시됩니다(바인딩·호출 시점 확인 필요) | `biz:CommonData.YesOrNo` (dtValidYN:51, dtYesOrNo:48) |
| TC-SCP0005-004 | 초기화 | 화면 열림 | clbTransMode 목록을 펼칩니다 | — | LookupCommon 코드 목록이 표시됩니다(바인딩 확인 필요) | `biz:CommonData.CommonDataList` [code=LookupCommon] (dtTransMode:49) |
| TC-SCP0005-005 | 초기화 | 화면 열림 | 국가 공통코드 로딩을 확인합니다(필드 dtFromCountry/dtToCountry) | — | SCM_MST_COUNTRY 기준 국가 목록이 로딩됩니다(사용 위치 확인 필요) | `biz:CommonData.CommonDataList` [code=COUNTRY_MST] (44/46) |
| TC-SCP0005-006 | 조회 | 화면 열림, SCP_MST_DISTRIBUTION_ROUTE에 데이터 있음 | 조회조건(cboValidYN, clbTransMode)을 입력하고 툴바 조회(FindButton)를 누릅니다 | Valid=Y, Trans Mode=1개 이상 체크 | spdMain 시트 `Distribution Route` 에 결과가 바인딩되고 SetSpreadColumn(siMain)이 실행됩니다 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / SP `SCP0005_GET_DISTRIBUTION_ROUTE` (FindDataMain:424, 452) |
| TC-SCP0005-007 | 조회 | 화면 열림 | 결과가 없는 조건으로 FindButton을 누릅니다 | 존재하지 않는 txtFromCity 값 | 그리드가 0행이고 SetSpreadColumn은 호출되지 않습니다(Rows.Count>0 조건). 안내 메시지 여부는 확인 필요 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / SP `SCP0005_GET_DISTRIBUTION_ROUTE` (452 조건) |
| TC-SCP0005-008 | 조회 | FindDataReceive 분기 조건 충족(조건 확인 필요) | FindButton을 누릅니다 | ROUTE_ID 관련 조건(확인 필요) | 시트 `Distribution Route` 에 ROUTE_ID 기준 결과가 표시되고, Rows>0이면 SetSpreadColumn이 실행됩니다 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` / SP `SCP0005_GET_DISTRIBUTION_ROUTEID` (FindDataReceive:499, 521) |
| TC-SCP0005-009 | 조회 | GetData_Country 분기 조건 충족(확인 필요) | FindButton을 누릅니다 | txtFromCountry/txtToCountry 값 | SCM_MST_CITY 기준 국가·도시 데이터가 조회됩니다. SetCityCode(COUNTRY, CITY, CITY_NAME) 반영 여부는 확인 필요 | `SCP.SCP0005_GET_COUNTRY_CITY` / SP `SCP0005_GET_COUNTRY_CITY` (GetData_Country:916) |
| TC-SCP0005-010 | 조회 | 조회 SP 오류 상황(DB 연결 실패 등) | FindButton을 누릅니다 | — | 오류를 처리하고 그리드는 갱신되지 않습니다(오류 표시 방식 확인 필요) | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0005-011 | 이벤트 | 화면 열림 | btnFromSrch를 누르고 City 팝업(popCity)에서 한 행을 선택합니다 | Country/City 선택 | txtFromCountry = popCity.Country, txtFromCity = popCity.City | `btnFromSrch_Click` (350/351) |
| TC-SCP0005-012 | 이벤트 | 화면 열림 | btnToSrch를 누르고 City 팝업(popCity)에서 한 행을 선택합니다 | Country/City 선택 | txtToCountry = popCity.Country, txtToCity = popCity.City | `btnToSrch_Click` (368/369) |
| TC-SCP0005-013 | 이벤트 | 조회 결과 있음 | spdMain 셀 하나를 편집합니다 | 임의 셀 값 변경 | 핸들러가 해제(970)·재등록(1082)되어 재귀 실행이 일어나지 않습니다. 연쇄 셀 변경 내용은 확인 필요 | `spdMainDataModel_Changed` |
| TC-SCP0005-014 | 이벤트 | 조회 결과 있음 | spdMain 셀을 더블클릭합니다 | 데이터 행 셀 | Changed 핸들러가 해제(1135)·재등록(1164)됩니다. 팝업 호출과 값 설정 여부는 확인 필요 | `spdMain_CellDoubleClick` |
| TC-SCP0005-015 | 이벤트 | 화면 열림 | btnExcel_Form을 누릅니다 | — | Excel 양식이 제공됩니다(생성 방식·컬럼은 확인 필요. 메타 SCM_ADM_EXCEL_COLUMNS 1행) | `btnExcel_Form_Click` (Designer:327) |
| TC-SCP0005-016 | 이벤트 | 업로드할 Excel 파일 준비 | btnEaxel_Upload를 누르고 파일을 선택합니다 | 양식에 맞는 Excel | 업로드 처리 후 FindDataMain으로 재조회되어 시트 `Distribution Route` 가 갱신됩니다(업로드 저장 경로 확인 필요) | `btnEaxel_Upload_Click` → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` / SP `SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0005-017 | 저장 | 조회 결과 있음 | 행을 추가하고 값을 입력한 뒤 툴바 저장(SaveButton)을 누릅니다 | 신규 경로 1행 | SCP_MST_DISTRIBUTION_ROUTE에 INSERT되고 이력(SCP_MST_DISTRIBUTION_ROUTE_H)과 배치 로그(SCM_SYS_LOG_BATCH)가 기록된 뒤 목록이 재조회됩니다 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` (SaveData:752) → `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0005-018 | 저장 | 조회 결과 있음 | 기존 행 값을 바꾸고 SaveButton을 누릅니다 | 리드타임 값 변경 | UPDATE와 이력 기록 후 재조회 결과에 변경값이 반영됩니다 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` |
| TC-SCP0005-019 | 저장 | 조회 결과 있음 | 행을 삭제 표시하고 SaveButton을 누릅니다 | 삭제 대상 1행 | DELETE 후 재조회 결과에서 해당 행이 사라집니다(삭제 UI 방식 확인 필요) | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SP `SCP0005_SAVE_DISTRIBUTION_ROUTE` |
| TC-SCP0005-020 | 저장 | SP가 오류를 반환하는 데이터 | SaveButton을 누릅니다 | SP 오류 유발 값(조건 확인 필요) | `dtErr.Rows[0]["ERR_MESSAGE"]` 값을 사용자에게 알립니다(표시 방식 확인 필요). 재조회 여부는 확인 필요 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` / SaveData:871 |
| TC-SCP0005-021 | 그리드 | 조회 완료 | 시트 `Distribution Route` 컬럼을 확인합니다 | — | 메타 39컬럼(ROUTE_ID ~ LAST_UPDATE_DATE)이 헤더 2행으로 표시되고, 헤더 라벨이 메타 원문(Route Id, Country*, …)과 같습니다 | 시트 `Distribution Route`, SetSheetHeaderColumn@InitSpread:246 |
| TC-SCP0005-022 | 그리드 | 조회 완료 | 사용자 컬럼 표시 설정에서 ROUTE_ID를 숨겨 봅니다 | — | ROUTE_ID는 필수(USER_SELECTABLE_FLAG='N')라 숨길 수 없습니다 | 시트 `Distribution Route` (grid_effective ROUTE_ID=필수) |
| TC-SCP0005-023 | 그리드 | 이력 팝업 열림 | 시트 `POPUP` 컬럼을 확인합니다 | — | 메타 16컬럼(ROUTE_ID, LT_*, DAYS_*, LAST_UPDATED_BY, LAST_UPDATE_DATE)이 헤더 2행으로 표시됩니다 | 시트 `POPUP`, SetSheetHeaderColumn@InitSpread:136 |
| TC-SCP0005-024 | 조회 | 이력 데이터가 있는 ROUTE_ID | 이력 팝업(SCP0005_DistributionRoutePopup)을 엽니다 | ROUTE_ID(전달 방식 확인 필요) | 팝업 `Form_Load` 에서 FindData가 실행되어 시트 `POPUP` 에 이력 행이 표시됩니다 | `Form_Load`(팝업 .ctor:98) → `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` / SP `SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` |
| TC-SCP0005-025 | 조회 | 이력 팝업 열림 | 팝업 툴바 FindButton을 누릅니다 | — | 이력을 다시 조회합니다 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` (FindData:171) |
| TC-SCP0005-026 | 조회 | 이력이 없는 ROUTE_ID | 이력 팝업을 엽니다 | 이력 없는 ROUTE_ID | 시트 `POPUP` 이 0행입니다(안내 메시지 여부 확인 필요) | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` |
| TC-SCP0005-027 | division | division 40, 81, 82, EE(및 하위 HD/HG/HM/ST/UC) 사용자 각각 | 화면을 열고 조회합니다 | — | 모든 division에서 `Distribution Route` 39컬럼, `POPUP` 16컬럼이 똑같이 표시됩니다(division 변형 없음) | 시트 `Distribution Route`, 시트 `POPUP` (grid_rule 14 division 동일) |
| TC-SCP0005-028 | 권한 | 조회 권한만 있는 그룹(TB_FX_GroupMenuAuth 값 확인 필요) | 화면을 열고 SaveButton 상태를 확인합니다 | — | 권한 값에 따라 저장이 제한됩니다(구체 동작 확인 필요) | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` |
| TC-SCP0005-029 | 초기화 | 화면 열림 | 사이트·BOD·운송모드 공통코드 사용처를 확인합니다 | — | GetFromSitebyDivision/GetToSitebyDivision/GetBodType/GetTransMode는 호출자가 없습니다. 실사용 여부를 확인하고, 미사용이면 NA로 판정합니다 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision/ToSiteByDivision/BodType/TransportMode] |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001, 002, 024 |
| 핸들러 | `btnToSrch_Click` | 012 |
| 핸들러 | `btnFromSrch_Click` | 011 |
| 핸들러 | `btnExcel_Form_Click` | 015 |
| 핸들러 | `spdMain_CellDoubleClick` | 014 |
| 핸들러 | `btnEaxel_Upload_Click` | 016 |
| 핸들러 | `spdMainDataModel_Changed` | 013 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 004, 005, 029 |
| 엔드포인트 | `biz:CommonData.YesOrNo` | 003 |
| 엔드포인트 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 006, 007, 010, 016, 017 |
| 엔드포인트 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTEID` | 008 |
| 엔드포인트 | `SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE` | 017~020, 028 |
| 엔드포인트 | `SCP.SCP0005_GET_COUNTRY_CITY` | 009 |
| 엔드포인트 | `SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID` | 024~026 |
| 시트 | `Distribution Route` | 001, 021, 022, 027 |
| 시트 | `POPUP` | 023, 024, 027 |
| 빈 결과 | — | 007, 026 |
| 오류 응답 | — | 010, 020 |
