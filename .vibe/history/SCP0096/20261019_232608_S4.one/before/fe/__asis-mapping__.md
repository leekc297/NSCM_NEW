# __asis-mapping__.md — SCP0096 design 번호 1:1 대사표 (TobeGen 초기본 — Fact Pack 기준)

> 원천: Doc/asisfacts/screens/SCP0096 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrButton1 / UsrButton |  | AS-IS events.csv 에 핸들러 바인딩 없음 — 미사용(화면 디자이너 잔존). To-Be 미노출 | 해당없음 |
| D00-1-002 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 dCalendar / UsrDateRangePicker3 | components/ShipmentWorkingDayOspForm.tsx (PeriodField 카탈로그) |  | 구현 |
| D00-1-004 | §1 btnInput / UsrButton | ShipmentWorkingDayOsp.tsx:118 (SubTitle customButtons → handleInput) |  | 구현 |
| D00-1-005 | §1 cboDivision / UsrCombo | components/ShipmentWorkingDayOspForm.tsx (DivisionField 카탈로그) |  | 구현 |
| D00-1-006 | §1 clbPlantSite / UsrCheckedList | components/ShipmentWorkingDayOspForm.tsx (PlantSiteField 카탈로그) |  | 구현 |
| D00-1-007 | §1 chkSum / UsrCheckBox | components/ShipmentWorkingDayOspForm.tsx (Checkbox) |  | 구현 |
| D00-1-008 | §1 cboInputValue / UsrCombo | components/ShipmentWorkingDayOspForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-009 | §1 cboDayWeek / UsrCombo | components/ShipmentWorkingDayOspForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-010 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-011 | §1 layoutControlItem7 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-012 | §1 emptySpaceItem2 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-013 | §1 emptySpaceItem4 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-014 | §1 emptySpaceItem9 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-015 | §1 emptySpaceItem10 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem5 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-019 | §1 emptySpaceItem6 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-020 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-021 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-022 | §1 layoutControlItem10 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-023 | §1 layoutSum / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-024 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-025 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-026 | §1 spdMain / FpSpread | components/ShipmentWorkingDayOspGrid.tsx (DataGrid ← Shipment Working Day OSP) |  | 구현 |
| D00-1-027 | §1 spdMain_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load | ShipmentWorkingDayOsp.tsx:44 (useEffect → fetchStaticColumns) |  | 구현 |
| D00-2-002 | §2 spdMain / CellDoubleClick | components/ShipmentWorkingDayOspGrid.tsx:66 (handleSpdMain → DataGrid dblClick) |  | 구현 |
| D00-2-003 | §2 spdMain / TopChange | components/ShipmentWorkingDayOspGrid.tsx:52 (grid.refresh — AS-IS SmartColMerge 등가, FlexGrid autoMerge) |  | 구현 |
| D00-2-004 | §2 cboDivision / SelectedIndexChanged | components/ShipmentWorkingDayOspForm.tsx:52 (PlantSiteField division prop cascade) |  | 구현 |
| D00-2-005 | §2 clbPlantSite / SelectedIndexChanged |  | AS-IS cs:665-668 본문 공백 no-op — To-Be 핸들러 불필요 | 해당없음 |
| D00-2-006 | §2 cboDayWeek / SelectedIndexChanged | components/ShipmentWorkingDayOspForm.tsx:29 (inputValueDisabled 파생 — AS-IS cs:670-682) |  | 구현 |
| D00-2-007 | §2 btnInput / Click | ShipmentWorkingDayOsp.tsx:49 (handleInput — AS-IS cs:684-809 이식) |  | 구현 |
| D00-2-008 | §2 chkSum / CheckedChanged | components/ShipmentWorkingDayOspGrid.tsx:40 (applySumVisibility useEffect — AS-IS cs:324-337) |  | 구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 biz:CommonData.CommonDataList /  | components/ShipmentWorkingDayOspForm.tsx:24 (useTabComboQueries 'Dayoftheweek') | 공통코드 콤보 → 등록 콤보ID(useTabComboQueries) | 구현 |
| D00-4-002 | §4 biz:CommonData.YesOrNo /  | components/ShipmentWorkingDayOspForm.tsx:24 (useTabComboQueries 'InputValue') | 공통코드 콤보 → 등록 콤보ID(useTabComboQueries) | 구현 |
| D00-4-003 | §4 DM.DM0003_GET_BUCKET_TYPE_CODE / DM0003_GET_BUCKET_TYPE_CODE |  | 공통코드 콤보 → 등록 콤보ID(useTabComboQueries) | 해당없음 |
| D00-4-004 | §4 SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP / SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | ShipmentWorkingDayOsp.tsx:33 (useTabProcQuery<MENU_ID>) + Doc/gen/SCP0096/SCP0096_PKG.sql (PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP) + SCP0096_registration.sql |  | 구현 |
| D00-4-005 | §4 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN / SCP0009_GET_SHEET_CALENDAR_3SPAN | Doc/gen/SCP0096/SCP0096_PKG.sql (PKG_SCP0096.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) — BE 내부 호출(메인 GET SP 와 결합 — To-Be 는 메인 SP 결과셋이 D_/W_/M_ 동적컬럼을 포함) |  | 구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'Shipment Working Day OSP' / META+코드연결 (6컬럼) | components/ShipmentWorkingDayOspGrid.tsx (SHEETS.SHIPMENT_WORKING_DAY_OSP) |  | 구현 |
