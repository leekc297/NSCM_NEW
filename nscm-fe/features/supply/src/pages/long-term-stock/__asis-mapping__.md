# SCP0084 Long-term stock — AS-IS ↔ TO-BE 매핑

> AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0084_LongTermStock/SCP0084_LongTermStock.cs` (+ Designer)
> 설계: `.atlas/gscm-design/SCP0084/design/01_layout.md`·`02_search-combo.md`·`03_grid-columns.md`
> TO-BE: `nscm-fe/features/supply/src/pages/long-term-stock/`
> 판정: 신규(NEW) — nscm FE 트리 폴더 부재 실측(goal.md ①).

## 1. 조회조건 (영역2, 02_search-combo.md)

| AS-IS | cs | TO-BE | 비고 |
|---|---|---|---|
| monthPicker (Month, 단일) | 40/143/293/361~368 | `LongTermStockForm` MonthPicker | 기본=최신월. 범위 SP `SCP0084_GET_MONTH_RANGE` 미배포 → 현재월/2021 폴백(convert-sp 후 재판정) |
| cboDivision (Division, 다중) | 40/294 | `useTabComboQueries({comboId:'Division_SCP',mnuId:MENU_ID})` + FE 클라필터 `ATTRIBUTE3!=='EE'` | MyDivision 재사용 금지(SCP0006). EE 제외는 CMBO SQL 에 없어 FE 재현(convert-core §2.6) |
| clbPlant (Plant, 다중, cascade) | 42/295/173~181/808~811 | `useTabComboQueries(['PlantByGroup1_SCP_ALL'])` + FE 클라 cascade 필터 `DIVISION_ID ∈ 선택 division` | 서버 재조회 아님(필터 방식). Division 변경 시 plantId=ALL 리셋(재바인딩 초기화 대응) |
| cboLongTermType (다중) | 97~106/151~167/296 | 정적 3옵션 `LONG_TERM_TYPE_OPTIONS`(CODE_2 비대상/CODE_5 장기 징후/CODE_6 장기) | SQL/lookup 아님. i18n LBL 신규는 사용자 결정(goal #4) → AS-IS 한글 하드코딩 그대로 재현(추측 번역 금지) |
| GetCheckedListValue → CSV 조립 | 293~314 | `useLongTermStockStore.setFilters` (ALL/미선택=빈문자열) | p_yyyymm/p_division_id/p_plant_id/p_long_term_type_code/debug_mode='F' |
| checkRequiredOfSearch | 285 | `useLongTermStockValidation.validateFind` (Month 필수, 통상 기본값 존재) | |
| SetDivisionAuthCheck (권한0행) | 146~147 | Form `noDivisionAuth` → SearchArea disable + MSG00097, page hotkey search 차단(R8) | |

## 2. 편집 잠금·토글 (영역1, 01_layout.md §2)

> **TO-BE 변경(사용자 결정 2026-10-12): Edit 토글 제거 — 진입(조회) 즉시 MEMO 수정모드.**
> AS-IS 는 조회 후 전셀 잠금 → Edit 버튼 토글로 MEMO 편집 개시였으나, TO-BE 요건은 데이터 로드 시
> MEMO 가 바로 편집 가능(상시 editable). 따라서 **Edit customButton 제거**, grid `editable` 상시 true,
> 저장 버튼은 `editable` 게이트 없이 `hasButton('SAVE')` 만으로 노출. 아래 표의 EditButton/토글 관련
> 행(W6·W7, R2~R7)은 AS-IS 기록으로만 유지(TO-BE 미재현). MEMO 셀은 상시 편집표시(노랑).

| AS-IS | cs | TO-BE | 비고 |
|---|---|---|---|
| 조회 후 전 컬럼 Lock (R2, W4) | 327 | 메타 INPUT_TP_CD 전건 'S' → DataGrid setEditableColumns 가 전 셀 편집 cancel | 기본 읽기전용 |
| EditButton → SwitchLock + LockRange (MEMO만 해제, R3/W6/W7) | 227~251/233/242/249 | `editable` 토글 + `LongTermStockGrid` beginningEdit 핸들러(editable && binding==MEMO → e.cancel=false) | 상수/좌표 이식 아님(hook #130) — binding·상태 기반 |
| **EditButton 노출** | 227 | **customButton 'Edit'** (hasButton('SAVE') 대리 게이트) | **공용 Hotkeys enum 에 edit 키 없음(F2='_F2_Unused') → hotkeyConfig 로 표현 불가. 설계(goal/plan)의 hotkeyConfig.edit 는 이 코드베이스에 부재 → customButton 으로 구현(BOD/SCP0007 SAVE 대리 선례). 툴바 위치는 표준버튼 좌측(공용 SubTitle 순서 고정) — 시각순서 차이는 사용자 확인 축** |
| Edit 가드 fps==null (R4) | 229 | `handleEditToggle`: `if(!gridRef.current) return` | |
| Edit 가드 RowCount==0 (R5) | 231 | `handleEditToggle`: `if(rows.length===0) return` | |
| Edit 가드 Action(String) 컬럼 hidden (R6) | 244 | **미해당(N/A)** | NSCM 공용 그리드는 별도 CRUD 플래그 표시 컬럼이 없고 EditTracker 가 CRUD_TYPE 추적 → AS-IS spread 아티팩트. 재현 대상 없음 |
| cellclipboardPast=false (R7) | 237~240 | 미해당 | 순수 상태 플래그(붙여넣기 모드 off) — NSCM 등가 없음 |

## 3. 그리드·저장·엑셀 (영역3, 03_grid-columns.md)

| AS-IS | cs | TO-BE | 비고 |
|---|---|---|---|
| SetSheetHeaderColumn + ColumnHeaderHeight(0,50) 다단 헤더 (R1/W2) | 205~207 | 메타 LARGE/SMALL_CLASS_LABEL 구동 다단 헤더(Exchange/KRW/Local) — DataGrid 자동 | 헤더 높이 48px 규약(hook #93)은 wrapper 기본 |
| SmartColMerge (W2/W5) | 206/329 | `allowMerging=Cells` + `MERGE_COLUMNS`(YYYYMM/DIVISION_ID/PLANT_DESCRIPTION/PLANT_ID) updatedLayout 재적용 | **best-effort**: AS-IS SmartColMerge per-column 정책은 FarPoint 템플릿에 있어 메타/.cs 에서 추출 불가 → 자매(ending-inventory) 검증 선두 식별 집합 적용. 누적키 방식 제약(grid-behavior-parity §1.3) — 사용자 확인 축 |
| siMain.Query(ds) 컬럼명 바인딩 (W3) | 325 | DataGrid staticColumns(59행) itemsSource 바인딩 | SP alias 대소문자 일치(hook #54) |
| FIXED_FLAG=Y (ITEM_UOM) 틀고정 | 메타 | DataGrid 메타 구동 | |
| 통화 파생(SP CASE) | SP | 서버(SP) 계산 — FE 재계산 없음 | design 03 §4.2 |
| SaveData_Memo (I/M/D 행, 6키+MEMO) | 405~420 | `handleSave` finishEditing → CRUD_TYPE 행 수집 → `useSaveWithValidation`+`useProcMutation` | 표준 배선(convert-core §2.4). 성공 MSG00002/오류 MSG00003 = TO-BE 표준(AS-IS MSG00004 임의재사용 금지, hook #114). 저장 후 editable=false(재조회 재잠금) |
| ExcelButton + MSG00100 confirm (R9) | 258~274/263~270 | `handleExcel`: 0건 가드(MSG00719) + `GridAction.excelDownload` | **W9(*_XLS 고정밀 치환)·W10(콤보→텍스트)·W12(Footer)·MSG00100("저장않고 열기") 미구현** — 공용 excelDownload 에 per-export 정밀도 스왑 훅 없음 + web 다운로드 모델은 저장/열기 선택 대화 없음 + SP 미배포로 런타임 검증 불가. 04 확인필요(사용자 축) 기록 |
| ORPHAN 18컬럼(OCCR_RSN_CD·EXHT_TP_CD·QTY_1~12 등) | 미배선 | 메타 구동 그대로(콤보 미배선) | AS-IS 현행 미배선 유지(goal #2). CELL_COMBO_DATA_TYPE 미등록 → 텍스트로 표시(조용한 빈 콤보 방지 위해 추가 배선 안 함). 신기능 여부 사용자 결정 |

## 4. 미해결·확인 필요 (사용자 축)

1. **런타임 실행체인**: PKG_SCP0084(GET/GET_MONTH_RANGE/SAVE_MEMO) 미배포 → 조회/저장/월범위 브라우저 검증 불가(convert-sp 후속).
2. **엑셀 W9/W10/W12 + MSG00100**: 위 표 참조 — 미구현, 04 기록.
3. **셀 병합 정책**: best-effort 선두 집합 — 정확 병합 대상은 브라우저 육안 확인 필요.
4. **Long Term Type i18n**: 옵션 표시명 한글 하드코딩(AS-IS 동일) — LBL 신규 등록은 사용자/admin 결정.
5. **Edit/필수 LBL·MSG id**: LBL.EDIT(LBL00108)·MSG00013(필수)·MSG00097/00719 는 DB 실측으로 확정(05_register 단계 대조).
