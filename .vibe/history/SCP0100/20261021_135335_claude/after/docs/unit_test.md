# SCP0100 Global PSI Report — 단위테스트

> 근거 열에는 엔드포인트, SP, 핸들러, 시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출(commented_calls)은 0건이므로 테스트 대상이 없습니다.
> Fact Pack에서 동작을 확인할 수 없는 항목은 기대결과에 **확인 필요**로 적었습니다. 실행 전에 기대값을 확정해야 합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0100-001 | 초기화 | 로그인(세션 NowGroupID, USER_ID 있음) | SCP0100 화면을 엽니다 | — | 시트 SEARCH_LEVEL / REPORT / SEARCH_LEVEL_DETAIL이 생성되고, 메타 컬럼과 기간 컬럼이 3행 헤더로 구성됩니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` / SP SCP0100_GET_SHEET_CALENDAR_3SPAN |
| TC-SCP0100-002 | 초기화 | 위와 같음 | 화면을 연 뒤 cboPlanDate 목록을 확인합니다 | — | SP 결과 행이 cboPlanDate 항목으로 채워집니다(표시 형식은 확인 필요) | `Form_Load` > InitControls > GetPlanDate → `SCP.SCP0100_GET_PLAN_DATE` / SP SCP0100_GET_PLAN_DATE |
| TC-SCP0100-003 | 초기화 | 위와 같음 | 화면을 연 뒤 dCalendar 기간을 확인합니다 | — | PLAN_END_DATE 공통 데이터로 기간 범위가 설정됩니다(계산식은 확인 필요) | `Form_Load` > SetCalendar > GetDayRange > GetPlanEndDate → `biz:CommonData.CommonDataList_REPORT` |
| TC-SCP0100-004 | 초기화 | 화면 Load 완료 | 화면이 표시된 직후 clbToSite 목록을 확인합니다 | — | SP 결과가 clbToSite 항목으로 채워집니다 | `SCP0100_Global_PSI_Report_Shown` > InitControlsAfter > RefreshToSite > GetSiteList → `SCP.SCP0100_GET_SITE` / SP SCP0100_GET_SITE |
| TC-SCP0100-005 | 초기화 | 화면 Load 완료 | chkCellQty, chkAS, cboPlanType 상태를 확인합니다 | — | chkCellQty: Checked=true, Visible=false / chkAS: Visible=false / cboPlanType의 LayoutItem(PlanType): Enabled=false | designer:248/284/929/1159, `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged`, `CboPlanType_SelectedIndexChanged` |
| TC-SCP0100-006 | 이벤트 | cboPlanDate 항목 2개 이상 | cboPlanDate에서 다른 항목을 고릅니다 | 다른 Plan Date | 기간 헤더가 다시 구성되고, dCalendar 범위가 다시 계산됩니다 | `CboPlanDate_SelectedIndexChanged` → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.CommonDataList_REPORT` |
| TC-SCP0100-007 | 이벤트 | 화면 초기화 완료 | dCalendar의 From/To를 바꿉니다 | 기간 변경 | 기간 헤더가 다시 구성되고, 기간 컬럼 수가 새 기간에 맞게 바뀝니다 | `DCalendar_ValueChanged` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-008 | 이벤트 | 화면 초기화 완료 | rgrpSearchLevel 선택을 바꿉니다 | 다른 라디오 항목 | 헤더가 다시 구성됩니다. 시트 전환 여부는 확인 필요 | `rgrpSearchLevel_SelectedIndexChanged` → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-009 | 이벤트 | 화면 초기화 완료 | btnMeasure를 누릅니다 | — | 헤더가 다시 구성됩니다(메저 선택 UI는 확인 필요) | `btnMeasure_Click` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-010 | 이벤트 | 화면 초기화 완료 | btnColumn을 누릅니다 | — | 헤더가 다시 구성됩니다(컬럼 선택 UI는 확인 필요) | `BtnColumn_Click` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-011 | 이벤트 | 시트 생성 완료(_SI 있음) | cboBucketType을 MONTHLY로 바꿉니다 | MONTHLY | `M_`로 시작하는 컬럼만 보이고 나머지는 숨겨집니다. API 호출은 없습니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn :1103/:1107 |
| TC-SCP0100-012 | 이벤트 | 시트 생성 완료(_SI 있음) | cboBucketType을 WEEKLY로 바꿉니다 | WEEKLY | `W_`로 시작하는 컬럼만 보이고 나머지는 숨겨집니다. API 호출은 없습니다 | `CboBucketType_SelectedIndexChanged` > SetSpreadColumn :1114/:1118 |
| TC-SCP0100-013 | 이벤트 | 시트 미생성(_SI == null) | 시트 생성 전에 cboBucketType 변경 이벤트가 발생하는 경우 | 임의 | SetSpreadColumn이 호출되지 않고 예외도 없습니다 | `CboBucketType_SelectedIndexChanged` `if(_SI != null)` :1804 |
| TC-SCP0100-014 | 이벤트 | 화면 초기화 완료 | cboDisplay 항목을 차례로 고릅니다 | 콤보 각 항목 | splitContainer1.SplitterDistance가 0, 750, 270 중 하나로 바뀝니다. 값별 대응은 확인 필요. 0일 때 Panel1(chartMain)이 접힙니다 | `CboDisplay_SelectedIndexChanged` :1833/:1841/:1849 |
| TC-SCP0100-015 | 이벤트 | 화면 초기화 완료 | cboSearchLevel 항목을 바꿉니다 | 각 항목 | 예외 없이 처리됩니다. 세부 동작(SetLayout 호출 여부)은 확인 필요 | `CboSearchLevel_SelectedIndexChanged` |
| TC-SCP0100-016 | 이벤트 | 화면 초기화 완료 | clbDivision 체크를 바꿉니다 | division 선택/해제 | 예외 없이 처리됩니다. 세부 동작은 확인 필요. 선택값은 getDivision(CODE)으로 수집됩니다 | `ClbDivision_SelectedIndexChanged`, getDivision:466 |
| TC-SCP0100-017 | 이벤트 | 화면 초기화 완료 | cboGraphType 항목을 바꿉니다 | 각 항목 | 예외 없이 처리됩니다. chartMain 반영 여부는 확인 필요 | `CboGraphType_SelectedIndexChanged` |
| TC-SCP0100-018 | 이벤트 | 화면 초기화 완료 | cboUnitQty 항목을 바꿉니다 | 각 항목 | 예외 없이 처리됩니다. 세부 동작은 확인 필요 | `CboUnitQty_SelectedIndexChanged` |
| TC-SCP0100-019 | 이벤트 | PlanType LayoutItem Enabled=false | cboPlanType 변경 이벤트를 발생시킵니다(코드/테스트 하네스로) | 각 항목 | 예외 없이 처리됩니다. 세부 동작은 확인 필요. 화면에서 사용자가 직접 바꿀 수 없음을 확인합니다 | `CboPlanType_SelectedIndexChanged`, designer:1159 |
| TC-SCP0100-020 | 이벤트 | 화면 초기화 완료 | btnItemId를 누르고 팝업에서 Model을 고릅니다 | Model 1건 | txtItemId에 선택한 값(sItemId)이 들어갑니다. 팝업 화면 ID는 확인 필요 | `BtnItemId_Click` :1947 |
| TC-SCP0100-021 | 이벤트 | 화면 초기화 완료 | btnProject를 누르고 팝업에서 Project를 고릅니다 | Project 1건 | txtProject에 선택한 값(sProjectCode)이 들어갑니다. 팝업 화면 ID는 확인 필요 | `BtnProject_Click` :1981 |
| TC-SCP0100-022 | 이벤트 | chkCellQty Visible=false | chkCellQty 체크 변경 이벤트를 발생시킵니다(하네스) | true→false | 예외 없이 처리됩니다. 세부 동작은 확인 필요 | `ChkCellQty_CheckedChanged` |
| TC-SCP0100-023 | 이벤트 | chkAS Visible=false | chkAS 체크 변경 이벤트를 발생시킵니다(하네스) | false→true | 예외 없이 처리됩니다. 세부 동작은 확인 필요 | `ChkAS_CheckedChanged` |
| TC-SCP0100-024 | 그리드 | spdDetail 표시 상태 | 시트 REPORT의 컬럼을 확인합니다 | — | 표시: Div, Model, From Site, To Site, INCOTERMS, Operation, Trans Mode or Line or Project, Cell Group, Cell Qty, Measure Group, Measure Name(11개) + PRODUCT_LEVEL1~3(동적) / 숨김: MEASURE_UI, D0, D1 | 시트 REPORT, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, grid_effective |
| TC-SCP0100-025 | 그리드 | spdSearchLevel 표시 상태 | 시트 SEARCH_LEVEL의 컬럼을 확인합니다 | — | 표시: Div, Operation Group, Cell Group, Measure Group, Measure Name(5개) + PRODUCT_LEVEL1~3(동적) / 숨김: MEASURE_UI, D0, D1 | 시트 SEARCH_LEVEL, grid_effective |
| TC-SCP0100-026 | 그리드 | spdSearchLevelDetail 표시 상태 | 시트 SEARCH_LEVEL_DETAIL의 컬럼을 확인합니다 | — | SEARCH_LEVEL과 같은 구성(5개 + PRODUCT_LEVEL1~3 동적), MEASURE_UI/D0/D1 숨김 | 시트 SEARCH_LEVEL_DETAIL, grid_effective |
| TC-SCP0100-027 | 그리드 | 3SPAN 결과에 `B_`가 위치 1 이후에 들어간 COLUMN_NAME 있음 | 기간 컬럼 속성을 확인합니다 | — | 해당 컬럼은 Text 컬럼, 폭 0, 숨김입니다. 그 외 컬럼은 Num 컬럼, 폭 70, 표시입니다 | InitSpreadDateColumn :755/:760, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0100-028 | 그리드 | `_plan_start_yyyymm`을 포함한 `M_` 컬럼 있음 | 글자색을 확인합니다 | — | 빨강입니다 | InitSpreadDateColumn :767 |
| TC-SCP0100-029 | 그리드 | `W_` 컬럼의 라벨에 "A" 또는 "B" 포함 | 글자색을 확인합니다 | — | 파랑입니다 | InitSpreadDateColumn :774/:778 |
| TC-SCP0100-030 | 그리드 | 헤더 구성 완료 | 기간 컬럼 헤더를 확인합니다 | — | 0행: LARGE_CLASS_LABEL_NAME 병합 / 1행: SMALL_CLASS_LABEL_NAME 병합 / 2행: "Qty" | InitSpreadDateColumn :787~816, SetSheetHeaderColumn(_SI, 3) |
| TC-SCP0100-031 | 그리드 | `!_is_detail` | cboSearchLevel.SelectedIndex를 1, 2, 3, 4로 바꾼 뒤 SetLayout 결과를 확인합니다 | 1 / 2 / 3 / 4 | 1: L1·L2 표시 / 2: L1만 / 3: L2만 / 4: L1·L2·L3. SetLayout 실행 트리거는 확인 필요 | SetLayout :1498~1529, `CboSearchLevel_SelectedIndexChanged` |
| TC-SCP0100-032 | 그리드 | `!_is_detail` | case 라벨이 미추출인 분기로 진입시킵니다 | 1~4 외 값(확인 필요) | PRODUCT_LEVEL1~3 모두 숨김 | SetLayout :1536~1538 |
| TC-SCP0100-033 | 그리드 | 화면 초기화 완료 | spdSearchLevel, spdDetail, spdSearchLevelDetail의 Visible을 확인합니다 | — | 항상 하나만 Visible입니다. lciSearchLevel.Enabled = !_is_detail입니다. 전환 조건은 확인 필요 | VisibleSheet :1880~1896, EnableSearchLevel :1874, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL |
| TC-SCP0100-034 | division | division별 사용자 준비(40, 81, 82, EE 계열 등 14개) | division별로 로그인 또는 clbDivision을 선택한 뒤 각 시트 컬럼 수를 비교합니다 | 14개 division | 모든 division에서 REPORT 11 (?3), SEARCH_LEVEL 5 (?3), SEARCH_LEVEL_DETAIL 5 (?3)로 같습니다 | grid_effective, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL, `ClbDivision_SelectedIndexChanged` |
| TC-SCP0100-035 | 권한 | TB_FX_GroupMenuAuth 4개 그룹 사용자 | 그룹별로 화면에 진입합니다 | 그룹별 계정 | 그룹별 C/R/U/D 값에 맞는 화면 접근과 버튼 활성이 적용됩니다. 값은 확인 필요 | TB_FX_GroupMenuAuth, BaseForm.OnShown:522, `Form_Load` |
| TC-SCP0100-036 | 조회 | 3SPAN SP 결과 0행인 조건 | 화면을 열거나 dCalendar를 바꿉니다 | 데이터 없는 기간 | 기간 컬럼이 추가되지 않습니다. ColumnHeaderSpan이 `dsSpdTitle.Tables[0].Rows[0][2]`를 참조하므로 0행일 때 예외가 날 수 있습니다 → 실제 동작은 확인 필요 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, InitSpreadDateColumn :787~816, `DCalendar_ValueChanged` |
| TC-SCP0100-037 | 조회 | PLAN_DATE SP 결과 0행인 조건 | 화면을 엽니다 | — | cboPlanDate가 비어 있습니다. 이후 동작(예외·메시지)은 확인 필요 | `SCP.SCP0100_GET_PLAN_DATE`, `Form_Load` |
| TC-SCP0100-038 | 조회 | SITE SP 결과 0행인 조건 | 화면을 엽니다 | — | clbToSite가 비어 있습니다. 예외는 없어야 합니다(확인 필요) | `SCP.SCP0100_GET_SITE`, `SCP0100_Global_PSI_Report_Shown` |
| TC-SCP0100-039 | 조회 | PLAN_END_DATE 공통 데이터가 없거나 Biz 호출이 실패하는 조건 | 화면을 열거나 cboPlanDate를 바꿉니다 | — | 오류 처리(메시지·기본 기간)는 확인 필요 | `biz:CommonData.CommonDataList_REPORT`, `CboPlanDate_SelectedIndexChanged` |
| TC-SCP0100-040 | 조회 | 3SPAN SP가 오류를 응답하는 조건(권한 누락 등) | btnColumn을 누릅니다 | — | 오류 메시지 표시 방식은 확인 필요. 기존 그리드 상태가 유지되는지 확인합니다 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `BtnColumn_Click` |
| TC-SCP0100-041 | 조회 | 조회조건 입력 완료 | 조회를 실행합니다 | 기본 조건 | 시트·차트 본문 데이터 표시 — **엔드포인트 미식별. 확인 후 TC 확정** | 메인 조회 엔드포인트 미식별(Fact Pack 미검출) |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 엔드포인트 | `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` | 001, 006~010, 024, 027, 036, 040 |
| | `SCP.SCP0100_GET_SITE` | 004, 038 |
| | `SCP.SCP0100_GET_PLAN_DATE` | 002, 037 |
| | `biz:CommonData.CommonDataList_REPORT` | 003, 006, 039 |
| 핸들러(18) | `Form_Load` 001~003, 035 / `SCP0100_Global_PSI_Report_Shown` 004, 038 / `ClbDivision_SelectedIndexChanged` 016, 034 / `CboGraphType_SelectedIndexChanged` 017 / `CboPlanDate_SelectedIndexChanged` 006, 039 / `CboBucketType_SelectedIndexChanged` 011~013 / `CboDisplay_SelectedIndexChanged` 014 / `CboSearchLevel_SelectedIndexChanged` 015, 031 / `CboUnitQty_SelectedIndexChanged` 018 / `rgrpSearchLevel_SelectedIndexChanged` 008 / `BtnItemId_Click` 020 / `btnMeasure_Click` 009 / `BtnProject_Click` 021 / `CboPlanType_SelectedIndexChanged` 005, 019 / `BtnColumn_Click` 010, 040 / `DCalendar_ValueChanged` 007, 036 / `ChkCellQty_CheckedChanged` 005, 022 / `ChkAS_CheckedChanged` 005, 023 | — |
| 시트 | REPORT 024 / SEARCH_LEVEL 025 / SEARCH_LEVEL_DETAIL 026 (공통 033, 034) | — |
| division | 14개 division 동일 → 034 | — |
| 빈 결과 / 오류 | 036~040 | — |
