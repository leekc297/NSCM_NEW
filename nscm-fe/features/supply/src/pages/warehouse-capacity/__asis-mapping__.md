# __asis-mapping__.md — AS-IS 1:1 대사표 (SCP0133 Warehouse Capacity)

> 원천: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0133_WarehouseCapacity/SCP0133_WarehouseCapacity.cs`(1559줄),
>   `.Designer.cs`(782줄), `design/00~03`. 생성: convert-gap-resolve iter-2 수기(--init 승인 차단 — settings.json allow 목록에 `--check` 만 등재).
> 상태 허용값: 미구현 / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.
> iter-2 종결 상태는 미완(ERROR) — 미구현 행(A1 Site 원천, A2/A3 ItemMapping GET/SAVE, A5 파생, G8 탭가드)은 런타임 검증이 필요한 R2 로 이월.

## 이벤트·제약 (AS-IS 핸들러 1:1)

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:FindButton | FindData_Main — WhCapa/ItemMap 분기 조회(.cs:537/581) | WarehouseCapacity.tsx:93 handleSearch + useTabProcQuery(main) | - | 구현 |
| HANDLER:InsertButton | Insert_Row 신규행 기본값(.cs:695) DIVISION_ID + VALID_YN='Y' / ItemMap STOR_PER='1' | WarehouseCapacity.tsx:126 handleInsert(VALID_YN/STOR_PER iter-2 반영) | - | 구현 |
| HANDLER:DeleteButton | fps==null 가드 후 Delete(.cs:547) | WarehouseCapacity.tsx:138 handleDelete(grid null 가드 + removeRow) | - | 구현 |
| HANDLER:EditButton | SwitchLock 수정모드 토글(.cs:556) | — | EditButton 토글 어포던스 전 화면 미이식 결정(ANL-06, editbutton-toggle-not-ported) — 잠금 화이트리스트는 isCellEditable 로 유지 | 제외 |
| HANDLER:SaveButton | SaveData_WhCapa/SaveData_ItemMapping 분기(.cs:568) | WarehouseCapacity.tsx:148 handleSave(WhCapa만 saveWithValidation) | ItemMapping SAVE(P_SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING, 배포됨) 미배선 — A3(R2, 런타임 왕복 검증 필요) | 미구현 |
| HANDLER:ClbDivision_SelectedIndexChanged | Division 변경 → cascade 재적재 + 그리드 clear(.cs:1156) | WarehouseCapacityForm.tsx:114 onChange→setDivision + confirmIfDirtyKey | - | 구현 |
| HANDLER:CboPlanGroup_SelectedIndexChanged | PlanGroup 변경 → ItemMap Site-by-PlanGroup 재적재(.cs:1164) | — | 조회영역 PlanGroup→Site 재조회 cascade 미재현 — A4(R2) | 미구현 |
| HANDLER:SpdMain_CellClick | 행 클릭 시 Division+PlanGroup 로 셀 콤보(dtPlanGroup/dtWarehouse/dtSiteSub) 재필터(.cs:1184) | — | 그리드 셀 콤보 cascade(PARAM2) 미와이어링 — A4(R2, ATTRIBUTE2 NULL) | 미구현 |
| HANDLER:SpdMain_CellDoubleClick | ITEM_ID 더블클릭 → MaterialByDivisionPopup → SetText(.cs:1244) | WarehouseItemMappingGrid.tsx:114 handleDblClick→Modal→storeChange(ITEM_ID) | - | 구현 |
| HANDLER:SpdMain_ClipboardPasted | 붙여넣기: PlanGroup name→code, WH_NM→Site/Stage 파생, StorLocName→StorLoc @E/@W(.cs:1282) | WarehouseItemMappingGrid.tsx:97 pastedCell(StorLoc 파생만) | PlanGroup name→code, WH_NM→Site/Stage 파생 미구현 — A5(R2) | 미구현 |
| HANDLER:SpdMain_ComboSelChange | ItemMap WH_NM 선택 → Site/Stage 파생, StorLocName→StorLoc(.cs:1366) | WarehouseItemMappingGrid.tsx:97 cellEditEnded(StorLoc 파생만) | WH_NM→Site/Stage 파생 미구현 — A5(R2, 창고 데이터셋 필요) | 미구현 |
| HANDLER:SpdMain_ActiveSheetChanged | 시트 전환 → Item/Warehouse/Period 라벨 가시성 토글 + ItemMap 콤보 재적재(.cs:1414) | WarehouseCapacity.tsx:201 TabWrapper(탭 전환) | 시트별 조회영역 컨트롤 가시성 토글(btnItemId/lblWarehouse/lblPeriod) 미재현 — State 축 이월 | 미구현 |
| HANDLER:spdSub_ActiveSheetChanging | 편집 중 시트 전환 차단 + MSG00129(.cs:1458) | — | 탭 전환 미저장 가드 미구현 — G8(R2, MSG00129 실재 확인됨) | 미구현 |
| HANDLER:SpdMain_TopChange | 스크롤 시 SmartColMerge() 인자 없이 호출(.cs:1177) | WarehouseCapacityGrid.tsx allowMerging=None | 병합 대상 컬럼 정의가 base class(UsrConditionPanel/SheetView) 소스 밖 — 추측 병합 금지, G12(R3 선행 소스 확보) | 제외 |
| HANDLER:SpdMain_EditChange | 편집 셀 인덱스 추적(.cs:1469) | — | WinForms 셀 인덱스 배관 — Wijmo 네이티브 편집 이벤트로 등가(플랫폼 차이) | 해당없음 |
| HANDLER:SpdMain_EditModeOff | 편집 종료 시 MAX_CAPA 음수 0 클램프(.cs:1475/1496) | warehouseCapacityEditLock.ts:34 clampNonNegative + WarehouseCapacityGrid.tsx | - | 구현 |
| HANDLER:SpdMain_Changed | 데이터 변경 시 MAX_CAPA 음수 0 클램프(.cs:1485) | warehouseCapacityEditLock.ts:34 clampNonNegative | - | 구현 |
| HANDLER:btnItemId_Click | 조회영역 Item 검색 → MaterialByDivisionPopup(.cs:1344) | WarehouseCapacity.tsx:227 MaterialByDivisionModal(scpModuleType='SCP0133') | - | 구현 |
| HANDLER:Form_Load | InitForm/InitControls/CreateSpread/SetVisibleSheetColumns(.cs:156) | WarehouseCapacity.tsx:82 useEffect(fetchStaticColumns + restoreSearchCondition) | - | 구현 |

## CRUD·모달 매트릭스

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:SEARCH | Find → GET_WAREHOUSE_CAPACITY(WhCapa) / GET_WAREHOUSE_ITEM_MAPPING(ItemMap) | WarehouseCapacity.tsx:93 handleSearch(main) | ItemMapping GET(배포됨) 미배선 — A2(R2) | 미구현 |
| CRUD:INSERT | Insert_Row 신규행 기본값 | WarehouseCapacity.tsx:123 handleInsert | - | 구현 |
| CRUD:DELETE | siMain.Delete() | WarehouseCapacity.tsx:138 handleDelete | - | 구현 |
| CRUD:SAVE | SAVE_WAREHOUSE_CAPACITY / SAVE_WAREHOUSE_ITEM_MAPPING | WarehouseCapacity.tsx:148 handleSave(WhCapa) | ItemMapping SAVE 미배선 — A3(R2) | 미구현 |
| MODAL:MaterialByDivisionModal | Item 검색(조회영역 + ItemMap 셀 더블클릭) SCM0002_MaterialByDivisionPopup | WarehouseCapacity.tsx:227, WarehouseItemMappingGrid.tsx:139 | - | 구현 |

## UI 공통(통합테스트) 체크 축 (전 화면 상시 6항목)

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터 유지한 채 추가 행 노출 | — | 공용 DataGrid/GridAction.addRow 표준 처리 — 이 화면 개별 로직 없음 | 해당없음 |
| COMMON:UC-02 | 수정 중 재조회 시 'There are unsaved changes...' confirm(MSG00703) | WarehouseCapacity.tsx:110 handleSearch(trackerRef/itemMappingTrackerRef.hasChanges → MSG00703) | - | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외 적용 시 기존 조회 Reset 후 재조회 | — | 공용 Column/Measure 설정 모달 표준(SubTitle) — 이 화면 개별 로직 없음 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 Toast | WarehouseCapacity.tsx:150 setToast | - | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 Code 아닌 Name 출력 | — | 공용 SubTitle excel + gridAction dataMap 표준 — 이 화면 개별 로직 없음 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중 입력 전건 조회 | useWarehouseCapacityStore.ts:66 joinOrAll + WarehouseCapacityForm.tsx toMultiArray | - | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 | — | 공용 DataGrid rebindFilterColumns 표준 — 이 화면 개별 로직 없음 | 해당없음 |
