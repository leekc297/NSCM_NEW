# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 cboDivision / UsrCombo | WaterfallShipmentPlanFgForm.tsx:208-214 (single Division CustomDropdown) |  | 구현 |
| D00-1-002 | §1 cboBizType / UsrCombo | WaterfallShipmentPlanFgForm.tsx:215-221 (single OperationGroup CustomDropdown, isEe 스왑 Form:64) |  | 구현 |
| D00-1-003 | §1 txtProject / UsrMultiLineEditor | WaterfallShipmentPlanFgForm.tsx:256-258 (popupField Project InputField) |  | 구현 |
| D00-1-004 | §1 btnProject / UsrButton | WaterfallShipmentPlanFgForm.tsx:184-191 (popupField endAdornment FunctionSearchIcon) → page:246 onProjectSearch |  | 구현 |
| D00-1-005 | §1 txtItem_Id / UsrMultiLineEditor | WaterfallShipmentPlanFgForm.tsx:253-255 (popupField Model InputField) |  | 구현 |
| D00-1-006 | §1 clbElecType / UsrCheckedList | WaterfallShipmentPlanFgForm.tsx:232-238 (multi Electrode CustomDropdown, enable=isEe) |  | 구현 |
| D00-1-007 | §1 btnItem_Id / UsrButton | WaterfallShipmentPlanFgForm.tsx:184-191 (popupField endAdornment) → page:245 onModelSearch |  | 구현 |
| D00-1-008 | §1 btnMeasure / UsrButton | WaterfallShipmentPlanFg.tsx:268-274 (SubTitle customButtons Measure) |  | 구현 |
| D00-1-009 | §1 clbVersion / UsrCheckedList | WaterfallShipmentPlanFgForm.tsx:223-230 (multi Version CustomDropdown) |  | 구현 |
| D00-1-010 | §1 cboBucketType / UsrCombo | WaterfallShipmentPlanFgForm.tsx:243-245 (single Bucket CustomDropdown) |  | 구현 |
| D00-1-011 | §1 chkSum / UsrCheckBox | WaterfallShipmentPlanFgForm.tsx:261-273 (Sum Checkbox, WeeklyISO 숨김) |  | 구현 |
| D00-1-012 | §1 usrConditionPanel1 / UsrConditionPanel | WaterfallShipmentPlanFgForm.tsx:202-276 (SearchArea) |  | 구현 |
| D00-1-013 | §1 spdMain / FpSpread | WaterfallShipmentPlanFgGrid.tsx:266-280 (DataGrid) |  | 구현 |
| D00-1-014 | §1 btnColumn / UsrButton | WaterfallShipmentPlanFg.tsx:260-267 (SubTitle customButtons Column Set) |  | 구현 |
| D00-1-015 | §1 dCalendar / UsrDateRangePicker3 | WaterfallShipmentPlanFgForm.tsx:246-252 (PeriodField) |  | 구현 |
| D00-1-016 | §1 spdMain_Sheet1 / SheetView | WaterfallShipmentPlanFgGrid.tsx:266-280 (DataGrid main sheet, staticColumns+dynamicColumns) |  | 구현 |
| D00-1-017 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-018 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-019 | §1 lblCombo1 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-020 | §1 lblCombo / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-021 | §1 lblProject / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-022 | §1 lblItemId / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-023 | §1 lblBucket / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-024 | §1 lciSum / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-025 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-026 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-027 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-028 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-029 | §1 layoutControlItem5 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-030 | §1 layoutControlItem6 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-031 | §1 layoutControlItem7 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-032 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-033 | §1 emptySpaceItem2 / EmptySpaceItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-034 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-035 | §1 components / Container |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-036 | §1 usrButton1 / UsrButton |  | AS-IS Designer 잔존 미사용 버튼 — 화면 로직·toolbarOverride·event 어디에도 배선 없음(00_checklist §2 이벤트 목록에 usrButton1 핸들러 부재). TO-BE 미노출 | 해당없음 |
| D00-2-001 | §2 cboDivision / SelectedIndexChanged | WaterfallShipmentPlanFgForm.tsx:213 onPick=setDivision → useWaterfallShipmentPlanFgStore.ts:149-162 setDivision(cascade 초기화) |  | 구현 |
| D00-2-002 | §2 clbVersion / SelectedIndexChanged | WaterfallShipmentPlanFgForm.tsx:227 setVersions → useWaterfallShipmentPlanFgStore.ts:165-175 (periodFromVersion → Period 재산정) |  | 구현 |
| D00-2-003 | §2 btnProject / Click | WaterfallShipmentPlanFgForm.tsx:189 onClick=onOpen → page:247 onProjectSearch setOpenProject(true) |  | 구현 |
| D00-2-004 | §2 btnItem_Id / Click | WaterfallShipmentPlanFgForm.tsx:189 onClick=onOpen → page:246 onModelSearch setOpenModel(true) |  | 구현 |
| D00-2-005 | §2 btnColumn / Click | WaterfallShipmentPlanFg.tsx:264 action=setOpenColumnSetting(true) |  | 구현 |
| D00-2-006 | §2 btnMeasure / Click | WaterfallShipmentPlanFg.tsx:271 action=setOpenMeasureSelect(true) |  | 구현 |
| D00-2-007 | §2 cboBucketType / SelectedIndexChanged | WaterfallShipmentPlanFgForm.tsx:243-245 set bucket → Grid dynamicColumns baseVisibleOf 재평가(WaterfallShipmentPlanFgGrid.tsx:88-93) |  | 구현 |
| D00-2-008 | §2 chkSum / CheckedChanged | WaterfallShipmentPlanFgForm.tsx:265-269 set chkSum → Grid baseVisibleOf W_/M_ 토글(WaterfallShipmentPlanFgGrid.tsx:127) |  | 구현 |
| D00-2-009 | §2 dCalendar / ValueChanged | WaterfallShipmentPlanFgForm.tsx:250 PeriodField onChange set from/to |  | 구현 |
| D00-2-010 | §2 spdMain / CellDoubleClick | WaterfallShipmentPlanFgGrid.tsx:207-232 onDblClick 헤더 드릴 + WeeklyISO 가드(Grid:212) |  | 구현 |
| D00-2-011 | §2 spdMain / TopChange | WaterfallShipmentPlanFgGrid.tsx:191-203 scrollPositionChanged → g.invalidate() (세로병합 재계산) |  | 구현 |
| D00-3-001 | §3 SmartColMerge / () | waterfall.merge.ts:20-110 WaterfallMergeManager 세로병합 + WaterfallShipmentPlanFgGrid.tsx:183-188 mergeManager 배선 |  | 구현 |
| D00-3-002 | §3 SetReNumerCellType / 숫자셀타입(cCOLUMN_NAME, -9999999999, 0) | waterfall.columns.ts:151 format `#,##0`(scale 0 정수) |  | 구현 |
| D00-3-003 | §3 ColumnHeaderSpan / (0,...,cMMDD_LABEL_NAME) 헤더 span | waterfall.columns.ts:187-203 buildDynamicColumns 1단 그룹 + waterfall.merge.ts:94-106 헤더 가로병합 |  | 구현 |
| D00-3-004 | §3 ColumnHeaderSpan / (1,...,cCOLUMN_LABEL_NAME) | waterfall.columns.ts:193-202 2단 subgroup + waterfall.merge.ts:94-106 |  | 구현 |
| D00-3-005 | §3 ColumnHeaderSpan / (2,...,"SUM") | waterfall.columns.ts:171 3단 leaf header 'SUM'(rank 0/1) |  | 구현 |
| D00-3-006 | §3 SetReNumerCellType / 숫자셀타입 | waterfall.columns.ts:151 format `#,##0` |  | 구현 |
| D00-3-007 | §3 SetReNumerCellType / 숫자셀타입 | waterfall.columns.ts:151 format `#,##0` |  | 구현 |
| D00-3-008 | §3 ForeColor= / 헤더 요일색: Saturday=Blue else Red | WaterfallShipmentPlanFgGrid.tsx:235-263 formatItem SAT/SUN → HEADER_COLORS(waterfall-shipment-plan-fg.constants.ts:99-102) |  | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / (0, iLargeStartCol, ..., sLargeSpanName) | waterfall.columns.ts:187-190 1단 월 그룹 라벨 + waterfall.merge.ts:96-98 largeKeyOf 가로병합 |  | 구현 |
| D00-3-010 | §3 ColumnHeaderSpan / (1, iLargeStartCol, 2,1,..,"SUM") | waterfall.merge.ts:87-91 최상위 합계(월) 2·3단 세로병합 |  | 구현 |
| D00-3-011 | §3 ColumnHeaderSpan / (1, iSmallStartCol, .., sSmallSpanName) | waterfall.columns.ts:193-198 2단 주차 subgroup + waterfall.merge.ts:99 subKeyOf |  | 구현 |
| D00-3-012 | §3 ColumnHeaderSpan / (2, iSmallStartCol, .., "SUM") | waterfall.columns.ts:171 leaf 'SUM'(rank 1 주합) |  | 구현 |
| D00-3-013 | §3 ColumnHeaderSpan / (1, iSmallStartCol, .., sSmallSpanName) | waterfall.columns.ts:193-198 2단 subgroup + waterfall.merge.ts:99 |  | 구현 |
| D00-3-014 | §3 ColumnHeaderSpan / (2, iSmallStartCol, .., "SUM") | waterfall.columns.ts:171 leaf 'SUM' |  | 구현 |
| D00-3-015 | §3 ColumnHeaderSpan / (1, iSmallStartCol, .., sSmallSpanName) | waterfall.columns.ts:193-198 2단 subgroup + waterfall.merge.ts:99 |  | 구현 |
| D00-3-016 | §3 ColumnHeaderSpan / (2, iSmallStartCol, .., "SUM") | waterfall.columns.ts:171 leaf 'SUM' |  | 구현 |
| D00-3-017 | §3 ColumnHeaderSpan / (0, iLargeStartCol, .., sLargeSpanName) | waterfall.columns.ts:187-190 1단 월 그룹 + waterfall.merge.ts:96-98 |  | 구현 |
| D00-3-018 | §3 ColumnHeaderSpan / (1, iLargeStartCol, 2,1,.., "SUM") | waterfall.merge.ts:87-91 최상위 월합 세로병합 |  | 구현 |
| D00-3-019 | §3 SmartColMerge / () | waterfall.merge.ts:56-76 데이터 셀 좌측 누적 세로병합 + Grid:183-188 |  | 구현 |
| D00-3-020 | §3 Query / (dsBinding) 그리드 바인딩 | WaterfallShipmentPlanFgGrid.tsx:99 gridData + Grid:271 DataGrid itemsSource (useTabProcQuery Grid:60/page:87) |  | 구현 |
| D00-3-021 | §3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 잠금(read-only) | WaterfallShipmentPlanFgGrid.tsx:269 DataGrid isReadOnly={true} |  | 구현 |
| D00-3-022 | §3 SmartColMerge / () | waterfall.merge.ts:20-110 WaterfallMergeManager + Grid:183-188 |  | 구현 |
| D00-3-023 | §3 SetValue / (iRow, bef_month_idx, sum_month) 월합 파생 | waterfall.derive.ts:80 monthOf.forEach(apply) 월합 재합산 |  | 구현 |
| D00-3-024 | §3 SetValue / (iRow, bef_month_idx, val) | waterfall.derive.ts:71-77 apply 합산 |  | 구현 |
| D00-3-025 | §3 SetValue / (iRow, bef_week_idx, sum_week) 주합 파생 | waterfall.derive.ts:80 weekOf.forEach(apply) 주합 재합산 |  | 구현 |
| D00-3-026 | §3 SetValue / (iRow, bef_week_idx, val) | waterfall.derive.ts:71-77 apply 합산 |  | 구현 |
| D00-3-027 | §3 SetValue / (iRow, bef_week_idx, sum_week) | waterfall.derive.ts:80 weekOf.forEach(apply) |  | 구현 |
| D00-3-028 | §3 SetValue / (iRow, bef_month_idx, sum_month) | waterfall.derive.ts:81 monthOf.forEach(apply) |  | 구현 |
| D00-3-029 | §3 SetValue / (iRow, bef_week_idx, val) | waterfall.derive.ts:69-70 BALANCE=소속 D_ 마지막(R8) |  | 구현 |
| D00-3-030 | §3 SetValue / (iRow, bef_month_idx, val) | waterfall.derive.ts:69-70 BALANCE=소속 D_ 마지막(R8) |  | 구현 |
| D00-3-031 | §3 SetDblClickColumnShowHide / (sender, e) 기간컬럼 펼침/접기 | WaterfallShipmentPlanFgGrid.tsx:207-232 onDblClick 헤더 드릴(rank 하위 접기/펼치기) |  | 구현 |
| D00-3-032 | §3 ColumnHeaderHeight / (0, 20) 헤더 높이 | WaterfallShipmentPlanFgGrid.tsx:151-180 headerRowHeight 48/tier updatedLayout 강제 |  | 구현 |
| D00-3-033 | §3 Visible= / Daily: isDaily/isWeekly → true | waterfall.periods.ts:56-57 DAILY kind==='D' → true |  | 구현 |
| D00-3-034 | §3 Visible= / Daily: isMonthly/isWeekly → chkSum.Checked | waterfall.periods.ts:58 DAILY W_/M_ → chkSum |  | 구현 |
| D00-3-035 | §3 Visible= / Weekly: isDaily → false | waterfall.periods.ts:52 WEEKLY kind==='D' → false |  | 구현 |
| D00-3-036 | §3 Visible= / Weekly: isWeekly → true | waterfall.periods.ts:53 WEEKLY kind==='W' → true |  | 구현 |
| D00-3-037 | §3 Visible= / Weekly: isMonthly → chkSum.Checked | waterfall.periods.ts:54 WEEKLY M_ → chkSum |  | 구현 |
| D00-3-038 | §3 Visible= / WeeklyISO: isWeeklyISO | waterfall.periods.ts:50 WEEKLY_ISO kind==='W' → true(그 외 숨김) |  | 구현 |
| D00-3-039 | §3 Visible= / Monthly: isDaily/isWeekly → false | waterfall.periods.ts:49 MONTHLY kind!=='M' → false |  | 구현 |
| D00-3-040 | §3 Visible= / Monthly: else → true | waterfall.periods.ts:49 MONTHLY kind==='M' → true |  | 구현 |
| D00-4a-001 | §4a SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL / FindData_Main(736) | WaterfallShipmentPlanFgGrid.tsx:60-66 useTabProcQuery(main) + page:87-93 (SHEETS.MAIN main/SEARCH 배선; PKG_SCP0016 미배포 = 런타임 R01) |  | 구현 |
| D00-4a-002 | §4a SCP.SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL / FindData_Main(779) | useWaterfallShipmentPlanFgStore.ts:196-199 title(캘린더 3span) filters + Grid:60-66 useTabProcQuery(SHEETS.TITLE) |  | 구현 |
| D00-4a-003 | §4a (localConst, 빈 sp명) / GetSpdTitle(1120) | WaterfallShipmentPlanFgGrid.tsx:68-84 titleRows→splitTitleRows→buildDynColMetas (spreadTitle 캘린더 소비, SP_SHEET_NAME waterfall-shipment-plan-fg.constants.ts:29) |  | 구현 |
| D00-4b-001 | §4b FindButton / toolbarOverride / Search | WaterfallShipmentPlanFg.tsx:157-162 handleSearch + page:227 hotkeyConfig.search |  | 구현 |
| D00-4b-002 | §4b EditButton / toolbarOverride / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4b-003 | §4b SaveButton / toolbarOverride / Save |  | 조회전용 화면 — AS-IS NO-OP/미노출, DB 버튼 메타 미등록 | 해당없음 |
| D00-4b-004 | §4b BtnColumn_Click / event / btnColumn | WaterfallShipmentPlanFg.tsx:264 action=setOpenColumnSetting(true) → ColumnLayoutModal(page:307-324) |  | 구현 |
| D00-4b-005 | §4b BtnItem_Id_Click / event / btnItem_Id | WaterfallShipmentPlanFgForm.tsx:189 onClick → page:246 onModelSearch → ItemByDivisionModal(page:288-295) |  | 구현 |
| D00-4b-006 | §4b BtnProject_Click / event / btnProject | WaterfallShipmentPlanFgForm.tsx:189 onClick → page:247 onProjectSearch → ProjectByDivisionModal(page:298-304) |  | 구현 |
| D00-4b-007 | §4b CboDivision_SelectedIndexChanged / event / cboDivision | WaterfallShipmentPlanFgForm.tsx:213 setDivision → useWaterfallShipmentPlanFgStore.ts:149-162 (cascade 재조회) |  | 구현 |
| D00-4b-008 | §4b ClbVersion_SelectedIndexChanged / event / clbVersion | WaterfallShipmentPlanFgForm.tsx:227 setVersions → useWaterfallShipmentPlanFgStore.ts:165-175 (Period 재산정) |  | 구현 |
| D00-4b-009 | §4b SpdMain_CellDoubleClick / event / spdMain | WaterfallShipmentPlanFgGrid.tsx:207-232 onDblClick 헤더 드릴 + WeeklyISO 가드(Grid:212) |  | 구현 |
| D00-4b-010 | §4b SpdMain_TopChange / event / spdMain | WaterfallShipmentPlanFgGrid.tsx:191-203 scrollPositionChanged → invalidate |  | 구현 |
| D00-4b-011 | §4b btnMeasure_Click / event / btnMeasure | WaterfallShipmentPlanFg.tsx:271 action=setOpenMeasureSelect(true) → MeasureSelectModal(page:327-333) |  | 구현 |
| D00-4b-012 | §4b cboBucketType_SelectedIndexChanged / event / cboBucketType | WaterfallShipmentPlanFgForm.tsx:243-245 set bucket → Grid dynamicColumns 재평가(Grid:88-93) |  | 구현 |
| D00-4b-013 | §4b chkSum_CheckedChanged / event / chkSum | WaterfallShipmentPlanFgForm.tsx:265-269 set chkSum → Grid baseVisibleOf 토글(Grid:127) |  | 구현 |
| D00-4b-014 | §4b dCalendar_ValueChanged / event / dCalendar | WaterfallShipmentPlanFgForm.tsx:246-252 PeriodField onChange set from/to |  | 구현 |
| D00-4d-001 | §4d SpdMain_CellDoubleClick / (grid dblclick) | WaterfallShipmentPlanFgGrid.tsx:207-232 host dblclick 리스너 헤더 드릴다운 |  | 구현 |
| D00-4e-001 | §4e SCM0002_TitleSetForm_Popup / ShowDialog(modal) | WaterfallShipmentPlanFg.tsx:307-324 ColumnLayoutModal(btnColumn 'C') |  | 구현 |
| D00-4e-002 | §4e SCM0002_TitleSetForm_Popup / ShowDialog(modal) | WaterfallShipmentPlanFg.tsx:327-333 MeasureSelectModal(btnMeasure 'M') |  | 구현 |
| D00-4e-003 | §4e SCM0002_ItembyDivisionPopup / ShowDialog(modal) | WaterfallShipmentPlanFg.tsx:288-295 ItemByDivisionModal |  | 구현 |
| D00-4e-004 | §4e SCM0002_ProjectbyDivisionPopup / ShowDialog(modal) | WaterfallShipmentPlanFg.tsx:298-304 ProjectByDivisionModal |  | 구현 |
| D00-4e-005 | §4e GSCM...ProgressForm / Show(non-modal) |  | AS-IS 진행중 다이얼로그 = TO-BE react-query isLoading/isFetching 로 대체(별도 로딩 컨트롤 미추가, popups 표·design 04 §5). 화면 로컬 컴포넌트 아님 | 해당없음 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:D00-4b-001:SEARCH | [SEARCH] §4b FindButton / toolbarOverride / Search | WaterfallShipmentPlanFg.tsx:157-162 handleSearch + page:227 hotkeyConfig.search |  | 구현 |
| CRUD:D00-4b-002:EDIT | [EDIT] §4b EditButton / toolbarOverride / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| CRUD:D00-4b-003:SAVE | [SAVE] §4b SaveButton / toolbarOverride / Save |  | 조회전용 화면 — AS-IS NO-OP/미노출, DB 버튼 메타 미등록 | 해당없음 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | WaterfallShipmentPlanFg.tsx:288-295 ItemByDivisionModal · page:298-304 ProjectByDivisionModal · page:307-324 ColumnLayoutModal · page:327-333 MeasureSelectModal (4 공용 모달) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 조회전용 화면 — Insert 미제공(page:229 insert:false, DB 버튼 메타 미등록). 신규행 추가 경로 없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 조회전용 화면 — 편집 상태 없음(isReadOnly, insert/save/delete=false page:229-231). 수정 중 데이터 개념 부재 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | WaterfallShipmentPlanFg.tsx:173-198 handleSaveColumnLayout · page:202-221 handleApplyMeasures — clearFilters()+queryClient.removeQueries()로 기존 데이터 Reset 후 fetchStaticColumns/fetchStaticMeasures 재구성 |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 조회전용 화면 — CRUD 데이터 저장 없음(save/insert/delete=false). Column/Measure 설정 저장 완료는 setToast 사용(page:194/217)이나 데이터 CRUD 완료 알림 대상은 없음 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) |  | 그리드 셀 콤보 0건(전 FPTextBox/FPNumber, design 04 §3-B) — Code→Name 매핑 대상 없음. Excel export 자체는 DataGrid 기본(Grid:279 excelFileName) | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | WaterfallShipmentPlanFgForm.tsx:172-199 popupField(Model/Project) key-in + 모달 콤마조인(ProjectByDivisionModal 반환) → useWaterfallShipmentPlanFgStore.ts:188-189 projectCode/itemId 콤마문자열 그대로 SP IN 파라미터 전달 |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1481-1483 rebindFilterColumns(재조회 시 필터-컬럼 연결 복구) + Grid:281 gridFilterRef 전달(page:281) |  | 구현 |

## 이벤트 (events 11) ↔ TO-BE

| # | AS-IS handler (cs:line) | 효과 | TO-BE 반영 |
|--:|---|---|---|
| 1 | CboDivision_SelectedIndexChanged(601) | SetOperationGroupByDivision(EE 분기 재조회) + SetChangedControl(Version 재조회, Electrode enable) | `useWaterfallShipmentPlanFgStore.setDivision` + Form isEe 콤보 스왑(OperationGroup(EE)_SCP / WaterfallVer_FG2_SCP @divisionId) |
| 2 | ClbVersion_SelectedIndexChanged(607) | dCalendar.InitValue = GetDayRange() | `setVersions` → periodFromVersion(코드 뒤 8자 = 계획시작일, +12개월 근사) |
| 3 | BtnProject_Click(1304) | ProjectbyDivisionPopup → txtProject | `ProjectByDivisionModal` (page onProjectSearch) |
| 4 | BtnItem_Id_Click(1283) | ItembyDivisionPopup → txtItem_Id | `ItemByDivisionModal` (page onModelSearch) |
| 5 | BtnColumn_Click(580) | TitleSetForm 'C' → InitSpread_2 재구성 | SubTitle customButton → `ColumnLayoutModal`('C') → handleSaveColumnLayout |
| 6 | btnMeasure_Click(1324) | TitleSetForm 'M'(Shipment Plan FG) → InitSpread_2 | SubTitle customButton → `MeasureSelectModal` → handleApplyMeasures. titleSet 저장 sheetNm='Shipment Plan FG'(measure sheet — fetchStaticMeasures 와 round-trip, iter-2 G02 교정) |
| 7 | cboBucketType_SelectedIndexChanged(1193) | InitSpread_2+SetSpreadColumn+SetVisibleMontColumns+SetVisibleSum | Grid dynamicColumns(baseVisibleOf) + Form showSum(WeeklyISO 숨김) 재평가 |
| 8 | chkSum_CheckedChanged(1207) | SetSpreadColumn(SUM 컬럼 visible 토글) | searchParams.chkSum → Grid baseVisibleOf(W_/M_) |
| 9 | dCalendar_ValueChanged(1351) | cboBucketType 핸들러 재호출(그리드 재구성) | PeriodField onChange → searchParams from/to (조회 시 재구성) |
| 10 | SpdMain_CellDoubleClick(1051) | WeeklyISO 가드 후 SetDblClickColumnShowHide(펼침/접기) | Grid onDblClick 드릴다운 + `if(bucket===WEEKLY_ISO)return`(buttonGuard #1) |
| 11 | SpdMain_TopChange(592) | SmartColMerge(스크롤 재계산) | Grid scrollPositionChanged → g.invalidate() |

## validations (2) ↔ TO-BE

| # | AS-IS (cs:line) | TO-BE |
|--:|---|---|
| 1 | MSG00109 EditButton 읽기전용 가드(644) | 편집 버튼 미노출(hotkeyConfig.insert/save/delete=false) — read-only 화면(자매 SCP0017/SCP0018 선례) |
| 2 | GMessageBoxForException SetOperationGroupByDivision(908) | 콤보 재조회 실패는 react-query 에러 처리 위임 |

## toolbarOverride (3) ↔ TO-BE hotkeyConfig

| override | AS-IS 본문 | TO-BE |
|---|---|---|
| FindButton(636) | FindData_Main() 실동작 | `hotkeyConfig.search = noDivisionAuth ? false : handleSearch` (main/SEARCH 등록) |
| EditButton(641) | MSG00109 "읽기 전용입니다" 후 return | `insert/save/delete=false`(미노출). AS-IS 버튼은 보였으나 NO-OP, 사내 read-only 선례가 미노출 — self-check §3 예외(근거: 이 문서) |
| SaveButton(648) | NO-OP 빈 `{}` | `save=false`(미노출). 조회전용이라 SAVE 미등록 |

## 조회조건 콤보 (comboCalls 7 → 5 SQL_ID + lookup) ↔ TO-BE (convert-core §2.6 의미 패리티)

| AS-IS code (cs) | TO-BE SQL_ID/lookup | 비고 |
|---|---|---|
| MyDivisionInEE(49) | `MyDivisionInEE_SCP`(@mnuId) | EE 포함(이름 함정) — 표준 MyDivision(EE 제외) 재사용 금지. `COMBO.DIVISION` |
| LookupCommon OPERATION_GROUP(203) | lookup(초기 P/A/E) | 초기 로드. division 선택 시 아래 EE 분기로 스왑(division 자동 기본선택으로 즉시 분기) |
| OperationGroup(928) / OperationGroupEE(932) | `OperationGroup_SCP`{P,A} / `OperationGroupEE_SCP`{A,E} | isEe 로 comboId 스왑(재조회 방식) |
| LookupCommon ELECTRODE_TYPE(206) | lookup `ELECTRODE_TYPE`(다중) | enable=isEe(비EE clear+disable) |
| WaterfallVer_FG2(234) | `WaterfallVer_FG2_SCP`(@divisionId) | 다중 CheckedList, 최신10. 조회조건 저장 제외(ConditionNotUse — TO-BE 조회조건 저장 미구현이라 자동 충족) |
| BucketISO(221) | `BucketISO_SCP` | DAILY/WEEKLY/MONTHLY/WEEKLY_ISO 4옵션, 기본 DAILY |

## popups (5) ↔ TO-BE

| AS-IS | TO-BE |
|---|---|
| SCM0002_TitleSetForm 'C'(btnColumn) | `ColumnLayoutModal` (공용) |
| SCM0002_TitleSetForm 'M'(btnMeasure) | `MeasureSelectModal` (공용) |
| SCM0002_ItembyDivisionPopup | `ItemByDivisionModal` (공용, div 필터) |
| SCM0002_ProjectbyDivisionPopup | `ProjectByDivisionModal` (공용, div 필터) |
| ProgressForm(로딩) | react-query isLoading/isFetching(별도 토스트 미추가) |

## 그리드 동작 파리티 (grid-behavior-parity.md gate-grid-behavior-parity)

전환 대상 `.cs` gridSignals 40 전건은 design 03 §3 R1~R12 에 소진됨. Add*Column 계열 병합 인자는 AS-IS SmartColMerge(siMain) 직접 호출(#1/#19/#22) — grep 토큰 `SmartColMerge` 매칭. TO-BE 매핑:

| AS-IS 동작 (gridSignal #) | TO-BE 기제 | 상태 |
|---|---|---|
| 전 컬럼 Lock(#21, R1) | DataGrid `isReadOnly={true}` | 구현 |
| SmartColMerge 세로병합(#1/#19/#22, R2) | `WaterfallMergeManager`(KEY_IDX 좌측 누적 그룹) + `allowMerging=All` | 구현 |
| TopChange sticky(#19) | scrollPositionChanged → invalidate | 구현 |
| 다단 헤더 span 3단(#3~18, R5) | `buildDynamicColumns`(월/주/SUM) + WaterfallMergeManager 헤더 병합 | 구현 |
| 요일 헤더색(#8, R9) | formatItem SAT=Blue/SUN=Red(HEADER_COLORS) | 구현(색 육안=사용자 확인 축) |
| 더블클릭 펼침/접기(#31, R10) | Grid onDblClick 드릴 + WeeklyISO 가드 | 구현(동작 육안=사용자 확인 축) |
| 헤더높이(#32, R11) | headerRowHeight 48/tier | 구현 |
| BucketType×chkSum visible 8분기(#33~40, R12) | `baseVisibleOf` | 구현 |
| 숫자 셀타입(#2/#6/#7, R4) | dynamicColumns format `#,##0`(정수) | 구현 |
| 그리드 바인딩(#20, R3) | useTabProcQuery → DataGrid itemsSource(derivePeriodSums 적용) | 구현(SP 미배포 = 런타임 미검증) |
| 월/주합 파생 SetValue(#23~30, R6~R8) | `derivePeriodSums`(utils/waterfall.derive) — D_ 만 신뢰 후 W_/M_ FE 재합산, BALANCE=기간 마지막 D_(R8). Grid gridData 로 서버 plain SUM 덮어씀 | 구현(iter-2 G01, 단위테스트 waterfall.derive.test) |

## 확인 필요 / 잔여 (정직 보고)

1. **PKG_SCP0016 미배포** — 메인 조회 런타임 미검증. convert-sp 후속. 캘린더(spreadTitle)는 공용 PKG_COM0000 SP(VALID) 재사용이라 런타임 가능.
2. **월/주합(W_/M_) 계산 위치**(design 03 §6-2, iter-2 G01 해소) — AS-IS 패리티(FE 재합산)로 확정 구현. `derivePeriodSums` 가 D_ 만 신뢰해 W_/M_=ΣD_, BALANCE=기간 마지막 D_(R8) 로 재합산하고 서버 plain SUM 을 덮어쓴다. 소속 D_ 가 없으면(ISO 주) 서버값 유지. SP 미배포라 서버 반환값과의 값 동일성(비-BALANCE) 대사는 런타임(convert-sp 후) 확인 축으로 남는다.
3. **DateUtil.GetDayRange 산식**(design 02 §7, iter-2 G03 부분 해소) — `getDayRange(division, bucket, fromDate)` 로 이식. 반영: (a) 12개월 offset(자매 SCP0017 DateUtil.cs:156 실측), (b) bucket MONTHLY 는 anchor 월초 정렬. **미반영(확인필요)**: division 별 offset 차등 — AS-IS 원본(회사 소스) 접근 차단으로 근거 실측 불가, anti-simplification 상 임의 부여 금지. 정본 산식은 공통 유틸/SP 확정 후 반영.
4. **ISO 캘린더 소싱** — 공용 3SPAN SP 는 start/end 2-IN 뿐(ISO 파라미터 없음). WeeklyISO 주(_ISO) 컬럼이 공용 SP 로 나오는지, 아니면 별도 ISO SP 필요한지는 런타임(convert-sp/runtime-parity) 확정. FE 는 W_ 패턴을 ISO/비ISO 공통 수용.
5. **요일 헤더색/드릴다운/병합 시각** — 브라우저 육안·조작감 축(사용자 확인 축) = 미확인.
