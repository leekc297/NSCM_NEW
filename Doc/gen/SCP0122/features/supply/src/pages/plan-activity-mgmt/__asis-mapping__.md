# __asis-mapping__.md — SCP0122 design 번호 1:1 대조표 (TobeGen 초기본 — Fact Pack 기준)

> 원천: Doc/asisfacts/screens/SCP0122 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrLayoutControl1 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-002 | §1 layoutControlGroup1 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-004 | §1 cboPlanGroup / UsrComboBox | components/PlanActivityMgmtForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-005 | §1 cboProcess / UsrComboBox | components/PlanActivityMgmtForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-006 | §1 cboDivision / UsrCombo | components/PlanActivityMgmtForm.tsx (DivisionField 카탈로그) |  | 구현 |
| D00-1-007 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-008 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-009 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-010 | §1 layoutControlItem9 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-011 | §1 Division / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-012 | §1 spdMain / FpSpread | components/PlanActivityMgmtGrid.tsx (DataGrid ← Plan Activity Mgmt) |  | 구현 |
| D00-1-013 | §1 spdMain_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-014 | §1 imageList1 / ImageList |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load | PlanActivityMgmt.tsx (useEffect) (handleForm 스텁) |  | 구현 |
| D00-2-002 | §2 cboDivision / SelectedIndexChanged | PlanActivityMgmt.tsx (handleClbDivision 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-003 | §2 cboPlanGroup / SelectedIndexChanged | PlanActivityMgmt.tsx (handleCboPlanGroup 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-004 | §2 spdMain / ComboSelChange | components/PlanActivityMgmtGrid.tsx (handleSpdMainComboSelChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-005 | §2 spdMain / CellClick | components/PlanActivityMgmtGrid.tsx (handleMainCell 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 biz:CommonData.CommonDataList /  | register.json → SCP0122/Plan Activity Mgmt/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-002 | §4 SCP.SCP0121_GET_SEARCH_INFO / SCP0121_GET_SEARCH_INFO |  | 사용자별 조회조건 저장/복원(G1) → /admin/menu/{MENU}/search-conditions (store fetchStaticColumns 내장) | 해당없음 |
| D00-4-003 | §4 SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT / SCP0122_GET_PLAN_ACTIVITY_MGMT | register.json → SCP0122/Plan Activity Mgmt/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-004 | §4 SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT / SCP0122_SAVE_PLAN_ACTIVITY_MGMT | register.json → SCP0122/Plan Activity Mgmt/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'Plan Activity Mgmt' / META+코드연결 (15컬럼) | components/PlanActivityMgmtGrid.tsx (SHEETS.PLAN_ACTIVITY_MGMT) |  | 구현 |
