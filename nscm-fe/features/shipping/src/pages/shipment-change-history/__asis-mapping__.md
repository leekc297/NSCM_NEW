# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 FromSite / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-002 | §1 Incotemrs / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-003 | §1 ShipmentDate / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-004 | §1 ToSite / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-005 | §1 TransportMode / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-006 | §1 btnItemId / UsrButton | components/ShipmentChangeHistoryForm.tsx:300-307 | Model 팝업 오픈 버튼('...') → onOpenModelPopup | 구현 |
| D00-1-007 | §1 chkCurrent / UsrCheckBox | components/ShipmentChangeHistoryForm.tsx:356-361 | Current 체크박스 → sc.chkCurrent 토글 | 구현 |
| D00-1-008 | §1 clbDivision / UsrCheckedList | components/ShipmentChangeHistoryForm.tsx:142-152 | Division CustomDropdown(multiple, MyDivisionInEE_SCP) | 구현 |
| D00-1-009 | §1 clbFromSite / UsrCheckedList | components/ShipmentChangeHistoryForm.tsx:164-174 | From Site CustomDropdown(multiple, EE 분기 comboId) | 구현 |
| D00-1-010 | §1 clbIncomterms / UsrCheckedList | components/ShipmentChangeHistoryForm.tsx:206-215 | Incoterms CustomDropdown(multiple, ssp0019_Incoterms_SCP) | 구현 |
| D00-1-011 | §1 clbToSite / UsrCheckedList | components/ShipmentChangeHistoryForm.tsx:185-195 | To Site CustomDropdown(multiple, EE 분기 comboId) | 구현 |
| D00-1-012 | §1 clbTransportMode / UsrCheckedList | components/ShipmentChangeHistoryForm.tsx:227-236 | Trans Mode CustomDropdown(multiple, ssp0019_TransportMode_SCP) | 구현 |
| D00-1-013 | §1 components / Container | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-014 | §1 drpPeriod / UsrDateRangePicker | components/ShipmentChangeHistoryForm.tsx:248-277 | Shipment Date 기간 range(DatePickerCalendar × 2) | 구현 |
| D00-1-015 | §1 emptySpaceItem4 / EmptySpaceItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem6 / EmptySpaceItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem7 / EmptySpaceItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-018 | §1 imageList1 / ImageList | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-019 | §1 layoutControlGroup1 / LayoutControlGroup | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-020 | §1 layoutControlItem1 / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-021 | §1 layoutControlItem2 / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-022 | §1 layoutControlItem3 / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-023 | §1 lblItemId / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-024 | §1 lblSONo / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-025 | §1 lcDivision / LayoutControlItem | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-026 | §1 spdMain / FpSpread | components/ShipmentChangeHistoryGrid.tsx:130-140 | 공용 DataGrid(spdMain 단일 그리드) | 구현 |
| D00-1-027 | §1 spdMain_Sheet1 / SheetView | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-028 | §1 splitter1 / Splitter | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-029 | §1 txtConfirmId / UsrMultiLineEditor | components/ShipmentChangeHistoryForm.tsx:338-344 | Confirm ID InputField(콤마 다중) | 구현 |
| D00-1-030 | §1 txtItemId / UsrMultiLineEditor | components/ShipmentChangeHistoryForm.tsx:293-299 | Model InputField(콤마 다중) | 구현 |
| D00-1-031 | §1 txtSoNo / UsrMultiLineEditor | components/ShipmentChangeHistoryForm.tsx:320-326 | SO No InputField(콤마 다중) | 구현 |
| D00-1-032 | §1 usrConditionPanel1 / UsrConditionPanel | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-033 | §1 usrLayoutControl1 / UsrLayoutControl | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-2-001 | §2 btnItemId / Click | ShipmentChangeHistory.tsx:157,182-191 | onOpenModelPopup → ItemByDivisionModal 오픈(division/scmSite/itemId 사전필터) | 구현 |
| D00-2-002 | §2 chkCurrent / CheckedChanged | ShipmentChangeHistory.tsx:67-73 | displayRows 필터(체크=LAST_SEQ='C' 만) + Grid formatItem 강조 | 구현 |
| D00-2-003 | §2 clbDivision / SelectedIndexChanged | components/ShipmentChangeHistoryForm.tsx:109-119,60-63 | handleDivisionChange(하위 4콤보 초기화) + EE 분기 comboId + divisionCsv 재조회 | 구현 |
| D00-2-004 | §2 spdMain / CellClick | components/ShipmentChangeHistoryGrid.tsx:104-114 | REQUEST_NO 셀 클릭 가드(값 존재) → onRequestNoClick 드릴다운 | 구현 |
| D00-2-005 | §2 spdMain / TopChange | components/ShipmentChangeHistoryGrid.tsx:139 | 공용 DataGrid allowMerging=All(스크롤 시 병합 유지, CustomMergeManager) | 구현 |
| D00-3-001 | §3 Freeze / (0, GetColumnIndex(CONFIRM_ID)+1) | shipment-change-history.constants.ts:71-74 | FREEZE_COLUMN_COUNT=7 — 실제 고정은 SCM_MST_SHEET_COLUMNS.FIXED_FLAG 메타(05_register.sql) → DataGrid frozenColumns | 구현 |
| D00-3-002 | §3 VisibleTab / (true) | — | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-3-003 | §3 Query / (dsBinding) | components/ShipmentChangeHistoryGrid.tsx:133-134 | DataGrid itemsSource=rows(useTabProcQuery o_rc1 바인딩) | 구현 |
| D00-3-004 | §3 LockColumn / (0, GetMaxColumnIndex(), true) — 전열 잠금(읽기전용) | components/ShipmentChangeHistoryGrid.tsx:133 + utils/shipmentChangeHistoryColumns.ts:57-58 | DataGrid isReadOnly + fallback INPUT_TP_CD 전건 SEARCH_ONLY('S') | 구현 |
| D00-3-005 | §3 SmartColMerge / () | components/ShipmentChangeHistoryGrid.tsx:139 | allowMerging=AllowMerging.All(CustomMergeManager) | 구현 |
| D00-3-006 | §3 SetBGColor / (i, SEQ..MaxCol, LightSkyBlue 80) | components/ShipmentChangeHistoryGrid.tsx:91-100 | formatItem LAST_SEQ='C' → CURRENT_ROW_BG(rgba 135,206,250,0.8) | 구현 |
| D00-3-007 | §3 VisibleRow / (i, true) | ShipmentChangeHistory.tsx:67-73 | displayRows(chkCurrent 해제=전행 표시) | 구현 |
| D00-3-008 | §3 VisibleRow / (i, false) | ShipmentChangeHistory.tsx:69-71 | displayRows(chkCurrent 체크=비-'C' 행 숨김) | 구현 |
| D00-3-009 | §3 VisibleRow / (0, RowCount-1, true) | ShipmentChangeHistory.tsx:72 | displayRows(체크 해제 시 rows 전건 반환) | 구현 |
| D00-3-010 | §3 SetBGColor / (i, SEQ..MaxCol, LightSkyBlue 80) | components/ShipmentChangeHistoryGrid.tsx:96-98 | formatItem 'C' 행 배경색(공통 강조, D00-3-006 동일 핸들러) | 구현 |
| D00-3-011 | §3 SmartColMerge / () | components/ShipmentChangeHistoryGrid.tsx:139 | allowMerging=All 재적용(TopChange 스크롤 유지, D00-3-005 동일 배선) | 구현 |
| D00-4a-001 | §4a SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY / FindData_Main (line 409) | useShipmentChangeHistoryStore.ts:84-108 + ShipmentChangeHistory.tsx:55-61 | setFilter 12파라미터 매핑 → useTabProcQuery(SP 미배포, 배선 완비) | 구현 |
| D00-4a-002 | §4a SCP.GET_DATE_RANGE_1MONTH / GetDayRange (line 522) | ShipmentChangeHistory.tsx:81-86 | mount 시 기본 기간 오늘~+1개월(dayjs) 세팅 | 구현 |
| D00-4b-001 | §4b FindButton / toolbarOverride / Search | ShipmentChangeHistory.tsx:91-125,138 | handleSearch(권한/기간 검증 → setFilter) + hotkeyConfig.search(hasButton) | 구현 |
| D00-4b-002 | §4b btnItemId_Click / event / btnItemId.Click | ShipmentChangeHistory.tsx:157 + components/ShipmentChangeHistoryForm.tsx:300-307 | onOpenModelPopup → ItemByDivisionModal | 구현 |
| D00-4b-003 | §4b DeleteButton / toolbarOverride / Delete | ShipmentChangeHistory.tsx:140 | 조회전용 inquiry — AS-IS NO-OP 공백, hotkeyConfig.delete=false·DB 버튼메타 SEARCH 만 등록 | 해당없음 |
| D00-4b-004 | §4b EditButton / toolbarOverride / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4b-005 | §4b InsertButton / toolbarOverride / Insert | ShipmentChangeHistory.tsx:139 | 조회전용 inquiry — AS-IS NO-OP 공백, hotkeyConfig.insert=false·DB 버튼메타 SEARCH 만 등록 | 해당없음 |
| D00-4b-006 | §4b SaveButton / toolbarOverride / Save | ShipmentChangeHistory.tsx:141 | 조회전용 inquiry — AS-IS NO-OP 공백, hotkeyConfig.save=false·DB 버튼메타 SEARCH 만 등록 | 해당없음 |
| D00-4b-007 | §4b ChkCurrent_CheckedChanged / event / chkCurrent.CheckedChanged | ShipmentChangeHistory.tsx:67-73 + components/ShipmentChangeHistoryForm.tsx:356-361 | Current 체크박스 change → displayRows 'C' 행 필터 토글 | 구현 |
| D00-4b-008 | §4b SpdMain_CellClick / event / spdMain.CellClick | components/ShipmentChangeHistoryGrid.tsx:104-114 | REQUEST_NO 값 존재 가드 → onRequestNoClick 드릴다운 | 구현 |
| D00-4b-009 | §4b SpdMain_TopChange / event / spdMain.TopChange | components/ShipmentChangeHistoryGrid.tsx:139 | allowMerging=All(스크롤 병합 유지, CustomMergeManager) | 구현 |
| D00-4b-010 | §4b clbDivision_SelectedIndexChanged / event / clbDivision.SelectedIndexChanged | components/ShipmentChangeHistoryForm.tsx:109-119,60-63 | handleDivisionChange 하위콤보 초기화 + EE 분기 + divisionCsv 재조회 | 구현 |
| D00-4e-001 | §4e SCM0002_ShipmentPlanRequestPopup / ShowDialog | components/modals/ShipmentPlanRequestModal.tsx:15-42 + ShipmentChangeHistory.tsx:194-198 | REQUEST_NO 드릴다운 모달(트리거·가드·파라미터 구현, 상세는 SP 배포 후 유예) | 구현 |
| D00-4e-002 | §4e SCM0002_ItembyDivisionPopup / ShowDialog | components/modals/ItemByDivisionModal.tsx:43-195 + ShipmentChangeHistory.tsx:182-191 | Item by Division 팝업(로컬, division/scmSite/itemId 사전필터) | 구현 |
| D00-4e-003 | §4e GSCM.Windows.Forms.UI.ProgressForm / Show | components/modals/ItemByDivisionModal.tsx:155-160 | 공용 로딩(ProgressIndicator/useTabProcQuery isLoading — 별도 팝업 불요) | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:D00-4b-001:SEARCH | [SEARCH] §4b FindButton / toolbarOverride / Search | ShipmentChangeHistory.tsx:91-125,138 | handleSearch(권한/기간 검증 → setFilter) + hotkeyConfig.search(hasButton('SEARCH')) | 구현 |
| CRUD:D00-4b-003:DELETE | [DELETE] §4b DeleteButton / toolbarOverride / Delete | ShipmentChangeHistory.tsx:140 | 조회전용 inquiry — AS-IS NO-OP 공백, hotkeyConfig.delete=false·DB 버튼메타 SEARCH 만 등록 | 해당없음 |
| CRUD:D00-4b-004:EDIT | [EDIT] §4b EditButton / toolbarOverride / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| CRUD:D00-4b-005:INSERT | [INSERT] §4b InsertButton / toolbarOverride / Insert | ShipmentChangeHistory.tsx:139 | 조회전용 inquiry — AS-IS NO-OP 공백, hotkeyConfig.insert=false·DB 버튼메타 SEARCH 만 등록 | 해당없음 |
| CRUD:D00-4b-006:SAVE | [SAVE] §4b SaveButton / toolbarOverride / Save | ShipmentChangeHistory.tsx:141 | 조회전용 inquiry — AS-IS NO-OP 공백, hotkeyConfig.save=false·DB 버튼메타 SEARCH 만 등록 | 해당없음 |
| MODAL:ItemByDivisionModal | FE 실존 모달 (components/modals/ItemByDivisionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/ItemByDivisionModal.tsx:43-195 + ShipmentChangeHistory.tsx:182-191 | AS-IS SCM0002_ItembyDivisionPopup(Model 조회조건) 로컬 복사 — division/scmSite/itemId 사전필터 | 구현 |
| MODAL:ShipmentPlanRequestModal | FE 실존 모달 (components/modals/ShipmentPlanRequestModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/ShipmentPlanRequestModal.tsx:15-42 + ShipmentChangeHistory.tsx:194-198 | AS-IS SCM0002_ShipmentPlanRequestPopup(REQUEST_NO 드릴다운) 로컬 — 트리거·가드·파라미터 구현, 상세는 SP 배포 후 유예 | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | components/modals/ItemByDivisionModal.tsx:107-193 + components/modals/ShipmentPlanRequestModal.tsx:17-41 | AS-IS 두 ShowDialog(ItembyDivision/ShipmentPlanRequest) → CustomDialog 모달 2종 | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 조회전용 inquiry — 신규행 Insert 없음(hotkeyConfig.insert=false, ShipmentChangeHistory.tsx:139). 대상 시나리오 미해당 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | — | 조회전용 inquiry — 편집 없음(전열 isReadOnly, ShipmentChangeHistoryGrid.tsx:133). 수정 중 상태 자체가 없어 confirm 미해당 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | — | 이 화면에 Column Set / Measure 설정 모달 없음(grep 무매치). Column 설정 적용 핸들러 부재로 Reset 후 재조회 대상 미해당(pivot 아님) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | — | 조회전용 inquiry — CRUD 완료 이벤트 없음(SEARCH 만 동작). 완료 Toast 대상 미해당 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | components/ShipmentChangeHistoryGrid.tsx:84-87 + ShipmentChangeHistory.tsx:162-165 | 셀콤보 3종 col.dataMap 주입(FCST_TYPE/CHANGE_REASON_CODE 직접 주입, DIVISION_ID auto-wire) → SubTitle grid+gridFilter 로 Excel export 시 wijmo 가 dataMap 으로 Name 렌더 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useShipmentChangeHistoryStore.ts:99-102 + components/ShipmentChangeHistoryForm.tsx:293-344 | Model/SO No/Confirm ID InputField 원문(콤마 포함) → setFilter p_item_id/p_sono/p_confirm_id 로 SP 에 그대로 전달(trimOrEmpty, join 안 함) | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ShipmentChangeHistoryGrid.tsx:132 + ShipmentChangeHistory.tsx:35,163 | 공용 DataGrid gridFilterRef 배선(FlexGridFilter 유지·rebind, DataGrid.tsx:1196 / 1110-1112) — 재조회 시 필터 상태 보존 | 구현 |

## 1. 이벤트/진입점 (events 5 + entryPoints 10)

| AS-IS `.cs:line` | AS-IS 동작 | TO-BE 구현 | 축 |
|---|---|---|---|
| FindButton (347) `FindData_Main()` | 조회 실행 | `ShipmentChangeHistory.handleSearch` → `setFilter` → `useTabProcQuery` | event |
| btnItemId_Click (214) | Model 팝업 오픈 | `ShipmentChangeHistoryForm.onOpenModelPopup` → `ItemByDivisionModal` | event |
| clbDivision_SelectedIndexChanged (235) `SetChangedControl` | Division cascade(4자식 재조회) + EE 분기 | `Form.handleDivisionChange`(하위 선택 초기화) + 동적 comboId(EE 분기) + divisionCsv @divisionId 재조회 | event/combo |
| ChkCurrent_CheckedChanged (241) `SetCheckRow` | 현재값 행 표시/강조 토글 | `Page.displayRows` 필터(체크=LAST_SEQ='C') + `Grid.formatItem`('C' 행 LightSkyBlue) | event/grid |
| SpdMain_CellClick (199) | REQUEST_NO 이미지셀 드릴다운 | `Grid` click 핸들러(REQUEST_NO 가드) → `onRequestNoClick` → `ShipmentPlanRequestModal` | event/grid |
| SpdMain_TopChange (533) SmartColMerge 재적용 | 스크롤 시 병합 유지 | 공용 DataGrid `allowMerging=All` + CustomMergeManager sticky(hook69) | grid |
| InsertButton/DeleteButton/EditButton/SaveButton (352~367) | **NO-OP**(빈 본문) | `hotkeyConfig.insert/delete/save=false` (admin 메타 미등록=미노출, 읽기전용 화면별 확정). `false` 근거: AS-IS 본문 완전 공백 = 무동작, TO-BE 는 SEARCH 한정 등록(design 01 §4d) | button |

주의(hotkeyConfig false 근거 — self-check 예외 조항): 편집 4버튼은 AS-IS 에서 본문 공백 NO-OP 였고, TO-BE 는 admin 버튼메타에 SEARCH 만 등록(05_register.sql)해 미노출한다. skill self-check 는 NO-OP 버튼에 `() => undefined`(노출 유지)를 요구하나, "화면별 별도 확정으로 숨김"은 예외로 `false` 허용 — 본 화면은 design 01 §4d/goal 이 SEARCH 한정 등록으로 확정했으므로 `false`(미노출)가 정합이다.

## 2. 콤보/데이터소스 (comboCalls 7 + inner-table 1)

| AS-IS `.cs:line` CODE | TO-BE SQL_ID | TO-BE 위치 | 축 |
|---|---|---|---|
| MyDivision inner-table (170,273) + EE literal 제외 | `MyDivisionInEE_SCP` + FE `code!=='EE'` 필터 | `Form.divisionOptions` (filter EE) | combo |
| PlantSiteByDivision (297, 비-EE) / ShipmentPlanPlantSite (302, EE) | `PlantSiteByDivision_SCP` / `ShipmentPlanPlantSite_SCP` | `Form.fromSiteComboId`(EE 분기) | combo |
| SSPToSiteByDivision (298, 비-EE) / ShipmentPlanToSite (303, EE) | `SSPToSiteByDivision_SCP` / `ShipmentPlanToSite_SCP` | `Form.toSiteComboId`(EE 분기) | combo |
| ssp0019_Incoterms (306) | `ssp0019_Incoterms_SCP` (@divisionId) | `Form` Incoterms | combo |
| ssp0019_TransportMode (307) | `ssp0019_TransportMode_SCP` (@divisionId) | `Form` Trans Mode | combo |
| GET_DATE_RANGE_1MONTH (284,522) | 오늘 기준 1개월(dayjs) | `Page` mount 기본 기간 세팅 | combo/init |
| 셀콤보 CHANGE_REASON_CODE_ALL (334) | lookup `CHANGE_REASON_CODE`(직접 fetch, CODE=SEG1/표시 'CODE : 명') | `Grid.changeReasonMap` → col.dataMap 주입 | grid combo |
| 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE) | lookup `SALES_TYPE_CODE`(직접 fetch, CODE=SEG1/NAME=SEG2) | `Grid.fcstTypeMap` → col.dataMap 주입 | grid combo |
| 셀콤보 DIVISION_ID (Division) | `Division`(CODE=NAME, lookupType 불요) | admin 메타 auto-wire(comboParams @mnuId) | grid combo |

## 3. 그리드 규칙 (gridSignals 11 + 이미지셀 + 셀콤보)

| AS-IS `.cs:line` | 규칙 | TO-BE 구현 | 축 |
|---|---|---|---|
| Freeze(0, CONFIRM_ID+1) (336) | 좌측 7열 고정 | `SCM_MST_SHEET_COLUMNS.FIXED_FLAG='Y'`(SORT_ORDER_NO 1~7, 05_register.sql) → DataGrid frozenColumns=7 | grid |
| LockColumn(0,max,true) (438) | 전열 읽기전용 | `DataGrid isReadOnly` + INPUT_TP_CD 전건 'S' | grid |
| SmartColMerge (440,536) | 세로 병합 + 스크롤 유지 | `allowMerging=All` + CustomMergeManager(hook69) | grid |
| SetBGColor LightSkyBlue (471,487) | 'C' 행 강조 | `Grid.formatItem` LAST_SEQ='C' → CURRENT_ROW_BG | grid |
| VisibleRow (472,476,482) | chkCurrent 행 표시 토글 | `Page.displayRows` 필터 | grid |
| REQUEST_NO cellTypeImage (339) + 가드(201,205) | 값 존재 시 드릴다운 | `Grid` click(REQUEST_NO && 값존재) → 팝업 | grid |
| 셀콤보 dataMap (334) | 코드→명 표시 | `Grid` lookup 직접 fetch dataMap 주입 | grid |

## 4. 팝업 (popups 3)

| AS-IS | TO-BE | 축 |
|---|---|---|
| SCM0002_ItembyDivisionPopup (Model, 221) | `components/modals/ItemByDivisionModal`(로컬 복사) | popup |
| SCM0002_ShipmentPlanRequestPopup (REQUEST_NO 드릴다운, 207) | `components/modals/ShipmentPlanRequestModal`(로컬, SP 미배포로 상세 유예) | popup |
| ProgressForm (376) | 공용 로딩(별도 팝업 불요) | - |

## 5. SP 계약

| AS-IS SP | TO-BE | 상태 |
|---|---|---|
| SSP0019_GET_SHIPMENT_CHANGE_HISTORY (12파라미터, 47컬럼 반환) | `PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | **미배포** — `store.setFilter` 12파라미터 배선 완비, 실행은 convert-sp 배포 후 |

## 6. 미이식/유예 (정직 보고)

- REQUEST_NO 드릴다운 상세 데이터: SCM0002 별도 팝업 전환 + SP 배포 대상 — 트리거·가드·파라미터까지 구현, 상세 convert-sp 유예.
- 셀콤보 코드→명 표시(FCST_TYPE/CHANGE_REASON_CODE): dataMap 주입 배선 완비, 런타임 표시는 SP 배포 후 브라우저 실검증(사용자 축).
- 기본 조회기간 1개월 방향(from=오늘/to=오늘+1개월): GET_DATE_RANGE_1MONTH SP 미접근으로 브라우저 실검증 대상(사용자 축).
