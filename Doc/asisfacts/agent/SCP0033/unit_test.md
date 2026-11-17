# SCP0033 Shipment Semi Dept Day — 단위테스트

> 근거 열에는 엔드포인트, SP, 핸들러, 시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 본문이 추출되지 않은 핸들러는 기대결과에 "오류 없이 처리됨 + 상세 동작 확인 필요"로 적었습니다. 주석 처리된 호출은 0건이라 테스트 대상에서 제외한 것이 없습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0033-001 | 초기화 | 권한 있는 사용자로 로그인 | 1. SCP0033 화면을 연다 | - | 화면 로드 시 오류가 없음. usrConditionPanel1(상단)·usrLayoutControl2 안에 txtItemId(Model)·cboValidYN(Valid)·clbDivision(Division)이 표시되고 하단에 spdMain이 표시됨. 핸들러 상세 동작은 확인 필요 | `Form_Load` (.ctor:83) |
| TC-SCP0033-002 | 초기화 | TC-001 | 1. spdMain 시트를 확인한다 | - | spdMain_Sheet1에 시트 `Shipment Semi Dept Day`가 생성되고 메타 기반 컬럼 헤더 1행이 구성됨 | 시트 `Shipment Semi Dept Day`, CreateSpread:147~149, SetSheetHeaderColumn@InitSpread:161 |
| TC-SCP0033-003 | 그리드 | TC-001, 조회 결과 1건 이상 | 1. 조회한다 2. spdMain 헤더를 확인한다 | - | 표시 컬럼 10개: Division*, Model*, Nick Name, Operation Group, Departure day, Valid, Created By, Creation Date, Last Updated By, Last Update Date. 컬럼 순서는 SCM_MST_SHEET_COLUMNS 원문과 대조 | 시트 `Shipment Semi Dept Day`, grid_effective.csv |
| TC-SCP0033-004 | 그리드 | TC-003 | 1. spdMain에서 S_VALID_YN 컬럼 표시 여부를 확인한다 | - | `S_VALID_YN` 컬럼이 숨김 상태임 | 시트 `Shipment Semi Dept Day`, grid_effective.csv S_VALID_YN=숨김 |
| TC-SCP0033-005 | 그리드 | TC-001 | 1. spdMain 컬럼 헤더 스타일을 확인한다 | - | 헤더 정렬 General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced와 동등함 | 시트 `Shipment Semi Dept Day`, InitializeComponent:270~273 |
| TC-SCP0033-006 | 조회 | TC-001, 데이터 존재 | 1. txtItemId에 Model 입력 2. cboValidYN 선택 3. clbDivision 체크 4. 조회(FindButton) | Model=조회 가능한 ITEM_ID, Valid=임의 값, Division=사용자 Division | 조건에 맞는 행이 spdMain에 표시됨 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, FindData_Main:258 |
| TC-SCP0033-007 | 조회 | TC-001 | 1. clbDivision에서 여러 Division을 체크 2. 조회 | Division 2개 이상 | 체크한 Division의 CODE 값이 전달되고 해당 Division 행만 조회됨 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, GetCheckedListValue@FindData_Main:241/242/244 |
| TC-SCP0033-008 | 조회 | TC-001 | 1. txtItemId에 없는 Model 입력 2. 조회 | Model=존재하지 않는 값 | 오류 없이 spdMain이 0건으로 표시됨(0건 안내 메시지는 확인 필요) | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-009 | 조회 | DB 연결 차단 또는 SP 오류를 유발할 수 있는 환경 | 1. 조회 | - | 오류 응답이 사용자에게 표시되고 화면이 멈추지 않음(메시지 문구는 확인 필요) | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-010 | 그리드 | 시트 잠금 아님, 활성 시트 `Shipment Semi Dept Day` | 1. 행 추가(InsertButton) 2. 새 행의 DIVISION_ID 셀을 확인한다 | - | DIVISION_ID 셀이 Combo이고 항목은 사용자 Division 목록(BLUtils.GetDivision(false,""))임 | 시트 `Shipment Semi Dept Day`, InsertButton:204 |
| TC-SCP0033-011 | 권한 | 시트가 잠금 상태(IsLock=true) | 1. 행 추가 시도 | - | DIVISION_ID Combo 설정이 적용되지 않음. 행 추가 자체가 가능한지는 확인 필요 | 시트 `Shipment Semi Dept Day`, InsertButton:204 조건 `IsLock == false` |
| TC-SCP0033-012 | 저장 | TC-010 | 1. 새 행에 Division*, Model* 및 나머지 값 입력 2. 저장(SaveButton) | Division=콤보 값, Model=유효 ITEM_ID, Departure day/Valid=유효 값 | SCP_MST_SHIPMENT_SEMI_DEPT_DAY에 INSERT되고 이력(_H)·로그가 기록됨. 이후 자동 재조회로 새 행이 표시됨 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, 재조회 `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-013 | 저장 | TC-006 조회 결과 있음 | 1. 기존 행의 편집 가능 셀 수정 2. 저장 | 수정 값 | SCP_MST_SHIPMENT_SEMI_DEPT_DAY가 UPDATE되고 PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST가 실행됨. 재조회 결과에 수정 값이 반영됨 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-014 | 저장 | TC-010 | 1. 새 행에서 Model*을 비운 채 저장 | Model=빈값 | 필수 오류로 저장이 거부되거나 SP 오류가 응답됨(검증 위치와 문구는 확인 필요). 데이터 미반영 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, 시트 `Shipment Semi Dept Day` 라벨 `Model*` |
| TC-SCP0033-015 | 저장 | 저장 SP 오류를 유발할 수 있는 환경 | 1. 변경 후 저장 | - | 오류 응답이 표시되고 테이블은 변경되지 않음 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-016 | 이벤트 | TC-006 | 1. spdMain 임의 셀을 클릭한다 | - | 오류 없이 처리됨. 상세 동작은 확인 필요 | `SpdMain_CellClick` (.ctor:84) |
| TC-SCP0033-017 | 이벤트 | TC-006 | 1. spdMain 셀에 포커스를 두고 키를 입력한다 | 영문·숫자 키 | 오류 없이 처리됨. 상세 동작은 확인 필요 | `SpdMain_KeyPress` (.ctor:85) |
| TC-SCP0033-018 | 이벤트 | 화면 높이를 넘는 행 수의 조회 결과 | 1. spdMain을 세로 스크롤한다 | - | 상단 행 변경 시 오류 없이 처리됨. 상세 동작은 확인 필요 | `SpdMain_TopChange` (InitEvent:107) |
| TC-SCP0033-019 | 초기화 | TC-001 | 1. 화면 초기화 시 공통 Lookup 데이터 호출을 확인한다 | code=LookupCommon | 호출이 성공함. 바인딩 대상(그리드 DEPARTURE_DAY 등)은 확인 필요 | `biz:CommonData.CommonDataList` [code=LookupCommon], `<field:dtDepartureDay>`:43 |
| TC-SCP0033-020 | 초기화 | TC-001 | 1. 화면 초기화 시 Y/N 공통 데이터 호출을 확인한다 | - | 호출이 성공함. 바인딩 대상(cboValidYN 또는 그리드 VALID_YN)은 확인 필요 | `biz:CommonData.YesOrNo`, `<field:dtYesOrNo>`:44 |
| TC-SCP0033-021 | division | Division 40 사용자 | 1. 조회 2. spdMain 컬럼 수 확인 | Division=40 | 표시 10컬럼, S_VALID_YN 숨김 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(40) |
| TC-SCP0033-022 | division | Division 81계열 사용자(81, 81_HD/HG/HM/ST/UC) | 1. 조회 2. spdMain 컬럼 수 확인 | Division=81계열 | 표시 10컬럼, 40과 같음 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(81계열) |
| TC-SCP0033-023 | division | Division 82 사용자 | 1. 조회 2. spdMain 컬럼 수 확인 | Division=82 | 표시 10컬럼, 40과 같음 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(82) |
| TC-SCP0033-024 | division | Division EE계열 사용자(EE, EE_HD/HG/HM/ST/UC) | 1. 조회 2. spdMain 컬럼 수 확인 | Division=EE계열 | 표시 10컬럼, 40과 같음 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(EE계열) |
| TC-SCP0033-025 | 권한 | 권한 그룹별 계정(TB_FX_GroupMenuAuth 11행 기준) | 1. 그룹별로 화면 열기, 조회, 저장 시도 | 그룹별 계정 | 그룹별 C/R/U/D 설정대로 동작함(기대값은 권한 행 확인 후 확정 — 확인 필요) | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |

## 커버리지 점검

| 대상 | TC |
|---|---|
| `Form_Load` | 001 |
| `SpdMain_CellClick` | 016 |
| `SpdMain_KeyPress` | 017 |
| `SpdMain_TopChange` | 018 |
| `biz:CommonData.CommonDataList` | 019 |
| `biz:CommonData.YesOrNo` | 020 |
| `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | 006, 007, 008, 009, 012, 025 |
| `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | 012, 013, 014, 015, 025 |
| 시트 `Shipment Semi Dept Day` | 002, 003, 004, 005, 010, 011, 021~024 |
| 빈 결과 / 오류 응답 | 008 / 009, 015 |
| division별 | 021(40), 022(81계열), 023(82), 024(EE계열). 변형은 없고 동일성만 확인 |
