# __asis-mapping__.md — SCP0100 design 번호 1:1 대사표 (TobeGen 초기본 — Fact Pack 기준)

> 원천: Doc/asisfacts/screens/SCP0100 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrButton1 / UsrButton | GlobalPsiReport.tsx (SubTitle customButtons) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-002 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 rgrpSearchLevel / RadioGroup | components/GlobalPsiReportForm.tsx (RadioGroup) |  | 구현 |
| D00-1-004 | §1 chkCellQty / UsrCheckBox | components/GlobalPsiReportForm.tsx (Checkbox) |  | 구현 |
| D00-1-005 | §1 cboPlanDate / UsrCombo | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-006 | §1 cboBucketType / UsrCombo | components/GlobalPsiReportForm.tsx (BucketField 카탈로그) |  | 구현 |
| D00-1-007 | §1 dCalendar / UsrDateRangePicker3 | components/GlobalPsiReportForm.tsx (PeriodField 카탈로그) |  | 구현 |
| D00-1-008 | §1 cboGraphType / UsrCombo | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-009 | §1 btnItemId / UsrButton | components/GlobalPsiReportForm.tsx (ItemField 내장 팝업) |  | 구현 |
| D00-1-010 | §1 btnMeasure / UsrButton | GlobalPsiReport.tsx (SubTitle MEASURE_SELECT) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-011 | §1 txtItemId / UsrTextBox | components/GlobalPsiReportForm.tsx (ItemField 카탈로그 + 팝업 내장) |  | 구현 |
| D00-1-012 | §1 cboDisplay / UsrCombo | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-013 | §1 txtProject / UsrTextBox | components/GlobalPsiReportForm.tsx (ProjectField 카탈로그 + 팝업 내장) |  | 구현 |
| D00-1-014 | §1 clbFromSite / UsrCheckedList2 | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-015 | §1 clbToSite / UsrCheckedList2 | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-016 | §1 txtCellGroup / UsrTextBox | components/GlobalPsiReportForm.tsx (InputField) |  | 구현 |
| D00-1-017 | §1 btnProject / UsrButton | components/GlobalPsiReportForm.tsx (ProjectField 내장 팝업) |  | 구현 |
| D00-1-018 | §1 cboPlanType / UsrCombo | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-019 | §1 btnColumn / UsrButton | GlobalPsiReport.tsx (SubTitle COLUMN_SETUP) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-020 | §1 cboSearchLevel / UsrCombo | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-021 | §1 chkAS / UsrCheckBox | components/GlobalPsiReportForm.tsx (Checkbox) |  | 구현 |
| D00-1-022 | §1 cboUnitQty / UsrCombo | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-023 | §1 clbDivision / UsrCheckedList2 | components/GlobalPsiReportForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-024 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-025 | §1 layModel / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-026 | §1 layoutbtnitem / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-027 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-028 | §1 lblToSite / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-029 | §1 lblCellGroup1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-030 | §1 lblCellGroup / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-031 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-032 | §1 lblBucket / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-033 | §1 PlanType / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-034 | §1 layDisplay / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-035 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-036 | §1 emptySpaceItem5 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-037 | §1 emptySpaceItem7 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-038 | §1 emptySpaceItem6 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-039 | §1 emptySpaceItem4 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-040 | §1 lblGraphType / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-041 | §1 layPeriod / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-042 | §1 emptySpaceItem13 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-043 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-044 | §1 layMeasure / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-045 | §1 layoutBtnColumn / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-046 | §1 layUnit_qty / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-047 | §1 emptySpaceItem8 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-048 | §1 emptySpaceItem10 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-049 | §1 lciSearchLevel / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-050 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-051 | §1 layAS / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-052 | §1 layCategoryCC / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-053 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-054 | §1 layoutPlanDate / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-055 | §1 splitContainer1 / SplitContainer |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-056 | §1 chartMain / ChartControl |  | 차트 컴포넌트 — 화면별 결정 | 미구현 |
| D00-1-057 | §1 spdSearchLevel / FpSpread | components/GlobalPsiReportGridSearchLevel.tsx (DataGrid ← SEARCH_LEVEL) |  | 구현 |
| D00-1-058 | §1 spdMain_Sheet / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-059 | §1 spdDetail / FpSpread | components/GlobalPsiReportGridDetail.tsx (DataGrid ← SEARCH_LEVEL_DETAIL) |  | 구현 |
| D00-1-060 | §1 spdSearchLevel_Sheet / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-061 | §1 spdSearchLevelDetail / FpSpread | components/GlobalPsiReportGridSearchLevelDetail.tsx (DataGrid ← REPORT) |  | 구현 |
| D00-1-062 | §1 spdSearchLevelDetail_Sheet / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 this / Load | GlobalPsiReport.tsx (useEffect) (handleForm 스텁) |  | 구현 |
| D00-2-002 | §2 this / Shown | GlobalPsiReport.tsx (useEffect) (handleSCP0100GlobalPSIReportShown 스텁) |  | 구현 |
| D00-2-003 | §2 clbDivision / SelectedIndexChanged | GlobalPsiReport.tsx (handleClbDivision 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-004 | §2 cboGraphType / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboGraphType 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-005 | §2 cboPlanDate / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboPlanDate 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-006 | §2 cboBucketType / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboBucketType 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-007 | §2 cboDisplay / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboDisplay 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-008 | §2 cboSearchLevel / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboSearchLevel 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-009 | §2 cboUnitQty / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboUnitQty 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-010 | §2 rgrpSearchLevel / SelectedIndexChanged | GlobalPsiReport.tsx (handlergrpSearchLevel 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-011 | §2 btnItemId / Click | GlobalPsiReport.tsx (handleItemId 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-012 | §2 btnMeasure / Click | GlobalPsiReport.tsx (handleMeasure 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-013 | §2 btnProject / Click | GlobalPsiReport.tsx (handleProject 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-014 | §2 cboPlanType / SelectedIndexChanged | GlobalPsiReport.tsx (handleCboPlanType 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-015 | §2 btnColumn / Click | GlobalPsiReport.tsx (handleColumn 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-016 | §2 dCalendar / ValueChanged | GlobalPsiReport.tsx (handleDCalendarValue 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-017 | §2 chkCellQty / CheckedChanged | GlobalPsiReport.tsx (handleChkCellQty 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-018 | §2 chkAS / CheckedChanged | GlobalPsiReport.tsx (handleChkAS 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN / SCP0100_GET_SHEET_CALENDAR_3SPAN | register.json → SCP0100/calendar/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-002 | §4 SCP.SCP0100_GET_SITE / SCP0100_GET_SITE | register.json → SCP0100/REPORT/SITE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-003 | §4 SCP.SCP0100_GET_PLAN_DATE / SCP0100_GET_PLAN_DATE | register.json → SCP0100/REPORT/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-004 | §4 biz:CommonData.CommonDataList_REPORT /  | register.json → SCP0100/REPORT/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'REPORT' / META+코드연결 (17컬럼) | components/GlobalPsiReportGridSearchLevelDetail.tsx (SHEETS.REPORT) |  | 구현 |
| D00-5-002 | §5 시트 'SEARCH_LEVEL' / META+코드연결 (11컬럼) | components/GlobalPsiReportGridSearchLevel.tsx (SHEETS.SEARCH_LEVEL) |  | 구현 |
| D00-5-003 | §5 시트 'SEARCH_LEVEL_DETAIL' / META+코드연결 (11컬럼) | components/GlobalPsiReportGridDetail.tsx (SHEETS.SEARCH_LEVEL_DETAIL) |  | 구현 |

## §6 동적 컬럼 (As-is 타이틀 SP · DB루프 컬럼 생성)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-6-001 | §6 동적 헤더 원천 SCP0100_GET_SHEET_CALENDAR_3SPAN → 시트 'calendar' (사내 PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN) | GlobalPsiReport.tsx (useTabProcQuery SHEETS.CALENDAR) | 타이틀 시트를 조회기간으로 조회해 o_rc1 로 헤더 생성 후 구현으로(B27) | 미구현 |
| D00-6-002 | §6 InitSpreadDateColumn / 755 (DB루프 컬럼 생성 ← 타이틀 SP 결과셋) | components/GlobalPsiReportGrid.tsx (dynamicColumns) | o_rc1 행(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE) → 컬럼 생성 후 구현으로(M08) | 미구현 |
| D00-6-003 | §6 InitSpreadDateColumn / 760 (DB루프 컬럼 생성 ← 타이틀 SP 결과셋) | components/GlobalPsiReportGrid.tsx (dynamicColumns) | o_rc1 행(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE) → 컬럼 생성 후 구현으로(M08) | 미구현 |
