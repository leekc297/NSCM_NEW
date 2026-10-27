// SCP0122 PlanActivityMgmt — TobeGen 생성 골격 (As-is SCP0122_PlanActivityMgmt, Fact Pack Doc/asisfacts/screens/SCP0122)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 기반 단위테스트 초안 — Doc/asisfacts/agent/SCP0122/unit_test.md 의 TC 를 it.todo 로. 구현 시 it 로 바꾸고 삭제 금지(건수 게이트 대상).
import { describe, it } from 'vitest';

describe('SCP0122 PlanActivityMgmt — As-is 단위테스트 (28건)', () => {
  it.todo('TC-ID [구분] 기대결과 — 근거: 근거');
  it.todo('TC-SCP0122-001 [초기화] `Form_Load`가 실행됩니다. usrConditionPanel1(상단, 접기 가능) 안에 cboDivision / cboPlanGroup / cboProcess가 보이고, spdMain에 시트 `Plan Act — 근거: `Form_Load`, `Plan Activity Mgmt` (CreateSpread:185, InitSpread:198)');
  it.todo('TC-SCP0122-002 [초기화] 클래스 생성 시 `biz:CommonData.CommonDataList` [code=LookupCommon]이 1회 호출되어 dtProcessCdAll에 적재됩니다. cboProcess에 바인딩되는지는 **확인 필요 — 근거: `biz:CommonData.CommonDataList` (`<field:dtProcessCdAll>`:47, UP_FX_GetCommonDataList)');
  it.todo('TC-SCP0122-003 [초기화] `SCP.SCP0121_GET_SEARCH_INFO` → SP `SCP0121_GET_SEARCH_INFO`가 호출되고 cboPlanGroup에 Plan Group 목록이 채워집니다 — 근거: `SCP.SCP0121_GET_SEARCH_INFO`, `SCP0121_GET_SEARCH_INFO` (GetPlanGroupByUserID:155·143)');
  it.todo('TC-SCP0122-004 [초기화] 빈 결과에서도 오류 없이 cboPlanGroup이 비어 있습니다(빈 목록 처리 방식 **확인 필요**) — 근거: `SCP.SCP0121_GET_SEARCH_INFO` (빈 결과)');
  it.todo('TC-SCP0122-005 [이벤트] `ClbDivision_SelectedIndexChanged`가 실행됩니다. cboPlanGroup이 선택 Division 기준으로 갱신되는지(RefreshPlanGroupByDivision:171) **확인 필요* — 근거: `ClbDivision_SelectedIndexChanged` (InitEvent:217)');
  it.todo('TC-SCP0122-006 [이벤트] `CboPlanGroup_SelectedIndexChanged`가 실행됩니다. 연동 처리(cboProcess 갱신 등)는 **확인 필요** — 근거: `CboPlanGroup_SelectedIndexChanged` (InitEvent:218)');
  it.todo('TC-SCP0122-007 [조회] 시트가 `Plan Activity Mgmt`로 전환(306)되고, 조건 3개가 GetCheckedListValue(CODE)로 전달(308~310)된 뒤 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGM — 근거: `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`, `SCP0122_GET_PLAN_ACTIVITY_MGMT`, `Plan Activity Mgmt`');
  it.todo('TC-SCP0122-008 [조회] 오류 없이 spdMain이 0행이고 헤더 15컬럼은 유지됩니다(조회 결과 없음 메시지 여부 **확인 필요**) — 근거: `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (빈 결과)');
  it.todo('TC-SCP0122-009 [조회] 오류 응답 시 오류 메시지가 표시되고 기존 그리드가 깨지지 않습니다(메시지 문구 **확인 필요**) — 근거: `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (오류 응답)');
  it.todo('TC-SCP0122-010 [그리드] 시트 `Plan Activity Mgmt`에 15컬럼 헤더 Auto Flag, Confirm Flag, Div., Link UI Type, Activity Code, Activity Name, Act. Seq, Pl — 근거: `Plan Activity Mgmt` (SetSheetHeaderColumnSCP@SetSpreadInit:212, grid_effective.csv)');
  it.todo('TC-SCP0122-011 [그리드] COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG, CELL_CONTROL_ — 근거: `Plan Activity Mgmt` (SetSheetHeaderColumnSCP)');
  it.todo('TC-SCP0122-012 [그리드] 헤더 정렬은 General, NoteIndicatorColor는 Red(Designer.cs:252~255)입니다 — 근거: `Plan Activity Mgmt` (InitializeComponent:252~255)');
  it.todo('TC-SCP0122-013 [이벤트] `SpdMain_ComboSelChange`가 실행됩니다. 연동 셀 갱신 등 처리 내용은 **확인 필요** — 근거: `SpdMain_ComboSelChange` (InitEvent:220), `Plan Activity Mgmt`');
  it.todo('TC-SCP0122-014 [이벤트] `spdMain_CellClick`이 실행됩니다. 처리 내용은 **확인 필요** — 근거: `spdMain_CellClick` (InitEvent:221), `Plan Activity Mgmt`');
  it.todo('TC-SCP0122-015 [저장] `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`로 SCP_OPMZ_PLAN_GR_ACTV_M에 INSERT된 뒤 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`로 재조회되어 신규 — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP.SCP0122_GET_PLAN_ACTI');
  it.todo('TC-SCP0122-016 [저장] SCP_OPMZ_PLAN_GR_ACTV_M에 UPDATE되고 재조회 결과에 변경값이 반영됩니다 — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`');
  it.todo('TC-SCP0122-017 [저장] SCP_OPMZ_PLAN_GR_ACTV_M에서 DELETE되고 재조회 결과에서 사라집니다 — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`');
  it.todo('TC-SCP0122-018 [저장] SCP_OPMZ_PLAN_GR_ACTV_H(SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST 경유)와 SCM_SYS_LOG_BATCH(PR_SCM_SYS_LOG_BATCH 경유)에 행이 적재됩니다(적재  — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`');
  it.todo('TC-SCP0122-019 [저장] 오류 응답 시 메시지가 표시되고 원장이 변경되지 않습니다. 재조회 수행 여부는 **확인 필요** — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` (오류 응답)');
  it.todo('TC-SCP0122-020 [저장] 변경 없음 처리(메시지 또는 무동작)는 **확인 필요**. 원장 변경 0건 — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` (빈 페이로드)');
  it.todo('TC-SCP0122-021 [division] `Plan Activity Mgmt` 15컬럼 전부 표시(기본 15/선택 0) — 근거: `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 40)');
  it.todo('TC-SCP0122-022 [division] 15컬럼 전부 표시, 40과 동일 — 근거: `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 81 계열)');
  it.todo('TC-SCP0122-023 [division] 15컬럼 전부 표시, 40과 동일 — 근거: `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv 82)');
  it.todo('TC-SCP0122-024 [division] 15컬럼 전부 표시, 40과 동일 — 근거: `Plan Activity Mgmt`, `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` (grid_effective.csv EE 계열)');
  it.todo('TC-SCP0122-025 [권한] 조회(FindButton)는 가능하고, 저장(SaveButton)·행추가의 노출·비활성 여부는 권한 메타에 따릅니다(**확인 필요**) — 근거: `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`, `Form_Load` (TB_FX_GroupMenuAuth 3행)');
  it.todo('TC-SCP0122-026 [권한] 저장 권한 그룹은 `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` 호출에 성공합니다. 권한이 없으면 저장이 차단됩니다(차단 방식 **확인 필요**) — 근거: `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT`');
  it.todo('TC-SCP0122-027 [권한] `SCP.SCP0121_GET_SEARCH_INFO` 결과가 그룹별로 다를 수 있습니다(차이 규칙은 SP 원문 **확인 필요**) — 근거: `SCP.SCP0121_GET_SEARCH_INFO`, `SCP0121_GET_SEARCH_INFO` (NowGroupID:143)');
});
