# SCP0122 Plan Activity Mgmt — 단위테스트

> 근거 열은 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름 원문을 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출(commented_calls)은 0건이라 제외 대상이 없습니다. 핸들러 본문이 확인되지 않은 항목은 기대결과에 **확인 필요**를 적었으니, 원문을 확인한 뒤 기대값을 확정해야 합니다.

## 1. 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0122-001 | 초기화 | SCP0122 메뉴 권한이 있는 사용자로 로그인 | 1) SCP0122 화면을 연다 2) usrConditionPanel1, spdMain을 확인한다 | 없음 | `Form_Load`가 실행됩니다. usrConditionPanel1(상단, 접기 가능) 안에 cboDivision / cboPlanGroup / cboProcess가 보이고, spdMain에 시트 `Plan Activity Mgmt`가 활성 상태로 표시됩니다. 조회 전 그리드는 빈 상태(**확인 필요**) | `Form_Load`, `Plan Activity Mgmt` (CreateSpread:185, InitSpread:198) |
| TC-SCP0122-002 | 초기화 | SCM_ADM_LOOKUP_MASTER / _DETAIL에 LookupCommon 대상 코드 존재(코드값 **확인 필요**) | 1) 화면을 연다 2) 공통코드 호출 여부를 확인한다 3) cboProcess 목록을 확인한다 | LookupCommon | 클래스 생성 시 `biz:CommonData.CommonDataList` [code=LookupCommon]이 1회 호출되어 dtProcessCdAll에 적재됩니다. cboProcess에 바인딩되는지는 **확인 필요** | `biz:CommonData.CommonDataList` (`<field:dtProcessCdAll>`:47, UP_FX_GetCommonDataList) |
| TC-SCP0122-003 | 초기화 | 로그인 사용자 NowGroupID에 해당하는 SCP_OPMZ_PLAN_GR_M 데이터 존재 | 1) 화면을 연다(또는 cboDivision을 변경한다 — 호출 시점 **확인 필요**) 2) cboPlanGroup 목록을 확인한다 | NowGroupID = 로그인 사용자 그룹 | `SCP.SCP0121_GET_SEARCH_INFO` → SP `SCP0121_GET_SEARCH_INFO`가 호출되고 cboPlanGroup에 Plan Group 목록이 채워집니다 | `SCP.SCP0121_GET_SEARCH_INFO`, `SCP0121_GET_SEARCH_INFO` (GetPlanGroupByUserID:155·143) |
| TC-SCP0122-004 | 초기화 | 사용자 그룹에 해당하는 Plan Group 데이터 없음 | 1) 화면을 연다 2) cboPlanGroup을 펼친다 | NowGroupID = 데이터 없는 그룹 | 빈 결과에서도 오류 없이 cboPlanGroup이 비어 있습니다(빈 목록 처리 방식 **확인 필요**) | `SCP.SCP0121_GET_SEARCH_INFO` (빈 결과) |
| TC-SCP0122-005 | 이벤트 | TC-001 완료 | 1) cboDivision 선택값을 바꾼다 | Division 값 1개 이상 | `ClbDivision_SelectedIndexChanged`가 실행됩니다. cboPlanGroup이 선택 Division 기준으로 갱신되는지(RefreshPlanGroupByDivision:171) **확인 필요** | `ClbDivision_SelectedIndexChanged` (InitEvent:217) |
| TC-SCP0122-006 | 이벤트 | cboPlanGroup 목록 적재됨 | 1) cboPlanGroup 선택값을 바꾼다 | Plan Group 1건 | `CboPlanGroup_SelectedIndexChanged`가 실행됩니다. 연동 처리(cboProcess 갱신 등)는 **확인 필요** | `CboPlanGroup_SelectedIndexChanged` (InitEvent:218) |
| TC-SCP0122-007 | 조회 | SCP_OPMZ_PLAN_GR_ACTV_M에 조건에 맞는 데이터 존재 | 1) cboDivision, cboPlanGroup, cboProcess를 선택한다 2) 조회(FindButton)를 누른다 | Division / Plan Group / Process 각 CODE | 시트가 `Plan Activity Mgmt`로 전환(306)되고, 조건 3개가 GetCheckedListValue(CODE)로 전달(308~310)된 뒤 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`가 호출(321)되어 spdMain에 결과가 표시됩니다 | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`, `SCP0122_GET_PLAN_ACTIVITY_MGMT`, `Plan Activity Mgmt` |
| TC-SCP0122-008 | 조회 | 조건에 맞는 데이터 없음 | 1) 데이터가 없는 조합을 선택한다 2) 조회(FindButton)를 누른다 | 데이터 없는 Plan Group/Process | 오류 없이 spdMain이 0행이고 헤더 15컬럼은 유지됩니다(조회 결과 없음 메시지 여부 **확인 필요**) | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (빈 결과) |
| TC-SCP0122-009 | 조회 | SP 오류 유발 환경(예: SP 권한 회수·DB 연결 차단) | 1) 조회(FindButton)를 누른다 | 정상 조건 | 오류 응답 시 오류 메시지가 표시되고 기존 그리드가 깨지지 않습니다(메시지 문구 **확인 필요**) | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (오류 응답) |
| TC-SCP0122-010 | 그리드 | SCM_MST_SHEET_COLUMNS SCP0122 15행 존재 | 1) 화면을 연다 2) spdMain 헤더를 확인한다 | 없음 | 시트 `Plan Activity Mgmt`에 15컬럼 헤더 Auto Flag, Confirm Flag, Div., Link UI Type, Activity Code, Activity Name, Act. Seq, Plan Group ID, Plan Group, Process CD, Process, Option Flag, PRE_OPMZ_ACTV_CD, PRE_OPMZ_ACTV_SEQ, Program Name이 표시됩니다(표시 순서는 메타 원문 **확인 필요**) | `Plan Activity Mgmt` (SetSheetHeaderColumnSCP@SetSpreadInit:212, grid_effective.csv) |
| TC-SCP0122-011 | 그리드 | TC-010 완료 | 1) 각 컬럼의 폭·정렬·고정·최대길이·대문자 적용을 메타 값과 비교한다 | SCM_MST_SHEET_COLUMNS 원문 | COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE가 메타대로 적용됩니다 | `Plan Activity Mgmt` (SetSheetHeaderColumnSCP) |
| TC-SCP0122-012 | 그리드 | TC-001 완료 | 1) 컬럼 헤더 스타일을 확인한다 | 없음 | 헤더 정렬은 General, NoteIndicatorColor는 Red(Designer.cs:252~255)입니다 | `Plan Activity Mgmt` (InitializeComponent:252~255) |
| TC-SCP0122-013 | 이벤트 | TC-007 조회 완료, 콤보 셀 존재(셀 유형 메타 **확인 필요**) | 1) spdMain의 콤보 셀에서 값을 선택한다 | 콤보 항목 1건 | `SpdMain_ComboSelChange`가 실행됩니다. 연동 셀 갱신 등 처리 내용은 **확인 필요** | `SpdMain_ComboSelChange` (InitEvent:220), `Plan Activity Mgmt` |
| TC-SCP0122-014 | 이벤트 | TC-007 조회 완료 | 1) spdMain 임의 셀을 클릭한다 | 셀 위치(행/열) | `spdMain_CellClick`이 실행됩니다. 처리 내용은 **확인 필요** | `spdMain_CellClick` (InitEvent:221), `Plan Activity Mgmt` |
| TC-SCP0122-015 | 저장 | 조회조건 선택됨, 원장에 없는 Activity 키 준비 | 1) 행 추가(Insert_Row — 진입 버튼 **확인 필요**) 2) 필수 셀을 입력한다 3) 저장(SaveButton)을 누른다 | 신규 OPMZ_ACTV_CD 등 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`로 SCP_OPMZ_PLAN_GR_ACTV_M에 INSERT된 뒤 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`로 재조회되어 신규 행이 표시됩니다 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-016 | 저장 | TC-007 조회 완료 | 1) 기존 행의 편집 가능 셀을 수정한다 2) 저장(SaveButton)을 누른다 | 예: Activity Name 변경 | SCP_OPMZ_PLAN_GR_ACTV_M에 UPDATE되고 재조회 결과에 변경값이 반영됩니다 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-017 | 저장 | TC-007 조회 완료, 삭제 진입점 확인됨(**확인 필요**) | 1) 행 삭제 표시를 한다 2) 저장(SaveButton)을 누른다 | 삭제 대상 1행 | SCP_OPMZ_PLAN_GR_ACTV_M에서 DELETE되고 재조회 결과에서 사라집니다 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-018 | 저장 | TC-015~017 중 1건 수행 | 1) 저장 후 이력·로그 테이블을 조회한다 | 저장한 키 | SCP_OPMZ_PLAN_GR_ACTV_H(SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST 경유)와 SCM_SYS_LOG_BATCH(PR_SCM_SYS_LOG_BATCH 경유)에 행이 적재됩니다(적재 조건 **확인 필요**) | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-019 | 저장 | SP 오류 유발 데이터(예: 중복 키 — 원장 실존 키) 준비 | 1) 오류를 유발하는 행으로 저장(SaveButton)을 누른다 | 오류 유발 값 | 오류 응답 시 메시지가 표시되고 원장이 변경되지 않습니다. 재조회 수행 여부는 **확인 필요** | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` (오류 응답) |
| TC-SCP0122-020 | 저장 | TC-007 조회 완료, 변경 없음 | 1) 아무것도 수정하지 않고 저장(SaveButton)을 누른다 | 없음 | 변경 없음 처리(메시지 또는 무동작)는 **확인 필요**. 원장 변경 0건 | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` (빈 페이로드) |
| TC-SCP0122-021 | division | Division 40 사용자/조건 | 1) cboDivision = 40으로 조회(FindButton)한다 | Division 40 | `Plan Activity Mgmt` 15컬럼 전부 표시(기본 15/선택 0) | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 40) |
| TC-SCP0122-022 | division | Division 81 계열 사용자/조건 | 1) cboDivision = 81(및 81_HD/81_HG/81_HM/81_ST/81_UC)로 조회(FindButton)한다 | 81 계열 | 15컬럼 전부 표시, 40과 동일 | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 81 계열) |
| TC-SCP0122-023 | division | Division 82 사용자/조건 | 1) cboDivision = 82로 조회(FindButton)한다 | Division 82 | 15컬럼 전부 표시, 40과 동일 | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 82) |
| TC-SCP0122-024 | division | Division EE 계열 사용자/조건 | 1) cboDivision = EE(및 EE_HD/EE_HG/EE_HM/EE_ST/EE_UC)로 조회(FindButton)한다 | EE 계열 | 15컬럼 전부 표시, 40과 동일 | `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv EE 계열) |
| TC-SCP0122-025 | 권한 | 조회 권한만 있는 그룹(TB_FX_GroupMenuAuth 값 **확인 필요**) | 1) 화면을 연다 2) 조회·저장 버튼 노출을 확인한다 | 권한 그룹 A | 조회(FindButton)는 가능하고, 저장(SaveButton)·행추가의 노출·비활성 여부는 권한 메타에 따릅니다(**확인 필요**) | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`, `Form_Load` (TB_FX_GroupMenuAuth 3행) |
| TC-SCP0122-026 | 권한 | 저장 권한 그룹 / 권한 없는 그룹 각 1계정 | 1) 각 계정으로 행 추가·수정 후 저장(SaveButton)을 시도한다 | 권한 그룹 B / 권한 없음 | 저장 권한 그룹은 `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` 호출에 성공합니다. 권한이 없으면 저장이 차단됩니다(차단 방식 **확인 필요**) | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` |
| TC-SCP0122-027 | 권한 | 서로 다른 NowGroupID 사용자 2명 | 1) 각 계정으로 화면을 열어 cboPlanGroup 목록을 비교한다 | 그룹 X / 그룹 Y | `SCP.SCP0121_GET_SEARCH_INFO` 결과가 그룹별로 다를 수 있습니다(차이 규칙은 SP 원문 **확인 필요**) | `SCP.SCP0121_GET_SEARCH_INFO`, `SCP0121_GET_SEARCH_INFO` (NowGroupID:143) |

## 2. 커버리지 대조

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 025 |
| | `ClbDivision_SelectedIndexChanged` | 005 |
| | `CboPlanGroup_SelectedIndexChanged` | 006 |
| | `SpdMain_ComboSelChange` | 013 |
| | `spdMain_CellClick` | 014 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 002 |
| | `SCP.SCP0121_GET_SEARCH_INFO` | 003, 004(빈 결과), 027 |
| | `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | 007, 008(빈 결과), 009(오류), 021~025 |
| | `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | 015~018, 019(오류), 020(빈 페이로드), 026 |
| 시트 | `Plan Activity Mgmt` | 001, 007, 010~014, 021~024 |
| division | 40 / 81 계열 / 82 / EE 계열 | 021 / 022 / 023 / 024 (차이 없음 확인) |

## 3. 보류 (사실 미확정으로 TC 미작성)

- `SpdMain_ClipboardPasted`(574, dtPlanGroup NAME→CODE 변환): events.csv에 배선이 없습니다. 배선이 확인되면 붙여넣기 TC를 추가합니다.
- 조회조건 필수값 검증, 저장 필수·중복 검증 메시지: Fact Pack에 사실이 없어 원문을 확인한 뒤 TC를 추가합니다.
