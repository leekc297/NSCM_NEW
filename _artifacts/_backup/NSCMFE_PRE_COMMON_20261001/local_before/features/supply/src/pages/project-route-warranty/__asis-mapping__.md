# SCP0048 Project Route Warranty — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0048_ProjectRoute_Warranty/SCP0048_ProjectRoute_Warranty.cs`.
설계 근거: `.atlas/gscm-design/SCP0048/design/00_checklist.md` · `01_layout.md` · `02_search-combo.md` · `03_grid-columns.md` · `04_react-gap.md`.
자매화면: SCP0006 Project Route(`features/supply/src/pages/project-route`) — 골격/핸들러 준용. 단, SCP0006 은 3-grid, SCP0048 은 단일 grid(spdMain) + Edit 토글.

## 레이아웃(design/01)

| AS-IS | TO-BE |
|---|---|
| usrConditionPanel(HidePanel) | `MainTitle` openSearchArea + `ProjectRouteWarrantyForm`(SearchArea) |
| spdMain(FpSpread 단일 시트) | `ProjectRouteWarrantyGrid`(DataGrid, staticColumns) |
| 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(SwitchLock) | `SubTitle` hotkeyConfig(권한 hasButton 게이트) + customButtons Edit 토글 |
| R1 권한 division 0건 → SetDivisionAuthCheck | `Division_SCP`(EE 제외 후) 0건 → `ProjectRouteWarrantyForm` noDivisionAuth(MSG00097 alert + 조회패널 비활성). 자매 SCP0006 패턴 준용(04_react-gap GAP-5) |

## 조회조건(design/02 §5)

| AS-IS 컨트롤 | TO-BE |
|---|---|
| clbDivision (`BLUtils.GetDivisionWithoutEE` 2단계) | `useTabComboQueries(['Division_SCP'])` + `EXCLUDE_EE_DIVISION` 클라 필터(ATTRIBUTE3<>'EE') + 권한목록 교정 effect |
| clbPlantSite (division cascade, ALL) | `useTabComboQueries([{comboId:'PlantSiteByDivision', divisionId}])` + 선두 ALL sentinel(ALL→SP NULL) |
| cboOperationGroup (LookupCommon) | UI 숨김·store-only(design/02 §5 #3) — 렌더하지 않음. GET operationGroup 파라미터로만 전달 |
| txtItemId + btnItemId (Model) | InputField + `ItemByDivisionModal`(base SCM0002, callFromCell=false) |
| cboValid (YesOrNo, ALL) | `useTabComboQueries(['YesOrNo'])` + 선두 ALL sentinel |

## 그리드(design/03) — 31 컬럼 DB 메타 구동

| AS-IS | TO-BE |
|---|---|
| spdMain gridColumns=0 → DB 메타 | `fetchStaticColumns`(SCM_MST_SHEET_COLUMNS, sheetNm='Main') mount+Search 재조회, `staticColumns` prop |
| DIVISION_ID 셀콤보(신규행 MyDivision) | `ProjectRouteWarrantyGrid` DataMap + getDisplayValues insert-only override(CRUD_TYPE='I' 만 후보). PARAM9 메타 금지(insert-only 하드코딩) |
| PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperation_SCP 3-bind) | `comboParams` re-seat(divisionId/operationGroup='W'/itemId, 홑따옴표). 행별 재조회는 정적메타 한계(GAP-3) |
| VALID_YN 셀콤보(YesOrNo) | 유일 정적메타 콤보 — DataGrid 자동 배선 |
| R-C1 DIVISION_ID 신규행만 MyDivision | beginningEdit: DIVISION_ID 는 CRUD_TYPE='I' 만 편집 허용 |
| R-D1 PLANT_SITE_ID → TACT_TIME_FLAG(표시 마지막문자) | cellEditEnded `deriveTactTimeFlag` |
| R-D3 VALID_YN 되돌림(opGroup≠W & Y & orgN → N + AS-IS MSG00211→TO-BE MSG01222) | cellEditEnded VALID_YN 분기(storeChange 'N' + refreshRow + alert) |
| R-D4 DIVISION_ID 변경 → PLANT_SITE_ID/ITEM_ID/NICK_NAME clear, 비-81 SCM_SITE_ID/PROJECT_CODE='-'(R-D5) | cellEditEnded DIVISION_ID 분기 |
| R-D8 ITEM_ID 셀 더블클릭 → Item 팝업 | dblClick hitTest → `onItemCellDblClick` → `ItemByDivisionModal`(callFromCell=true) |
| R-D6 div=81 SCM_SITE_ID/PROJECT_CODE 셀 → SalesSite 팝업 | dblClick → `onSalesSiteCellDblClick`(tsx:228 mode='salesSite') → base `ItemByDivisionModal` 재사용. 반환은 setSelectedValue(...,scmSiteId,projectCode) 로 SCM_SITE_ID/PROJECT_CODE 한 쌍 write-back(tsx:253~271). 별도 Ex 팝업 없이 COM0008 o_rc1 의 두 컬럼으로 GAP-1 해소(2026-09-25) |
| R-L1 Edit 토글 off → 전셀 잠금 | beginningEdit `!editMode → cancel` |
| R-L2 opGroup≠W → PLANT_SITE_ID~VALID_YN 잠금 | beginningEdit `LOCK_ON_NON_WARRANTY` |
| R-L3 W & PRIORITY_SEQ≠"" 기존행 → PLANT_SITE_ID~PROJECT_CODE 잠금 | beginningEdit `LOCK_ON_WARRANTY_EXISTING` |
| ALWAYS_LOCK 감사·파생·키 컬럼 | beginningEdit `ALWAYS_LOCKED_COLUMNS` |

## 저장검증(design/03 §4.3) — N1~N11 (N6 없음)

| MSG | 검증 | TO-BE(`useProjectRouteWarrantyValidation`) |
|---|---|---|
| MSG00212 | N1 동일 FROM·상이 TO(TO 마킹) | validateWarrantySave N1 |
| MSG00213 | N2 동일 TO·상이 FROM(FROM 마킹) | N2 |
| MSG00215 | N5 기간 중첩(startInside/endInside, 동일기간 skip) | N5 |
| MSG00214 | N3 동일기간 + Plant 중복 | N3 |
| MSG00215 | N4 동일기간 + Priority 중복 | N4 |
| MSG00107 | N7 Priority 양의 정수 | N7 |
| MSG00048/MSG00219 | N8 날짜 형식·범위(<17530101)·from>to. 공백은 silent(무알림) 차단 | N8 |
| MSG00220 | N9 기간별 Priority=1 존재(Warranty 행 제외) | N9 |
| MSG00002 | N10 div=81 SCM_SITE_ID/PROJECT_CODE 필수(공백·'-' 불가) | N10 |
| AS-IS MSG00322→TO-BE MSG01319 | N11 Warranty PRIORITY≥11 | N11 |

group-by 키 = `DIVISION_ID^ITEM_ID^SCM_SITE_ID^PROJECT_CODE`(SCP0048 은 자매와 달리 DIVISION_ID 포함, design/03 §4.3).

## SAVE(design/03 §4.3)

| AS-IS | TO-BE(`submitWarrantySaveRequest`) |
|---|---|
| P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 args = 14 CLOB + P_DEBUG_MODE + O_* 3) | 14 CLOB `^`-delim 병렬배열 payload + debugMode='F' → POST `/SCP0048/main/SAVE/call-proc` |
| PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B(표시 합성값 아님) | `acc.plantSiteId.push(PLANT_SITE_ID_B)` |
| ITEM_ID `.ToUpper()` | `acc.itemId.push(...toUpperCase())` |
| PRIORITY_SEQ 빈값 → 'M'→'I' 승격 | CRUD_TYPE='I' → activeFlag 'I' |

## CRUD 버튼(design/01 §2 · 03 §3.5)

| AS-IS | TO-BE(`ProjectRouteWarranty.tsx`) |
|---|---|
| Search(F5) | `handleSearch`(setFilters + fetchStaticColumns, editMode off) |
| Insert(신규행, opGroup P/A silent 차단) | `handleInsert`(INSERT_BLOCKED_OPERATION_GROUPS 가드 + 신규행 기본값) |
| Delete('I'행만, 알림 없음) | `handleDelete`(CRUD_TYPE='I' 만 removeRow) |
| Save | `handleSave`(finishEditing → I/M filter → NO_CHANGE → validate → setInvalidCells + (!silent)alert → saveWithValidation → submit) |
| Excel | `handleExcelDownload`(GridAction.excelDownload) |
| Edit 토글(SwitchLock, R-L1/R-G2) | customButton `handleEditToggle`(데이터 0건 AS-IS MSG00259→TO-BE MSG00662 차단). 라벨 Edit=LBL00414/Cancel=LBL00394 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SCP0048 은 공용 DataGrid/SearchArea/SubTitle 을 그대로 쓰므로 UC-01·02·04·05·07 은 공용 컴포넌트가 화면 코드 수정 없이 처리한다(각 파일:라인 근거). UC-03·06 은 이 화면에 없는 기능이라 해당없음. 자매 SCP0027 과 동일 인프라·동일 판정.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | `ProjectRouteWarranty.tsx:114` GridAction.addRow → `packages/foundation/src/utils/gridAction.ts:863`(addRow) → :808(addRowSet) → :836 `keepRowVisibleUnderFilter(grid, row)` |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm | 공용 DataGrid 자동 등록 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:564` registerDirtyCheck → SearchArea/SubTitle `confirmIfDirtyKey`. SCP0048 은 excludeFromDirtyCheck 미설정이라 자동 대상 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 | — | 해당없음: 이 화면은 Column/Measure 설정 UI(ColumnLayoutModal/MeasureSelectModal)가 없다. 31컬럼은 SCM_MST_SHEET_COLUMNS admin 메타 구동(fetchStaticColumns), PIVOT measure 없음 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | `ProjectRouteWarranty.tsx:147` `setToast({type:'success', message:MSG.SAVE_RESULT})`(저장 성공 시). 오류만 setAlert |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) | `ProjectRouteWarranty.tsx:201` GridAction.excelDownload → `packages/foundation/src/utils/gridAction.ts:257`(dataMap 스냅샷, 전체 화면 공통) FlexGridXlsxConverter 가 컬럼 dataMap(VALID_YN YesOrNo · DIVISION_ID MyDivision · PLANT_SITE_ID)으로 NAME 출력 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | — | 해당없음: 조회조건 Model 은 단일 품번 픽커(ItemByDivisionModal, callFromCell=false)라 콤마 다중입력 대상 아님(AS-IS txtItemId 도 단일 Model). Division/PlantSite/Valid 는 단일 콤보 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns) | 공용 DataGrid 자동 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1483` `rebindFilterColumns(grid, getGridFilter())`(updatedLayout 마다, 끊어진 필터만 복구) |  | 구현 |

## 미완/확인필요 (정직 보고 — convert-core §4.3)

1. **GAP-1 SalesSite 반환 해소(2026-09-25)**: div=81 의 SCM_SITE_ID/PROJECT_CODE 반환 팝업(AS-IS `SCP0048_ItembyDivisionPopupEx`)은 별도 컴포넌트 미이관이나, COM0008 응답(o_rc1)에 두 컬럼이 실려 있어 base `ItemByDivisionModal`(mode='salesSite')의 setSelectedValue 에 scmSiteId/projectCode 두 인자를 additive 로 추가해 반환 배선(모달 tsx + `ProjectRouteWarranty.tsx:253~271`). 별도 Ex 팝업 신설 불필요. 미사용 호출부(다른 ~10 화면) 회귀 없음(trailing optional 인자).
2. **GAP-3 셀콤보 메타 부재**: DIVISION_ID·PLANT_SITE_ID 는 SCM_MST_SHEET_COLUMNS 전건 NULL(admin 미등록). FE 코드 규칙(R-C1~C6)으로 배선, PLANT_SITE_ID 행별 재조회는 comboParams re-seat 로 근사(정적 메타 한계).
3. **GAP-4 INPUT_TP_CD 전건 'S'**: 조건부 편집(R-L2/R-L3)은 메타로 재현 불가 → beginningEdit override 코드 배선(메타 하드코딩 금지).
4. **GAP-6 TACT_TIME_FLAG 이중 파생**: 서버 CASE + 클라 last-char 값 일치 회귀검증 후속.
5. **NICK_NAME(R-D2)**: 저장 SP 가 FN_GET_ITEM_NICKNAME 재계산 → 화면 셀 반영은 재조회 의존(즉시 표시 미반영). ITEM_ID 팝업 확정 시 ITEM_ID 만 반영.
6. **저장검증 실패 셀 하이라이트(G-5 해소)**: `invalidCells`(dataItem 참조 + 컬럼 binding) 를 Grid formatItem 핸들러가 배경 강조 — 뷰행 index 가 아니라 dataItem 식별이라 스크롤·정렬 후에도 유지. BodGrid SAVE_ERROR_BG_COLOR 패턴 준용(INVALID_CELL_BG_COLOR='#cce5ff').
