# __asis-mapping__.md — DMF0052 design 번호 1:1 대사표 (TobeGen 초기본 — Fact Pack 기준)

> 원천: Doc/asisfacts/screens/DMF0052 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 splitContainer1 / SplitContainer |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-002 | §1 splitContainer2 / SplitContainer |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 spdSummary / FpSpread | components/Dmf0052GridSummary.tsx (DataGrid ← SUMMARY) |  | 구현 |
| D00-1-004 | §1 spdSummary_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-005 | §1 spdSummaryPJT / FpSpread | components/Dmf0052GridSummaryPjt.tsx (DataGrid ← Summary Pjt) |  | 구현 |
| D00-1-006 | §1 spdSummaryPJT_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-007 | §1 usrLayoutControl1 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-008 | §1 btnRefresh / SimpleButton | Dmf0052.tsx:127 (customButtons → handleRefresh) |  | 구현 |
| D00-1-009 | §1 chkToday / UsrCheckBox | components/Dmf0052Form.tsx (Checkbox) |  | 구현 |
| D00-1-010 | §1 txtItemId / UsrMultiLineEditor | components/Dmf0052Form.tsx (ItemField 카탈로그 + 팝업 내장) |  | 구현 |
| D00-1-011 | §1 txtProject / UsrMultiLineEditor | components/Dmf0052Form.tsx (ProjectField 카탈로그 + 팝업 내장) |  | 구현 |
| D00-1-012 | §1 btnProject / UsrButton | components/Dmf0052Form.tsx (ProjectField 내장 팝업) |  | 구현 |
| D00-1-013 | §1 btnItemId / UsrButton | components/Dmf0052Form.tsx (ItemField 내장 팝업) |  | 구현 |
| D00-1-014 | §1 drpPeriod / UsrDateRangePicker | components/Dmf0052Form.tsx (PeriodField 카탈로그) |  | 구현 |
| D00-1-015 | §1 clbEDISender / UsrCheckedList | components/Dmf0052Form.tsx (CustomDropdown) |  | 구현 |
| D00-1-016 | §1 layoutControlGroup1 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-018 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-019 | §1 lblProject / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-020 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-021 | §1 lblModel / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-022 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-023 | §1 Period / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-024 | §1 lblEDISender / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-025 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-026 | §1 splitContainer3 / SplitContainer |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-027 | §1 spdSummaryStatus / FpSpread | components/Dmf0052GridSummaryStatus.tsx (DataGrid ← Summary Status) |  | 구현 |
| D00-1-028 | §1 spdSummaryStatus_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-029 | §1 spdData / FpSpread | components/Dmf0052GridData.tsx (DataGrid ← ERP Data/GSCM Data) |  | 구현 |
| D00-1-030 | §1 spdData_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-031 | §1 imageList1 / ImageList |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 spdSummaryPJT / CellDoubleClick | components/Dmf0052GridSummaryPjt.tsx:40 (handlePjt → CHECK_GSCM_CNT/CHECK_ERP_CNT 분기 + setActiveSheetData + setSelectedPjtKey, V-003 가드) |  | 구현 |
| D00-2-002 | §2 btnRefresh / Click | Dmf0052.tsx:106 (handleRefresh → setActiveSheetData(GSCM_DATA)+bumpDataRefreshKey) |  | 구현 |
| D00-2-003 | §2 chkToday / CheckedChanged | components/Dmf0052Form.tsx:38 (handleTodayChange → setSearchParams today/periodFrom/periodTo) |  | 구현 |
| D00-2-004 | §2 btnProject / Click | components/Dmf0052Form.tsx:74 (ProjectField 내장 팝업 — division/value/onChange 바인딩) |  | 구현 |
| D00-2-005 | §2 btnItemId / Click | components/Dmf0052Form.tsx:67 (ItemField 내장 팝업 — division/value/onChange 바인딩) |  | 구현 |
| D00-2-006 | §2 spdData / ActiveSheetChanging | Dmf0052.tsx:130 (dataCustomButtons → setActiveSheetData ERP_DATA/GSCM_DATA, 단일 DataGrid 가 store.activeSheetData 구독) |  | 구현 |
| D00-2-007 | §2 spdData / CellDoubleClick | components/Dmf0052GridData.tsx:30 (handleData → setSelectedDataRow + setOpenGSCMDataModal, V-004 가드) |  | 구현 |
| D00-2-008 | §2 this / Load | Dmf0052.tsx (useEffect) (handleForm 스텁) |  | 구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 DM.DMF0052_GET_SUMMARY_DATA / DMF0052_GET_SUMMARY_DATA | Dmf0052.tsx:50 (useTabProcQuery SHEETS.SUMMARY) + Doc/gen/DMF0052/register.json/procs[0] + DMF0052_PKG.sql P_DMF0052_GET_SUMMARY_DATA |  | 구현 |
| D00-4-002 | §4 DM.DMF0052_GET_PJT_DATA / DMF0052_GET_PJT_DATA | Dmf0052.tsx:59 (useTabProcQuery SHEETS.SUMMARY_PJT) + Doc/gen/DMF0052/register.json/procs[1] + DMF0052_PKG.sql P_DMF0052_GET_PJT_DATA |  | 구현 |
| D00-4-003 | §4 DM.DMF0052_GET_STATUS_DATA / DMF0052_GET_STATUS_DATA | Dmf0052.tsx:68 (useTabProcQuery SHEETS.SUMMARY_STATUS) + Doc/gen/DMF0052/register.json/procs[2] + DMF0052_PKG.sql P_DMF0052_GET_STATUS_DATA |  | 구현 |
| D00-4-004 | §4 DM.DMF0052_GET_DETAIL_DATA / DMF0052_GET_DETAIL_DATA | Dmf0052.tsx:90 (useTabProcQuery activeSheetData — GSCM Data 분기 FindData_GSCMData) + Doc/gen/DMF0052/register.json/procs[3] + DMF0052_PKG.sql P_DMF0052_GET_DETAIL_DATA |  | 구현 |
| D00-4-005 | §4 DM.DMF0052_GET_ERP_DATA / DMF0052_GET_ERP_DATA | Dmf0052.tsx:90 (useTabProcQuery activeSheetData — ERP Data 분기 FindData_ERPData) + Doc/gen/DMF0052/register.json/procs[4] + DMF0052_PKG.sql P_DMF0052_GET_ERP_DATA |  | 구현 |
| D00-4-006 | §4 DM.DMF0052_GET_SPREAD_TITLE / DMF0052_GET_SPREAD_TITLE |  | 그리드 헤더 메타 → /admin/menu/{MENU}/column(SCM_MST_SHEET_COLUMNS) + spreadTitle 시트(동적 헤더 SP) | 해당없음 |
| D00-4-007 | §4 DM.UP_FX_GetCommonDataList_DM / UP_FX_GETCOMMONDATALIST_DM |  | 공통 콤보 조회 → useTabComboQueries(콤보ID 등록) | 해당없음 |
| D00-4-008 | §4 DM.DMF0052_GET_SITE_POPUP / DMF0052_GET_SITE_POPUP | components/modals/GSCMDataModal.tsx:43 (useTabProcQuery SHEETS.EDI_SUMMARY_GSCM_DATA_POPUP ← 팝업 조회 SP) + Doc/gen/DMF0052/register.json/procs[7] + DMF0052_PKG.sql P_DMF0052_GET_SITE_POPUP |  | 구현 |

## POPUP 매핑 (룰 25 §3 — button/SP/event/validation 4축)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-P-001 | §P DMF0052_GSCMDataPopup / 팝업(이벤트 3, SP 1: DMF0052_GET_SITE_POPUP) | components/modals/GSCMDataModal.tsx (CustomDialog + DataGrid + useTabProcQuery SHEETS.EDI_SUMMARY_GSCM_DATA_POPUP + handleSearch(preSearchParams+selectedRow 키 머지) + Load useEffect + Confirm/Cancel) · 트리거 Dmf0052GridData.tsx:30(spdData_CellDoubleClick → setSelectedDataRow/setOpenGSCMDataModal) + Dmf0052.tsx:138(handleModalSelect 반환값 소비) |  | 구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'EDI Summary GSCM DATA Popup' / 코드 하드코딩 전용(메타 없음) (9컬럼) | components/modals/GSCMDataModal.tsx (SHEETS.EDI_SUMMARY_GSCM_DATA_POPUP) | 모달 DataGrid staticColumns — 9컬럼은 DMF0052_registration.sql 로 메타 등록(store 가 /admin/menu/DMF0052/column 로 로드) | 구현 |
| D00-5-002 | §5 시트 'ERP Data' / META+코드연결 (10컬럼) | components/Dmf0052GridData.tsx (SHEETS.ERP_DATA) |  | 구현 |
| D00-5-003 | §5 시트 'GSCM Data' / META+코드연결 (10컬럼) | components/Dmf0052GridData.tsx (SHEETS.GSCM_DATA) |  | 구현 |
| D00-5-004 | §5 시트 'Site Popup' / 메타 정의만, 코드 미참조(미사용 가능) (9컬럼) |  | 메타 정의만 있고 As-is 코드 미참조(미사용) — 실제 팝업은 'EDI Summary GSCM DATA Popup' 하드코딩 시트 사용, 등록·배선 생략 | 제외 |
| D00-5-005 | §5 시트 'SUMMARY' / META+코드연결 (4컬럼) | components/Dmf0052GridSummary.tsx (SHEETS.SUMMARY) |  | 구현 |
| D00-5-006 | §5 시트 'Summary Pjt' / META+코드연결 (8컬럼) | components/Dmf0052GridSummaryPjt.tsx (SHEETS.SUMMARY_PJT) |  | 구현 |
| D00-5-007 | §5 시트 'Summary Status' / META+코드연결 (4컬럼) | components/Dmf0052GridSummaryStatus.tsx (SHEETS.SUMMARY_STATUS) |  | 구현 |
