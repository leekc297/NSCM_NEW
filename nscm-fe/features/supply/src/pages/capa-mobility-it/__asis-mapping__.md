# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | `CapaMobilityItForm.tsx` (Division FormItem, `FIXED_DIVISION`) | | 구현 |
| D00-1-002 | §1 btnCopyData / UsrButton | `CapaMobilityIt.tsx` (SubTitle customButtons Copy Data → `setCopyOpen`) | | 구현 |
| D00-1-003 | §1 btnInput / UsrButton | `BulkUpdateModal` (Bulk Update 팝업으로 대체 — To-Be 문서 SCP0098) |  | 구현 |
| D00-1-004 | §1 btnItemId / UsrButton | `CapaMobilityItForm.tsx` (Model/Nickname 돋보기 → `setOpenItem`, `ItemByDivisionModal`(COM0008, btnItemId_Click cs:3391 1:1 교정)) | | 구현 |
| D00-1-005 | §1 btnMeasure / UsrButton | | Measure 설정 버튼 복원(2026-10-13) — SubTitle customButtons 에 `hasButton('MEASURE_SELECT')` 게이트로 `setMeasureOpen` | 구현 |
| D00-1-006 | §1 cboBucketType / UsrCombo | | To-Be 문서(SCP0098) Bucket 조회조건 삭제 — `DEFAULT_BUCKET`(DAILY) 고정 | 제외 |
| D00-1-007 | §1 cboCategory / UsrCombo | `CapaMobilityIt.tsx` `handleBulkOpen` (팝업에는 Category 입력 없음) | 기획 확정(2026-10-13): 대상 measure 는 화면에 measure 가 하나뿐이면 그 measure, 여럿이면 팝업을 열 때 그리드 선택 행의 `MEASURE_UI` 로 정한다. 정할 수 없으면 alert 후 열지 않는다 | 구현 |
| D00-1-008 | §1 cboDayWeek / UsrCombo | `components/modals/BulkUpdateModal.tsx` (Day Type 드롭다운, `CustomDropdown`) + `utils/capa-mobility-it.bulkInput.ts` `BULK_TYPE_OPTIONS` | 기획 확정(2026-10-13): Bulk Update 팝업은 AS-IS 조회조건의 Day Type·Input Value 를 받아 Input 버튼 동작을 수행한다(적용 기간 입력 없음). Type 선택지 9개(EveryDay·SelectDay·Mon~Sun)는 항상 노출하고, DAILY_CAPA 에 요일을 고르면 `validateBulkType` 이 거부한다 | 구현 |
| D00-1-009 | §1 cboDivision / UsrCombo | `CapaMobilityItForm.tsx` (Division InputField readOnly `FIXED_DIVISION` — AS-IS Enabled=false 고정) | | 구현 |
| D00-1-010 | §1 chkDetail / UsrCheckBox | | To-Be 문서(SCP0098) Detail 체크박스 삭제 — Daily 는 일(`D_`) 컬럼만 표시하고 월(`M_`)은 숨김(AS-IS Detail 체크 상태와 동일, `visibleKinds`), 2026-10-13 확정 | 제외 |
| D00-1-011 | §1 clbLine / UsrCheckedList2 | `CapaMobilityItForm.tsx` (Line multi CustomDropdown, `LineByOperation`) | | 구현 |
| D00-1-012 | §1 clbPlantSite / UsrCheckedList2 | `CapaMobilityItForm.tsx` (Plant Site multi CustomDropdown, `PlantByDivisionOperation`) | | 구현 |
| D00-1-013 | §1 components / Container | — | 디자이너 컨테이너(WinForms IContainer) — React 컴포넌트 트리로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-014 | §1 dCalendar / UsrDateRangePicker3 | `CapaMobilityItForm.tsx` (공용 `PeriodRangePicker` start/end, required) | | 구현 |
| D00-1-015 | §1 emptySpaceItem1 / EmptySpaceItem | — | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem2 / EmptySpaceItem | — | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem3 / EmptySpaceItem | — | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem4 / EmptySpaceItem | — | LayoutControl 여백 — CSS/Grid 레이아웃으로 대체, 대사 대상 아님 | 해당없음 |
| D00-1-019 | §1 layoutControlGroup2 / LayoutControlGroup | — | WinForms 레이아웃 그룹 컨테이너 — SearchArea/Grid 구성으로 대체 | 해당없음 |
| D00-1-020 | §1 layoutControlItem1 / LayoutControlItem | `BulkUpdateModal` (Bulk Update 팝업으로 대체 — To-Be 문서 SCP0098) |  | 구현 |
| D00-1-021 | §1 layoutControlItem13 / LayoutControlItem | `CapaMobilityIt.tsx` (SubTitle 버튼 라벨 영역) | | 구현 |
| D00-1-022 | §1 layoutControlItem14 / LayoutControlItem | `CapaMobilityIt.tsx` (SubTitle Measure 버튼 라벨) | | 구현 |
| D00-1-023 | §1 layoutControlItem16 / LayoutControlItem | `CapaMobilityItForm.tsx` (Line 라벨) | | 구현 |
| D00-1-024 | §1 layoutControlItem19 / LayoutControlItem | `BulkUpdateModal` (Bulk Update 팝업으로 대체 — To-Be 문서 SCP0098) |  | 구현 |
| D00-1-025 | §1 layoutControlItem2 / LayoutControlItem | `CapaMobilityItForm.tsx` (Model/Nickname 라벨 `LBL.MODEL_NICKNAME`) | | 구현 |
| D00-1-026 | §1 layoutControlItem3 / LayoutControlItem | `CapaMobilityIt.tsx` (SubTitle 라벨 영역) | | 구현 |
| D00-1-027 | §1 layoutControlItem4 / LayoutControlItem | `CapaMobilityItForm.tsx` (Nick Name 라벨) | | 구현 |
| D00-1-028 | §1 layoutControlItem5 / LayoutControlItem | `BulkUpdateModal` (Bulk Update 팝업으로 대체 — To-Be 문서 SCP0098) |  | 구현 |
| D00-1-029 | §1 layoutControlItem6 / LayoutControlItem | `components/modals/BulkUpdateModal.tsx` (Day Type 라벨 `LBL.DAY_TYPE`=LBL01066 FormItem) | 기획 확정(2026-10-13): Bulk Update 팝업은 AS-IS 조회조건의 Day Type·Input Value 를 받아 Input 버튼 동작을 수행한다(적용 기간 입력 없음). | 구현 |
| D00-1-030 | §1 layoutControlItem7 / LayoutControlItem | `CapaMobilityItForm.tsx` (Plant Site 라벨) | | 구현 |
| D00-1-031 | §1 layoutControlItem8 / LayoutControlItem | `BulkUpdateModal` (Bulk Update 팝업으로 대체 — To-Be 문서 SCP0098) |  | 구현 |
| D00-1-032 | §1 layoutControlItem9 / LayoutControlItem | | To-Be 문서(SCP0098) Bucket 삭제 | 제외 |
| D00-1-033 | §1 lblBucket / LayoutControlItem | | To-Be 문서(SCP0098) Bucket 삭제 | 제외 |
| D00-1-034 | §1 spdMain / FpSpread | `CapaMobilityItGrid.tsx` (공용 `DataGrid`) | | 구현 |
| D00-1-035 | §1 spdMain_Sheet1 / SheetView | `CapaMobilityItGrid.tsx` (단일 `DataGrid` — FpSpread 다중시트 미사용) | 단일 그리드로 통합(spdInfo 별도 시트 미이식, §5 R8/C3) | 해당없음 |
| D00-1-036 | §1 txtInpuValue / TextBox | `BulkUpdateModal` (Bulk Update 팝업으로 대체 — To-Be 문서 SCP0098) |  | 구현 |
| D00-1-037 | §1 txtItemId / UsrTextBox | `CapaMobilityItForm.tsx` (Model/Nickname InputField `sc.itemId`) | | 구현 |
| D00-1-038 | §1 txtNickName / TextBox | | To-Be 문서(SCP0098) Nick Name 조회조건 삭제 — Model/Nickname 에 통합, `nickName` 은 '' 고정 전송 | 제외 |
| D00-1-039 | §1 usrButton1 / UsrButton | — | AS-IS x/y=0·tabIndex=0 용도불명 숨김 컨트롤(00_checklist §1 확인필요) — 실동작 없음, 미이식 | 제외 |
| D00-1-040 | §1 usrConditionPanel1 / UsrConditionPanel | `CapaMobilityItForm.tsx` (`SearchArea` 조회조건 컨테이너) | | 구현 |
| D00-1-041 | §1 usrLayoutControl2 / UsrLayoutControl | — | WinForms 레이아웃 컨트롤 컨테이너 — React 레이아웃으로 대체 | 해당없음 |
| D00-2-001 | §2 btnCopyData / Click | `CapaMobilityIt.tsx` `handleCopy` (CopySelect → P_COPY_MONTH_WEEK → 재조회) | 기획 확정(2026-10-13): DAILY_CAPA 외 measure 는 삭제 예정이라 복사는 DAILY_CAPA 만 유지하고 `PROD_READY_RATE`(NO_WORK 행 보관)는 현행 그대로 둔다. FE 무변경, SP 수정은 `07_sp-copy-daily-capa.sql`(DB 담당자 적용 대기) | 구현 |
| D00-2-002 | §2 btnInput / Click | `CapaMobilityIt.tsx` `handleBulkConfirm` + `capa-mobility-it.bulkInput.ts` `applyBulkInput` |  | 구현 |
| D00-2-003 | §2 btnItemId / Click | `CapaMobilityItForm.tsx` (`ItemByDivisionModal` open → itemId(COM0008 교정)) | | 구현 |
| D00-2-004 | §2 btnMeasure / Click | `CapaMobilityIt.tsx` (`MeasureSelectModal` open, onApply → `saveTitleSet('M')` → `fetchStaticMeasures`+`refetch`) | | 구현 |
| D00-2-005 | §2 cboBucketType / SelectedIndexChanged | | To-Be 문서(SCP0098) Bucket 삭제 | 제외 |
| D00-2-006 | §2 cboDivision / SelectedIndexChanged | — | Division '40' 고정·비활성(AS-IS cs L182~183) — cascade 재적재 이벤트 발생 안 함 | 해당없음 |
| D00-2-007 | §2 chkDetail / CheckedChanged | | To-Be 문서(SCP0098) Detail 삭제 | 제외 |
| D00-2-008 | §2 clbPlantSite / SelectedIndexChanged | `CapaMobilityItForm.tsx` (Plant onPick → `setSearchParams`; Line 재조회는 AS-IS S1 NO-OP) | | 구현 |
| D00-2-009 | §2 dsdmLine / Changed (=SpdMain_Changed) | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (NO_WORK Y/N + PRODUCT_READY Auto-Sync) | | 구현 |
| D00-2-010 | §2 spdMain / CellClick | — | 셀 클릭 단독 파생 로직 없음(AS-IS 본문 NO-OP) — Wijmo 기본 선택 동작으로 등가 | 해당없음 |
| D00-2-011 | §2 spdMain / CellDoubleClick | — | AS-IS SetDblClickColumnShowHide(pivot 드릴 후보) 미이식 — 컬럼 show/hide 는 chkDetail/Column 설정으로 대체(§5 C2/04 기재) | 제외 |
| D00-2-012 | §2 spdMain / ClipboardPasted | `CapaMobilityItGrid.tsx` (`pastedCell` → `cellEditEndedHandler`) | | 구현 |
| D00-2-013 | §2 spdMain / ClipboardPasting | `CapaMobilityItGrid.tsx` (`pastingCell` → `beginningEditHandler` 편집잠금 가드) | | 구현 |
| D00-2-014 | §2 spdMain / TopChange | — | FpSpread 가상스크롤 top 변경 배관 — Wijmo 네이티브 스크롤로 등가, 파생 로직 없음 | 해당없음 |
| D00-3-001 | §3 ChangeActiveSheet / 260 | — | FpSpread 다중시트 전환 — 단일 DataGrid 로 통합, 시트 전환 개념 부재 | 해당없음 |
| D00-3-002 | §3 SmartColMerge / 275 | — | spdInfo(정보시트) 컬럼 머지 — 별도 info 시트 미이식(§5 R8/C3, 04 기재) | 제외 |
| D00-3-003 | §3 ForeColor= / 340 | `CapaMobilityItGrid.tsx` `formatHandler` (ColumnHeader 토/일 Blue/Red) | | 구현 |
| D00-3-004 | §3 ColumnHeaderSpan / 348 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` + `buildDynamicColumns`(3단 nested) | | 구현 |
| D00-3-005 | §3 ColumnHeaderSpan / 349 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (헤더 span) | | 구현 |
| D00-3-006 | §3 ColumnHeaderSpan / 355 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (소분류 span) | | 구현 |
| D00-3-007 | §3 ColumnHeaderSpan / 356 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (헤더 span) | | 구현 |
| D00-3-008 | §3 ColumnHeaderSpan / 364 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (소분류 span) | | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / 365 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (SUM span) | | 구현 |
| D00-3-010 | §3 ColumnHeaderSpan / 378 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (대분류 span) | | 구현 |
| D00-3-011 | §3 ColumnHeaderSpan / 379 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (헤더 span) | | 구현 |
| D00-3-012 | §3 ColumnHeaderSpan / 383 | `capa-mobility-it.dynamicColumns.ts` `CapaHeaderMergeManager` (소분류 span) | | 구현 |
| D00-3-013 | §3 SwitchLock / 430 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-014 | §3 LockRange / 435 | `capa-mobility-it.editLock.ts` `isCellEditable` (전체 기본 잠금 — 미지 컬럼 false) | | 구현 |
| D00-3-015 | §3 LockRange / 463 | `capa-mobility-it.editLock.ts` `isCellEditable` (MEASURE_NAME 이하 정적컬럼 잠금) | | 구현 |
| D00-3-016 | §3 LockRange / 464 | `capa-mobility-it.editLock.ts` `isCellEditable` (PRODUCT_READY 항상 편집 허용) | | 구현 |
| D00-3-017 | §3 LockRange2 / 477 | `capa-mobility-it.editLock.ts` `isCellEditable` (DAILY_CAPA 행 非M_ 잠금, `M_EDIT_MEASURES`) | | 구현 |
| D00-3-018 | §3 LockRange2 / 478 | `capa-mobility-it.editLock.ts` `isCellEditable` (DAILY_CAPA 행 M_ 외 잠금) | | 구현 |
| D00-3-019 | §3 LockRange2 / 485 | `capa-mobility-it.editLock.ts` `isCellEditable` (DAILY_CAPA 행 M_ 편집 허용) | | 구현 |
| D00-3-020 | §3 LockRange / 492 | `capa-mobility-it.editLock.ts` `isCellEditable` (NO_WORK/LOAD_RATE/RAMP_UP 행 `D_EDIT_MEASURES`) | | 구현 |
| D00-3-021 | §3 LockRange2 / 499 | `capa-mobility-it.editLock.ts` `isCellEditable` (非DAILY_CAPA 행 M_ 잠금) | | 구현 |
| D00-3-022 | §3 LockRange2 / 503 | `capa-mobility-it.editLock.ts` `isCellEditable` (非DAILY_CAPA 행 D_ 편집 허용) | | 구현 |
| D00-3-023 | §3 Query / 742 | `CapaMobilityItGrid.tsx` (`DataGrid` itemsSource=data) + `useCapaMobilityItStore.ts` `setFilters` | | 구현 |
| D00-3-024 | §3 LockColumn / 745 | `capa-mobility-it.editLock.ts` `isCellEditable` (0열/정적 키컬럼 잠금) | | 구현 |
| D00-3-025 | §3 SmartColMerge / 747 | `CapaMobilityItGrid.tsx` (공용 DataGrid `allowMerging` + `CapaHeaderMergeManager`) | | 구현 |
| D00-3-026 | §3 SetActiveCell / 766 | — | FpSpread 저장 후 선택셀 복원 배관 — Wijmo 편집 유지로 등가, 파생 로직 없음 | 해당없음 |
| D00-3-027 | §3 ShowCell / 767 | — | FpSpread 선택셀 스크롤 표시 배관 — Wijmo 네이티브 스크롤로 등가 | 해당없음 |
| D00-3-028 | §3 ForeColor= / 848 | `CapaMobilityItGrid.tsx` `formatHandler` (NO_WORK 셀 Blue) | | 구현 |
| D00-3-029 | §3 Value= / 849 | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (NO_WORK Y/N 정규화 값 설정) | | 구현 |
| D00-3-030 | §3 Value= / 854 | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (PRODUCT_READY 동일키 값 복제) | | 구현 |
| D00-3-031 | §3 Value= / 858 | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (파생 값 설정) | | 구현 |
| D00-3-032 | §3 SwitchLockEx / 2405 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 저장 후 잠금 토글 미이식(편집 기본 ON) | 제외 |
| D00-3-033 | §3 SwitchLockEx / 2744 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 저장 후 잠금 토글 미이식(편집 기본 ON) | 제외 |
| D00-3-034 | §3 VisibleColumns / 3202 | `capa-mobility-it.dynamicColumns.ts` `visibleKinds`(Daily → D_ 표시, Detail 체크박스 삭제로 상시) | | 구현 |
| D00-3-035 | §3 VisibleColumns / 3204 | `capa-mobility-it.dynamicColumns.ts` `visibleKinds`(Daily → M_ 숨김, D_ 만 표시) | | 구현 |
| D00-3-036 | §3 Visible= / 3234 | `CapaMobilityItGrid.tsx` (동적컬럼 가시성 effect → `col.visible`) | | 구현 |
| D00-3-037 | §3 Visible= / 3241 | `CapaMobilityItGrid.tsx` (동적컬럼 가시성 effect → `col.visible`) | | 구현 |
| D00-3-038 | §3 Visible= / 3245 | `CapaMobilityItGrid.tsx` (동적컬럼 가시성 effect → `col.visible`) | | 구현 |
| D00-3-039 | §3 Visible= / 3249 | `CapaMobilityItGrid.tsx` (동적컬럼 가시성 effect → `col.visible`) | | 구현 |
| D00-3-040 | §3 SmartColMerge / 3478 | `CapaMobilityItGrid.tsx` (`sender.invalidate` 후 `CapaHeaderMergeManager` 재적용) | | 구현 |
| D00-3-041 | §3 SetValue / 3591 | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (PRODUCT_READY Auto-Sync `storeChange`) | | 구현 |
| D00-3-042 | §3 SetValue / 3622 | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (NO_WORK Y/N 검증 후 값 설정) | | 구현 |
| D00-3-043 | §3 SetDblClickColumnShowHide / 3719 | — | 더블클릭 pivot 컬럼 show/hide 미이식 — chkDetail/Column 설정 모달로 대체(§5 C2, 04 기재) | 제외 |
| D00-3-044 | §3 Get / 3800 | `capa-mobility-it.bulkInput.ts` `applyBulkInput` (편집가능 셀만 setCell) |  | 구현 |
| D00-3-045 | §3 GetModelColumnFromViewColumn / 3943 | `capa-mobility-it.dynamicColumns.ts` `kindOf` (binding→종류 매핑; view/model 컬럼 분리 불요) | | 구현 |
| D00-3-046 | §3 GetModelColumnFromViewColumn / 3944 | `capa-mobility-it.dynamicColumns.ts` `kindOf` (binding 기준 컬럼 식별) | | 구현 |
| D00-3-047 | §3 SetText / 3956 | `CapaMobilityItGrid.tsx` `formatHandler` (DAILY_CAPA 정수 천단위 innerText) | | 구현 |
| D00-3-048 | §3 SetText / 3973 | `CapaMobilityItGrid.tsx` `formatHandler` (LOAD_RATE/RAMP_UP 소수 innerText) | | 구현 |
| D00-3-049 | §3 SetText / 3990 | `CapaMobilityItGrid.tsx` `formatHandler` (0/빈값 → 빈칸) | | 구현 |
| D00-3-050 | §3 SetText / 4014 | `CapaMobilityItGrid.tsx` `formatHandler` (`paintNegativeText` 음수 표기) | | 구현 |
| D00-3-051 | §3 GetModelColumnFromViewColumn / 4035 | `capa-mobility-it.dynamicColumns.ts` `kindOf` (binding 기준 컬럼 식별) | | 구현 |
| D00-3-052 | §3 GetModelColumnFromViewColumn / 4036 | `capa-mobility-it.dynamicColumns.ts` `kindOf` (binding 기준 컬럼 식별) | | 구현 |
| D00-3-053 | §3 SetText / 4048 | `CapaMobilityItGrid.tsx` `formatHandler` (NO_WORK 중앙정렬 텍스트) | | 구현 |
| D00-3-054 | §3 SetText / 4065 | `CapaMobilityItGrid.tsx` `formatHandler` (셀 텍스트 설정) | | 구현 |
| D00-3-055 | §3 SetText / 4082 | `CapaMobilityItGrid.tsx` `formatHandler` (셀 텍스트 설정) | | 구현 |
| D00-3-056 | §3 SetText / 4106 | `CapaMobilityItGrid.tsx` `formatHandler` (헤더 leaf 일자 텍스트) | | 구현 |
| D00-3-057 | §3 SetText / 4114 | `CapaMobilityItGrid.tsx` `formatHandler` (헤더 텍스트 설정) | | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivision / (false) / dtMyDivision | `capa-mobility-it.constants.ts` `FIXED_DIVISION` ('40' 고정 — AS-IS Division read-only) | | 구현 |
| D00-4b-002 | §4b Data.Common / LookupCommon / dtElectrodeType | — | dead(참조 0, design 02 §1 #2) — 미바인딩 콤보, 이관 불요 | 제외 |
| D00-4b-003 | §4b Data_SCP.Common / CellTypeGr / dtCellTypeGr | — | dead(참조 0, design 02 §1 #3) — 이관 불요 | 제외 |
| D00-4b-004 | §4b Data_SCP.Common / OperationGroupEE / dtOperationGroup | — | EE 전용(div40≠EE, design 02 §1 #4) — 이관 불요 | 제외 |
| D00-4b-005 | §4b Data_SCP.Common / OperationGroup / dtOperationGroup | — | 미바인딩(pOperationGroup='', design 02 §1 #5) — 이관 불요 | 제외 |
| D00-4b-006 | §4b Data_SCP.Common / PlantSiteProdPlan / dtPlantSiteByDivision | — | EE 전용(design 02 §1 #6) — div40 은 PlantByDivisionOperation 사용, 이관 불요 | 제외 |
| D00-4b-007 | §4b Data.Common / PlantByDivisionOperation / dtPlantSiteByDivision | `CapaMobilityItForm.tsx` (`useTabComboQueries` `PlantByDivisionOperation` divisionId '40') | | 구현 |
| D00-4b-008 | §4b Data.Common / DATE_WEEKLY / dtPlanDate | `useCapaMobilityItStore.ts` `makeInitSearchParams` (초기 기간 근사 W52, design 02 §2-5) | | 구현 |
| D00-4b-009 | §4b Data_SCP.Common / LineProdPlanLine / dtLine | — | L1890 LineByOperation 이 덮어씀(design 02 §1 #9) — 이관 불요 | 제외 |
| D00-4b-010 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | — | L1890 LineByOperation 이 덮어씀(design 02 §1 #10) — 이관 불요 | 제외 |
| D00-4b-011 | §4b Data.Common / LineByOperation / dtLine | `CapaMobilityItForm.tsx` (`useTabComboQueries` `LineByOperation` divisionId '40') + `useCapaMobilityItStore.ts` `joinLineCsv`('-'→'') | | 구현 |
| D00-4d-001 | §4d EditButton / fps==null | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-002 | §4d EditButton / fps.Name=="spdMain" | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-003 | §4d EditButton / siMain.ActiveSheet.RowCount==0 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-004 | §4d EditButton / IsEditMode==false | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-005 | §4d SaveButton / fps==null | `CapaMobilityIt.tsx` `handleSave` (tracker null 가드 `if (!tracker) return`) | | 구현 |
| D00-4d-006 | §4d SaveButton / GMessageBox("MSG00012")==Yes | `CapaMobilityIt.tsx` `handleSave` (`setAlert` confirm `MSG.SAVE_CONFIRM`) | | 구현 |
| D00-4d-007 | §4d SaveButton / save_status=="RUN" | `CapaMobilityIt.tsx` `handleSave` (`saving` state 중복제출 차단) | | 구현 |
| D00-4d-008 | §4d BtnMeasure_Click / fps!=null | `CapaMobilityIt.tsx` (`MeasureSelectModal` — 그리드 존재 전제, 활성 그리드 단일) | | 구현 |
| D00-4d-009 | §4d SpdMain_Changed / !CanModelChange | `CapaMobilityItGrid.tsx` `beginningEditHandler` (`editableCell` false → e.cancel) | | 구현 |
| D00-4d-010 | §4d SpdMain_Changed / cellclipboardPast | `CapaMobilityItGrid.tsx` (`pastingCell`/`pastedCell` 핸들러 — 붙여넣기 재진입 등가) | | 구현 |
| D00-4d-011 | §4d SpdMain_Changed / ds==null | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (row/binding null 가드 — 조기반환) | | 구현 |
| D00-4d-012 | §4d SpdMain_Changed / strColName=="Action" | — | AS-IS Action(CRUD_TYPE) 컬럼 조기반환 가드 — TO-BE 는 Action 셀 편집 불가(정적 잠금)라 도달 없음 | 해당없음 |
| D00-4d-013 | §4d SpdMain_Changed / ds==null | `CapaMobilityItGrid.tsx` `cellEditEndedHandler` (2차 null 가드) | | 구현 |
| D00-4d-014 | §4d btnInput_Click / Columns.Get(0).Visible==false | `utils/capa-mobility-it.bulkInput.ts` `applyBulkInput` (Type 과 컬럼 종류로 대상 컬럼 지정 — 컬럼 표시 여부는 보지 않음) |  | 구현 |
| D00-4d-015 | §4d btnInput_Click / !CanModelChange | `CapaMobilityIt.tsx` `handleBulkOpen`/`handleBulkConfirm` (grid/tracker/`canEdit` 조기반환 가드) |  | 구현 |
| D00-4d-016 | §4d btnInput_Click / pDayWeekCode=="SelectDay" | `utils/capa-mobility-it.bulkInput.ts` `applyBulkInput` (SelectDay: `grid.selectedRanges` 행 x 컬럼 교집합, DAILY_CAPA 는 선택한 일 셀이 속한 월의 `M_` 에 입력) | AS-IS 의 행·컬럼·셀 선택 3분기를 한 규칙으로 통합 | 구현 |
| D00-4d-017 | §4d btnInput_Click / selCells.Length<1 | `CapaMobilityIt.tsx:256` `handleBulkConfirm` + `utils/capa-mobility-it.bulkInput.ts` `hasBulkSelection` (SelectDay 인데 유효 선택 없으면 alert) | AS-IS MSG00134 는 TO-BE 표준 ID 가 없어 영문 defaultValue 폴백 | 구현 |
| D00-4d-018 | §4d btnInput_Click / IsNullOrEmpty(pDayWeekCode) | `components/modals/BulkUpdateModal.tsx` (Type 초기값 EveryDay, 드롭다운이라 빈 값 입력 경로 없음) | | 구현 |
| D00-4d-019 | §4d btnInput_Click / pCategoryCode=="NO_WORK" | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (`MEASURE.NO_WORK` 분기) | | 구현 |
| D00-4d-020 | §4d btnInput_Click / checkValue!=Y && !=N | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (NO_WORK → 'INVALID_YN') | | 구현 |
| D00-4d-021 | §4d btnInput_Click / pCategoryCode=="LOAD_RATE" | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (`MEASURE.LOAD_RATE` 분기) | | 구현 |
| D00-4d-022 | §4d btnInput_Click / !(flt>=0.0 && <=100.0) | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (LOAD_RATE 0~100 → 'INVALID_LOAD_RATE') | | 구현 |
| D00-4d-023 | §4d btnInput_Click / pCategoryCode=="RAMP_UP" | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (`MEASURE.RAMP_UP` 분기) | | 구현 |
| D00-4d-024 | §4d btnInput_Click / !(flt>=0.0 && <=1.0) | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (RAMP_UP 0~1 → 'INVALID_RAMP_UP') | | 구현 |
| D00-4d-025 | §4d btnInput_Click / pCategoryCode=="DAILY_CAPA" | `capa-mobility-it.bulkInput.ts` `validateBulkValue` (`MEASURE.DAILY_CAPA` 분기) | | 구현 |
| D00-4d-026 | §4d btnInput_Click / flt<0 | `utils/capa-mobility-it.bulkInput.ts`:66 `validateBulkValue` (DAILY_CAPA 빈 값·비정수·음수 → 'INVALID_DAILY_CAPA', AS-IS int.Parse 예외와 동일하게 빈 값 거부) | | 구현 |
| D00-4d-027 | §4d btnInput_Click / !(EveryDay 또는 SelectDay) | `utils/capa-mobility-it.bulkInput.ts`:62 `validateBulkType` (DAILY_CAPA 에 요일 Type → 'WEEKDAY_NOT_ALLOWED') | AS-IS "Daily Capa 는 요일입력을 허용하지 않습니다"(.cs:3892~3897) | 구현 |
| D00-4d-028 | §4d btnInput_Click / ds==null | `CapaMobilityIt.tsx` `handleBulkConfirm` (grid/tracker null 조기반환 가드) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:CopySelectModal | FE 실존 모달 (components/modals/CopySelectModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `components/modals/CopySelectModal.tsx` `CopySelectModal` (AS-IS SCP0098_CopySelect_Popup — Week/Month 선택 → `handleCopy`) | 제목 `Copy Type`과 안내 문구는 AS-IS 원문 하드코딩(사용자 결정 2026-10-13), 라디오 2개 + 빨간 안내 2줄 + 축소 높이 | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | `CapaMobilityIt.tsx` (btnMeasure → `MeasureSelectModal`(공용, 2026-10-13 복원, AS-IS 개인화 팝업은 이것 하나); btnItemId → `ItemByDivisionModal`(COM0008); AS-IS TitleSetForm/ItembyDivision ShowDialog 팝업 매핑) | | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 셀 편집형 pivot 화면 — 신규 행 Insert 경로 부재(hotkeyConfig insert=false, AS-IS 툴바에 InsertRow 없음). 필터 하 신규행 유지 대상 없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | — | AS-IS(FindData_Main)·TO-BE 모두 수정중 재조회 confirm 없음 — AS-IS FindButton 이 dirty 확인 없이 즉시 조회(00_checklist §4d-1). 도입 시 공통 훅 확장 대상 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `CapaMobilityIt.tsx` (MeasureSelectModal `onApply`→`saveTitleSet('M')`→`fetchStaticMeasures`+`refetch`) | | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `CapaMobilityIt.tsx` `handleSave`/`handleCopy` (`setToast` 성공 알림) | | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `CapaMobilityIt.tsx` (SubTitle `excelFileName='SCP0098'` 표준 Excel — 공용 SubTitle dataMap Name 출력 승계) | | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | — | 조회조건은 콤보(PlantSite/Line 다중선택 CSV)·날짜·Item 단일 — key-in 콤마 다중 텍스트 조회조건 부재. Line/Plant 다중은 CustomDropdown CSV(`joinCsv`)로 이미 전건 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `CapaMobilityItGrid.tsx` (공용 `DataGrid` gridFilterRef — rebindFilterColumns 필터 보존) | | 구현 |

## 1. 화면 골격
| AS-IS | TO-BE |
|---|---|
| Form SCP0098_CAPAReprotSmall | `CapaMobilityIt.tsx` |
| usrConditionPanel1(HidePanel) 3행 | `components/CapaMobilityItForm.tsx` (SearchArea, 접이식) |
| spdMain(FpSpread) | `components/CapaMobilityItGrid.tsx` (공용 DataGrid) |
| SCP0098_CopySelect_Popup | `components/modals/CopySelectModal.tsx` |

## 2. comboCalls 11 (영역2) — design 02 §1 대사 1:1
| # | AS-IS code | TO-BE | 근거 |
|--:|---|---|---|
| 1 | GetDivision→Division_SCP | Division 고정 '40'(권한원천 콤보는 목록/권한용, 값 40 고정) | Form div read-only |
| 2 | LookupCommon(ElectrodeType) | 이관 불요(dead, 참조 0) | design 02 §1 #2 |
| 3 | CellTypeGr | 이관 불요(dead) | #3 |
| 4 | OperationGroupEE | 이관 불요(EE 전용, div40≠EE) | #4 |
| 5 | OperationGroup | 이관 불요(미바인딩, pOperationGroup='') | #5 |
| 6 | PlantSiteProdPlan | 이관 불요(EE 전용) | #6 |
| 7 | PlantByDivisionOperation | Form `PlantByDivisionOperation`(divisionId '40') 다중 | #7 정본 |
| 8 | DATE_WEEKLY | 기간 기본값 간접(초기 period 근사) | #8 |
| 9 | LineProdPlanLine | 이관 불요(L1890 덮어씀) | #9 |
| 10 | LineByOperationAddOSP | 이관 불요(L1890 덮어씀) | #10 |
| 11 | LineByOperation | Form `LineByOperation`(divisionId '40') 다중, '-'→'' 치환 | #11 정본 |

- PlantSite→Line 재조회(S1) = AS-IS `ClbPlantSite_SelectedIndexChanged` 전체 주석(NO-OP) → TO-BE 도 재조회 안 함(Form 주석).

## 3. buttonGuards 28 / toolbarOverride
| AS-IS | TO-BE |
|---|---|
| FindButton(실동작) | `handleSearch` (Period 필수검증 → setFilters) |
| SaveButton(MSG00012 확인 → save_status 가드 → SaveDataFull) | `handleSave` (SAVE_CONFIRM 확인 → saving 가드(mutation isPending 대체) → 3분기 저장) |
| EditButton(모드토글) | **미이식** — 편집 기본 ON, `canEdit=hasButton('EDIT')` mount 1회. `editMode/setEditMode` 신설 0(convert-core §2.4, self-check grep 0). 컬럼단위 잠금은 `utils/capa-mobility-it.editLock.ts` measure 매트릭스로 재현 |
| ExcelButton(FPC0109 옵션→Export) | SubTitle 표준 Excel(excelFileName='SCP0098'). 엑셀옵션 모달(Merge/Border/Zero, D4)은 후속(04 기재) |
| btnInput_Click 가드 #14~27(0열숨김/CanModelChange/SelectDay 선택0/category별 값검증) | `utils/capa-mobility-it.bulkInput.ts` `validateBulkType`+`validateBulkValue`+`applyBulkInput` (SelectDay 선택 0 가드는 `hasBulkSelection`) |
| SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds null) | Grid `cellEditEnded` 는 EditTracker 경유(자체 재진입 없음) |

## 4. validations 48 — 검증 매핑
| AS-IS | TO-BE |
|---|---|
| #1 MSG00012 저장확인 | `MSG.SAVE_CONFIRM`(MSG00001) |
| #2 MSG00199 작업중(save_status RUN) | `saving` state + mutation isPending (중복제출 차단) |
| #16/#23 CAPA_WORK>10000 저장불가 | `handleSave` `CAPA_WORK_SAVE_LIMIT` 가드 |
| #20 저장할 데이터 없음 | dirty 0 → `MSG.NO_CHANGES` toast |
| #35 [Y,N]만 입력 | Grid `cellEditEnded` NO_WORK D_ 셀 Y/N 강제 |
| #41 비조업 Y/N | `validateBulkValue` NO_WORK |
| #42 가동율 0~100 | `validateBulkValue` LOAD_RATE |
| #44 Ramp-up 0~1 | `validateBulkValue` RAMP_UP |
| #46/#47 Daily Capa >0/요일불가 | `validateBulkValue` DAILY_CAPA(정수≥0) |
| #17/#18/#19 [생산준비율/Capa/CapaWork] 저장실패 | 3분기 mutation reject → `handleSave` catch alert |
| #36/#37 복사 완료/실패 | `handleCopy` RESULT_CODE 판정 |
| 기타 tran/Exception | 표준 apiClient 인터셉터 + false-success 판정(res.status/code/RESULT_CODE) |

## 5. gridSignals 57 — 규칙 매핑 (design 03 §3 R1~R11)
| 규칙 | AS-IS | TO-BE |
|---|---|---|
| R1 PRODUCT_READY Auto-Sync | SetValue L3591 | Grid `cellEditEnded` 동일키(5축) 행 복제 |
| R1 NO_WORK Y/N | SetValue L3622 | Grid `cellEditEnded` Y/N 강제 |
| R2/R10 btnInput bulk-fill | SetText 11 | `applyBulkInput` (category 행필터 + D_/M_ 분기 + Type 별 범위: EveryDay 전체 / SelectDay 선택 영역 / Mon~Sun 요일 일치 D_ 컬럼) |
| R3 measure별 편집영역(LockRange 13) | EditButton L418~524 | `isCellEditable` (DAILY_CAPA→M_ / NO/LOAD/RAMP→D_ / PRODUCT_READY 항상 / 키 잠금). 상수 하드코딩 이식 0(hook #130) |
| R4 초기 잠금·좌측 세로머지 | LockColumn/SmartColMerge | 공용 DataGrid allowMerging + CustomMergeManager(CapaHeaderMergeManager) |
| R5 셀 포맷·색(NO_WORK Blue/DAILY_CAPA 정수콤마) | ForeColor/NumberCellType | Grid `formatItem` (wijmo DOM 셀 스타일) |
| R6 chkDetail D_↔M_ 토글 | VisibleColumns | Detail 체크박스 삭제 — `visibleKinds`(Daily → D_ 만 상시 표시) |
| R7 3단 헤더 span + 주말색 | ColumnHeaderSpan 9 + ForeColor | `buildDynamicColumns`(3단 nested) + `CapaHeaderMergeManager` + `formatItem` 토(Blue)/일(Red) |
| R8 spdInfo 머지 | SmartColMerge | 단일 DataGrid 다단헤더 통합(C3 — 별도 info 시트 미구현, 04 기재) |
| R9 시트전환/좌표 | ChangeActiveSheet 등 | 단일 그리드 — 불요 |

## 6. spCalls / 저장 3분기 (design 03 §4)
| SP(PKG_SCP0098 멤버) | TO-BE 배선 |
|---|---|
| P_GET_CAPA_MOBILITYIT | `useTabProcQuery` main (procedures.d.ts SCP0098.main) |
| P_SAVE_SCP_CAPA_PRODUCT_RATE | `useProcMutation` capaProductRate (`buildSavePayload.productRate`) |
| P_SAVE_SCP_CAPA | `useProcMutation` capaMonth (DAILY_CAPA M_) |
| P_SAVE_SCP_CAPA_WORK | `useProcMutation` capaWork (NO/LOAD/RAMP D_) |
| P_COPY_MONTH_WEEK | `handleCopy` apiClient.post copy |
| SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_SYS_GET_SPREAD_TITLE | 미보유(C4) — 기간헤더는 GET 응답 키 + 클라 date 산출(fallback). 04 기재 |

## 7. 미이식/확인필요 요약
- EditButton 모드토글 미이식(근거: convert-core §2.4, SCP0120 선례). 편집 기본 ON.
- Weekly/Monthly bucket 가시성(C2): AS-IS dead → TO-BE 기능적 해석(Weekly=W_/Monthly=M_ 표시). 스펙확정 대상.
- 기간헤더 SP(C4): 공통 SCP0009/calendar API 미확정 → GET 키 fallback.
- 엑셀 옵션 모달(D4)·spdInfo(C3)·컬럼 개인화 round-trip: 후속(04 기재).
