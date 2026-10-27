# SCP0007 단위테스트 케이스

> 근거 열의 엔드포인트, SP, 핸들러, 시트 이름은 업무분석서 §5, 화면설계서 §5와 같은 표기다. 절차 열의 컨트롤명은 화면설계서 §3의 컨트롤명이다.
> 기대결과 중 AS-IS 원문으로 확정하지 못한 부분은 **(확인 필요)**로 적었다. 이런 케이스는 AS-IS 실행 화면과 대조해서 판정한다.
> 주석 처리된 호출은 0건이며 테스트 대상에 넣지 않았다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0007-001 | 초기화 | 메뉴 권한(R)이 있는 사용자 | SCP0007 화면을 연다 | – | usrConditionPanel1(상단, HidePanel)과 spdMain(하단 Fill)이 표시된다. spdMain에 시트 `BOD`가 2단 헤더로 생성된다. 데이터 0행 | `Form_Load`(메인), 시트 `BOD`, CreateSpread:262, InitSpread:275 |
| TC-SCP0007-002 | 초기화 | TC-001 | 조회조건 컨트롤의 라벨을 확인한다 | – | clbDivision="Div", clbFromSite="From Site", clbToSite="To Site", clbIncoterms="Incoterms", clbTransMode="Trans Mode", clbIncotermsSSP="SSP Incoterms", cboValidYN="Valid", cboInputStatus="Input Status" | props.csv layout*.Text, usrLayoutControl2 |
| TC-SCP0007-003 | 초기화 | TC-001 | Incoterms·Trans Mode 공통코드가 로드됐는지 확인한다 | – | LookupCommon 코드 목록이 로드된다. 바인딩 대상 컨트롤(clbIncoterms, clbTransMode 후보)은 (확인 필요) | `biz:CommonData.CommonDataList` [code=LookupCommon], dtIncoterms:65, dtTransMode:66 |
| TC-SCP0007-004 | 초기화 | TC-001 | cboValidYN 목록을 연다 | – | Yes/No 목록이 표시된다(원천 확인 필요) | `biz:CommonData.YesOrNo`, dtValidYN:68 |
| TC-SCP0007-005 | 초기화 | TC-001 | incotermsEdit 공통코드가 로드됐는지 확인한다 | – | incotermsEdit 목록이 dtIncotermsEdit에 로드된다 | `biz:CommonData.CommonDataList` [code=incotermsEdit], dtIncotermsEdit:69 |
| TC-SCP0007-006 | 조회 | 조회 대상 BOD 데이터가 있음 | clbDivision, clbFromSite, clbToSite, clbIncoterms, clbTransMode, clbIncotermsSSP, cboValidYN, cboInputStatus를 고른 뒤 조회(FindButton) | 각 조건 1개 이상 선택 | spdMain 시트 `BOD`에 결과가 표시된다. 행 수는 SP 직접 실행 결과와 같다 | FindButton → FindData_Main, `SCP.SCP0007_GET_BOD`, SP `SCP0007_GET_BOD` |
| TC-SCP0007-007 | 조회 | TC-006 | 조회 시 국가·도시 조회가 호출되는지 확인한다(네트워크/로그) | TC-006과 같음 | `SCP.SCP0007_GET_COUNTRY_CITY`가 1회 호출되고 오류가 없다. GET_BOD와의 호출 순서와 결과 용도는 (확인 필요) | FindButton → GetData_Country, `SCP.SCP0007_GET_COUNTRY_CITY`, SP `SCP0007_GET_COUNTRY_CITY` |
| TC-SCP0007-008 | 조회 | 조건에 맞는 데이터 없음 | 데이터가 없는 조건 조합으로 조회(FindButton) | 존재하지 않는 clbFromSite·clbToSite 조합 | 시트 `BOD`가 0행으로 표시되고 오류가 나지 않는다. 0건 안내 메시지는 (확인 필요) | `SCP.SCP0007_GET_BOD`, SP `SCP0007_GET_BOD`, 시트 `BOD` |
| TC-SCP0007-009 | 조회 | SP 오류를 유도할 수 있는 환경(예: SP 권한 회수) | 조회(FindButton) | – | 오류 메시지가 표시되고 그리드 기존 데이터가 깨지지 않는다. 메시지 문구는 (확인 필요) | `SCP.SCP0007_GET_BOD`, SP `SCP0007_GET_BOD` |
| TC-SCP0007-010 | 조회 | TC-001 | clbDivision, clbFromSite, clbToSite, clbIncoterms, clbTransMode, clbIncotermsSSP에서 다중 선택 후 조회 | 각 2개 이상 선택 | 선택한 CODE 값이 모두 SP 파라미터로 전달된다(GetCheckedListValue). 파라미터 매핑은 (확인 필요) | FindData_Main:517/518/530~534, `SCP.SCP0007_GET_BOD` |
| TC-SCP0007-011 | 그리드 | TC-006 | 시트 `BOD`의 표시 컬럼을 센다 | – | 표시 34개. BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY 5개는 보이지 않는다. 헤더 라벨이 메타 라벨(예: "Route Id*", "To Site VMI")과 같다 | 시트 `BOD`, grid_effective.csv, SCM_MST_SHEET_COLUMNS |
| TC-SCP0007-012 | 그리드 | TC-006 | SAFETY_STOCK 컬럼 표시 여부를 확인한다 | – | SAFETY_STOCK(Safety Stock)이 숨겨져 있다 | 시트 `BOD`, InitSpread:338 Visible=false |
| TC-SCP0007-013 | 그리드 | 팝업 열림(TC-040) | 시트 `Distribution Route`의 컬럼과 헤더를 확인한다 | – | 코드 정의 33컬럼이 정의돼 있고 헤더 문구가 원문(예: "Shipping Document Preparation Data", "Sea/Air Ferry")과 같다. DAYS_MON~DAYS_SUN 7개는 bVisible=false로 정의돼 있으며, 실제로 보이는지는 (확인 필요) | 시트 `Distribution Route`, InitSpread:264~297 |
| TC-SCP0007-014 | 그리드 | TC-013 | `Distribution Route` 2단 헤더 병합을 확인한다 | – | Route Id, L/T Type, Valid, Trans Mode, Priority, Departure Days, Shipping Company, Shipping Document Preparation Data, Sum이 0행부터 2행 병합. FROM/TO/D_/A_ 계열 Country·City·Port Code는 1행. 상단 그룹 헤더 문구는 (확인 필요) | 시트 `Distribution Route`, ColumnHeaderSpan:301~335 |
| TC-SCP0007-015 | division | division 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 각각의 사용자 | division별 사용자로 로그인해 조회(FindButton)하고 시트 `BOD`의 컬럼을 센다(파라미터화 14회) | division 14종 | 모든 division에서 표시 34 / 숨김 5로 같다 | 시트 `BOD`, grid_effective.csv division 열 |
| TC-SCP0007-016 | division | TC-015 사용자 | division별로 팝업을 열고 시트 `Distribution Route`의 컬럼을 센다 | division 14종 | 모든 division에서 같은 33컬럼 정의(코드추가) | 시트 `Distribution Route`, grid_effective.csv |
| TC-SCP0007-017 | division | cboInputStatus="C" | 행 추가 후 DIVISION_ID 콤보 후보를 확인한다 | – | 후보가 `BLUtils.GetDivisionWithoutEE(false,"")` 결과와 같다. EE 계열 제외 여부는 (확인 필요) | InsertButton:387, 시트 `BOD` |
| TC-SCP0007-018 | 이벤트 | TC-001 | clbDivision 선택을 바꾼다 | Div 값 변경 | `cboDivision_SelectedIndexChanged`가 실행된다. 연동 결과(예: Site 목록 갱신)는 AS-IS 실행 결과와 대조 (확인 필요) | `cboDivision_SelectedIndexChanged` (InitEvent:176) |
| TC-SCP0007-019 | 이벤트 | 시트 `BOD` 편집 가능(잠금 아님) | spdMain에서 FROM_SITE_CODE 콤보로 sFromSite가 "E"인 Site를 고른다 | FROM_SITE_CODE = (sFromSite="E" Site) | TO_SITE_CODE 셀 콤보가 필터된 To Site 목록으로 다시 바인딩된다 | `SpdMain_ComboSelChange`:1146 |
| TC-SCP0007-020 | 이벤트 | 시트 `BOD` 편집 가능 | spdMain에서 sFromSite가 "A"이고 OSP_YN="Y"인 Site를 FROM_SITE_CODE로 고른다 | FROM_SITE_CODE = (sFromSite="A", OSP_YN="Y") | TO_SITE_CODE 셀 콤보가 필터 목록으로 다시 바인딩된다. 위 두 조건 밖의 값일 때의 동작은 (확인 필요) | `SpdMain_ComboSelChange`:1154 |
| TC-SCP0007-021 | 이벤트 | 시트 `BOD` 잠금 상태 | spdMain에서 FROM_SITE_CODE 콤보를 고른다 | – | TO_SITE_CODE 콤보가 다시 바인딩되지 않는다 | `SpdMain_ComboSelChange` (`!siMain.IsLock` 조건) |
| TC-SCP0007-022 | 이벤트 | 조회된 BOD 행 | spdMain에서 FROM_SITE_CODE 또는 TO_SITE_CODE 값을 바꾼다 | 유효한 From/To Site | `SCP.SCP0007_GET_ROUTE_CNT`가 호출되고 결과 `route_cnt`가 행에 반영된다(대상 컬럼 ROUTE_CNT 후보, 확인 필요). From/To 국가·도시, To VMI_YN·SITE_TYPE 관련 값이 채워진다 | `SpdMain_Changed` → SetCityCode:1448, `SCP.SCP0007_GET_ROUTE_CNT`, SP `SCP0007_GET_ROUTE_CNT` |
| TC-SCP0007-023 | 이벤트 | 조회된 BOD 행 | Route가 없는 From/To 조합으로 바꾼다 | SCP_MST_DISTRIBUTION_ROUTE에 없는 조합 | Route 건수 0이 반영되고 오류가 없다. 후속 처리는 (확인 필요) | `SpdMain_Changed`, `SCP.SCP0007_GET_ROUTE_CNT`, SP `SCP0007_GET_ROUTE_CNT` |
| TC-SCP0007-024 | 이벤트 | TC-022 | `SpdMain_Changed` 실행 중 이벤트 재진입 여부를 확인한다(호출 로그) | Site 1회 변경 | 셀 1회 변경에 `SCP.SCP0007_GET_ROUTE_CNT` 연쇄 재호출이 생기지 않는다(1284 해제 / 1315 재등록) | `SpdMain_Changed`:1284/1315 |
| TC-SCP0007-025 | 이벤트 | 시트 `BOD` 편집 가능 | 외부 데이터(From/To Site 포함 여러 행)를 spdMain에 붙여넣는다 | 클립보드 2행 | `SpdMain_ClipboardPasted`가 실행되고 OSP_YN, CITY를 참조해 처리한다. 결과는 AS-IS와 대조 (확인 필요) | `SpdMain_ClipboardPasted`:1218~1255 |
| TC-SCP0007-026 | 이벤트 | 시트 `BOD` 편집 가능 | spdMain 셀을 편집 중 값을 입력한다 | To Site가 PLANT인 행 | `SpdMain_EditChange`가 실행되고 To SITE_TYPE을 참조한다. 결과는 (확인 필요) | `SpdMain_EditChange`:1344 |
| TC-SCP0007-027 | 이벤트 | 조회된 BOD 행 | spdMain 셀에서 키를 입력한다 | 임의 문자 | `SpdMain_KeyPress`가 실행된다. 동작은 AS-IS와 대조 (확인 필요) | `SpdMain_KeyPress` (InitEvent:182) |
| TC-SCP0007-028 | 이벤트 | 화면 높이를 넘는 BOD 행 | spdMain을 세로로 스크롤한다 | – | `SpdMain_TopChange`가 실행된다. 동작은 AS-IS와 대조 (확인 필요) | `SpdMain_TopChange` (InitEvent:179) |
| TC-SCP0007-029 | 이벤트 | 조회된 BOD 행 | spdMain의 Route 관련 셀을 더블클릭하고 팝업에서 경로를 고른다 | – | 선택한 경로의 ROUTE_ID, TRANSPORT_MODE_NAME, PRIORITY, DAYS_MON~DAYS_SUN, VALID_YN, LT_SUM, LT_TYPE 값이 BOD 행에 반영된다(대상 컬럼 매핑 확인 필요). 반영 중 `SCP.SCP0007_GET_ROUTE_CNT`는 호출되지 않는다(1073 해제 / 1104 재등록) | `spdMain_CellDoubleClick`(메인):1068~1104, 시트 `BOD`, 시트 `Distribution Route` |
| TC-SCP0007-030 | 그리드 | cboInputStatus="C", 시트 `BOD` 잠금 아님 | 행 추가(InsertButton) | – | 새 행의 DIVISION_ID(dtMyDivision), INCOTERMS, INCOTERMS_SSP(dtIncotermsEdit)에 셀 콤보가 설정된다 | InsertButton:387/424/425, `biz:CommonData.CommonDataList` [code=incotermsEdit], 시트 `BOD` |
| TC-SCP0007-031 | 그리드 | cboInputStatus="R" | 행 추가(InsertButton) | – | TC-030의 셀 콤보 설정 분기로 들어가지 않는다. "R" 분기의 동작은 (확인 필요) | InsertButton (`else!(strSel_InputStatus == "R")` 분기) |
| TC-SCP0007-032 | 권한 | cboInputStatus="C", 시트 `BOD` 잠금 상태 | 행 추가(InsertButton) | – | 셀 콤보가 설정되지 않는다 | InsertButton (`siMain.IsLock(...) == false` 조건) |
| TC-SCP0007-033 | 그리드 | To Site SITE_TYPE="PLANT" 행이 있는 조회 결과, boolEditChange=true 상태 | 수정(EditButton) | – | PLANT 행의 INCOTERMS_SSP 콤보가 incotermsEdit 목록이다 | EditButton:476/484, `biz:CommonData.CommonDataList` [code=incotermsEdit] |
| TC-SCP0007-034 | 그리드 | TC-033과 같고 boolEditChange=false | 수정(EditButton) | – | PLANT 행의 INCOTERMS_SSP 콤보가 LookupCommon "INCOTERMS" 목록이다. PLANT가 아닌 행은 바뀌지 않는다 | EditButton:490, `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SCP0007-035 | 저장 | 신규 행(TC-030) 입력 완료, 원장에 없는 키 | 저장(SaveButton) | Division, From Site, To Site, FROM/TO 일자, Incoterms, Incoterms SSP, Priority, Route Id 입력 | `SCP.SCP0007_SAVE_BOD` 호출이 성공한다. SCP_MST_BOD에 행이 생기고, SCP_MST_BOD_H와 SCM_SYS_LOG_BATCH에 기록된다. 이어서 `SCP.SCP0007_GET_BOD` 재조회로 시트 `BOD`에 반영된다 | SaveData_Main:794, `SCP.SCP0007_SAVE_BOD`, SP `SCP0007_SAVE_BOD`, `SCP.SCP0007_GET_BOD` |
| TC-SCP0007-036 | 저장 | 조회된 기존 행 수정 | 저장(SaveButton) | Remarks 등 수정 | SCP_MST_BOD가 MERGE로 갱신되고, SCP_MST_BOD_ITEM INSERT/UPDATE 전개 결과가 SP 기대와 같다(전개 규칙 확인 필요). 재조회 후 수정값이 표시된다 | `SCP.SCP0007_SAVE_BOD`, SP `SCP0007_SAVE_BOD` |
| TC-SCP0007-037 | 저장 | SP 검증에 걸리는 데이터(예: 필수값 누락) | 저장(SaveButton) | 라벨 `*` 컬럼 1개를 비움 | `ERR_MESSAGE`의 오류 문구가 표시되고 원장에 반영되지 않는다. 검증 위치(FE/SP)와 오류 시 재조회 여부는 (확인 필요) | SaveData_Main:930 `ERR_MESSAGE`, `SCP.SCP0007_SAVE_BOD` |
| TC-SCP0007-038 | 저장 | 변경 행 없음 | 저장(SaveButton) | – | 저장 SP 호출 여부와 안내 메시지는 (확인 필요). 데이터 변경은 없다 | SaveButton, `SCP.SCP0007_SAVE_BOD` |
| TC-SCP0007-039 | 저장 | 삭제 대상 행이 있는 상태(삭제 표시 방식 확인 필요) | 저장(SaveButton) | – | SCP_MST_BOD에서 해당 행이 DELETE된다(SP 참조 DELETE:SCP_MST_BOD). 이력 기록 여부는 (확인 필요) | `SCP.SCP0007_SAVE_BOD`, SP `SCP0007_SAVE_BOD` |
| TC-SCP0007-040 | 초기화 | 메인 BOD 행 더블클릭으로 팝업 호출 | Distribution Route Popup이 열리는 것을 확인한다 | From/To 국가·도시 값이 있는 행 | txtFromCountry, txtFromCity, txtToCountry, txtToCity에 생성자 값이 표시되고 Enabled=false다. btnFromSrch, btnToSrch, clbTransMode도 Enabled=false. `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` 결과가 시트 `Distribution Route`에 표시된다 | `Form_Load`(팝업 .ctor:149) → FindDataMain:436, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`, SP `SCP0005_GET_DISTRIBUTION_ROUTE`, InitControls:214~229 |
| TC-SCP0007-041 | 조회 | TC-040 | btnButtonList의 조회 버튼을 누른다 | – | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`가 다시 호출되고 시트 `Distribution Route`가 갱신된다 | `btnButtonList_UsrButtonList_Click_Detected` → FindDataMain, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-042 | 조회 | TC-040 | 팝업 조회(FindButton) | – | TC-041과 같다 | 팝업 FindButton → FindDataMain, `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-043 | 조회 | From/To 조합에 경로 없음 | 경로가 없는 행에서 팝업을 연다 | SCP_MST_DISTRIBUTION_ROUTE에 없는 From/To | 시트 `Distribution Route`가 0행이고 오류가 없다 | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE`, SP `SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-044 | 조회 | SP 오류 유도 환경 | 팝업을 연다 | – | 오류 메시지가 표시되고 팝업이 비정상 종료되지 않는다. 문구는 (확인 필요) | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` |
| TC-SCP0007-045 | 이벤트 | btnFromSrch가 활성화된 상태(활성 조건 확인 필요) | btnFromSrch를 눌러 도시를 고른다 | 임의 국가/도시 | txtFromCountry ← popCity.Country, txtFromCity ← popCity.City | `btnFromSrch_Click`:689~690 |
| TC-SCP0007-046 | 이벤트 | btnToSrch가 활성화된 상태 | btnToSrch를 눌러 도시를 고른다 | 임의 국가/도시 | txtToCountry ← popCity.Country, txtToCity ← popCity.City | `btnToSrch_Click`:707~708 |
| TC-SCP0007-047 | 이벤트 | 기본 상태(InitControls) | btnFromSrch, btnToSrch를 누른다 | – | 버튼이 Enabled=false라 반응하지 않는다 | `btnFromSrch_Click`, `btnToSrch_Click`, InitControls:216/220 |
| TC-SCP0007-048 | 이벤트 | TC-040 | 팝업 spdMain 행을 더블클릭한다 | 경로 1행 | 팝업 `spdMain_CellDoubleClick`가 실행된다. 선택 행 반환 후 팝업 닫힘 여부는 (확인 필요) | `spdMain_CellDoubleClick`(팝업 InitEvent:201), 시트 `Distribution Route` |
| TC-SCP0007-049 | 이벤트 | TC-040, 셀 편집 가능 여부 확인 필요 | 팝업 spdMain 셀 값을 바꾼다 | – | `spdMainDataModel_Changed`가 실행되고 실행 중 자기 이벤트 해제(489)/재등록(521)으로 재진입이 생기지 않는다 | `spdMainDataModel_Changed`:489/521 |
| TC-SCP0007-050 | 그리드 | TC-040 | 시트 `Distribution Route`의 Valid와 요일 콤보 후보를 확인한다 | – | VALID_YN(및 DAYS_* 정의)이 Yes/No 목록이다 | `biz:CommonData.YesOrNo`, dtYesOrNo:48, 시트 `Distribution Route` |
| TC-SCP0007-051 | 초기화 | TC-040 | 팝업 국가 공통코드가 로드됐는지 확인한다 | – | COUNTRY_MST 목록이 dtFromCountry/dtToCountry에 로드된다. 사용처는 (확인 필요) | `biz:CommonData.CommonDataList` [code=COUNTRY_MST], dtFromCountry:44, dtToCountry:46 |
| TC-SCP0007-052 | 초기화 | TC-040 | 팝업 clbTransMode 목록을 확인한다 | – | LookupCommon 기반 Trans Mode 목록(Enabled=false 상태로 표시) | `biz:CommonData.CommonDataList` [code=LookupCommon], 팝업 dtTransMode:49 |
| TC-SCP0007-053 | 권한 | 그룹이 다른 사용자 A, B(TB_FX_USERGROUPAUTHEXTENTION 범위가 다름) | 각 사용자로 화면과 팝업을 열어 Division·From Site·To Site 후보를 비교한다 | NowGroupID A/B | 그룹 권한 범위에 따라 후보가 다르다. 팝업 GetDivision/GetFromSitebyDivision/GetToSitebyDivision 실제 호출 여부는 (확인 필요) | `biz:CommonData.CommonDataList` [code=MyDivision / FromSiteByDivision / ToSiteByDivision], NowGroupID(메인 55/60/63/64, 팝업 58) |
| TC-SCP0007-054 | 초기화 | TC-040 | BOD Type·Transport Mode 공통코드 호출 여부를 확인한다 | – | 파서 분류는 '진입점 미연결'이다. 실제 호출과 사용처를 AS-IS 실행으로 확인한다 (확인 필요) | `biz:CommonData.CommonDataList` [code=BodType / TransportMode], GetBodType:569, GetTransMode:579 |
| TC-SCP0007-055 | 권한 | TB_FX_GroupMenuAuth에 SCP0007 조회 전용 그룹 사용자 | 화면을 열어 조회·행 추가·수정·저장 버튼 사용 가능 여부를 확인한다 | – | 그룹 C/R/U/D 설정대로 버튼이 활성/비활성된다. 권한 값은 (확인 필요) | TB_FX_GroupMenuAuth 13행, FindButton / InsertButton / EditButton / SaveButton |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001, 040 |
| | `cboDivision_SelectedIndexChanged` | 018 |
| | `SpdMain_ComboSelChange` | 019, 020, 021 |
| | `SpdMain_Changed` | 022, 023, 024 |
| | `SpdMain_ClipboardPasted` | 025 |
| | `SpdMain_EditChange` | 026 |
| | `SpdMain_KeyPress` | 027 |
| | `SpdMain_TopChange` | 028 |
| | `spdMain_CellDoubleClick` | 029(메인), 048(팝업) |
| | `btnButtonList_UsrButtonList_Click_Detected` | 041 |
| | `btnFromSrch_Click` | 045, 047 |
| | `btnToSrch_Click` | 046, 047 |
| | `spdMainDataModel_Changed` | 049 |
| 엔드포인트 | `SCP.SCP0007_GET_BOD` | 006, 008, 009, 010, 035 |
| | `SCP.SCP0007_GET_COUNTRY_CITY` | 007 |
| | `SCP.SCP0007_GET_ROUTE_CNT` | 022, 023, 024 |
| | `SCP.SCP0007_SAVE_BOD` | 035~039 |
| | `SCP.SCP0005_GET_DISTRIBUTION_ROUTE` | 040~044 |
| | `biz:CommonData.CommonDataList` | 003, 005, 030, 033, 034, 051~054 |
| | `biz:CommonData.YesOrNo` | 004, 050 |
| 시트 | `BOD` | 001, 008, 011, 012, 015, 017, 029, 030 |
| | `Distribution Route` | 013, 014, 016, 029, 048, 050 |
| division | 14종(division별 차이 없음 → 파라미터화) | 015, 016, 017 |
| 빈 결과 / 오류 | 조회·Route 건수·팝업·저장 | 008, 009, 023, 037, 043, 044 |

---

세 문서 모두 대화로 받은 Fact Pack과 1차 분석서만으로 작성했고, 저장소 파일이나 DB는 확인하지 않았습니다. 기계 검사 7개 조건의 이름(엔드포인트 7, SP 5, 컨트롤 20, 시트 2, 핸들러 13)은 해당 문서에 원문 그대로 넣었습니다. 다만 실제 검사기는 돌려 보지 않았습니다.

- **레이아웃은 추정입니다:** props.csv에 SplitContainer가 0건이라 Dock(Top/Fill)과 parent 체인으로 분할 트리를 그렸습니다. 조회조건 행 배치는 컨트롤 크기가 맞는 조합으로 추정했고, 문서에도 **확인 필요**로 표시했습니다.
- **확인 필요가 남은 곳:** AS-IS 원문(SP 내부, `FindButton`·`SaveData_Main`·더블클릭 팝업 호출, 메시지 ID, 권한 C/R/U/D 값)이 Fact Pack에 없어 그대로 **확인 필요**로 남겼습니다. 이와 연결된 테스트 케이스는 AS-IS 실행 결과와 대조해서 판정하도록 적었습니다.
