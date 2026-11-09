# SCP0114 CAPA LineMaster — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0114_CAPA_LineMaster/SCP0114_CAPA_LineMaster{.cs,.Designer.cs}`
> 설계 근거: `.atlas/gscm-design/SCP0114/design/00_checklist.md` ~ `03_grid-columns.md`, `07_human-doc-supplement.md`
> 커버리지 대상(convert-core §2.1 #11): validations 4 / gridSignals 74 / buttonGuards 12 / entryPoints 22 / gridColumns 47 / comboCalls 8 / controls 29 / events 17
> 상태 표기: 구현 / 해당없음 / 미완(사유 명시). "확인 필요"는 남기지 않고 04_react-gap.md 로 올린다.

---

## 1. 진입점 (entryPoints 22건 — 00 §4-2)

| # | AS-IS name (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | `FindButton` (346) | `CapaLineMaster.tsx handleSearch` → store `setFilter()` (Level1) | 구현 |
| 2 | `SaveButton` (669) → `SaveData` (763) | `CapaLineMaster.tsx handleSave` / `doSave` | 구현 |
| 3 | `SpdLevel1_CellDoubleClick` (1743) | `CapaLineMasterLevelGrid` dblClick → `store.drillDown(1, row)` | 구현 |
| 4 | `SpdLevel2_CellDoubleClick` (1762) | 동일 (level=2) | 구현 |
| 5 | `SpdLevel3_CellDoubleClick` (1779) | 동일 (level=3) | 구현 |
| 6 | `SpdLevel4_CellDoubleClick` (1797) | 동일 (level=4) | 구현 |
| 7 | `cboDivision_SelectedIndexChanged` (1835) | `CapaLineMasterForm` Division 변경 → `setSearchCondition` → 페이지 조회조건 effect 의 **division 분기**: `clearAllTrackers()` + `clearFilters()`(5그리드·applied·drill 전부) + `fetchStaticColumns(새 division)`. AS-IS `FindData(1)` → `InitSpread(1~5)` 와 **범위 동일**. **즉시 재조회만 하지 않는다**(명시 Search 게이트, 2026-09-23 사용자 확정) | 구현(결정 반영) |
| 8 | `rgrpSearchLevel_SelectedIndexChanged` (1845) | Product Group 변경 → 같은 effect 의 **product-group 분기**: `tracker4`·`tracker5` 만 clear 후 store `resetForProductGroup()` — **L4·L5 filter 만 삭제**하고 L1~L3 filter·drill(SITE/COMPANY/PLANT)·`applied.divisionId` 는 유지, `applied.shopGroupId` 만 교체, `drill` 의 `FACTORY_*` 만 제거. AS-IS `FindData(4,…)` → `case 4: InitSpread(4); InitSpread(5)`(cs:712~716) 와 **범위 동일**. 편집모드는 비우는 레벨(4·5)일 때만 해제하고 L1~L3 편집은 유지한다 — AS-IS `RefreshEditMode`(cs:1629~1636)가 `IsEditModes` dict 만 되돌리고 실제 저장 게이트 `IsLock`(cs:784)은 건드리지 않기 때문 | 구현(결정 반영) |
| 9 | `DeleteButton` (358) | `handleDelete` — 가드 3 + 신규행('I')만 `GridAction.removeRow(grid, true)` | 구현 |
| 10 | `EditButton` (462) | `handleEdit` → `store.toggleEditingLevel(activeLevel)` | 구현 |
| 11 | `InsertButton` (353) → `InsertRow` (1196) | `handleInsert` + `buildInsertRow` | 구현 |
| 12 | `SpdLevel5_CellDoubleClick` (1816) | **재조회 없음**(AS-IS 도 ID 캐시만 하고 `FindData` 미호출). `canDrillDown` 이 level<5 로 차단 | 구현(무동작 재현) |
| 13~17 | `spdAssign_Change` ×5 (1727, 그 외 동일 핸들러) | 공용 `EditTracker`(DataGrid wrapper)가 셀 변경을 `CRUD_TYPE='M'` 으로 마킹. AS-IS 본문은 가드 2건 후 전부 주석(1739~1740) | 구현(공용 대체) |
| 18~22 | `spdLevelN_ClipboardPasted` ×5 (1867/1876/1886/1896/1906) | AS-IS 본문은 전부 주석 처리(사문). TO-BE 는 `pastingCell` 에 편집잠금 게이트를 걸어 잠긴 셀 붙여넣기를 차단(AS-IS LockRange 와 등가) | 구현(상위 규칙으로 흡수) |

---

## 2. 버튼 가드 (buttonGuards 12건 — 00 §4d)

| # | AS-IS condition (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | Delete `spreadLevel == null` (364) | `handleDelete` — `if (!grid) return` | 구현 |
| 2 | Delete `ActiveSheet.RowCount == 0` (367) | `if (grid.rows.length === 0) return` | 구현 |
| 3 | Delete `ActiveSheet.ActiveRow == null` (370) | `if (!grid.selectedRows?.length) return` | 구현 |
| 4 | Edit `EditCnt == 'I' \|\| 'M'` (482) | `handleEdit` — 활성 그리드 source 에 `CRUD_TYPE` I/M 행 있으면 return | 구현 |
| 5 | Edit `editCnt > 1` (498) | `store.toggleEditingLevel` — 다른 레벨이 편집중이면 무시(동시 1개) | 구현 |
| 6 | Change `spreadLevel == null` (1733) | 그리드별 핸들러라 sender 가 항상 존재 — 구조상 해소 | 해당없음 |
| 7 | Change `spreadLevel.IsLock(SheetName)` (1736) | `beginningEdit` 게이트(`isCellEditable`)가 편집모드 아닌 시트의 셀 변경을 애초에 차단 | 구현 |
| 8 | L1 dblClick `Rows.Count <= 0` (1745) | `canDrillDown(level, rowCount, editingLevel)` — rowCount>0 조건 | 구현 |
| 9 | L2 dblClick `Rows.Count <= 0` (1764) | 동일 | 구현 |
| 10 | L3 dblClick `Rows.Count <= 0` (1781) | 동일 | 구현 |
| 11 | L4 dblClick `Rows.Count <= 0` (1799) | 동일 | 구현 |
| 12 | L5 dblClick `Rows.Count <= 0` (1818) | 동일 (+ level<5 로 이미 무동작) | 구현 |

추가 가드(가드표 밖, `InsertRow`/`SaveData` 본문):

| AS-IS | TO-BE | 상태 |
|---|---|:--:|
| `InsertRow` `spreadLevel.IsLock(SheetName) == false` (1202) | `handleInsert` — `editingLevel !== activeLevel` 이면 삽입 안 함(+ MSG00662 안내) | 구현 |
| `SaveData` `_si.ActiveSheet.Rows.Count <= 0` (782) | `handleSave` — dirty 0건이면 MSG00004 후 return | 구현 |
| `SaveData` `_si.IsLock(SheetName) == false` (784) | `handleSave` — `editingLevel !== level` 이면 return | 구현 |
| 드릴다운 `Columns[StringAction].Visible` (1748/1767/1784/1802) | `canDrillDown` — `editingLevel === level` 이면 억제 | 구현 |

---

## 3. 검증 (validations 4건 — 00 §2-B)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | `"Id 또는 Name 값이 없습니다."` / `CheckDummyDuplication()` (771) | `hooks/useCapaLineMasterValidation.findMissingIdOrName` — 'I' 행 자기 ID+NAME, 'M' 행 자기 NAME 공백 차단. 메시지는 TO-BE `MSG00429 "{0} value is required."` + 컬럼 라벨(hook #114 — AS-IS 문자열 리터럴 직접 이식 금지). 공용 `useSaveWithValidation`(메타 INPUT_TP_CD=IM/M) 병행 | 구현 |
| 2 | `MSG00004` 저장 건수 (933) | `doSave` 성공 토스트 = TO-BE `MSG00672 "{0} data saved."`. **AS-IS MSG00004 는 TO-BE 에서 "No changes to save." 라 번호 이식 금지**(hook #114) | 구현 |
| 3 | 저장 결과 비'S' 메시지 (961) | `doSave` — `result_code !== 'S'` 시 서버 message 표면화, 없으면 `MSG00060`(중복). SAVE SP 의 유일한 비'S' 경로가 `THROW 99020 중복`(07 §3 S3) | 구현 |
| 4 | `GMessageBoxForException` (968) | `doSave` catch — Error.message 또는 `MSG00003 "Failed to save."` | 구현 |

---

## 4. 그리드 시그널 (gridSignals 74건 — 03 §3 규칙 R1~R18 로 합성)

| ID | AS-IS 규칙 (signal 라인) | 구현 위치 (파일:라인) | 사유 / 보충 | 상태 |
|---|---|---|---|---|
| R1 | `AddActionTextBox` ×5 (242/259/278/298/320) — CRUD 마킹 숨김열 | `CapaLineMasterLevelGrid.tsx:142` `editTrackerRef` → 공용 `EditTracker` + `CRUD_TYPE` | 구조적 대체 — CRUD 마킹은 admin 컬럼이 아니라 공용 래퍼 소관이라 `SCM_MST_SHEET_COLUMNS` 47행에 없는 것이 정상. 자체 행상태 필드 신설 0건(grep) | 구현 |
| R2 | `Freeze(0, 앵커)` ×5 (249/268/288/310/336) | 공용 `DataGrid`(`frozenColumns` 미지정 — admin `FIXED_FLAG` 로 위임) | **2026-10-13 gap-resolve iter-2 수정.** `Freeze` 2번째 인자는 개수이고 `AddActionTextBox` 가 0번에 숨김 Action 컬럼을 넣어 AS-IS 실효(화면상) 고정열은 5시트 전부 **0**이다(`.atlas/memory/grid-freeze-parity-fixed-flag-vs-prop.md`). `SCM_MST_SHEET_COLUMNS` `FIXED_Y` 도 전건 `'-'`(=0)라 **DB 변경 없이 화면의 `resolveFrozenColumns`/`FREEZE_ANCHOR_COLUMN` 를 제거**하는 것이 정합이다 — 이전엔 L1 앵커(`DIVISION_ID`)가 visible 이라 FE 가 index+1=1 로 오프바이원 계산해 그 컬럼을 시각적으로 고정시키고 있었다(CLAUDE.md §2 체크4 저촉, G33 재분류: R3 사용자승인→R1 코드 해소) | 구현 |
| R3 | `VisibleTab(true)` ×5 + `VisibleAlternatingRow` (251/270/290/312/338/754) | `CapaLineMaster.tsx:459~487` 5그리드 정적 렌더(PanelGroup) + `CapaLineMasterLevelGrid.tsx:140` 레벨 캡션 | zebra·rowHeader 는 공용 DataGrid 기본값(hook #95/#108). 동적 show/hide 분기 0건 — design 01 §2 L1·L3 | 구현 |
| R4 | `Query(ds)` (747) — 결과셋 바인딩 | `CapaLineMaster.tsx:103~137` `useTabProcQuery` ×5 → `:140~144` `rows{1..5}` → `CapaLineMasterLevelGrid.tsx:145` `itemsSource` | 시트별 독립 query. 응답 키 `o_rc1` 은 PKG 배포 후 `runtime-parity-gate` 재판정 대상(§10) | 구현 |
| R5 | `LockColumn(0, max, true)` (748) — 조회 직후 전열 읽기전용 | `utils/capaLineMaster.editLock.ts:68` `if (editingLevel !== level) return false` | 조회 직후 `editingLevel=null` 이라 전열 false. `beginningEdit`(`CapaLineMasterLevelGrid.tsx:96`)·`pastingCell`(`:108`)·`formatItem`(`:81`) 이 같은 함수를 공유 | 구현 |
| R6 | L1 SwitchLock + per-row LockRange (512~538, 11건) | `editLock.ts:50~72` `isCellEditable(1,…)` + `constants.ts:95` `LEVEL_ID_COLUMN[1]='SITE_ID'` / `:105` `LEVEL_NAME_COLUMN[1]='SITE_NAME'` / `:133~138` `ALWAYS_LOCKED_COLUMNS` | hook #130 — LockRange 컬럼 인덱스 상수 미이식, 컬럼명 축으로 의미 재현 | 구현 |
| R7 | L2 동일 (544~567, 8건) | `editLock.ts:50~72` `isCellEditable(2,…)` + `constants.ts:96`/`:106` (`COMPANY_ID`/`COMPANY_NAME`) | 동일 함수의 레벨 파라미터 분기 — 레벨별 중복 코드 없음 | 구현 |
| R8 | L3 동일 (573~596, 8건) | `editLock.ts:50~72` `isCellEditable(3,…)` + `constants.ts:97`/`:107` (`PLANT_ID`/`PLANT_NAME`) | 〃 | 구현 |
| R9 | L4 동일 (602~625, 8건) | `editLock.ts:50~72` `isCellEditable(4,…)` + `constants.ts:98`/`:108` (`FACTORY_ID`/`FACTORY_NAME`) | 〃 | 구현 |
| R10 | L5 동일 (631~660, 12건) | `editLock.ts:50~72` `isCellEditable(5,…)` + `:62` `isValidYnOfLevel5` + `constants.ts:99`/`:109` (`LINE_ID`/`LINE_NAME`) | `SHOP_GROUP_ID`·`DUMMY_YN` 은 `ALWAYS_LOCKED_COLUMNS` 라 편집모드에서도 잠금(cs:650/658) | 구현 |
| R11 | `Insert()` + SORT_ORDER=Max+1 (1214) | `editLock.ts:88~95` `nextSortOrder(rows)` | 행 0건이면 1 — AS-IS `ds` 부재 시 1 과 동일(cs:1206~1212) | 구현 |
| R12 | 공통 기본값 VALID_YN='Y', DUMMY_YN='Y' (1259~1262) | `editLock.ts:113~115` + `constants.ts:149~150` `INSERT_DEFAULT_VALID_YN`/`INSERT_DEFAULT_DUMMY_YN` | 신규행은 항상 dummy — 사람설계서 업무규칙 4 와 정합 | 구현 |
| R13 | L1 신규행 DIVISION_ID + 잠금 (1267/1268) | `editLock.ts:103~125` `buildInsertRow(1,…)` + `constants.ts:115` `LEVEL_PARENT_KEYS[1]=[]` | L1 은 부모키가 없어 division 만 상속. `hasParentContext(1,…)` 는 빈 배열이라 항상 통과(AS-IS 동일) | 구현 |
| R14 | L2 신규행 부모키(SITE_*) (1273) | `editLock.ts:119~121` + `constants.ts:116` `LEVEL_PARENT_KEYS[2]` | 부모키 원천은 드릴다운 컨텍스트(`useCapaLineMasterStore.ts:162~179`) — 빈 값 폴백 금지(convert-core §2.4) | 구현 |
| R15 | L3 신규행 +COMPANY_* (1278) | `editLock.ts:119~121` + `constants.ts:117` `LEVEL_PARENT_KEYS[3]` | 〃 | 구현 |
| R16 | L4 신규행 +PLANT_* (1283) | `editLock.ts:119~121` + `constants.ts:118` `LEVEL_PARENT_KEYS[4]` | 〃 | 구현 |
| R17 | L5 신규행 +FACTORY_* + SHOP_GROUP_ID (1288) | `editLock.ts:119~123` + `constants.ts:119~128` `LEVEL_PARENT_KEYS[5]` + `CapaLineMaster.tsx:237` 확정 `applied.shopGroupId` | SHOP_GROUP_ID 는 입력중 `searchCondition` 이 아니라 Search 로 확정된 `applied` 에서 온다(CommonCheckList Division §) | 구현 |
| R18 | 신규행만 `Delete()`, 기존행 return (378) | `CapaLineMaster.tsx:246~253` `handleDelete` → `GridAction.removeRow(grid, true)`(`gridAction.ts:895~898` `deleteOnlyNew`) | 기존행은 제거도 `CRUD_TYPE='D'` 마킹도 하지 않는다 — hook #138. AS-IS 는 단건 ActiveRow, TO-BE 는 선택행 전건이나 대상이 신규행에 한정돼 데이터 결함 없음(04 `issues L5`) | 구현 |

소진 signal 합 = 5+5+6+1+1+11+8+8+8+12+1+1+2+1+1+1+1+1 = **74** (03 §3 대사와 동일).

---

## 5. 그리드 컬럼 (gridColumns 47건 — 03 §1)

| 시트 | AS-IS `InitSpread` 라인 | 데이터 컬럼 수 | TO-BE |
|---|---|--:|---|
| Level1 | 244~248 | 5 | `LEVEL_COLUMNS[1]` + `SCM_MST_SHEET_COLUMNS` SHEET_NAME='Level1'(등록 완료) |
| Level2 | 261~267 | 7 | `LEVEL_COLUMNS[2]` / 'Level2' |
| Level3 | 279~287 | 9 | `LEVEL_COLUMNS[3]` / 'Level3' |
| Level4 | 299~309 | 11 | `LEVEL_COLUMNS[4]` / 'Level4' |
| Level5 | 321~335 | 15 | `LEVEL_COLUMNS[5]` / 'Level5' (VALID_YN = FPComboBox/YesOrNo, align C) |
| 합 | — | **47** | 03 §1 대사 일치 |

하위 시트의 부모레벨 컬럼은 `visible=false` 로 **컬럼을 유지**한다(데이터 보유·화면 숨김) — AS-IS `AddTextColumn(..., bVisible:false)` 와 동일.

---

## 6. 콤보 (comboCalls 8건 — 00 §4b)

| # | AS-IS | TO-BE | 상태 |
|--:|---|---|:--:|
| 1 | `BLUtils.GetDivisionWithoutEE(false,"")` (63) → `Data_SCP.Common(Type.Division)` + `ATTRIBUTE3<>'EE'` | `CapaLineMasterForm` — `useTabComboQueries({comboId:'Division_SCP', mnuId})` + `ATTRIBUTE3!=='EE'` 클라 필터 | 구현 |
| 2~6 | `Data_SCP.CommonAll(Capa{Site,Company,Plant,Factory,Line})` (64~68) | AS-IS 에서도 소비 지점(`RefreshSpreadAll`)이 `InsertRow` 조기 return 으로 **도달하지 않는 사문 배선**(03 §1.7). 그리드 컬럼은 전부 텍스트 입력 | 해당없음(사문) |
| 7 | `Data.Common(Type.YesOrNo)` (89) → siLevel5.VALID_YN 셀콤보 | `SCM_MST_SHEET_COLUMNS` Level5 VALID_YN `CELL_COMBO_DATA_TYPE='YesOrNo'` → 공용 DataGrid 자동 배선 | 구현 |
| 8 | `Data_SCP.CommonAll(CapaSite)` 저장 후 재로드 (1615) | #2~#6 과 동일 사문 경로 | 해당없음(사문) |

---

## 7. 컨트롤 / 레이아웃 (controls 29건 — 00 §1, 01 §1)

| AS-IS | TO-BE | 상태 |
|---|---|:--:|
| `usrPanel`(UsrConditionPanel, HidePanel) + `usrLayoutControl2` + `layoutControlGroup2` | `SearchArea`(`CapaLineMasterForm`) + `MainTitle.openSearchArea` 토글 | 구현 |
| `cboDivision`(UsrCombo) + `Division` LayoutControlItem | `CustomDropdown` 단일선택 + `FormItem label=t('LBL00641')` | 구현 |
| `usrLabel1`("Product Group") + `rgrpSearchLevel`(RadioGroup 3항목) | `FormItem label=t('LBL00088')` + `CustomDropdown` 단일선택 3옵션. **공용 RadioGroup 컴포넌트 부재로 드롭다운 매핑**(04 §확인필요) | 구현(컨트롤 대체) |
| `splitContainer1`(Horizontal, SplitterDistance=271) | `PanelGroup orientation='vertical'` 상/하 2분할 | 구현 |
| `panel4/5/6` + `spdLevel1/2/3` | 상단 `PanelGroup orientation='horizontal'` 3분할 + `CapaLineMasterLevelGrid` ×3 | 구현 |
| `panel1`(라디오바) | Product Group 을 조회영역(SearchArea)으로 이전(design 02 §5 TO-BE 매핑) — 하단 라디오바 없음 | 구현(위치 이동) |
| `panel2/3` + `spdLevel4/5` | 하단 `PanelGroup orientation='horizontal'` 2분할 + 그리드 ×2 | 구현 |
| 공통 툴바(Find/Insert/Delete/Edit/Save) | `SubTitle hotkeyConfig`(search/insert/delete/save) + `customButtons`(Edit) — 전부 `useTabBtnPermissions().hasButton()` 조건부 | 구현 |
| `RefreshEnabled()` (1705) — 5그리드 항상 `Enabled=true` | 동적 enable 분기 없음(도입하지 않음) | 해당없음 |
| `DefineProperty()` (198~202) — 패널 높이/Visible 전부 주석 | 런타임 강제 숨김 없음 | 해당없음 |

---

## 8. 저장 계약 (03 §4.3)

| AS-IS (line) | TO-BE |
|---|---|
| `activeLevel = fps.Name 끝자리` (776) | `store.activeLevel`(그리드 `gotFocus`) |
| I/M/D 마킹행만 수집 (813) | `CRUD_TYPE === 'I' \|\| 'M'` (이 화면은 D 를 만들지 않는다 — 삭제는 신규행 로컬 제거뿐) |
| `^` 구분 병렬 배열 17 파라미터 (824~897) | `doSave` — `p_active_flag ... p_last_updated_by` 동일 이름·순서, `values.join('^')` |
| 레벨별 미해당 컬럼 `'-'` (832~892) | `SAVE_NOT_APPLICABLE` + `level >= N` 분기 |
| `p_shop_group_id` L1~3 `'-'` / L4~5 `_shopgroupId` (840/853/866/879/892) | `level >= 4 ? applied.shopGroupId : '-'` |
| `p_valid_yn` 전 레벨 `'Y'` 하드코딩 (841/854/867/880/893) | `SAVE_VALID_YN = 'Y'` — **2026-09-23 사용자 확정 (a) AS-IS 재현**. UI VALID_YN 편집값은 전송하지 않는다 |
| `p_created_by/p_last_updated_by` = 세션 UserId (896~897) | `useSessionStore().session.userId` (감사키 빈문자열 금지) |
| 결과 `Rows[0][0]=='S'` 분기 (930) | `doSave` — HTTP/code false-success 차단 + `result_code` 판정 |
| 성공 후 `FindData(activeLevel)` (935~954) → `InitSpread(activeLevel..5)` (689~721) | `clearBelowLevel(level)`(하위 레벨 filter·EditTracker 비움) + `refetchByLevel[level]()`(활성 레벨만 재조회, 전체 재조회 금지) |

---

## 9. 사람 화면설계서 보완 (07 §3)

| ID | 보완 요지 | 구현 위치 (파일:라인) | 사유 / 보충 | 상태 |
|---|---|---|---|---|
| S3 | SAVE 중복검사 Insert=ID-OR-NAME / Modify=NAME / `THROW 99020` | `CapaLineMaster.tsx:324~341` — `result_code !== 'S'` 시 서버 message 표면화, 공란이면 `MSG00060`(중복). 성공 토스트는 `:345~351` 로 분기 뒤에만 도달 | 중복 판정 자체는 SAVE SP 소관(FE 재구현 금지). FE 책임은 비'S' 응답을 삼키지 않는 것 — false-success 차단은 `:315` HTTP/code 분기와 2중 | 구현 |
| S4 | VALID_YN 편집·필수 의도 vs 라이브 'Y' 하드코딩 | `CapaLineMaster.tsx:299~301` `acc.p_valid_yn.push(SAVE_VALID_YN)` + `constants.ts:168~171` `SAVE_VALID_YN='Y'` | **(a) AS-IS 재현 = 2026-09-23 사용자 확정.** 셀 편집은 허용(03 §1.6, `editLock.ts:62`)하되 저장 payload 는 'Y' 고정 — quirk 를 저장 경로 주석에 명시(이모지 금지) | 구현 |
| S5 | 레벨별 CHK 체크박스 신설 금지 | `CapaLineMaster.tsx:250` `grid.selectedRows` 단건 선택 모델. 컬럼 정의(`constants.ts:193~293`)에 CHK/CheckBox 컬럼 0건 | 사람설계서 2.데이터항목의 CHK 는 템플릿 표기이고 소스(Roslyn `AddColumn` 47건)·삭제가드(`ActiveRow` 단건)에 없다 — 소스 우선(07 §3 S5) | 구현 |

---

## 10. 미완 / 후속

| 축 | 상태 | 사유 |
|---|---|---|
| `PKG_SCP0114` GET/SAVE 런타임 | **해소(2026-10-13 gap-resolve iter-2)** | `all_objects`: `PKG_SCP0114` PACKAGE + PACKAGE BODY 모두 `VALID`(convert-sp 가 iter-1 이후 배포) |
| `SCM_ADM_PROC_M` 파라미터 메타 | **해소(2026-10-13 gap-resolve iter-2)** | `SCM_ADM_PROC_M` GET 8키·SAVE 17키(+OUT 2) = 29행, `all_arguments` 와 이름·순서·타입 1:1 일치. 전건 `p_*` 접두로 등록돼 FE 25키(`p_*`)와 그대로 정합 — iter-1 이 경고한 "camelCase 등록 시 NULL 바인딩" 리스크는 발생하지 않았다(convert-sp 가 `p_*` 로 등록) |
| 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터) | **미완(사용자 확인 축)** | 정적 검증으로 대체 불가 |

---

## 11. AS-IS 정본 확정 (2026-09-23 gap-resolve iter-1)

`SCP0114_CAPA_LineMaster.cs` 는 **2본**이 존재하고 둘 다 AssemblyName 이 `SCP0114_CAPA_LineMaster` 라
경로만으로는 정본이 갈리지 않는다. 실측으로 **Master 본**을 정본 확정했다(이 대사표 전체의 근거 원천).

| 후보 | 행수 | SAVE SP 호출 | `DUMMY_YN` | `rgrpSearchLevel` | 판정 |
|---|--:|---|--:|--:|---|
| `GSCM/06.UIL/GSCM.SCP.Forms.UIL/**Master**/SCP0114_CAPA_LineMaster/…cs` (`namespace GSCM.SCP.Master.UIL`) | 1,933 | `SCP0114_SAVE_CAPA_LINE_MASTER` 호출 | 31 | 4 | **정본** |
| `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0114_CAPA_LineMaster/…cs` (`namespace GSCM.SCP.Report.UIL`) | 1,561 | 호출 없음(GET 만) | 0 | 0 | 구 read-only 계열 — 대상 아님 |

근거: ① AS-IS MSSQL `sys.objects` 에 `SCP0114_SAVE_CAPA_LINE_MASTER` 실재(`asis.py` 실측) — 호출자는 Master 뿐.
② 사람설계서 업무규칙 4(Dummy 컬럼 고정/Name 만 변경)는 `DUMMY_YN` 이 없는 Report 본에서 성립하지 않는다.
③ 업무규칙 3(Level4·5 Product Group 조건)의 `rgrpSearchLevel` 이 Report 본에 없다.
`_artifacts/_diagnostics/combo_callsite_parity.py` 의 `ASIS_CANON` 에 같은 근거로 등록해 게이트 SKIP 을 해소했다.

---

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행(+2026-08-14 신설 UC-07).
> 화면 분석 md 에 없는 전 UI 공통 요구 — `asis_mapping_gate.py --check` 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | `CapaLineMaster.tsx:232` `GridAction.addRow` → `packages/foundation/src/utils/gridAction.ts:836` `keepRowVisibleUnderFilter(grid, row)`(필터 예외 등록 후 `:851` refresh). 필터 인스턴스는 `CapaLineMasterLevelGrid.tsx:143` `gridFilterRef` 로 공용 DataGrid 에 배선 | 5그리드 전부 같은 `CapaLineMasterLevelGrid` 경유라 레벨별 차이 없음. 화면 코드에 필터 clear 호출 0건(grep) | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703) | `packages/shared/src/components/organisms/search-area/SearchArea.tsx:113~116` `confirmIfDirtyKey(dirtyKey,'search')` ← `CapaLineMasterForm.tsx:73~76` `<SearchArea onSearch>` / 단축키·SubTitle 경로도 `packages/shared/src/components/organisms/sub-title/SubTitle.tsx:198` 에서 동일 confirm ← `CapaLineMaster.tsx:434~441` | dirty 등록 원천은 `CapaLineMasterLevelGrid.tsx:142` `editTrackerRef`(EditTracker 가 셀 변경을 CRUD_TYPE 으로 마킹). 버튼 경로·단축키 경로 **둘 다** confirm 을 탄다 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2) | 해당없음 — 이 화면은 Column/Measure 설정 UI 자체가 없다 | 공용 `DataGrid.tsx:713~716` 이 Column Settings·Save/Load/Reset Layout 컨텍스트 메뉴를 **`layoutKey` 지정 시에만** 만든다. `CapaLineMasterLevelGrid.tsx:141~150` 은 `layoutKey` 를 넘기지 않으므로 메뉴가 렌더되지 않는다. Measure 도 `SCM_MST_SHEET_MEASURE` 0행(pivot 없음, design 03 §2). 04 §4 "TitleSet 저장 후 복원 = 미해당" 과 동일 판정 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준) | `CapaLineMaster.tsx:345~351` 저장 성공 `setToast({type:'success', …MSG00672})` + `:377` 변경없음 `setToast({type:'error', …MSG00004})` | 저장 **실패**(`:316~322` HTTP/code) · **중복 99020**(`:333~339`) · 필수값 미입력(`:388~396`) · Division 미선택(`:193~199`) 은 CRUD 완료가 아니라 차단/에러라 `setAlert` 가 맞다(AS-IS GMessageBox 동일 의미) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) | `CapaLineMaster.tsx:439` `SubTitle excelFileName='CapaLineMaster'` → `SubTitle.tsx:185` `GridAction.excelDownload` → `gridAction.ts:257~281` dataMap 스냅샷(살아있는 `col.dataMap` 우선, columnGroups 폴백) | 이 화면 셀 콤보는 **1건**(Level5 `VALID_YN` → `YesOrNo`)이고, `SCM_ADM_CMBO_SQL_M` 본문이 `SELECT 'Y' AS CODE,'Y' AS NAME … UNION ALL 'N','N'`(ora.py 실측)라 **CODE=NAME** — Code/Name 드리프트가 구조적으로 발생하지 않는다. 나머지 46컬럼은 텍스트(AS-IS `AddTextColumn` 46건과 정합) | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | 해당없음 — 텍스트 Key-in 조회조건 0건 | 조회조건 2건이 전부 단일선택 드롭다운이다(`CapaLineMasterForm.tsx:86~93` Division / `:104~112` Product Group). AS-IS 도 `cboDivision`(UsrCombo) + `rgrpSearchLevel`(RadioGroup) 뿐이라 콤마 다중입력 대상 텍스트박스가 없다(00 §1 #2·#15, 02 §1). 콤마 다중검색 요구 미해당 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1477~1479` `rebindFilterColumns(grid, getGridFilter())` — itemsSource 재적재로 끊어진 필터-컬럼 연결 복구. `CapaLineMasterLevelGrid.tsx:143` `gridFilterRef` 전달로 이 화면 5그리드 전부 경유 | 이 화면의 재조회 경로 3종(Search `CapaLineMaster.tsx:201` / 드릴다운 `useCapaLineMasterStore.ts:185~191` / 저장 후 `CapaLineMaster.tsx:355`)이 전부 `itemsSource` 참조 교체라 동일 복구 경로를 탄다 | 구현 |
