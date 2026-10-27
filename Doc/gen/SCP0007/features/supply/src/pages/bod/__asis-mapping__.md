# __asis-mapping__.md — SCP0007 design 번호 1:1 대조표 (TobeGen 초기본 — Fact Pack 기준)

> 원천: Doc/asisfacts/screens/SCP0007 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrLayoutControl1 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-002 | §1 layoutControlGroup1 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-004 | §1 clbDivision / UsrCheckedList2 | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-005 | §1 clbIncotermsSSP / UsrCheckedList2 | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-006 | §1 clbTransMode / UsrCheckedList2 | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-007 | §1 clbIncoterms / UsrCheckedList2 | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-008 | §1 clbToSite / UsrCheckedList2 | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-009 | §1 clbFromSite / UsrCheckedList2 | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-010 | §1 cboValidYN / UsrCombo | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-011 | §1 cboInputStatus / UsrCombo | components/BodForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-012 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-013 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-014 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-015 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-017 | §1 layoutFrom / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-018 | §1 layoutToSite / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-019 | §1 layoutIncoterms / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-020 | §1 layoutTransMode / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-021 | §1 layoutSSPIncoterms / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-022 | §1 layoutDivision / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-023 | §1 spdMain / FpSpread | components/BodGrid.tsx (DataGrid ← BOD/Distribution Route) |  | 구현 |
| D00-1-024 | §1 spdMain_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-025 | §1 imageList1 / ImageList |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load | Bod.tsx (useEffect) (handleForm 스텁) |  | 구현 |
| D00-2-002 | §2 clbDivision / SelectedIndexChanged | Bod.tsx (handleDivision 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-003 | §2 spdMain / CellDoubleClick | components/BodGrid.tsx (handleMain 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-004 | §2 spdMain / TopChange | components/BodGrid.tsx (handleSpdMainTopChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-005 | §2 spdMain / ComboSelChange | components/BodGrid.tsx (handleSpdMainComboSelChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-006 | §2 spdMain / ClipboardPasted | components/BodGrid.tsx (handleSpdMainClipboardPasted 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-007 | §2 spdMain / KeyPress | components/BodGrid.tsx (handleSpdMainKeyPress 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-008 | §2 spdMain / EditChange | components/BodGrid.tsx (handleSpdMainEditChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-009 | §2 dsdm / Changed | Bod.tsx (handleSpdMain 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-010 | §2 dsdm / Changed | Bod.tsx (handleSpdMain 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-011 | §2 dsdm / Changed | Bod.tsx (handleSpdMain 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 biz:CommonData.CommonDataList /  | register.json → SCP0007/BOD/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-002 | §4 biz:CommonData.YesOrNo /  | register.json → SCP0007/BOD/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-003 | §4 SCP.SCP0007_GET_BOD / SCP0007_GET_BOD | register.json → SCP0007/BOD/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-004 | §4 SCP.SCP0007_GET_COUNTRY_CITY / SCP0007_GET_COUNTRY_CITY | register.json → SCP0007/BOD/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-005 | §4 SCP.SCP0007_SAVE_BOD / SCP0007_SAVE_BOD | register.json → SCP0007/BOD/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-006 | §4 SCP.SCP0007_GET_ROUTE_CNT / SCP0007_GET_ROUTE_CNT | register.json → SCP0007/Distribution Route/ROUTE_CNT | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-007 | §4 SCP.SCP0005_GET_DISTRIBUTION_ROUTE / SCP0005_GET_DISTRIBUTION_ROUTE | register.json → SCP0007/Distribution Route/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |

## POPUP 매핑 (룰 25 §3 — button/SP/event/validation 4축)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-P-001 | §P SCP0007_DistributionRoutePopup / 팝업(이벤트 7, SP 1: SCP0005_GET_DISTRIBUTION_ROUTE) | components/modals/DistributionRouteModal.tsx | 골격만 — 트리거·조회 파라미터·반환·검증 4축 이식 후 구현으로 (공통 lookup 으로 대체하면 사유에 명시하고 파일 삭제) | 미구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'BOD' / META+코드연결 (39컬럼) | components/BodGrid.tsx (SHEETS.BOD) |  | 구현 |
| D00-5-002 | §5 시트 'Distribution Route' / 코드 하드코딩 전용(메타 없음) (33컬럼) | components/BodGrid.tsx (SHEETS.DISTRIBUTION_ROUTE) | HARD_COLUMNS 배열 — 메타 등록 시 전환 | 구현 |
