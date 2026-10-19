# SCP0124 PlanGroupDashboard — AS-IS ↔ TO-BE 매핑

> AS-IS `.cs`/`.Designer.cs` 원본이 이 세션의 GSCM 체크아웃에 물리적으로 없음(`.atlas/gscm-design/SCP0124/design/01_layout.md §0`, `02_search-combo.md` 상단 참조). 근거는 Roslyn 산출(`roslyn/screen-analysis.json`, `SCP0124_PlanGroupDashboard.json`) + `00_checklist.md`~`03_grid-columns.md` + TO-BE Oracle 실측(`ora.py`)으로 한정된다.

## 검증(validations) / gridSignals 매핑

Roslyn `validations` = 0건(00_checklist.md §0 카운트 요약) — AS-IS 검증 로직 없음, 매핑 대상 없음.

| # | AS-IS 근거 | TO-BE 코드 위치 | 상태 |
|---|---|---|---|
| gridSignals#1 ChangeActiveSheet (line253) | 단일 sheet 구조 자체(React DataGrid 단일 그리드) | 반영 불요(노이즈, 03_grid-columns.md §3) |
| gridSignals#2 SetSheetHeaderColumnSCP (line264) | `PlanGroupDashboardGrid.tsx` 헤더는 `SCM_MST_SHEET_COLUMNS` 라벨 그대로 반영 | 확인 필요 — 파라미터 의미 미확정(03_grid-columns.md §6 한계1) |
| gridSignals#3 Query (line344) | `PlanGroupDashboard.tsx` `useTabProcQuery` → `data.o_rc1` | 구현 |
| gridSignals#4 LockColumn 전체잠금 (line345) | `PlanGroupDashboardGrid.tsx` staticColumns 그대로 반영(전건 INPUT_TP_CD='S'), 리터럴 오버라이드 없음 | 구현 |

## 조회조건 6종 매핑

| AS-IS 컨트롤 | TO-BE 필드 | SP 파라미터 | 콤보 SQL_ID | 상태 |
|---|---|---|---|---|
| cboDivision | `PlanGroupDashboardForm.tsx` Division 필드 | `divisionId` | `Division`(잠정 — 확인 필요, §2.1) | 부분구현 |
| cboPlanGroup | Plan Group 필드 | `planGroupId` | `PlanGroup_SCP_ALL`(유력, 필터 방식) | 부분구현 |
| clbPlant | (미노출) | `plantId`(항상 'ALL' 고정 전송) | 확인 필요 — 공급 SQL_ID 미확정 | 미구현(확인 필요) |
| cboCompleted | Completed 필드 | `completedYn` | 리터럴 Y/N(확인 필요) | 부분구현 |
| dCalendar | Period 필드(`PeriodRangePicker`) | `startDate`/`endDate` | 해당 없음(로컬 상태) | 구현 |
| usrConditionPanel1 하위 ActivityCode | extraConditions Activity Code 필드 | 배선 없음(SP 파라미터 아님) | `ActivityCode_SCP_ALL`(확정) | 부분구현(확인 필요 — boundControl) |
| usrConditionPanel1 하위 ProcessCode | extraConditions Process Code 필드 | 배선 없음(SP 파라미터 아님) | `LookupCommon` + `@lookupType='OPMZ_PRS_CD'`(확정) | 부분구현(확인 필요 — boundControl) |

## 버튼 가드(buttonGuards) 매핑

| # | AS-IS override | TO-BE hotkeyConfig | 상태 |
|---|---|---|---|
| FindButton(Search) | `PlanGroupDashboard.tsx` `hotkeyConfig.search = hasButton('SEARCH') ? setFilters : false` | 구현(admin 메타 미등록 시 `hasButton`이 자연히 false 반환) |
| Insert/Delete/Save | `hotkeyConfig.{insert,delete,save} = false`(명시적 NO-OP) | 구현 |

## 그리드 동작(behavior) 파리티 게이트 (grid-behavior-parity.md 적용)

- 셀 병합(`SmartColMerge`/`RangeMerge`/`RightColMerge`/`SetColumnMerge`/`MergePolicy`/`FPMerge`): grep 0건. `Add*Column` 계열 리터럴 컬럼 선언 자체가 0건(gridColumns=0, DB 메타 구동)이라 2차 확정(전수 read) 대상 코드가 존재하지 않는다 — 병합 없음으로 판정(03_grid-columns.md §1 "셀 콤보 해당 없음"과 동일 근거, 컬럼 자체가 `Add*Column` 인자로 선언되지 않음).
- Lock 계열(`LockColumn`/`LockRange`/`SwitchLock`): `LockColumn(0, GetMaxColumnIndex(), true)` 1건 — 전체 read-only, `staticColumns`(INPUT_TP_CD='S' 13/13) 그대로 반영으로 구현.
- 셀 타입 콤보(`SetCellTypeCombo`): 0건(03_grid-columns.md §1 "셀 콤보 해당 없음: 13건 전부 CELL_CONTROL_OBJECT_TYPE_CODE 공란").
- 기타(FrozenColumnCount/Sort/Filter/SetValue Auto-Sync): Roslyn 산출에 해당 신호 없음.

## 확인 필요 종합 (design 문서 승계 — 임의 확정 아님)

1. cboDivision 최종 SQL_ID(Division/MyDivision/Division_SCP 3후보) — 소스 미확보로 확정 불가.
2. clbPlant 공급 SQL_ID — 후보 자체 없음, 화면 미노출.
3. cboCompleted 데이터소스(리터럴 Y/N 확정 여부) — 잠정 리터럴 채택.
4. ActivityCode/ProcessCode 의 boundControl(조회조건 vs 그리드 코드→명 변환) — 조회조건으로 잠정 배치, SP 파라미터 미포함.
5. `SCP.SCP0121_GET_SEARCH_INFO` 사용 여부(Form_Load 프리로드 가설) — 미해소, 이 화면 구현에 포함하지 않음.
6. 다국어 LABEL 6건 전체 — `SCM_ADM_MSG_M` 역조회 미시도(문구 미확보), `t()` 폴백 문구로 임시 표기.
7. `PKG_SCP0124` 배포 후 `all_arguments` 재확인 — convert-sp 후속.
