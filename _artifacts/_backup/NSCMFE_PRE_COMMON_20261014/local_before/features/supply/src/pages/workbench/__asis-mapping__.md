# SCP0125 Workbench — AS-IS ↔ TO-BE 매핑 매트릭스

> convert-react iter-1 (2026-09-26) 산출. AS-IS 정본 =
> `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0125_Workbench/SCP0125_Workbench.cs` (2,404라인) +
> `SCP0125_Workbench.Designer.cs` (523라인).
> 식별자(C·E·G·D·F·B·U·P·V·N·X·MSG)는 `design/00_checklist.md`~`03_grid-columns.md` 의 번호를 그대로 쓴다.

## 이 파일의 표기 규약 (Gate 1 양식 정합화 — 2026-09-26)

- **ID 표기**: 설계문서 번호 `Exx`(예 `E01`) ↔ 대사표 ID `E-xx`(예 `E-01`) 는 **같은 행**이다.
  게이트(`_artifacts/_diagnostics/asis_mapping_gate.py` `RE_LEGACY_EID_ROW`)가 하이픈 없는 `E01` 을
  구양식으로 보고 FAIL 시키므로 대사표에서만 하이픈을 쓴다. 나머지 축(C·G·D·F·B·U·P)도 같은 규칙으로
  통일했다(`C01` ↔ `C-01`). **번호 자체는 하나도 바뀌지 않았다.**
- **범위 행 전개**: 종전 `G01~G05` / `G18~G22` / `B09~B16` / `U01~U05` 같은 범위 표기는 게이트가
  파싱하지 못해 **행이 통째로 사라진다**. 개별 ID 로 전개하고, 전개 사실을 각 행 사유에 남겼다.
- **표 양식**: ID 를 가진 표는 5열 고정이다 — `| ID | 요지 | 구현 위치(파일:라인) | 사유 | 상태 |`.
- **상태 허용값**(게이트 소스 `STATUS_*` 상수): `구현`(구현 위치 필수) / `제외`(사유 필수) /
  `해당없음`(사유 필수) / `미구현`(잔여). 종전 표기 `이식 없음` · `미해당` · `미이식` 은 게이트
  허용어가 아니라 `제외` · `해당없음` 으로 바꾸고 **원 문구를 사유 칸에 그대로 남겼다.**
- 표 셀 안에 `|` 를 쓰지 않는다(게이트가 열 구분자로 읽어 열이 밀린다) — 논리합은 `‖` 로 적는다.

---

## 1. 컨트롤 (controls 23건 = C-01~C-23)

| ID | AS-IS | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| C-01 | `Division` LayoutControlItem 라벨 | `components/WorkbenchForm.tsx:161~176` `FormItem` label = `LBL00641` | — | 구현 |
| C-02 | `cboDivision` UsrCombo | `components/WorkbenchForm.tsx:66~68·167~173` `CustomDropdown` + `useTabComboQueries` (`Division_SCP_NoEE`) | — | 구현 |
| C-03 | `cboPlanDate` UsrComboBox | `components/WorkbenchForm.tsx:80~87·186~191` `CustomDropdown` (`OPMZ_DATE_WEEKLY_SCP_ALL` + F-02 클라필터 `filterPlanDates`) | — | 구현 |
| C-04 | `cboVersion` UsrComboBox | `components/WorkbenchForm.tsx:89~97·233~238` `CustomDropdown` (`init` `o_rc1` + F-03 클라필터 `filterVersions`) | — | 구현 |
| C-06 | `dpPlanDate_Days` UsrDatePicker | `components/WorkbenchForm.tsx:205~219` `DatePickerCalendar` (`mindate` 1999-01-01 / `maxdate` 2099-12-31) | — | 구현 |
| C-09 | `imageList1` ImageList | — | 종전 표기 **이식 없음(dead)** — AS-IS 참조 0건(design 01 §1.2). 대응 TO-BE 코드를 만들지 않는 것이 파리티다 | 제외 |
| C-10 | `layoutControlGroup1` | — | 종전 표기 **이식 없음(dead)** — 부모 미부착이라 런타임에 존재하지 않는다 | 제외 |
| C-11 | `layoutControlGroup2` | `components/WorkbenchForm.tsx:154~279` `SearchArea` `conditions` 1행 6필드 | — | 구현 |
| C-12 | `Nick Name` 라벨 | `components/WorkbenchForm.tsx:248` `FormItem` label = `LBL00767` | — | 구현 |
| C-13 | `Model` 라벨 | `components/WorkbenchForm.tsx:265` `FormItem` label = `LBL00669` | — | 구현 |
| C-14 | `lciPlanDate` (Visibility 토글) | `components/WorkbenchForm.tsx:179` weekly 분기 조건부 렌더 (R04) | — | 구현 |
| C-15 | `lciPlanDate_Days` (Visibility 토글) | `components/WorkbenchForm.tsx:198` daily 분기 조건부 렌더 (R04) | — | 구현 |
| C-16 | `lciVersion` (Visibility 토글) | `components/WorkbenchForm.tsx:226` `usesVersion(activeTab)` 조건부 렌더 (R03) | — | 구현 |
| C-17 | `spdMain` FpSpread (5 SheetView) | `Workbench.tsx:413~431` `TabWrapper` `persist` × 5 `TabItem` + `components/WorkbenchGrid.tsx:233~247` 공용 `DataGrid` | — | 구현 |
| C-18 | `spdMain_Sheet1` Designer 기본 시트 | — | 종전 표기 **이식 없음(dead)** — 런타임 AddSheet 5시트로 대체된다 | 제외 |
| C-19 | `txtItem` UsrTextBox | `components/WorkbenchForm.tsx:268~274` `InputField` (Model → `itemId`) | — | 구현 |
| C-20 | `txtNickName` UsrTextBox | `components/WorkbenchForm.tsx:251~257` `InputField` (Nick Name → `nickName`) | — | 구현 |
| C-21 | `usrConditionPanel1` (HidePanel) | `Workbench.tsx:386~400` `MainTitle` `openSearchArea` + 조건부 `WorkbenchForm` 렌더 | — | 구현 |
| C-22 | `usrLayoutControl1` | — | 종전 표기 **이식 없음(dead)** — `this.Controls.Add` 가 없어 화면에 붙지 않는다 | 제외 |
| C-23 | `usrLayoutControl2` | `components/WorkbenchForm.tsx:101~109` 조회조건 폼 전체 + 권한 게이트 `disabled` (R01) | — | 구현 |

**소진 23 / 23** (dead 4건 = C-09·C-10·C-18·C-22 — 이식 대상 아님)

---

## 2. 이벤트 (events 8건 = E-01~E-08)

설계문서 `00_checklist.md` 는 이 8건을 `E01`~`E08` 로 부른다 — 같은 행이다(머리말 ID 표기 규약).

| ID | AS-IS | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| E-01 | `cboDivision.SelectedIndexChanged` cs:1991 | `Workbench.tsx:146~152` `handleDivisionChange` (하위 콤보 재계산 + `clearFilters()` 5탭 비움) | — | 구현 |
| E-02 | `cboPlanDate.SelectedIndexChanged` cs:2000 | `Workbench.tsx:155~161` `handlePlanDateChange` (Version 재계산 + `clearFilters()`) | — | 구현 |
| E-03 | `spdMain.ActiveSheetChanged` cs:2046 | `Workbench.tsx:187` `setActiveTab` 커밋 → R03/R04 조건부 렌더 + `components/WorkbenchGrid.tsx:71~74` 동적 컬럼 재평가(`useMemo` deps) | — | 구현 |
| E-04 | `spdMain.ActiveSheetChanging` cs:2054 | `Workbench.tsx:167~191` `handleTabChange` 가드(R09 무메시지 / R10 `MSG01149`) | — | 구현 |
| E-05 | `spdMain_CellClick` cs:2072 | `Workbench.tsx:232` `grid.selection.row`(Delete 가드 입력) + `components/WorkbenchGrid.tsx:137~149` `beginningEdit` 셀 콤보 게이트 | — | 구현 |
| E-06 | `SpdMain_CellDoubleClick` cs:2174 | `components/WorkbenchGrid.tsx:180~193` `dblClickHandler` (팝업 2종, 가드 D-09·D-10) | — | 구현 |
| E-07 | `SpdMain_ClipboardPasted` cs:2235 | `components/WorkbenchGrid.tsx:160~175` `pastingCell`(게이트) + `pastedCell`(파생 D1·D2·D4) | — | 구현 |
| E-08 | `SpdMain_ComboSelChange` cs:2300 | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` → `deriveOnCellChange` (파생 D1~D4) | — | 구현 |

**소진 8 / 8**

---

## 3. gridSignals (48건 = G-01~G-48)

### 3.1 영역3 24건

| ID | AS-IS (line) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| G-01 | `VisibleTab(true)` 356 | `Workbench.tsx:414~430` `TAB_ORDER.map` — 탭 5개 상시 노출 | 종전 범위행 `G01~G05` 를 개별 ID 로 전개했다(게이트는 범위 표기를 파싱하지 않아 5건이 통째로 누락된다). 5건 모두 같은 구현으로 수렴한다 | 구현 |
| G-02 | `VisibleTab(true)` 376 | `Workbench.tsx:414~430` `TAB_ORDER.map` | 범위행 전개 2/5 | 구현 |
| G-03 | `VisibleTab(true)` 384 | `Workbench.tsx:414~430` `TAB_ORDER.map` | 범위행 전개 3/5 | 구현 |
| G-04 | `VisibleTab(true)` 391 | `Workbench.tsx:414~430` `TAB_ORDER.map` | 범위행 전개 4/5 | 구현 |
| G-05 | `VisibleTab(true)` 400 | `Workbench.tsx:414~430` `TAB_ORDER.map` | 범위행 전개 5/5 | 구현 |
| G-06 | `ChangeActiveSheet` 410 | — | 종전 표기 **이식 없음(dead)** — 호출부가 주석처리라 AS-IS 런타임에서도 실행되지 않는다 | 제외 |
| G-07 | `VisibleTab(true)` 411 | — | 종전 표기 **이식 없음(dead)** — G-06 과 같은 메서드 안이라 도달 불가 | 제외 |
| G-08 | `SetSheetHeaderColumnSCP` 422 | `useWorkbenchStore.ts:132~146` `fetchStaticColumns()` — mount 1회(`Workbench.tsx:110`) + **Search 마다 refetch**(`Workbench.tsx:125`) | — | 구현 |
| G-09 | `Delete()` 507 | `Workbench.tsx:229~239` `handleDelete` + `utils/workbench.editLock.ts:86~90` `isRowDeletable`(`CHG_TYPE` 가드) | — | 구현 |
| G-13 | `Query(ds)` 699 | `hooks/useWorkbenchData.ts:81~127` `useTabProcQuery` 결과 → `Workbench.tsx:418` `DataGrid` `itemsSource` | — | 구현 |
| G-15 | `Insert()` 723 | `Workbench.tsx:203~213` `GridAction.addRow` (`handleInsert`) | — | 구현 |
| G-17 | `SetValue` 746 (N1) | `utils/workbench.insert.ts:42~52` MKT FCST 기본값 4~5개 | — | 구현 |
| G-23 | `SetValue` 778 (N2) | `utils/workbench.insert.ts:53~57` STOCK·StockElec 기본값 3개 | — | 구현 |
| G-29 | `SetValue` 795 (N3) | `utils/workbench.insert.ts:58~62` Elec. Demand 기본값 4개 | — | 구현 |
| G-34 | `SetValue` 826 (N4) | `utils/workbench.insert.ts:63~66` 2nd OCV 기본값 3개 | — | 구현 |
| G-40 | `SetText(e.Row, e.Column, sProject)` 2210 | `components/WorkbenchGrid.tsx:190·212~225` `setCellValue(COL.PROJECT_CODE, …)` — 공백이면 미대입 | — | 구현 |
| G-41 | `SetText(e.Row, ITEM_ID, sItemId)` 2227 | `components/WorkbenchGrid.tsx:191·212~225` `setCellValue(COL.ITEM_ID, …)` — 컬럼 지정 | — | 구현 |
| G-42 | Paste `FCST_TYPE` 2248 | `components/WorkbenchGrid.tsx:171~175` `pastedCell` → `utils/workbench.derive.ts:84~85` D1 | — | 구현 |
| G-43 | Paste `STOCK_TYPE` 2265 | `components/WorkbenchGrid.tsx:171~175` `pastedCell` → `utils/workbench.derive.ts:88~92` D2 (2nd OCV 포함) | — | 구현 |
| G-44 | Paste `OPERATION_ID` 2288 | `components/WorkbenchGrid.tsx:171~175` `pastedCell` → `utils/workbench.derive.ts:95~107` D4 | — | 구현 |
| G-45 | Combo `FCST_TYPE` 2307 | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` → `utils/workbench.derive.ts:84~85` D1 | — | 구현 |
| G-46 | Combo `STOCK_TYPE` 2316 | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` → `utils/workbench.derive.ts:88~92` D2 | — | 구현 |
| G-47 | Combo `OPERATION_ID` 2361 | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` → `utils/workbench.derive.ts:95~107` D4 | — | 구현 |
| G-48 | Combo `STOCK_TYPE`(2nd OCV) 2370 | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` → `utils/workbench.derive.ts:88~92` D2 | — | 구현 |

### 3.2 영역1 lock 24건 — `utils/workbench.editLock.ts` 한 함수로 수렴

| ID | AS-IS (line) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| G-10 | `SwitchLock()` 517 | `utils/workbench.editLock.ts:77~79` `isCellEditable` 기존행 경로 → `EDITABLE_ON_EXISTING_ROW` = `CHG_QTY`·`CHG_RSN` | 종전 묶음행 `G10·G11·G12` 를 개별 ID 로 전개(게이트 파싱 대상화). 3건이 한 판정으로 수렴한다 | 구현 |
| G-11 | `LockColumn` 518 | `utils/workbench.editLock.ts:77~79` + `workbench.constants.ts:195` `EDITABLE_ON_EXISTING_ROW` | 묶음행 전개 2/3 | 구현 |
| G-12 | `LockColumn` 519 | `utils/workbench.editLock.ts:77~79` + `workbench.constants.ts:195` `EDITABLE_ON_EXISTING_ROW` | 묶음행 전개 3/3 | 구현 |
| G-14 | `LockColumn(0, max, true)` 700 | — | 종전 표기 **미이식**(규범 `convert-core.md §2.4` — 조회 후 전열 잠금은 **모드축**이고 모드 토글 자체를 이식하지 않는다, §10-9). 그 자리는 권한축이 대신한다 — `utils/workbench.editLock.ts:54` `if (!canEdit) return false` | 제외 |
| G-16 | `LockRange CELL_PROD_SITE_ID` 738 | `utils/workbench.editLock.ts:62~63` 조건부 잠금 1 (division ≠ '40') + `utils/workbench.insert.ts:50` 값 `'-'`(`NOT_APPLICABLE`) | — | 구현 |
| G-18 | LockRange 748 (MKT FCST) | `workbench.constants.ts:203~216` `EDITABLE_ON_INSERT_ROW` MKT FCST + `utils/workbench.editLock.ts:56~58` | 종전 범위행 `G18~G22` 전개 1/5 | 구현 |
| G-19 | LockRange 749 (MKT FCST) | `workbench.constants.ts:203~216` + `utils/workbench.editLock.ts:56~58` | 범위행 전개 2/5 | 구현 |
| G-20 | LockRange 750 (MKT FCST) | `workbench.constants.ts:203~216` + `utils/workbench.editLock.ts:56~58` | 범위행 전개 3/5 | 구현 |
| G-21 | LockRange 751 (MKT FCST) | `workbench.constants.ts:203~216` + `utils/workbench.editLock.ts:56~58` | 범위행 전개 4/5 | 구현 |
| G-22 | LockRange 752 (MKT FCST) | `workbench.constants.ts:203~216` + `utils/workbench.editLock.ts:56~58` | 범위행 전개 5/5 | 구현 |
| G-24 | LockRange 780 (STOCK·StockElec) | `workbench.constants.ts:218~247` `EDITABLE_ON_INSERT_ROW` STOCK / STOCK_ELEC | 종전 범위행 `G24~G28` 전개 1/5 | 구현 |
| G-25 | LockRange 781 (STOCK·StockElec) | `workbench.constants.ts:218~247` | 범위행 전개 2/5 | 구현 |
| G-26 | LockRange 782 (STOCK·StockElec) | `workbench.constants.ts:218~247` | 범위행 전개 3/5 | 구현 |
| G-27 | LockRange 783 (STOCK·StockElec) | `workbench.constants.ts:218~247` | 범위행 전개 4/5 | 구현 |
| G-28 | LockRange 784 (STOCK·StockElec) | `workbench.constants.ts:218~247` | 범위행 전개 5/5 | 구현 |
| G-30 | LockRange 797 (Elec. Demand) | `workbench.constants.ts:249~256` `EDITABLE_ON_INSERT_ROW` Elec. Demand | 종전 범위행 `G30~G33` 전개 1/4 | 구현 |
| G-31 | LockRange 798 (Elec. Demand) | `workbench.constants.ts:249~256` | 범위행 전개 2/4 | 구현 |
| G-32 | LockRange 799 (Elec. Demand) | `workbench.constants.ts:249~256` | 범위행 전개 3/4 | 구현 |
| G-33 | LockRange 800 (Elec. Demand) | `workbench.constants.ts:249~256` | 범위행 전개 4/4 | 구현 |
| G-35 | LockRange 828 (2nd OCV) | `workbench.constants.ts:258~267` `EDITABLE_ON_INSERT_ROW` 2nd OCV | 종전 범위행 `G35~G39` 전개 1/5 | 구현 |
| G-36 | LockRange 829 (2nd OCV) | `workbench.constants.ts:258~267` | 범위행 전개 2/5 | 구현 |
| G-37 | LockRange 830 (2nd OCV) | `workbench.constants.ts:258~267` | 범위행 전개 3/5 | 구현 |
| G-38 | LockRange 831 (2nd OCV) | `workbench.constants.ts:258~267` | 범위행 전개 4/5 | 구현 |
| G-39 | LockRange 832 (2nd OCV) | `workbench.constants.ts:258~267` | 범위행 전개 5/5 | 구현 |

**소진 48 / 48** (dead 2건 = G-06·G-07 / 모드축 미이식 1건 = G-14)

### 3.3 그리드 동작(behavior) 파리티 게이트 — `guides/grid-behavior-parity.md`

이 표는 ID 축이 아니라 동작축 요약이다(게이트 파싱 대상 아님 — 각 동작의 판정은 위 G 행에 있다).

| 축 | AS-IS 전수 확인 결과 | TO-BE |
|---|---|---|
| 셀 병합 | `SmartColMerge`/`RangeMerge`/`RightColMerge`/`SetColumnMerge`/`MergePolicy`/`FPMerge` **grep 0건** + `Add*Column` 호출 **0건**(이 화면은 컬럼을 코드로 선언하지 않고 `SCM_MST_SHEET_COLUMNS` 메타로 구성한다 — `gridColumns` 0건, design 03 §2.1) → **병합 없음 확정** | `allowMerging` 미지정(공용 기본 `ColumnHeaders`) · `CustomMergeManager` 미도입 |
| Lock 계열 | `LockColumn` / `LockRange` / `SwitchLock` 24건 | `utils/workbench.editLock.ts` (§3.2) |
| 셀 타입 콤보 | `SetComBoParam` 8 + `SetComboDataRow` 15 | 컬럼 메타 `FPComboBox` + 화면 주입 `dataMap` (`utils/workbench.gridCombos.ts`) |
| FrozenColumnCount | 호출 0건 · `FIXED_FLAG` 전건 `'-'` | `frozenColumns` 미지정 |
| Sort / Filter | 공용 F3/F4 | `SubTitle` 기본(`buttonActions.sort`/`filter` 미override) |
| SetValue Auto-Sync | G-42~G-48 | `utils/workbench.derive.ts` (D1~D4) |

---

## 4. buttonGuards (18건 = D-01~D-18)

| ID | AS-IS | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D-01 | `fps == null` cs:496 | `Workbench.tsx:231` `if (!grid) return` (`handleDelete`) | — | 구현 |
| D-02 | `fps.Name == "spdMain"` cs:498 | `Workbench.tsx:403` `SubTitle` `grid={gridRefs[activeTab]}` — 활성 시트 라우팅 | — | 구현 |
| D-03 | `_currRowIdx < 0` cs:502 | `Workbench.tsx:232~233` `if (selected < 0) return` (`handleDelete`) | — | 구현 |
| D-04 | `fps == null` cs:525 | `Workbench.tsx:320` `if (!grid) return` (`handleSave`) | — | 구현 |
| D-05 | `_isFinding` cs:2056 | `Workbench.tsx:169` `if (isFetching) return` (`handleTabChange`, R09) | — | 구현 |
| D-06 | `!IsLock(활성시트)` cs:2063 | `Workbench.tsx:177~186` `if (source.some(isDirtyRow)) { alert(MSG01149); return }` | **R10 대체 규칙**(규범 §2.4 / goal.md §8) — 모드가 아니라 **미저장 변경(`CRUD_TYPE`) 유무**로 차단한다. 모드 기준을 그대로 옮기면 편집 기본 ON 이라 탭 전환이 영구 차단된다 | 구현 |
| D-07 | `!IsLock(sheet)` cs:2074 | `components/WorkbenchGrid.tsx:137~149` `beginningEdit` → `isCellEditable(… canEdit …)` | — | 구현 |
| D-08 | `GetText(row, Action) == 'I'` | `utils/workbench.editLock.ts:56~58` `isCellEditable` 신규행 경로 (`EDITABLE_ON_INSERT_ROW`) | — | 구현 |
| D-09 | `!e.ColumnHeader` | `components/WorkbenchGrid.tsx:183` `if (hit.cellType !== CellType.Cell) return` | — | 구현 |
| D-10 | `IsLock` ‖ `Action != 'I'` | `components/WorkbenchGrid.tsx:181·186` `if (!canEditRef.current) return` + `if (!isInsertRow(row)) return` | 모드축 → 권한축 재표현(규범 §2.4). AS-IS 원문의 논리합 기호(파이프 2개)는 게이트가 열 구분자로 읽으므로 요지 칸에 `‖` 로 적었다 | 구현 |
| D-11 | `chg_type != ""` cs:509 | `utils/workbench.editLock.ts:86~90` `isRowDeletable` | — | 구현 |
| D-12 | Edit 모드 아니면 Insert 무동작 cs:720 | `Workbench.tsx:373` `insert: hasButton('INSERT') && canEdit ? handleInsert : false` + `Workbench.tsx:199` `if (!canEdit) return` | — | 구현 |
| D-13 | Edit 모드 아니면 Save return cs:840 | `Workbench.tsx:375` `save: … && canEdit ? handleSave : false` + `Workbench.tsx:318` `if (!canEdit) return` | — | 구현 |
| D-14 | `RowCount == 0` cs:842 | `Workbench.tsx:325~328` `setToast(MSG00004)` | alert 아님 — hook #132 §3 | 구현 |
| D-15 | `checkRequiredOfSearch` cs:539 | `Workbench.tsx:116~123` `handleSearch` 첫 줄 division 가드 | 필수 `*` 조회조건이 0건이라 이 분기만 유효하다(`components/WorkbenchForm.tsx:283~284`) | 구현 |
| D-16 | Paste 는 Edit 모드에서만 cs:2235 | `components/WorkbenchGrid.tsx:160~168` `pastingCell` → `isCellEditable` | — | 구현 |
| D-17 | ComboSelChange 는 Edit 모드에서만 cs:2300 | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` | `cellEditEnded` 는 편집이 열려야 발생 = `beginningEdit` 게이트가 선행한다 | 구현 |
| D-18 | `dtMyDivision.Rows.Count == 0` cs:190 | `components/WorkbenchForm.tsx:101~109` `noAuthority` → 전 필드 `disabled` + `MSG00667` 1회 | — | 구현 |

**소진 18 / 18**

---

## 5. filterCalls (27건 = F-01~F-27)

| ID | AS-IS | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| F-01 | `dtDivision_GM` 필터 → Plan Date 위젯 판정 cs:261 | `hooks/useWorkbenchData.ts:60~63` `isGmDivision`(lookup) + `workbench.constants.ts:542~543` `resolvePlanDateMode` | — | 구현 |
| F-02 | `dtPlanDateAll ⋂ DIVISION_ID` cs:275 | `utils/workbench.cascade.ts:21~27` `filterPlanDates` | — | 구현 |
| F-03 | `dtVersionNoAll ⋂ division + planStart~+6d` cs:288 | `utils/workbench.cascade.ts:33~48` `filterVersions` | — | 구현 |
| F-04 | `dtSalesSiteAll ⋂ division` | `utils/workbench.gridCombos.ts:170·180` `salesSite` → MKT FCST `SCM_SITE_ID` 후보 | — | 구현 |
| F-05 | `dtPlantSiteAll ⋂ division` | `utils/workbench.gridCombos.ts:171·183~184` `plantSite` | — | 구현 |
| F-06 | `dtScmSiteAll ⋂ division` | `utils/workbench.gridCombos.ts:172·190·196` `scmSite` | — | 구현 |
| F-07 | `dtLineAll ⋂ division` | `utils/workbench.gridCombos.ts:119·145` `buildStockLineRows` / `buildElecDemandLineRows` 1단 | — | 구현 |
| F-08 | `dtPlantIDAll ⋂ division` | `utils/workbench.gridCombos.ts:81~93·205` `buildPlantIdRows` | — | 구현 |
| F-09 | 조회 `p_plan_start_yyyymmdd` 원천 분기 cs:626 | `Workbench.tsx:100~104` `planStartYyyymmdd` 단일 원천 | **B2 정정** — 위젯·조회·CUTOFF 를 항상 일치시킨다(AS-IS 4지점 불일치 미재현, §10-1) | 구현 |
| F-10 | `dtVersionNo ⋂ division+code` → 신규행 CUTOFF cs:732 | `utils/workbench.insert.ts:44~48` `versionAll.find(...)` (MKT FCST) | — | 구현 |
| F-11 | `dtDivision_GM` → STOCK 계열 CUTOFF cs:758 | `utils/workbench.insert.ts:56` `planStartYyyymmdd` | B2 정정(§10-1) | 구현 |
| F-12 | `dtDivision_GM` → 2nd OCV CUTOFF cs:806 | `utils/workbench.insert.ts:65` `planStartYyyymmdd` | B2 정정 — AS-IS 3중 불일치 미재현(§10-1) | 구현 |
| F-13 | `dtMktFcstAll` 11키 중복검사 | `workbench.constants.ts:387~399` `DUPLICATE_KEYS` MKT FCST + `hooks/useWorkbenchValidation.ts:71~91` `buildDuplicateKey` | — | 구현 |
| F-14 | `dtProjectCodeAll ⋂ division+code` | `hooks/useWorkbenchValidation.ts:202~212` (`projectAll`) | — | 구현 |
| F-15 | `dtProjectCodeAll_40 ⋂ code` | `hooks/useWorkbenchValidation.ts:195~200` (`projectCode40All`) | — | 구현 |
| F-16 | `dtItemAll ⋂ division+item` (MKT FCST) | `hooks/useWorkbenchValidation.ts:216~227` (`itemAll`) | — | 구현 |
| F-17 | `dtStockAll` 9키(+UC 2 / Elec 1) | `workbench.constants.ts:401~424·450` `DUPLICATE_KEYS` STOCK / STOCK_ELEC + `STOCK_UC_DUPLICATE_KEYS` (`hooks/useWorkbenchValidation.ts:83`) | — | 구현 |
| F-18 | `dtElecDemandAll` 8키(SEQ 제외) | `workbench.constants.ts:426~435` `DUPLICATE_KEYS` Elec. Demand | — | 구현 |
| F-19 | `dtItemAll` (Elec. Demand) | `workbench.constants.ts:490~496` `ITEM_EXISTENCE_CHECK` + `hooks/useWorkbenchValidation.ts:216~227` | — | 구현 |
| F-20 | `dtStockSecondOcvAll` 7키 + NULL 분기 | `workbench.constants.ts:437~446` `DUPLICATE_KEYS` 2nd OCV | 빈 `SECOND_OCV_DATE` 는 빈 토큰으로 등가(`buildDuplicateKey`) | 구현 |
| F-21 | `ActiveSheetChanged` GM 분기 cs:2032 | `Workbench.tsx:93` `resolvePlanDateMode(activeTab, isGmDivision)` | — | 구현 |
| F-22 | `dtPlantSite ⋂ division+scmSite` → PLANT_ID | `utils/workbench.gridCombos.ts:109~116` `siteIdsByPlant` 역인덱스 | — | 구현 |
| F-23 | `dtLineAll ⋂ division+plantId` (STOCK) | `utils/workbench.gridCombos.ts:118~123` + 컬럼 메타 `ATTRIBUTE2` (행 단위 좁힘) | — | 구현 |
| F-24 | `dtPlantSite ⋂ division+plantSite` (Elec.) | `utils/workbench.gridCombos.ts:135~142` `buildElecDemandLineRows` | — | 구현 |
| F-25 | `dtLineAll ⋂ division+plantId` (Elec.) | `utils/workbench.gridCombos.ts:144~149` + 컬럼 메타 `ATTRIBUTE2` | — | 구현 |
| F-26 | `GetOperationByLine` 1단 | `utils/workbench.derive.ts:44~48` `operationByLine` 1단(plantSite → plantId) | — | 구현 |
| F-27 | `GetOperationByLine` 2단 → OPERATION_ID | `utils/workbench.derive.ts:50~56` 2단(line → `OPERATION_ID`) | — | 구현 |

**소진 27 / 27**

---

## 6. 콤보 원천 (comboCalls 7 = B-01~B-07, 추가 원천 B-08~B-18)

| ID | AS-IS | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| B-01 | `BLUtils.GetDivisionWithoutEE` → `Division_SCP` + `ATTRIBUTE3<>'EE'` | `workbench.constants.ts:87` CMBO `Division_SCP_NoEE` + `components/WorkbenchForm.tsx:66~68` | EE 제외를 WHERE 에 흡수한 등록본을 쓰고 `mnuId` 는 미전달한다(§7 U1) | 구현 |
| B-02 | `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY)` | `workbench.constants.ts:89` CMBO `OPMZ_DATE_WEEKLY_SCP_ALL` + F-02 클라필터 + `utils/workbench.cascade.ts:56~57` `stripTimeFromLabel` | U2 표시 보정(공유 SQL 본문 수정 금지) | 구현 |
| B-03 | lookup `SALES_TYPE_CODE` | `hooks/useWorkbenchData.ts:27·47~49` `useTabLookupQueries` → 후보는 `utils/workbench.gridCombos.ts:73~74` `asDisplayKeyRows`(CODE=NAME=표시명) 로 화면 주입, 파생 D1 은 원본 후보로 NAME→CODE 역변환(`utils/workbench.derive.ts:25~29` `codeByName`) | 메타 자동 경로(`CELL_COMBO_DATA_TYPE='FcstType'`)는 iter-2 `05_register.sql` (4-2) 로 해제했다(DB 실측 `CELL_COMBO_DATA_TYPE IS NOT NULL` = 1 = `YesOrNo` 만) | 구현 |
| B-04 | lookup `INCOTERMS` | `hooks/useWorkbenchData.ts:27` + `utils/workbench.gridCombos.ts:43~44·173` `withLeadingDash`(B-18) → 3시트 주입 | — | 구현 |
| B-05 | lookup `STOCK_TYPE` | `hooks/useWorkbenchData.ts:27` + `utils/workbench.gridCombos.ts:175` → 3시트 `STOCK_TYPE_NAME` 주입 + 파생 D2 | — | 구현 |
| B-06 | lookup `OPMZ_DIVISION_GM` | `workbench.constants.ts:82` `GM_LOOKUP_TYPE` + `hooks/useWorkbenchData.ts:60~63` `isGmDivision` | FE 화이트리스트 리터럴 0건(hook #113) | 구현 |
| B-07 | `dtBefore_YN` (lookup `STOCK_TYPE`) | — | 종전 표기 **이식 없음(dead)** — AS-IS 참조 0건이고 `BEFORE_DEGAS` 는 메타 `YesOrNo` 자동 콤보가 담당한다 | 제외 |
| B-08 | `GET_SEARCH_INFO` Tables[0] | `hooks/useWorkbenchData.ts:131` `init` `o_rc1` → `init.versionAll` | — | 구현 |
| B-09 | Tables[1] (SalesSite) | `hooks/useWorkbenchData.ts:132` `o_rc2` → `salesSiteAll` | 종전 범위행 `B09~B16` 을 개별 ID 로 전개(게이트 파싱 대상화). 대응은 `Tables[n]` ↔ `o_rc{n+1}` 위치 대응이며 필드명은 `hooks/useWorkbenchData.ts:129~142` 실측 | 구현 |
| B-10 | Tables[2] (PlantSite) | `hooks/useWorkbenchData.ts:133` `o_rc3` → `plantSiteAll` | 범위행 전개 2/8 | 구현 |
| B-11 | Tables[3] (ScmSite) | `hooks/useWorkbenchData.ts:134` `o_rc4` → `scmSiteAll` | 범위행 전개 3/8 | 구현 |
| B-12 | Tables[4] (Item) | `hooks/useWorkbenchData.ts:135` `o_rc5` → `itemAll` | 범위행 전개 4/8 | 구현 |
| B-13 | Tables[5] (Project) | `hooks/useWorkbenchData.ts:136` `o_rc6` → `projectAll` | 범위행 전개 5/8 | 구현 |
| B-14 | Tables[6] (EndCustomer = PROJECT_CODE_40) | `hooks/useWorkbenchData.ts:137` `o_rc7` → `projectCode40All` | 범위행 전개 6/8 | 구현 |
| B-15 | Tables[7] (Location) | `hooks/useWorkbenchData.ts:138` `o_rc8` → `locationAll` | 범위행 전개 7/8 | 구현 |
| B-16 | Tables[8] (Line) | `hooks/useWorkbenchData.ts:139` `o_rc9` → `lineAll` | 범위행 전개 8/8 | 구현 |
| B-17 | `dtPlantIDAll` 클라 합성(CODE=NAME=PLANT_ID) | `utils/workbench.gridCombos.ts:81~93` `buildPlantIdRows` (X3) | — | 구현 |
| B-18 | `dtIncoterms` 선두 `'-'` InsertAt(0) | `utils/workbench.gridCombos.ts:43~44` `withLeadingDash` | 공유 참조 오염까지 재현해 3시트 모두 적용(X1) | 구현 |

---

## 7. 팝업 (popups 7 = U-01~U-07)

| ID | AS-IS | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| U-01 | `ProgressForm` (1/5) | — | 종전 표기 **이식 없음** — react-query `isFetching`(`hooks/useWorkbenchData.ts:178~183`)이 TO-BE 표준이고 별도 로딩 토스트 추가는 금지다(nscm-patterns §6). 종전 범위행 `U01~U05` 를 개별 ID 로 전개했다 | 제외 |
| U-02 | `ProgressForm` (2/5) | — | U-01 과 동일(범위행 전개 2/5) | 제외 |
| U-03 | `ProgressForm` (3/5) | — | U-01 과 동일(범위행 전개 3/5) | 제외 |
| U-04 | `ProgressForm` (4/5) | — | U-01 과 동일(범위행 전개 4/5) | 제외 |
| U-05 | `ProgressForm` (5/5) | — | U-01 과 동일(범위행 전개 5/5) | 제외 |
| U-06 | `SCM0002_ProjectbyDivisionPopupEx` (MKT FCST `PROJECT_CODE`) | `components/WorkbenchGrid.tsx:251~266` `ProjectByDivisionModal` — `preSearchParams` = **행** division·scmSite·project + `'ALL'` 2건(AS-IS 리터럴) | — | 구현 |
| U-07 | `SCM0002_ItembyDivisionPopup` (MKT FCST `ITEM_ID`) | `components/WorkbenchGrid.tsx:269~284` `ItemByDivisionModal` — division 원천은 **조회조건**(행 값 아님) | — | 구현 |

---

## 8. 진입점 (entryPoints 13 = P-01~P-13)

| ID | AS-IS override/handler | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| P-01 | `FindButton` cs:484 | `Workbench.tsx:372` `hotkeyConfig.search` | 권한 무관 — `hasButton('SEARCH')` 만 본다 | 구현 |
| P-02 | `InsertButton` cs:489 | `Workbench.tsx:373` `hotkeyConfig.insert` (`hasButton('INSERT') && canEdit`) | — | 구현 |
| P-03 | `DeleteButton` cs:494 | `Workbench.tsx:374` `hotkeyConfig.delete` (`hasButton('DELETE') && canEdit`) | — | 구현 |
| P-04 | `EditButton` cs:512 (**NO-OP 아님**) | — | 종전 표기 **미이식**(규범 §2.4 — 모드 토글). `customButtons` 없음 · `hotkeyConfig.edit` 도 없음(Hotkeys enum 에 없는 죽은 키). `EDIT` 버튼코드는 권한축(`canEdit = hasButton('EDIT')`, `Workbench.tsx:85`)으로만 쓰이고 DB 메타 7행은 유지한다(§10-9) | 제외 |
| P-05 | `SaveButton` cs:523 | `Workbench.tsx:375` `hotkeyConfig.save` | — | 구현 |
| P-06 | `ClbDivision_SelectedIndexChanged` | `Workbench.tsx:146~152` `handleDivisionChange` | — | 구현 |
| P-07 | `CboPlanDate_SelectedIndexChanged` | `Workbench.tsx:155~161` `handlePlanDateChange` | — | 구현 |
| P-08 | `SpdMain_ActiveSheetChanged` | `Workbench.tsx:187` `setActiveTab` + `components/WorkbenchGrid.tsx:71~74` `useMemo` 재평가 | — | 구현 |
| P-09 | `spdSub_ActiveSheetChanging` | `Workbench.tsx:167~191` `handleTabChange` | — | 구현 |
| P-10 | `spdMain_CellClick` | `Workbench.tsx:232` 선택행 추적 + `components/WorkbenchGrid.tsx:137~149` `beginningEdit` 게이트 | — | 구현 |
| P-11 | `SpdMain_CellDoubleClick` | `components/WorkbenchGrid.tsx:180~193` `dblClickHandler` (팝업 2종) | — | 구현 |
| P-12 | `SpdMain_ClipboardPasted` | `components/WorkbenchGrid.tsx:160~175` `pastingCell` + `pastedCell` | — | 구현 |
| P-13 | `SpdMain_ComboSelChange` | `components/WorkbenchGrid.tsx:242~246` `cellEditEnded` | — | 구현 |

`manual`/`upload` override 는 AS-IS 에 없다 → `hotkeyConfig` 에 `false` 명시(`Workbench.tsx:376~377`).
Excel override 도 없다(BaseForm 공통 살아 있음) → `excel` 키 미지정으로 공용 기본 유지.

---

## 9. 검증 (validations 40건)

AS-IS MSG 번호를 그대로 쓰지 않는다 — 전건 `SCM_ADM_MSG_M` 문구 역조회 실측(hook #114).
매핑표는 `workbench.constants.ts` 의 `MSG` JSDoc 에 있다.

아래 표의 첫 열은 **AS-IS `Save_Data` 검증 순서**이지 대사표 ID 축이 아니다(게이트 파싱 대상 아님).
같은 검증들이 D 축(D-13·D-14·D-15·D-18)과 F 축(F-13~F-20)에 ID 로 잡혀 있고 그쪽에서 판정했다.

| 순서 | AS-IS (호출 line) | 건수 | TO-BE 구현 |
|---|---|---:|---|
| 0 | Edit 모드 아님 cs:840 | 1 | `hotkeyConfig.save = … && canEdit` + `handleSave` 첫 줄 `if (!canEdit) return` (모드축 → 권한축, 규범 §2.4) |
| 0' | `RowCount == 0` cs:842 | 1 | `handleSave` → `setToast(MSG00004)` |
| 1 | 신규행 필수 공백 `MSG00001` 928·938·1271·1537·1801 | 5 | `INSERT_REQUIRED_COLUMNS` / `MKT_FCST_REQUIRED_SMALL` → `MSG01027` |
| 2 | 신규행 중복 `MSG00260` 973·1305·1560·1832 | 4 | `DUPLICATE_KEYS` + `buildDuplicateKey` → `MSG00428` |
| 3.1 | 날짜 형식 `MSG00046` 990·1323·1577·1851 | 4 | `isValidYyyymmdd` → `MSG01081` (`{0}` = `DATE_COLUMN_LABEL`) |
| 3.2 | Plan 시작일 역전 `MSG00463` 997·1330·1584 | 3 | `PLAN_START_REVERSE_CHECK` → `MSG01437` (2nd OCV 제외) |
| 4 | Project 존재 `MSG00457` 1009·1021 | 2 | `projectAll` / `projectCode40All` → `MSG00457`(동일 번호 정합) |
| 5 | Item 존재 `MSG00458` 1034·1593 | 2 | `ITEM_EXISTENCE_CHECK` → `MSG00458`(동일 번호 정합) |
| 6 | 기존행 필수값 `MSG00310` 1344·1606·1866 | 3 | `EXISTING_ROW_REQUIRED_MSG` → `MSG00013` |
| 6' | `checkRequiredOfSpread` 1045 (MKT FCST) | 1 | `EXISTING_ROW_REQUIRED_MSG[MKT_FCST]` = `MSG01027` |
| 7 | 변경 없음 skip 1041·1337·1600·1859 | 4 | `isUnchanged` → `continue`(무메시지) |
| 8 | `CHG_TYPE` 승격 1049·1350·1612·1872 | 4 | `promoteChange` (`activeFlag='I'`·`chgType='Change'`) |
| 9 | 음수 금지 `MSG00050` 1060·1360·1623·1885 | 4 | `Number(chgQty) < 0` → `MSG01082` |
| 10 | 저장 결과 `MSG00004` 1138·1439·1697·1958 | 4 | `sendSave` false-success 판별 후 `MSG00672` |
| 영역1 | 탭 전환 `MSG00129` 2065 | 1 | `handleTabChange` → `MSG01149` |
| 권한 | `MSG00097`(BaseForm:5274) | 1 | `noAuthority` → `MSG00667` |

**소진 40 + 권한 1 = 41 / 40** (권한 게이트는 `00_checklist §6b` 외 `§4d D18` 축에도 잡혀 중복 계수)

---

## 10. 의도적 정정 (AS-IS 결함 미재현) — `runtime-parity-gate` 에 이 절을 근거로 제출

이 표의 첫 열은 정정 일련번호이지 대사표 ID 축이 아니다(게이트 파싱 대상 아님).

| # | AS-IS 실동작 | TO-BE | 근거 |
|---|---|---|---|
| 1 | Plan Date 위젯 / 조회 기준일 / 신규행 CUTOFF 가 4지점에서 불일치 | `planStartYyyymmdd` 단일 원천으로 **항상 일치** | 사용자 결정 B2 (goal.md §7) |
| 2 | GM 분기에서 `cboPlanDate` 미갱신 → stale + 최초진입 NullReference | Plan Date 목록을 division 기준으로 **항상 재계산** | B2 · design 02 §7 U5 |
| 3 | `ToShortDateString().Replace("-","")` 로케일 의존 | `dayjs(...).format('YYYYMMDD')` 고정 | design 02 §7 U6 (명백한 버그) |
| 4 | `FindData_Main` 이 LockFlag 를 리셋하지 않아 "잠긴 듯 보이나 Insert/Save 동작" | **모드축 자체를 미이식**(§10-9)하여 이 결함 구간이 성립하지 않는다. 조회 후 리셋 코드도 없다 | design 01 §5 K3 → 규범 §2.4 로 무효화 (iter-3) |
| 5 | `PRE_CHG_QTY`/`PRE_CHG_RSN` 이 잠금범위 누락으로 편집 가능 | 편집 불가로 고정(SAVE SP 파라미터에 없어 저장 불가 = 무의미 편집) | design 01 §5 K4 |
| 6 | `dtLine` 전역 1개라 Plant Site 없이 Line 만 붙여넣으면 `OPERATION_ID` 공백 | 후보를 **행 단위**로 계산(메타 `ATTRIBUTE2`) → 결함 자연 해소 | design 03 §6 U7 (해소 권고) |
| 7 | `Elec. Demand.LINE_ID` 폭을 코드가 100 으로 덮어씀 | admin 메타 폭(80) 사용 — 코드 override 미재현 | design 03 §6 U6 (메타 정비 권고, hook #130 A-1) |
| 8 | `dpPlanDate_Days` 가 노출될 때마다 오늘로 덮어씀 | **daily 모드 진입 전이마다** 오늘로 재설정하고(`WorkbenchForm.tsx` 진입 전이 감지), 같은 모드에 머무는 동안은 사용자 선택을 보존한다 — iter-2 GAP-7 수정본 | B2 파생 — 표시일 = 조회일 불변식 유지 |
| 9 | 조회 직후 전열 잠금 → Edit 버튼 토글로 해제(모드 축: `siMain.IsLock` / `override EditButton` / `SetLockFlag`) | **미이식**. 편집은 기본 ON 이고 권한은 화면 오픈 시 1회(`canEdit = hasButton('EDIT')`). store `isEditMode`/`setEditMode` 없음 · Edit 토글 버튼 없음 · 조회 후 모드 복귀 없음. 컬럼 단위 잠금(`INPUT_TP_CD='S'` 축 4계층 배선 · 신규행 white-list · 조건부 2건)은 컬럼 속성이므로 **그대로 유지**. 파생 규칙: **R10 = 미저장 변경(`CRUD_TYPE`) 1건 이상일 때만 탭 전환 차단 + `MSG01149`**(모드 기준 그대로면 상시 차단) · D-10 팝업 게이트 = `canEdit` + 신규행 | 규범 `convert-core.md §2.4`(2026-09-25 사용자 전화면 지시) · 판정 `goal.md §8` · 선례 SCP0120 `convert-flow/decisions.md §2` (iter-3) |
| 10 | 저장 성공을 `MessageBox` 로 알림(cs:1138) | **Toast**(성공) — alert 금지 | design 01 §4 V25 · hook #132 (iter-3, GAP-17) |

**미재현 사유 없음(= AS-IS 그대로)**: `Incoterms` 선두 `'-'` 공유참조 오염(X1) · `STOCK.FROM_SITE_ID` 자유텍스트(U12) ·
`Elec. Demand.OPERATION_ID` 콤보 미동작(vestigial) · 팝업 파라미터 `'ALL'` 리터럴 · 라벨 `*` ↔ 실제 필수 불일치(U3, §4.3 표가 정본).

---

## 11. UI 공통(통합테스트) 체크 축 (전 화면 상시 7항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행
> + 2026-08-14 사용자 공통 수정사항 ②(UC-07). 화면 분석 md 에 없는 전 UI 공통 요구라
> 게이트가 상수(`UI_COMMON_ITEMS`)로 보유하고 **부재 시 FAIL** 시킨다.
> 이 절은 2026-09-26 Gate 1 정합화에서 신설했다 — 종전 대사표에는 이 축이 없었다.

| ID | 요지 | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | `Workbench.tsx:203` `GridAction.addRow` → `packages/foundation/src/utils/gridAction.ts:836` `keepRowVisibleUnderFilter(grid, row)`. 필터 인스턴스는 `components/WorkbenchGrid.tsx:235` `gridFilterRef` 로 공용 `DataGrid` 에 배선(5탭이 같은 컴포넌트) | 화면 코드에 필터 clear 호출 0건(grep). `clearFilters()` 는 조회조건 filters 초기화이지 그리드 컬럼 필터가 아니다 | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703) | `components/WorkbenchForm.tsx:154~157` `SearchArea` `onSearch` → `packages/shared/src/components/organisms/search-area/SearchArea.tsx:113~118` `confirmIfDirtyKey(dirtyKey, 'search')` · 단축키·SubTitle 경로도 `Workbench.tsx:401~410` → `packages/shared/src/components/organisms/sub-title/SubTitle.tsx:196~204` 에서 동일 confirm | dirty 등록 원천은 `components/WorkbenchGrid.tsx:236` `editTrackerRef`(`EditTracker` 가 셀 변경을 `CRUD_TYPE` 으로 마킹). 버튼 경로·단축키 경로 **둘 다** confirm 을 탄다 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2) | 해당없음 — 이 화면은 Column/Measure 설정 UI 자체가 없다 | 공용 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:713~716·1585~1586` 이 Column Settings…/Save·Load·Reset Layout 항목을 **`layoutKey` 지정 시에만** 만든다. `components/WorkbenchGrid.tsx:233~247` 은 `layoutKey` 를 넘기지 않으므로 메뉴가 렌더되지 않는다. PIVOT measure 축도 없다(화면 코드 참조 0건) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준) | `Workbench.tsx:284~290` 저장 성공 `setToast({type:'success', …MSG00672})` + `Workbench.tsx:325~333` 변경없음 `setToast({type:'error', …MSG00004})` | 차단·실패 경로(`Workbench.tsx:118~122` Division 미선택 · `:251~257`·`:269~275` 저장 실패 · `hooks/useWorkbenchValidation.ts:108~114` 검증 실패)는 CRUD 완료가 아니라 차단/에러라 `setAlert` 가 맞다(AS-IS GMessageBox 와 동일 의미) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) | `Workbench.tsx:406` `SubTitle` `excelFileName='Workbench'` → `packages/shared/src/components/organisms/sub-title/SubTitle.tsx:185` `GridAction.excelDownload` → `packages/foundation/src/utils/gridAction.ts:255~290·1068` dataMap 스냅샷(살아있는 `col.dataMap` 우선, `columnGroups` 폴백) | 이 화면 콤보 컬럼은 `utils/workbench.columns.ts:56~64` 이 `dataMap` 을 주입한 것 + 메타 자동 콤보 `YesOrNo` 뿐이다. 표시명 축 2종(`FCST_TYPE_NAME`·`STOCK_TYPE_NAME`)은 `utils/workbench.gridCombos.ts:73~74` `asDisplayKeyRows` 로 CODE=NAME 이라 Code/Name 드리프트가 구조적으로 생기지 않는다 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | — | **동작 미충족 — 조용히 통과시키지 않고 사유를 남긴다.** 이 화면 Key-in 조회조건은 Nick Name·Model 2건(`useWorkbenchStore.ts:99~100` Trim only 전달)인데, GET SP 7종이 전부 **단일 LIKE** 다 — `PKG_SCP0125` BODY:395·396·591·592·626·627 `A.ITEM_ID LIKE '%' ‖‖ UPPER(P_ITEM_ID) ‖‖ '%'` / `IC.NICK_NAME LIKE …`(`‖‖` = Oracle 연결연산자 — 표 셀에 파이프를 쓸 수 없어 치환했다. ora.py 2026-09-26 실측, `F_LIST_PARAM`·`INSTR` 계열 토큰 분해 0건). 따라서 `A,B` 를 넣으면 0건이 된다. 콤마 분해는 **SP 계약 변경(convert-sp 소관)** 이라 이 화면 FE 코드로는 해소할 수 없고(FE 가 분해해도 파라미터가 1개 스칼라라 전달 불가), AS-IS 도 동일 동작이라 파리티 결함도 아니다. FE 전환 범위에서 **제외**하고 `design/04_react-gap.md` SP 축 잔여(GAP-10 계열)로 올린다 | 제외 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1481~1483` `rebindFilterColumns(grid, getGridFilter())` — `itemsSource` 재적재로 끊어진 필터-컬럼 연결을 복구한다. `components/WorkbenchGrid.tsx:235` `gridFilterRef` 전달로 이 화면 5탭 그리드 전부 경유 | 이 화면 재조회 경로 2종(Search `Workbench.tsx:126~130` `setFilters` / 저장 후 `Workbench.tsx:294` `handleSearch`)이 전부 `itemsSource` 참조 교체라 같은 복구 경로를 탄다 | 구현 |

---

## 12. 비-'구현' 판정 요약 (무언 누락 금지)

각 행의 정본 판정은 위 §1~§11 표에 있다. 아래는 목록일 뿐이며, **표가 아니라 글머리표로 적는다** —
같은 ID 를 표 첫 열에 다시 쓰면 게이트가 그 줄을 **두 번째 대사 행**으로 읽어 이중 계상한다.

- **제외 · dead 컨트롤 4건** — C-09 · C-10 · C-18 · C-22: AS-IS 참조 0건 · 부모 미부착 · Designer 기본 시트. 이식하지 않는 것이 파리티다.
- **제외 · dead 시그널 2건** — G-06 · G-07: 호출부 주석처리로 AS-IS 런타임에서도 미실행.
- **제외 · 모드축 미이식 2건** — G-14(조회 후 전열 잠금) · P-04(`EditButton` 토글): 규범 `convert-core.md §2.4`. 권한축 `canEdit` 가 대체하고 `EDIT` 버튼코드 메타는 유지한다(§10-9).
- **제외 · dead 콤보 1건** — B-07: `dtBefore_YN` 참조 0건. `BEFORE_DEGAS` 는 메타 `YesOrNo` 자동 콤보가 담당한다.
- **제외 · 로딩 UI 5건** — U-01~U-05: `ProgressForm` → react-query `isFetching` 이 TO-BE 표준이고 별도 로딩 UI 추가는 금지다.
- **해당없음 1건** — COMMON:UC-03: Column/Measure 설정 UI 자체가 없다(`layoutKey` 미전달).
- **제외 · SP 계약 소관 1건** — COMMON:UC-06: Key-in 콤마 다중조회가 GET SP 단일 LIKE 라 **동작 미충족**이다. FE 코드로 해소 불가라 제외로 두되 사유를 전부 남겼다(§11). SP 축 잔여로 올린다.
