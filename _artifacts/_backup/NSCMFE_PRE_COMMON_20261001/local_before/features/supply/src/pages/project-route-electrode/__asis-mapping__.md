# SCP0027 Project Route Electrode — AS-IS ↔ TO-BE 매핑 매트릭스

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0027_ProjectRoute_Electrode/SCP0027_ProjectRoute_Electrode.cs`.
설계 근거: `.atlas/gscm-design/SCP0027/design/00_checklist.md` · `01_layout.md` · `02_search-combo.md` · `03_grid-columns.md` · `04_react-gap.md`.
자매화면: SCP0048 Project Route Warranty(`features/supply/src/pages/project-route-warranty`) — 골격/핸들러 준용. 두 화면 모두 단일 grid(spdMain) + Edit 토글. 차이점은 아래 각 절과 04_react-gap 에 명시.

## 레이아웃(design/01)

| AS-IS | TO-BE |
|---|---|
| usrConditionPanel(HidePanel) | `MainTitle` openSearchArea + `ProjectRouteElectrodeForm`(SearchArea) |
| spdMain(FpSpread 단일 시트) | `ProjectRouteElectrodeGrid`(DataGrid, staticColumns) |
| 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(SwitchLock) | `SubTitle` hotkeyConfig(권한 hasButton 게이트) + customButtons Edit 토글 |
| R-AUTH 권한 division 0건 → SetDivisionAuthCheck | `MyDivision`(권한·EE 제외 SQL 내재) 0건 → `ProjectRouteElectrodeForm` noDivisionAuth(MSG00097 alert + 조회패널 비활성). 자매 SCP0048 패턴 준용 |

## 조회조건(design/02 §5) — 1행 6컨트롤

| AS-IS 컨트롤 | TO-BE |
|---|---|
| clbDivision (`MyDivision`, EE·권한 SQL 내재) | `useTabComboQueries([{comboId:'MyDivision', mnuId:'SCP0027'}])` + 권한목록 교정 effect. 화면단 EE 필터 없음(SQL 내재, 자매 SCP0048 의 Division_SCP+클라 EE필터와 다른 지점) |
| clbPlantSite (division cascade, ALL) | `useTabComboQueries([{comboId:'PlantSiteByDivision', divisionId}])` + 선두 ALL sentinel(ALL→SP NULL) |
| cboOperationGroup (LookupCommon P/A/E, ALL) | `useTabLookupQueries([{lookupType:'OPERATION_GROUP'}])` + 선두 ALL sentinel(ALL→''). cascade 아님 — Search 시 grid 재조회만 |
| txtItemId + btnItemId (Model) | InputField + `ItemByDivisionModal`(base SCM0002, callFromCell=false) |
| cboValid (YesOrNo, ALL) | `useTabComboQueries(['YesOrNo'])` + 선두 ALL sentinel |

## 그리드(design/03) — 31 컬럼 DB 메타 구동

| AS-IS | TO-BE |
|---|---|
| spdMain gridColumns=0 → DB 메타 | `fetchStaticColumns`(SCM_MST_SHEET_COLUMNS, sheetNm='Main') mount+Search 재조회, `staticColumns` prop |
| DIVISION_ID 셀콤보(신규행 MyDivision) | `ProjectRouteElectrodeGrid` DataMap + getDisplayValues insert-only override(CRUD_TYPE='I' 만 후보). PARAM9 메타 금지(insert-only 하드코딩) |
| PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperation_SCP 3-bind) | `comboParams` re-seat(divisionId/operationGroup='E'/itemId, 홑따옴표). 행별 재조회는 정적메타 한계(GAP-3) |
| VALID_YN 셀콤보(YesOrNo) | 유일 정적메타 콤보 — DataGrid 자동 배선 |
| R-COMBO-DIV DIVISION_ID 신규행만 MyDivision | beginningEdit: DIVISION_ID 는 CRUD_TYPE='I' 만 편집 허용 |
| R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시 마지막문자) | cellEditEnded `deriveTactTimeFlag` |
| R-VALID VALID_YN 되돌림(opGroup≠E & Y & orgN → N + AS-IS MSG00211→TO-BE MSG01222) | cellEditEnded VALID_YN 분기(storeChange 'N' + refreshRow + alert) |
| R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_ID clear(PLANT_SITE 만, cs:777) | cellEditEnded DIVISION_ID 분기. 자매 SCP0048(ITEM_ID/NICK_NAME/SCM_SITE 도 clear)과 다른 지점 |
| R-DBLCLICK ITEM_ID 셀 더블클릭 → ElectrodeItembyDivisionPopup | dblClick hitTest → `onItemCellDblClick` → `ItemByDivisionModal`(callFromCell=true, item 모드) |
| (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 이 화면에 없음 — 전극 전용(GAP-1) |
| R-EDIT-TOGGLE off → 전셀 잠금 | beginningEdit `!editMode → cancel` |
| R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_ID·PRIORITY~TO_YYYYMMDD·VALID_YN 잠금 | beginningEdit `LOCK_ON_NON_ELECTRODE` |
| R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 → PLANT_SITE_ID 잠금 | beginningEdit `LOCK_ON_ELECTRODE_EXISTING` |
| ALWAYS_LOCK 감사·파생·키 컬럼 | beginningEdit `ALWAYS_LOCKED_COLUMNS` |

## 저장검증(design/03 §3-4) — N0~N9 (N10/N11 없음)

| MSG | 검증 | TO-BE(`useProjectRouteElectrodeValidation`) |
|---|---|---|
| MSG00257 | N0 신규행 ITEM_ID 가 전극아이템 목록에 존재 | validateElectrodeSave N0(electrodeItemIds 있을 때만 대조, 없으면 skip — GAP) |
| MSG00212 | N1 동일 FROM·상이 TO(TO 마킹) | N1 |
| MSG00213 | N2 동일 TO·상이 FROM(FROM 마킹) | N2 |
| MSG00214 | N3 동일기간 + Plant 중복 | N3 |
| MSG00215 | N4 동일기간 + Priority 중복 | N4 |
| MSG00216 | N5 기간 중첩(startInside/endInside/contains, 동일기간 skip) | N5 |
| MSG00217 | N6 기간 연속성(최대 종료일 제외, 종료일+1 = 다음 시작일) | N6 |
| MSG00107 | N7 Priority 양의 정수 | N7 |
| MSG00048/MSG00219 | N8 날짜 형식·범위(<17530101)·from>to. 공백은 silent(무알림) 차단 | N8 |
| MSG00220 | N9 기간별 Priority=1 존재(E 면 DIVISION 제외 그룹키) | N9 |

group-by 키(N1~N6) = `DIVISION_ID^ITEM_ID^SCM_SITE_ID^PROJECT_CODE`. N9 만 예외: OPERATION_GROUP='E' 면 DIVISION 제외(`ITEM^SITE^PROJECT`)(design/03 §3-4).

## SAVE(design/03 §4)

| AS-IS | TO-BE(`submitElectrodeSaveRequest`) |
|---|---|
| PKG_SCP0027.P_SAVE_ProjectRoute_Electrode(18 args = 14 CLOB + P_DEBUG_MODE + O_* 3) | 14 CLOB `^`-delim 병렬배열 payload + debugMode='F' → POST `/SCP0027/Main/SAVE/call-proc`. 14 CLOB 키 집합은 SCP0048 과 동일(BE call-proc key-name 매핑) |
| PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B(표시 합성값 아님) | `acc.plantSiteId.push(PLANT_SITE_ID_B)` |
| ITEM_ID `.ToUpper()` | `acc.itemId.push(...toUpperCase())` |
| PRIORITY_SEQ 빈값 → 'M'→'I' 승격 | CRUD_TYPE='I' → activeFlag 'I' |

## CRUD 버튼(design/01 §2 · 03)

| AS-IS | TO-BE(`ProjectRouteElectrode.tsx`) |
|---|---|
| Search(F5) | `handleSearch`(setFilters + fetchStaticColumns, editMode off) |
| Insert(신규행, opGroup P/A silent 차단, 6종 기본값·PRIORITY 기본값 없음) | `handleInsert`(INSERT_BLOCKED_OPERATION_GROUPS 가드 + 신규행 기본값 6종) |
| Delete('I'행만, 알림 없음) | `handleDelete`(CRUD_TYPE='I' 만 removeRow) |
| Save | `handleSave`(finishEditing → I/M filter → NO_CHANGE → validate(source) → setInvalidCells + (!silent)alert → saveWithValidation → submit) |
| Excel | `handleExcelDownload`(GridAction.excelDownload) |
| Edit 토글(SwitchLock, R-EDIT) | customButton `handleEditToggle`(데이터 0건 AS-IS MSG00259→TO-BE MSG00662 차단). 라벨 Edit=LBL00414/Cancel=LBL00394 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.
> SCP0027 은 공용 DataGrid/SearchArea/SubTitle 을 그대로 쓰므로 UC-01·02·04·05·07 은 공용 컴포넌트가 화면 코드 수정 없이 처리한다(각 파일:라인 근거). UC-03·06 은 이 화면에 없는 기능이라 해당없음.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | `ProjectRouteElectrode.tsx:112` GridAction.addRow → `packages/foundation/src/utils/gridAction.ts:857`(addRow) → :808(addRowSet) → :836 `keepRowVisibleUnderFilter(grid, row)` |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | 공용 DataGrid 자동 등록 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:564` registerDirtyCheck → SearchArea.tsx:115 · SubTitle.tsx:198 `confirmIfDirtyKey(dirtyKey,'search')`(MSG00704). SCP0027 은 excludeFromDirtyCheck 미설정이라 자동 대상 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | — | 해당없음: 이 화면은 Column/Measure 설정 UI(ColumnLayoutModal/MeasureSelectModal)가 없다. 31컬럼은 SCM_MST_SHEET_COLUMNS admin 메타 구동(fetchStaticColumns), PIVOT measure 없음 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `ProjectRouteElectrode.tsx:144` `setToast({type:'success', message:MSG.SAVE_RESULT})`(저장 성공 시). 오류만 setAlert |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `ProjectRouteElectrode.tsx:199` GridAction.excelDownload → `packages/foundation/src/utils/gridAction.ts:257`(dataMap 스냅샷, 전체 화면 공통) FlexGridXlsxConverter 가 컬럼 dataMap(VALID_YN YesOrNo · DIVISION_ID MyDivision · PLANT_SITE_ID)으로 NAME 출력 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | — | 해당없음: 조회조건 Model 은 단일 품번 픽커(ItemByDivisionModal, callFromCell=false)라 콤마 다중입력 대상 아님(AS-IS txtItemId 도 단일 Model). Division/PlantSite/OperationGroup/Valid 는 단일 콤보 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | 공용 DataGrid 자동 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1483` `rebindFilterColumns(grid, getGridFilter())`(updatedLayout 마다, 끊어진 필터만 복구) |  | 구현 |

## 미완/확인필요 (정직 보고 — convert-core §4.3)

1. **GAP-1 전극 화면 전용**: 자매 SCP0048 의 div=81 SalesSite 셀 팝업은 이 화면에 없다(AS-IS 도 없음). ITEM_ID 셀 팝업(ElectrodeItembyDivisionPopup)은 base `ItemByDivisionModal` item 모드로 재사용.
2. **GAP-2 N0 전극아이템 대조**: AS-IS 는 전극아이템 팝업 데이터셋(tblAll) 전체에 대조하나 FE 저장시점에 전체 목록을 신뢰성 있게 보유 못 함 → `electrodeItemIds` 있을 때만 N0 대조, 없으면 skip(BE SAVE SP 최종 방어). 04_react-gap 기록.
3. **GAP-3 셀콤보 메타 부재**: DIVISION_ID·PLANT_SITE_ID 는 SCM_MST_SHEET_COLUMNS 전건 NULL(admin 미등록). FE 코드 규칙으로 배선, PLANT_SITE_ID 행별 재조회는 comboParams re-seat(정적 메타 한계).
4. **GAP-4 INPUT_TP_CD 전건 'S'**: 조건부 편집(R-LOCK-*)은 메타로 재현 불가 → beginningEdit override 코드 배선(메타 하드코딩 금지).
5. **GAP-6 TACT_TIME_FLAG 이중 파생**: 서버 CASE + 클라 last-char 값 일치 회귀검증 후속.
6. **N1~N6 그룹키 SP 정합**: AS-IS checkValidN1~N6 의 SP-side group-by 키 본문 미확정(ora.py query 승인 차단). design/03 §3-4 의미규칙으로 재현, SP 배포 후 정합 확인.
7. **저장검증 실패 셀 하이라이트**: `invalidCells`(dataItem 참조 + 컬럼 binding)를 Grid formatItem 핸들러가 배경 강조 — 뷰행 index 가 아니라 dataItem 식별이라 스크롤·정렬 후에도 유지(INVALID_CELL_BG_COLOR='#cce5ff').
