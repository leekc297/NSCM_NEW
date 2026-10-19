# SCP0002 LineMaster — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0002_LineMaster/SCP0002_LineMaster{.cs,.Designer.cs}`
> 설계 근거: `.atlas/gscm-design/SCP0002/design/00_checklist.md` ~ `03_grid-columns.md`
> 커버리지 대상(convert-core §2.1): controls 23 / events 7 / validations 3 / spCalls 3 / gridSignals 31 / comboCalls 17 / buttonGuards 12 / entryPoints 12
> 상태 표기: 구현 / 해당없음 / 미완(사유 명시). "확인 필요"는 남기지 않고 04_react-gap.md 로 올린다.
> 화면 구조 전제: 단일 그리드 `spdMain` 2 SheetView 전환 — shtMain(Plant, ActiveSheetIndex 0, 조회 전용) / shtPacker(Packer/OSP, 편집·저장). TO-BE 는 단일 `DataGrid` + View(Plant/Packer) 토글로 시트 전환을 재현(04 G1).

---

## 1. 진입점 (entryPoints 12건 — 00 §4.2)

| # | AS-IS name (line) | kind | TO-BE 구현 | 상태 |
|--:|---|---|---|:--:|
| 1 | `FindButton` (310) → `Find_Data` | toolbarOverride | `LineMaster.tsx handleSearch` → Division 필수 가드 후 `setFilter()` + `fetchStaticColumns()`. 시트별 GET 분기는 `filters[PLANT]`/`filters[PACKER]` enabled | 구현 |
| 2 | `SaveButton` (365) → `Save_Data` (628) | toolbarOverride | `handleSave` — Plant 차단(MSG00109) / `finishEditing` → dirty 수집 → `saveWithValidation(…, mutatePacker)` (Packer 만) | 구현 |
| 3 | `DeleteButton` (342) | toolbarOverride | `handleDelete` — Plant no-op 차단 / Packer 신규행('I')만 `GridAction.removeRow`, 기존행은 토스트 후 return | 구현 |
| 4 | `EditButton` (320) → SwitchLock (334) | toolbarOverride | **Edit 토글 버튼 미도입** — NSCM 표준은 그리드 상시 편집(별도 Edit 모드 없음). 편집 순net 가부는 셀단위 `isPackerCellEditable` 화이트리스트로 등가 재현. 04 "Edit-button-drop" | 구현(표준 대체) |
| 5 | `InsertButton` (315) → `Insert_Row` (560) | toolbarOverride | `handleInsert` — Plant 차단 / Packer `GridAction.addRow(grid, packerInsertDefaults(divisionId))` | 구현 |
| 6 | `ClbBuilding_SelectedIndexChanged` (725) | event | `LineMasterForm` Building 변경 → `set({buildingIds})` (Plant 시트에서만 렌더) | 구현 |
| 7 | `ClbDivision_SelectedIndexChanged` (687) | event | Division 변경 → `set({divisionId, plantSiteIds:[], buildingIds:[], operationIds:[], lineIds:[]})` (하위 cascade 초기화) | 구현 |
| 8 | `ClbOperation_SelectedIndexChanged` (745) | event | Operation 변경 → `set({operationIds})` (Plant 전용) | 구현 |
| 9 | `ClbPlantSite_SelectedIndexChanged` (698) | event | PlantSite 변경 → `set({plantSiteIds, lineIds:[]})` (line 초기화) | 구현 |
| 10 | `SpdMain_ActiveSheetChanged` (261) | event | View(Plant/Packer) `CustomDropdown` → `setMode` — 시트 스왑 + 하위 초기화 + 공급 콤보(PlantSite/Line) 교체. AS-IS 라벨 Visibility 토글은 Building/Operation 조건부 렌더(`isPlant &&`)로 등가 | 구현(토글 대체) |
| 11 | `SpdMain_ClipboardPasted` (808) | event | `LineMasterMainGrid` `g.pastedCell`/`g.pastingCell` 핸들러 — 편집잠금 게이트(잠긴 셀 붙여넣기 차단) + 파생(SITE_DESCRIPTION/OPERATION_ID) 재적용 | 구현 |
| 12 | `SpdMain_ComboSelChange` (757) | event | `g.cellEditEnded` 핸들러 — SCM_SITE_ID 선택 → `deriveSiteSelection` / RACK_YN → `deriveOperationIdByRack` (Packer 신규행만) | 구현 |

override 본문 판정(00 §4.2): 5개 툴바 override 전부 실동작. Edit 만 표준 대체(토글 미도입), 나머지 4개는 실제 핸들러.

### 폼 로드 권한 게이트 (L5/V5 — SetDivisionAuthCheck)

| AS-IS name (line) | kind | TO-BE 구현 | 상태 |
|---|---|---|:--:|
| `SetDivisionAuthCheck(usrLayoutControl2)` (cs:142~143 → BaseForm.cs:5995~6003) | formLoad authGate | 권한 사업부(MyDivision, ATTRIBUTE3<>'EE'+VALID_YN='Y') 0건 → 검색영역 전체 비활성. `LineMasterForm` 이 `noDivisionAuth = divisions!==undefined && divisionOptions.length===0` 판정 후 store `authLocked` set + MSG00097 1회 안내, `<SearchArea sx={pointerEvents:'none',opacity:0.5}>` 로 `usrLayoutControl2.Enabled=false` 등가. F5/SubTitle 단축키 진입점은 `LineMaster.handleSearch` 의 `if (authLocked) return` 로 별도 차단(콤보 미로드 undefined 는 빈배열과 구분 — 초기 오잠금 방지). 근거 asis-checkedlist-blank-means-auth-csv-not-empty | 구현 |

---

## 2. 버튼 가드 (buttonGuards 12건 — 00 §4d)

| # | AS-IS method / condition (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | Edit `spdMain != null` (322) | `handleEdit` 미도입 — 그리드 상시 편집이라 존재 가드 불요 | 해당없음(표준 대체) |
| 2 | Edit `ActiveSheetIndex == 0` → MSG00109 (324) | Plant 시트의 편집 차단은 셀단위 `isPlantCellEditable()===false`(전열 잠금)로 상시 재현. 버튼 경로 MSG00109 는 handleInsert/Delete/Save 의 Plant 분기 alert 로 흡수 | 구현(셀 게이트로 흡수) |
| 3 | Delete `spdMain != null` (344) | `handleDelete` — `if (!grid) return` | 구현 |
| 4 | Delete `ActiveSheetIndex == 0` no-op (346) | `handleDelete` — `if (isPlant) alert(MSG00109); return` | 구현 |
| 5 | Delete `ActiveRow == null` (354) | `handleDelete` — `grid.selectedItems[0]` 없으면 `removeRow` 가 무동작 | 구현 |
| 6 | Save `fps == null` (367) | `handleSave` — `grid?.finishEditing()` 후 dirty 0건이면 MSG00004 return | 구현 |
| 7 | ComboSelChange `IsLock == false` (759) | `cellEditEnded` — `isPlantRef.current \|\| CRUD_TYPE!=='I'` 이면 파생 skip (편집 대상 아님) | 구현 |
| 8 | ComboSelChange `SheetName == shtPacker` (761) | 동일 가드의 `isPlantRef.current` 분기 = Packer 시트에서만 파생 | 구현 |
| 9 | ComboSelChange `RowCount == 0` (763) | `sender.rows[e.row]?.dataItem` 없으면 return | 구현 |
| 10 | ClipboardPasted `IsLock == false` (810) | `pastingCell`(=beginningEditHandler) 편집잠금 게이트가 잠긴 셀 붙여넣기 차단 | 구현 |
| 11 | ClipboardPasted `SheetName == shtPacker` (812) | `pastedCell`(=cellEditEndedHandler) 의 `isPlantRef.current` 분기 | 구현 |
| 12 | ClipboardPasted `RowCount == 0` (814) | `sender.rows[e.row]?.dataItem` 없으면 return | 구현 |

추가 가드(백본 밖, `Insert_Row` 본문 584/586): `IsLock==false && SheetName==shtPacker` → `handleInsert` 의 `if (isPlant) return` + (Packer 상시 편집이라 IsLock 항상 해제) 로 재현.

---

## 3. 검증 (validations 3건 — 00 §4.3)

| # | AS-IS msgId (line) | AS-IS 의미 | TO-BE 구현 | 상태 |
|--:|---|---|---|:--:|
| 1 | MSG00109 (327) | Plant 시트(read-only) Edit 차단 "읽기 전용입니다" | `MSG.READ_ONLY='MSG00109'` — handleInsert/Delete/Save 의 `if (isPlant) setAlert(MSG00109)`. AS-IS 번호 그대로 복사 아니라 TO-BE `SCM_ADM_MSG_M` 문구 역매핑(문구 기준) | 구현 |
| 2 | MSG00004 (654) | 저장 서버판정 `Rows[0][0]=='S'` | 저장 흐름: dirty 0건이면 `MSG.NO_CHANGES='MSG00004'` 토스트. 서버 result_code 'S'/'F' 판정은 공용 `useProcMutation`/`saveWithValidation` 소관 | 구현 |
| 3 | MSG00006 (671) | 저장 서버판정 후속 | 저장 성공 토스트는 공용 mutation 성공 경로(`MSG.SAVE_SUCCESS`). AS-IS MSG00006 번호 직접 이식 금지 — TO-BE 문구 역매핑 | 구현 |

추가 검증: Division 필수(design 02 §2.1 Division*) → `handleSearch` 의 `if (!sc.divisionId) setAlert(MSG.REQUIRED_FIELD)`. 필수 컬럼(메타 M/IM) 미입력 차단은 공용 `useSaveWithValidation`. 권한 사업부 0건 안내 `MSG.NO_AUTH_DIVISION='MSG00097'`(AS-IS SetDivisionAuthCheck GMessageBox 등가 — §1 폼 로드 권한 게이트 참조).

---

## 4. 그리드 시그널 (gridSignals 31건 — 03 §3)

### 4.1 value (SetValue 11건 — 파생/기본값, cs:569/775~857)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | 신규행 기본값 DIVISION_ID/VALID_YN='Y'/RACK_YN='N' (569) | `lineMasterEditLock.ts packerInsertDefaults(divisionId)` | 구현 |
| 2·3 | 콤보선택 SITE_DESCRIPTION/OPERATION_ID 파생 (775/776) | `lineMasterDerive.ts deriveSiteSelection` → `LineMasterMainGrid cellEditEnded` (SCM_SITE_ID changed) | 구현 |
| 4·5 | 미선택 시 SITE_DESCRIPTION/OPERATION_ID clear (781/782) | `deriveSiteSelection` — 콤보행 미매칭(`find` 실패) 시 setCell 미실행 → 빈 값 유지(insertDefaults 초기값 '') | 구현(등가) |
| 6 | Rack 파생 OPERATION_ID+"_R1" (795) | `deriveOperationIdByRack(base, 'Y')` → `cellEditEnded` (RACK_YN changed) | 구현 |
| 7 | Rack 해제 OPERATION_ID 원본 (799) | `deriveOperationIdByRack(base, 'N')` — 접미사 제거 | 구현 |
| 8·9 | 붙여넣기 SITE_DESCRIPTION/OPERATION_ID 파생 (850/851) | `g.pastedCell` = cellEditEndedHandler (동일 파생 경로 재사용) | 구현 |
| 10·11 | 붙여넣기 미매칭 clear (856/857) | 동일 — 미매칭 시 setCell 미실행 | 구현(등가) |

### 4.2 lock (9건 — SwitchLock 1 / LockColumn 5 / LockRange 3, cs:334~573)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 12 | SwitchLock 편집모드 토글 (334) | Edit 토글 미도입(상시 편집) — 셀단위 화이트리스트가 net 편집가부를 상시 재현 | 구현(표준 대체) |
| 13 | LockColumn DIVISION_ID~LINE_ID 키군 잠금 (335) | `EXISTING_ROW_EDITABLE` 에서 키 컬럼 제외 → `isPackerCellEditable` false | 구현 |
| 14 | LockColumn OPERATION_ID 잠금 (336) | OPERATION_ID 는 NEW/EXISTING 화이트리스트 모두 제외(파생 전용) | 구현 |
| 15 | LockColumn RACK_YN 잠금 (337) | 기존행 RACK_YN 잠금 — `EXISTING_ROW_EDITABLE` 에서 제외(신규행만 편집) | 구현 |
| 16 | LockColumn 전열 잠금 Plant 조회직후 (444) | `isPlantCellEditable()===false` — Plant 시트 전 칼럼 잠금 | 구현 |
| 17 | LockColumn 전열 잠금 Packer 조회직후 (517) | Packer 조회 결과행은 CRUD_TYPE 없음 → `EXISTING_ROW_EDITABLE`(3칼럼)만 열림. 조회직후 전열잠금 → 편집모드 순net = 3칼럼 (AS-IS SwitchLock 후 잔여와 등가) | 구현(등가) |
| 18 | LockRange 신규행 SITE_DESCRIPTION 잠금 (571) | `NEW_ROW_EDITABLE` 에서 SITE_DESCRIPTION 제외(파생 전용) | 구현 |
| 19 | LockRange 신규행 DIVISION_ID 잠금 (572) | `NEW_ROW_EDITABLE` 에서 DIVISION_ID 제외(insertDefaults 고정) | 구현 |
| 20 | LockRange 신규행 OPERATION_ID 잠금 (573) | `NEW_ROW_EDITABLE` 에서 OPERATION_ID 제외(파생 전용) | 구현 |

### 4.3 dataSource (Query 2건, cs:443/516)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 21 | Query(ds) Plant 바인딩 (443) | `useTabProcQuery<MENU_ID, SHEETS.PLANT>` → `plantData.o_rc1` → `mainRows`(isPlant) | 구현 |
| 22 | Query(ds) Packer 바인딩 (516) | `useTabProcQuery<MENU_ID, SHEETS.PACKER>` → `packerData.o_rc1` | 구현 |

### 4.4 cellType / freeze / visible (4건, cs:244/450/563)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 23 | SetCellTypeCombo 신규행 SCM_SITE_ID (563) | `LineMasterMainGrid insertOnlyDataMaps` — DataMap `getDisplayValues` 가 CRUD_TYPE==='I' 행에만 후보 반환(신규행 전용). 메타 PARAM 미사용, 화면 하드코딩(insert-only-combo-hardcode) | 구현 |
| 24 | Freeze SITE_DESCRIPTION 까지 좌측 고정 (244) | `resolveFrozenColumns` = FREEZE_ANCHOR('SITE_DESCRIPTION') 인덱스+1 → `g.frozenColumns` | 구현 |
| 25 | VisibleTab 시트탭 표시 (245) | 시트탭 = View(Plant/Packer) 토글로 대체(04 G1) | 구현(토글 대체) |
| 26 | VisibleAlternatingRow 교차행 배경 (450) | 공용 DataGrid 기본 zebra (소스상 주석 흔적 — 동적 분기 없음) | 해당없음(공용 기본) |

### 4.5 other (5건 — ChangeActiveSheet 3 / Delete 1 / Insert 1, cs:228~560)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 27 | ChangeActiveSheet shtMain 초기 (228) | store 초기값 `mode: LINE_MODE.PLANT` | 구현 |
| 28 | ChangeActiveSheet shtMain (269) | `setMode(PLANT)` (View 토글) | 구현 |
| 29 | ChangeActiveSheet shtPacker (279) | `setMode(PACKER)` (View 토글) | 구현 |
| 30 | Delete 신규행('I') (359) | `handleDelete` → `GridAction.removeRow`, 기존행 가드 | 구현 |
| 31 | Insert 신규행 Packer (560) | `handleInsert` → `GridAction.addRow` | 구현 |

소진 signal 합 = 11+9+2+4+5 = **31** (03 §3 대사 일치).

---

## 5. 컨트롤 / 레이아웃 (controls 23건 — 00 §1)

| AS-IS 영역 (건수) | TO-BE 구현 | 상태 |
|---|---|:--:|
| Layout 11 (`usrLayoutControl1/2`, `layoutControlGroup1/2`, `layoutControlItem2/4/5/6/9`, `usrConditionPanel1`, `Division` label) | `SearchArea`(LineMasterForm) + `MainTitle.openSearchArea` 토글 + `FormItem` 라벨. `layoutControlItem4/5` 시트 Visibility 토글 = Building/Operation `isPlant &&` 조건부 렌더 | 구현 |
| 조회조건 6 (`cboDivision`, `cboValid`, `clbPlantSite`, `clbBuilding`, `clbOperation`, `clbLine`) | `CustomDropdown` — Division 단일 + Valid 단일(ALL/Y/N) + PlantSite/Building/Operation/Line 다중(`multi()`). Building/Operation 은 Plant 전용 | 구현 |
| 그리드 3 (`spdMain`, `spdMain_Sheet1`, Packer 런타임 시트) | 단일 `DataGrid`(LineMasterMainGrid) + View(Plant/Packer) 토글 | 구현 |
| static 3 (`components`, `imageList1`, `emptySpaceItem`) | 비시각 — 매핑 대상 아님 | 해당없음 |

---

## 6. 콤보 (comboCalls 17건 → 고유 CODE 8종 — 00 §4b)

| # | AS-IS CODE (api) | 소비 위치 | TO-BE comboId | 상태 |
|--:|---|---|---|:--:|
| 1 | MyDivision (Data.Common) | cboDivision | `COMBO.DIVISION='MyDivision'` + 화면 ATTRIBUTE3<>'EE' + VALID_YN='Y' 필터 | 구현 |
| 2 | YesOrNo (Data.Common) | cboValid + 그리드 셀콤보 | `COMBO.VALID`/`YESORNO_COMBO_ID='YesOrNo'` — 조회조건 + VALID_YN/RACK_YN/SCS_PROD_AMEND 셀 | 구현 |
| 3 | PlantByDivisionOperOsp3 (Data_SCP) | 신규행 셀콤보 소스 | `SITE_COMBO_ID='PlantByDivisionOperOsp3_SCP'`, divisions='40,81,82' — insertOnlyDataMaps | 구현 |
| 4 | PlantByDivisionOperNonOsp (Data_SCP) | clbPlantSite (Plant 시트) | `COMBO.PLANT_SITE_PLANT='PlantByDivisionOperNonOsp123_SCP_ALL'` (CommonAll → _SCP_ALL, SCM_ADM_CMBO_SQL_M 등록명 실측) | 구현 |
| — | PlantByDivisionOperOsp3 (조회조건, Packer 시트) | clbPlantSite (Packer 시트) | `COMBO.PLANT_SITE_PACKER='PlantByDivisionOperOsp3_SCP'` (Common → _SCP) — 시트 분기 | 구현 |
| 5 | BuildingByDivision (Data.Common) | clbBuilding | `COMBO.BUILDING='BuildingByDivision1_SCP_ALL'` (Plant 전용, CommonAll → _SCP_ALL) | 구현 |
| 6 | LocationGroupByCapa (Data.Common) | clbOperation | `COMBO.OPERATION='LocationGroupByCapa'` (param-less 전량, 접미사 없는 공통 콤보) | 구현 |
| 7 | LineByOperation (Data.Common) | clbLine (Plant 시트) | `COMBO.LINE_PLANT='LineByOperation2_SCP_ALL'` (CommonAll → _SCP_ALL) | 구현 |
| 8 | LineByPlantPacker (Data_SCP) | clbLine (Packer 시트) | `COMBO.LINE_PACKER='LineByPlantPacker_SCP'` (Common → _SCP) — 시트 분기 | 구현 |

주의(combo-semantic-parity): Osp3/NonOsp/Packer 접미사는 별개 콤보 — 이름 유사로 통합 금지. Plant/Packer 시트로 PlantSite·Line 공급 콤보가 갈린다(`isPlant ? … : …`). cascade 는 전량 조회 후 client-side 필터(AS-IS CommonAll + DataTable.Select 재현). 나머지 9건은 cascade 재조회 반복 호출.

---

## 7. 저장 계약 (spCalls 3건 — 00 §4.1, 03 §4.4)

| AS-IS SP (line) | TO-BE |
|---|---|
| `SCP0002_GET_LINE_MASTER` (424, params 7) | `useTabProcQuery` PLANT — `filters[PLANT]={divisionId, scmSiteId, locationId:'ALL', factoryId, operationId, lineId, activeFlag}` (ALL→SP NULL 변환) |
| `SCP0002_GET_LINE_MASTER_OSP` (500, params 4) | `useTabProcQuery` PACKER — `filters[PACKER]={divisionId, scmSiteId, lineId, validYn}` |
| `SCP0002_SAVE_LINE_MASTER_OSP` (628, params 8, I/M) | `useProcMutation` PACKER — I/M 만(D 분기 없음, SAVE SP 에 D 사문). `saveWithValidation(dirty, staticColumns[PACKER], mutatePacker)` |

Plant 시트는 저장 SP 없음(조회 전용). Delete 는 신규행 로컬 제거뿐 — 기존행 물리삭제 SP 부재(AS-IS 재현). 감사키(created_by/last_updated_by)는 공용 mutation 이 세션 userId 로 채움(빈문자열 금지).

---

## 8. 미완 / 후속

| 축 | 상태 | 사유 |
|---|---|---|
| `PKG_SCP0002` GET/GET_OSP/SAVE 런타임 | 미완 | 배포 후 `convert-sp` + `runtime-parity-gate` 재판정 대상 |
| `SCM_ADM_MNU_M` 등록(ROUTE_PATH='supply/line-master') | 미완 | 05_register.sql — Task #3 |
| `SCM_MST_SHEET_COLUMNS` Plant 17 / Packer 9 | 등록됨(design 03 §6-3 PASS) | 'Line Master' 중복 sheetNm 은 미사용(매핑 제외) |
| 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze) | 미완(사용자 확인 축) | 정적 검증으로 대체 불가 |

---

## UI 공통(통합테스트) 체크 축 (전 화면 상시 6+1항목)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|:--:|
| COMMON:UC-01 | 필터 상태 Insert 시 필터 유지 | `LineMaster.tsx handleInsert` → `GridAction.addRow`(keepRowVisibleUnderFilter). 필터 clear 호출 0건(grep) | Packer 신규행만 — Plant 차단 | 구현 |
| COMMON:UC-02 | 수정 중 재조회 confirm (MSG00703) | 공용 `SearchArea.onSearch` / `SubTitle` 단축키가 dirty 시 confirm — `LineMasterForm onSearch` + `SubTitle hotkeyConfig` 경유 | dirty 원천 = `mainTrackerRef`(EditTracker) | 구현 |
| COMMON:UC-03 | Column 설정 적용 시 Reset 후 재조회 | 해당없음 — 이 화면 Column Settings UI 없음(`layoutKey` 미전달). Measure `SCM_MST_SHEET_MEASURE` 0행(pivot 없음) | DataGrid 컨텍스트 메뉴 미렌더 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 Toast (실패/차단은 Alert) | 저장 완료 = 공용 mutation 성공 Toast. Plant 차단(MSG00109)·Division 미선택(MSG00429)·변경없음(MSG00004)은 `setAlert`/`setToast(error)` | 차단/에러는 Alert 가 맞음(AS-IS GMessageBox 등가) | 구현 |
| COMMON:UC-05 | Excel 콤보 Code→Name 출력 | `SubTitle excelFileName='LineMaster'` → 공용 `GridAction.excelDownload` dataMap 스냅샷. 셀콤보 VALID_YN/RACK_YN/SCS_PROD_AMEND = YesOrNo(CODE=NAME) / SCM_SITE_ID = insertOnlyDataMaps | CODE=NAME 콤보라 드리프트 없음 | 구현 |
| COMMON:UC-06 | Key-in 콤마 다중조회 | 해당없음 — 조회조건 전부 드롭다운(단일 Division/Valid + 다중 PlantSite/Building/Operation/Line). 텍스트 Key-in 0건 | AS-IS 도 UsrCombo/UsrCheckedList 뿐 | 해당없음 |
| COMMON:UC-07 | 필터 상태 재조회 시 필터 유지 (rebindFilterColumns) | 공용 `DataGrid` rebindFilterColumns — `mainFilterRef` 전달로 경유. 재조회 경로(Search) 가 itemsSource 참조 교체 | Plant/Packer 시트 스왑도 동일 복구 경로 | 구현 |
