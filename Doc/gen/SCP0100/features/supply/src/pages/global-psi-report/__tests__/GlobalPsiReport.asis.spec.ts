// SCP0100 Global_PSI_Report — TobeGen 생성 골격 (As-is SCP0100_Global_PSI_Report, Fact Pack Doc/asisfacts/screens/SCP0100)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 기반 단위테스트 초안 — Doc/asisfacts/agent/SCP0100/unit_test.md 의 TC 를 it.todo 로. 구현 시 it 로 바꾸고 삭제 금지(건수 게이트 대상).
import { describe, it } from 'vitest';

describe('SCP0100 Global_PSI_Report — As-is 단위테스트 (42건)', () => {
  it.todo('TC-ID [구분] 기대결과 — 근거: 근거');
  it.todo('TC-SCP0100-001 [초기화] 시트 SEARCH_LEVEL / REPORT / SEARCH_LEVEL_DETAIL이 생성되고, 메타 컬럼과 기간 컬럼이 3행 헤더로 구성됩니다 — 근거: `Form_Load` > CreateSpread > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN` / SP ');
  it.todo('TC-SCP0100-002 [초기화] SP 결과 행이 cboPlanDate 항목으로 채워집니다(표시 형식은 확인 필요) — 근거: `Form_Load` > InitControls > GetPlanDate → `SCP.SCP0100_GET_PLAN_DATE` / SP SCP0100_GET_PLAN_DATE');
  it.todo('TC-SCP0100-003 [초기화] PLAN_END_DATE 공통 데이터로 기간 범위가 설정됩니다(계산식은 확인 필요) — 근거: `Form_Load` > SetCalendar > GetDayRange > GetPlanEndDate → `biz:CommonData.CommonDataList_REPORT`');
  it.todo('TC-SCP0100-004 [초기화] SP 결과가 clbToSite 항목으로 채워집니다 — 근거: `SCP0100_Global_PSI_Report_Shown` > InitControlsAfter > RefreshToSite > GetSiteList → `SCP.SCP0100_G');
  it.todo('TC-SCP0100-005 [초기화] chkCellQty: Checked=true, Visible=false / chkAS: Visible=false / cboPlanType의 LayoutItem(PlanType): Enabled=false — 근거: designer:248/284/929/1159, `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged`, `CboPlanType_Selecte');
  it.todo('TC-SCP0100-006 [이벤트] 기간 헤더가 다시 구성되고, dCalendar 범위가 다시 계산됩니다 — 근거: `CboPlanDate_SelectedIndexChanged` → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.CommonD');
  it.todo('TC-SCP0100-007 [이벤트] 기간 헤더가 다시 구성되고, 기간 컬럼 수가 새 기간에 맞게 바뀝니다 — 근거: `DCalendar_ValueChanged` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`');
  it.todo('TC-SCP0100-008 [이벤트] 헤더가 다시 구성됩니다. 시트 전환 여부는 확인 필요 — 근거: `rgrpSearchLevel_SelectedIndexChanged` → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`');
  it.todo('TC-SCP0100-009 [이벤트] 헤더가 다시 구성됩니다(메저 선택 UI는 확인 필요) — 근거: `btnMeasure_Click` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`');
  it.todo('TC-SCP0100-010 [이벤트] 헤더가 다시 구성됩니다(컬럼 선택 UI는 확인 필요) — 근거: `BtnColumn_Click` > InitSpread > GetSpdTitle → `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`');
  it.todo('TC-SCP0100-011 [이벤트] `M_`로 시작하는 컬럼만 보이고 나머지는 숨겨집니다. API 호출은 없습니다 — 근거: `CboBucketType_SelectedIndexChanged` > SetSpreadColumn :1103/:1107');
  it.todo('TC-SCP0100-012 [이벤트] `W_`로 시작하는 컬럼만 보이고 나머지는 숨겨집니다. API 호출은 없습니다 — 근거: `CboBucketType_SelectedIndexChanged` > SetSpreadColumn :1114/:1118');
  it.todo('TC-SCP0100-013 [이벤트] SetSpreadColumn이 호출되지 않고 예외도 없습니다 — 근거: `CboBucketType_SelectedIndexChanged` `if(_SI != null)` :1804');
  it.todo('TC-SCP0100-014 [이벤트] splitContainer1.SplitterDistance가 0, 750, 270 중 하나로 바뀝니다. 값별 대응은 확인 필요. 0일 때 Panel1(chartMain)이 접힙니다 — 근거: `CboDisplay_SelectedIndexChanged` :1833/:1841/:1849');
  it.todo('TC-SCP0100-015 [이벤트] 예외 없이 처리됩니다. 세부 동작(SetLayout 호출 여부)은 확인 필요 — 근거: `CboSearchLevel_SelectedIndexChanged`');
  it.todo('TC-SCP0100-016 [이벤트] 예외 없이 처리됩니다. 세부 동작은 확인 필요. 선택값은 getDivision(CODE)으로 수집됩니다 — 근거: `ClbDivision_SelectedIndexChanged`, getDivision:466');
  it.todo('TC-SCP0100-017 [이벤트] 예외 없이 처리됩니다. chartMain 반영 여부는 확인 필요 — 근거: `CboGraphType_SelectedIndexChanged`');
  it.todo('TC-SCP0100-018 [이벤트] 예외 없이 처리됩니다. 세부 동작은 확인 필요 — 근거: `CboUnitQty_SelectedIndexChanged`');
  it.todo('TC-SCP0100-019 [이벤트] 예외 없이 처리됩니다. 세부 동작은 확인 필요. 화면에서 사용자가 직접 바꿀 수 없음을 확인합니다 — 근거: `CboPlanType_SelectedIndexChanged`, designer:1159');
  it.todo('TC-SCP0100-020 [이벤트] txtItemId에 선택한 값(sItemId)이 들어갑니다. 팝업 화면 ID는 확인 필요 — 근거: `BtnItemId_Click` :1947');
  it.todo('TC-SCP0100-021 [이벤트] txtProject에 선택한 값(sProjectCode)이 들어갑니다. 팝업 화면 ID는 확인 필요 — 근거: `BtnProject_Click` :1981');
  it.todo('TC-SCP0100-022 [이벤트] 예외 없이 처리됩니다. 세부 동작은 확인 필요 — 근거: `ChkCellQty_CheckedChanged`');
  it.todo('TC-SCP0100-023 [이벤트] 예외 없이 처리됩니다. 세부 동작은 확인 필요 — 근거: `ChkAS_CheckedChanged`');
  it.todo('TC-SCP0100-024 [그리드] 표시: Div, Model, From Site, To Site, INCOTERMS, Operation, Trans Mode or Line or Project, Cell Group, Cell Qty, Measure G — 근거: 시트 REPORT, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, grid_effective');
  it.todo('TC-SCP0100-025 [그리드] 표시: Div, Operation Group, Cell Group, Measure Group, Measure Name(5개) + PRODUCT_LEVEL1~3(동적) / 숨김: MEASURE_UI, D0, D1 — 근거: 시트 SEARCH_LEVEL, grid_effective');
  it.todo('TC-SCP0100-026 [그리드] SEARCH_LEVEL과 같은 구성(5개 + PRODUCT_LEVEL1~3 동적), MEASURE_UI/D0/D1 숨김 — 근거: 시트 SEARCH_LEVEL_DETAIL, grid_effective');
  it.todo('TC-SCP0100-027 [그리드] 해당 컬럼은 Text 컬럼, 폭 0, 숨김입니다. 그 외 컬럼은 Num 컬럼, 폭 70, 표시입니다 — 근거: InitSpreadDateColumn :755/:760, `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`');
  it.todo('TC-SCP0100-028 [그리드] 빨강입니다 — 근거: InitSpreadDateColumn :767');
  it.todo('TC-SCP0100-029 [그리드] 파랑입니다 — 근거: InitSpreadDateColumn :774/:778');
  it.todo('TC-SCP0100-030 [그리드] 0행: LARGE_CLASS_LABEL_NAME 병합 / 1행: SMALL_CLASS_LABEL_NAME 병합 / 2행: "Qty" — 근거: InitSpreadDateColumn :787~816, SetSheetHeaderColumn(_SI, 3)');
  it.todo('TC-SCP0100-031 [그리드] 1: L1·L2 표시 / 2: L1만 / 3: L2만 / 4: L1·L2·L3. SetLayout 실행 트리거는 확인 필요 — 근거: SetLayout :1498~1529, `CboSearchLevel_SelectedIndexChanged`');
  it.todo('TC-SCP0100-032 [그리드] PRODUCT_LEVEL1~3 모두 숨김 — 근거: SetLayout :1536~1538');
  it.todo('TC-SCP0100-033 [그리드] 항상 하나만 Visible입니다. lciSearchLevel.Enabled = !_is_detail입니다. 전환 조건은 확인 필요 — 근거: VisibleSheet :1880~1896, EnableSearchLevel :1874, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL');
  it.todo('TC-SCP0100-034 [division] 모든 division에서 REPORT 11 (?3), SEARCH_LEVEL 5 (?3), SEARCH_LEVEL_DETAIL 5 (?3)로 같습니다 — 근거: grid_effective, 시트 REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL, `ClbDivision_SelectedIndexChanged`');
  it.todo('TC-SCP0100-035 [권한] 그룹별 C/R/U/D 값에 맞는 화면 접근과 버튼 활성이 적용됩니다. 값은 확인 필요 — 근거: TB_FX_GroupMenuAuth, BaseForm.OnShown:522, `Form_Load`');
  it.todo('TC-SCP0100-036 [조회] 기간 컬럼이 추가되지 않습니다. ColumnHeaderSpan이 `dsSpdTitle.Tables[0].Rows[0][2]`를 참조하므로 0행일 때 예외가 날 수 있습니다 → 실제 동작은 확인 필요 — 근거: `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, InitSpreadDateColumn :787~816, `DCalendar_ValueChanged`');
  it.todo('TC-SCP0100-037 [조회] cboPlanDate가 비어 있습니다. 이후 동작(예외·메시지)은 확인 필요 — 근거: `SCP.SCP0100_GET_PLAN_DATE`, `Form_Load`');
  it.todo('TC-SCP0100-038 [조회] clbToSite가 비어 있습니다. 예외는 없어야 합니다(확인 필요) — 근거: `SCP.SCP0100_GET_SITE`, `SCP0100_Global_PSI_Report_Shown`');
  it.todo('TC-SCP0100-039 [조회] 오류 처리(메시지·기본 기간)는 확인 필요 — 근거: `biz:CommonData.CommonDataList_REPORT`, `CboPlanDate_SelectedIndexChanged`');
  it.todo('TC-SCP0100-040 [조회] 오류 메시지 표시 방식은 확인 필요. 기존 그리드 상태가 유지되는지 확인합니다 — 근거: `SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN`, `BtnColumn_Click`');
  it.todo('TC-SCP0100-041 [조회] 시트·차트 본문 데이터 표시 — **엔드포인트 미식별. 확인 후 TC 확정** — 근거: 메인 조회 엔드포인트 미식별(Fact Pack 미검출)');
});
