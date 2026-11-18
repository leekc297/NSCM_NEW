# SCP0111 Integration PSI — 단위테스트

> 근거 열에는 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출은 0건이라 그로부터 만든 테스트 케이스는 없습니다. 기대결과 중 AS-IS 동작이 확인되지 않은 부분은 "확인 필요"로 적었고, AS-IS와 대조해서 판정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0111-001 | 초기화 | 메뉴 권한이 있는 사용자 | 화면을 엽니다. | - | 오류 없이 진입합니다. Line 목록을 조회합니다. | `Form_Load` > GetEssPackLineAll:490, `SCP.SCP0111_GET_ESS_PACK_LINE`, SP `SCP0111_GET_ESS_PACK_LINE` |
| TC-SCP0111-002 | 초기화 | TC-001 | 진입 직후 Bucket Type 호출 여부를 확인합니다. | - | Bucket Type 코드를 조회합니다(사용처 확인 필요). | `Form_Load` > InitControls > GetBucketType:1095, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0111-003 | 초기화 | TC-001 | `cmbFromMonth`, `cmbToMonth` 목록을 엽니다. | - | CalendarMonth 결과(CODE/NAME)가 바인딩되어 있습니다. | `Form_Load` > InitControls > SetChangedPeriod:287/288, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-004 | 초기화 | TC-001 | 조회조건 영역을 확인합니다. | - | `cboPlanType`, `btnCellItem_Id`는 보이지 않습니다. `cboDivision`(`Division*`)과 `cboPlanDate`(`Plan-date*`)는 필수로 표시됩니다. | props.csv Visible=false(305, 450), `Form_Load` |
| TC-SCP0111-005 | 초기화 | TC-001 | 그리드 `spdMain`을 확인합니다. | - | 시트 `Integration PSI`가 생성되고, 메타 컬럼과 월 컬럼이 만들어져 있습니다. | `Form_Load` > CreateSpread > InitSpread > SetCalendar:345, 시트 `Integration PSI`, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-006 | 초기화 | ESS Pack Line 데이터가 0건인 환경 | 화면을 엽니다. | - | 빈 결과여도 예외 없이 진입합니다. 이후 `spdMain_CellClick`에서 dtLine을 참조할 때 오류가 없어야 합니다(AS-IS 동작 확인 필요). | `SCP.SCP0111_GET_ESS_PACK_LINE`, SP `SCP0111_GET_ESS_PACK_LINE`, `spdMain_CellClick` |
| TC-SCP0111-007 | 이벤트 | TC-001 | `cboDivision` 값을 바꿉니다. | Division 다른 값 | `cmbFromMonth`/`cmbToMonth`를 다시 바인딩합니다. | `CboDivision_SelectedIndexChanged` > SetChangedPeriod:287/288, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-008 | 이벤트 | TC-001 | `cboPlanDate` 값을 바꿉니다. | Plan-date 다른 값 | Period를 다시 바인딩하고, 그리드 월 컬럼을 CalendarMonth 결과대로 다시 만듭니다. | `CboPlanDate_SelectedIndexChanged` > SetChangedPeriod:287/288, InitSpread > SetCalendar:345, `biz:CommonData.CommonDataList` [code=CalendarMonth], 시트 `Integration PSI` |
| TC-SCP0111-009 | 이벤트 | `cboPlanType`이 노출되거나 값이 바뀌는 조건(확인 필요) | `cboPlanType` 값을 바꿉니다. | Plan-type 다른 값 | Period를 다시 바인딩합니다. | `CboPlanType_SelectedIndexChanged` > SetChangedPeriod:287/288, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-010 | 이벤트 | TC-001 | 기본 데이터 모델을 바꾸는 동작을 합니다(발생 조건 확인 필요). | - | CalendarMonth를 다시 조회합니다(반영 대상 확인 필요). | `_defaultDataModel_Changed`:1980, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-011 | 이벤트 | TC-001 | `btnNickName`을 누르고 값을 선택합니다. | Nick Name 1건 이상 | 선택한 값이 `txtNickName`에 들어갑니다. | `BtnNickName_Click`:1887 (`txtNickName.Text = sNickName`) |
| TC-SCP0111-012 | 이벤트 | TC-001 | `btnItemId`를 누르고 값을 선택합니다. | Model 1건 이상 | 선택한 값이 `txtItemId`에 들어갑니다. | `BtnItemId_Click`:1926 (`txtItemId.Text = sItemId`) |
| TC-SCP0111-013 | 그리드 | 조회 결과 1건 이상, 편집 모드 | `spdMain`의 셀(LINE_ID 등)을 클릭합니다. | - | dtLine의 CODE/NAME을 참조해 처리합니다(셀 반영 내용 확인 필요). 오류가 없어야 합니다. | `spdMain_CellClick`:1781~1786, 시트 `Integration PSI` |
| TC-SCP0111-014 | 그리드 | 조회 결과 1건 이상 | `spdMain` 셀을 더블클릭합니다. | - | AS-IS와 같은 동작을 합니다(내부 동작 확인 필요). 오류가 없어야 합니다. | `SpdMain_CellDoubleClick`, 시트 `Integration PSI` |
| TC-SCP0111-015 | 그리드 | 조회 결과가 화면보다 많음 | `spdMain`을 세로로 스크롤합니다. | - | AS-IS와 같은 동작을 합니다(내부 동작 확인 필요). 오류가 없어야 합니다. | `SpdMain_TopChange`, 시트 `Integration PSI` |
| TC-SCP0111-016 | 조회 | 필수 조건 입력 | `cboDivision`, `cboPlanDate`, `cmbFromMonth`~`cmbToMonth`를 고르고 Find를 누릅니다. | 유효 Division/Plan-date/Period | 결과가 시트 `Integration PSI`에 표시되고, 월 컬럼이 다시 만들어집니다. | FindButton > FindData_Main:874, `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI`, SetCalendar:345 `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-017 | 조회 | 데이터가 없는 조건 | Find를 누릅니다. | 결과 0건 조건 | 그리드 0행, 오류 없음. 0건 안내 메시지 여부는 확인 필요입니다. | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-018 | 조회 | SP 오류를 유도할 수 있는 환경 | Find를 누릅니다. | SP 오류 응답 | 오류 메시지를 표시하고, 그리드에 잘못된 결과를 남기지 않습니다(메시지 원문 확인 필요). | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-019 | 조회 | TC-001 | `cboDivision` 또는 `cboPlanDate`를 비우고 Find를 누릅니다. | 필수값 빈값 | 필수값 검증으로 조회를 막습니다(검증 코드·메시지 확인 필요). | `Division*`/`Plan-date*` 라벨(props.csv 602/632), `SCP.SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-020 | 조회 | TC-016 조건 | `txtItemId`, `txtNickName`, `txtCellItemId`에 여러 줄 값을 넣고 Find를 누릅니다. | 2건 이상 멀티라인 | 입력한 모든 값으로 필터링됩니다(파라미터 매핑·구분자 확인 필요). | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI`(REF:STRING_SPLIT) |
| TC-SCP0111-021 | 조회 | TC-016 조건 | `chkQty`(`Qty < 0`)를 체크하고 Find를 누릅니다. | 체크 ON/OFF | 체크 여부에 따라 결과가 AS-IS와 같습니다(반영 방식 확인 필요). | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-022 | 그리드 | 조회 완료(조회 모드) | 시트 `Integration PSI`의 컬럼 헤더를 확인합니다. | - | 메타 표시 22컬럼(BOH, Cell Coversion Factor, Cell Model, Cell Model Nick Name, Company, Division, Incoterms, Model, Line, MEASURE, Measure, Nick Name, Operation, Plan Type, Plant, Plant, SEQ_FLAG, To Product, To Site, To Site, UOM, Valuation Type)이 정의되어 있고, MEASURE_COLOR와 MEASURE_ORDER_NO는 숨겨져 있습니다. | 시트 `Integration PSI`, SCM_MST_SHEET_COLUMNS, InitSpread SetSheetHeaderColumn:333 |
| TC-SCP0111-023 | 그리드 | 조회 완료(조회 모드) | SEQ_FLAG, MEASURE, PLANT_ID, TO_SITE를 확인합니다. | - | SEQ_FLAG·MEASURE는 숨김(폭 0), PLANT_ID·TO_SITE는 폭 0입니다. | 시트 `Integration PSI`, SetVisibleSheetColumns:1078~1082 |
| TC-SCP0111-024 | 그리드 | 조회 완료 | 월 컬럼 수와 헤더를 확인합니다. | Period 범위 | CalendarMonth 결과 행 수만큼 숫자 컬럼(헤더 YYYYMM_NAME, 폭 75)이 있습니다. Tag가 `D_`/`W_`인 컬럼은 숨기고 `M_`인 컬럼만 표시합니다. | 시트 `Integration PSI`, SetCalendar:354, SetSpreadColumn:392/396, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-025 | 이벤트 | 조회 완료 | Edit를 누릅니다. | - | 편집 모드로 바뀌고, SEQ_FLAG(60), MEASURE(80), PLANT_ID(65), TO_SITE(75)가 보입니다. | EditButton:554/622, `biz:CommonData.CommonDataList` [code=CalendarMonth], `biz:CommonData.CommonDataList` [code=LookupCommon], SetVisibleSheetColumns:1069~1073, 시트 `Integration PSI` |
| TC-SCP0111-026 | 저장 | 편집 모드, ADMIN 분기 조건 충족(조건 확인 필요) | 값을 수정하고 Save를 누릅니다. | 수정 1행 이상 | ADMIN 저장 SP가 실행되어 SCP_ANL_PSI_INTEGRATION에 UPDATE/INSERT되고 SCM_SYS_LOG_BATCH에 기록됩니다. 이어서 다시 조회합니다. | SaveButton > SaveData:1379, `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, SP `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, FindData_Main:874 `SCP.SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-027 | 저장 | 편집 모드, 일반 분기 조건 충족(조건 확인 필요) | 값을 수정하고 Save를 누릅니다. | 수정 1행 이상 | 일반 저장 SP가 실행되어 SCP_ANL_PSI_INTEGRATION에 INSERT/UPDATE되고 SCM_SYS_LOG_BATCH에 기록됩니다. 이어서 다시 조회합니다. | SaveButton > SaveData:1637, `SCP.SCP0111_SAVE_INTEGRATION_PSI`, SP `SCP0111_SAVE_INTEGRATION_PSI`, FindData_Main:874 `SCP.SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-028 | 저장 | 편집 모드 | Save를 누릅니다. | - | 저장 전에 CalendarMonth(1154/1242/1511)와 LookupCommon(1205)을 조회하고, 그 결과(dtTemp/dtToMonth/dtMonth CODE)로 저장 범위를 구성합니다(사용 방식 확인 필요). | SaveData, `biz:CommonData.CommonDataList` [code=CalendarMonth], `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SCP0111-029 | 저장 | 편집 모드, 수정 없음 | Save를 누릅니다. | 변경 0건 | 저장 SP를 호출하지 않거나 안내합니다(AS-IS 동작 확인 필요). | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, `SCP.SCP0111_SAVE_INTEGRATION_PSI` |
| TC-SCP0111-030 | 저장 | SP 오류를 유도할 수 있는 환경 | Save를 누릅니다. | SP 오류 응답 | 오류 메시지를 표시하고 데이터가 부분 반영되지 않습니다(메시지 원문·롤백 동작 확인 필요). | SP `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, SP `SCP0111_SAVE_INTEGRATION_PSI` |
| TC-SCP0111-031 | 권한 | 그룹이 다른 사용자 2명(NowGroupID 상이) | 각각 Edit와 Save를 실행합니다. | - | 그룹에 따라 편집/저장 동작(저장 SP 분기 포함)이 AS-IS와 같습니다(조건 확인 필요). | EditButton:559, SaveData:1159 NowGroupID, TB_FX_GroupMenuAuth, `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, `SCP.SCP0111_SAVE_INTEGRATION_PSI` |
| TC-SCP0111-032 | division | 대표 division 사용자(40, 81, 82, EE 계열) | 각 division으로 Find를 실행하고 컬럼을 비교합니다. | Division 40 / 81 / 82 / EE | 14개 division 모두 메타 표시 컬럼 22개가 같습니다(division 변형 없음). | 시트 `Integration PSI`, grid_effective.csv, `SCP.SCP0111_GET_INTEGRATION_PSI` |

### 커버리지 점검
| 대상 | TC |
|---|---|
| `Form_Load` | 001~006 |
| `BtnNickName_Click` | 011 |
| `BtnItemId_Click` | 012 |
| `SpdMain_CellDoubleClick` | 014 |
| `SpdMain_TopChange` | 015 |
| `spdMain_CellClick` | 006, 013 |
| `CboDivision_SelectedIndexChanged` | 007 |
| `CboPlanDate_SelectedIndexChanged` | 008 |
| `CboPlanType_SelectedIndexChanged` | 009 |
| `_defaultDataModel_Changed` | 010 |
| `biz:CommonData.CommonDataList` | 003, 005, 007~010, 016, 024, 025, 028 |
| `SCP.SCP0111_GET_ESS_PACK_LINE` | 001, 006 |
| `SCP.SCP0111_GET_INTEGRATION_PSI` | 016~021, 026, 027, 032 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | 002 |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | 026, 029~031 |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI` | 027, 029~031 |
| 시트 `Integration PSI` | 005, 008, 013~015, 022~025, 032 |
| 빈 결과 / 오류 응답 | 006, 017 / 018, 030 |
