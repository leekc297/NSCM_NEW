# TO-BE 00 — Screen Source Anatomy (소스 내부 골격 청사진)

> **추출 reference**: DMF0004 (sales-site) / DMF0005 (sales-site-project-model) / DMF0006 (customer-model-mapping)
> **목적**: 신규/수정 UI 작성 시 **누가 봐도 동일한 소스 내부 구조**가 되도록, 파일별 내부 코딩 순서(틀)와 화면 유형별 스켈레톤을 단일 진입으로 제공.
> **위치**: 본 문서는 `_tobe/01~13` 의 **상위 골격 뷰(index)** 이다. 상세 규칙은 중복하지 않고 cross-ref 한다.
>
> ⭐ **적용 범위 (Scope) — 2026-06-25 정책 확정**:
> 본 청사진·정준형(§8)은 **① 신규 생성 화면** 과 **② 사용자가 수정을 요청한 화면(해당 화면 작업 시)** 에만 적용한다.
> **기존 화면은 일괄 정렬(리팩토링)하지 않는다.** 즉 DMF0004/0005/0006 등 기존 화면의 §8 일탈은 그대로 보존하며, 본 문서를 근거로 한 사전 리팩토링은 수행하지 않는다. (해당 화면을 수정 요청받았을 때 비로소 정준형으로 맞춘다.)

---

## §0 사용법 & cross-ref 맵

작업 흐름: **본 문서로 골격 파악 → §2 유형 결정 → §5 스켈레톤 복붙 → 항목별 상세는 아래 cross-ref 룰/hook 준수.**

| 항목 | 상세 룰 | 강제 hook |
|---|---|---|
| 파일/폴더 구조·명명 | `_tobe/01_file_structure.md` | `screen-create-checklist` |
| import 순서 | `_tobe/02_imports.md` | `regression-zero-mandatory` |
| 메인 컴포넌트 | `_tobe/03_main_component.md` | `screen-conventions-mandatory`(#63) |
| store | `_tobe/04_store.md` | `screen-shell-composition-mandatory`(#61) |
| constants | `_tobe/05_constants.md` | `screen-conventions-mandatory`(#63) |
| SearchArea/Form | `_tobe/06_search_area.md` | `cascade-combo-filter`(#59) / `messaging-api-and-search-fields-mandatory`(#69) |
| DataGrid | `_tobe/07_datagrid.md` | `datagrid-shared-component-mandatory`(#60) / `grid-cell-interaction-patterns-mandatory`(#66) |
| 컬럼 메타 | `_tobe/08_column_meta.md` | `ui-category-setup-column-meta` |
| SubTitle/hotkey | `_tobe/09_subtitle_hotkey.md` | `subtitle-button-actions-mandatory`(#64) |
| Popup/Modal | `_tobe/10_popup_modal.md` | `popup-modal-and-routing-mandatory`(#67) |
| 메타 SQL / 권한 | `_tobe/12_metadata_sql.md` | `screen-meta-and-permissions-mandatory`(#68) |
| 라우팅/메뉴 | `_tobe/13_routing_menu.md` | `popup-modal-and-routing-mandatory`(#67) |
| 런타임 사고 차단 | — | `screen-runtime-pitfalls-mandatory`(#70) |

> 공용 부품 시그니처/카탈로그(단일 출처)는 §7 + 해당 hook 본문 참조. 본 문서는 카운트/시그니처를 중복 보유하지 않는다.

---

## §1 정준 폴더/파일 골격 (canonical)

```
features/{domain}/src/pages/{kebab-case-name}/
├─ index.ts                         ⭐ 단 한 줄 export
├─ {PascalCase}.tsx                 ⭐ 메인 컴포넌트 (페이지 셸)
├─ {kebab-case}.constants.ts        ⭐ MENU_ID / SHEETS / (SHEET_INDEX) / RESPONSE_SET
├─ {kebab-case}.types.ts            (선택 — SearchParamProps 분리 시)
├─ use{PascalCase}Store.ts          ⭐ Zustand store (createPersistedStoreWithTab)
├─ {PascalCase}.module.scss         (선택 — upperGrid/lowerGrid 등 layout)
├─ components/                      ⭐ 폴더명 정확히 `components` (오타 금지)
│  ├─ {PascalCase}Form.tsx          ⭐ 검색 폼 (SearchArea wrapper)
│  ├─ {PascalCase}Grid.tsx          ⭐ 메인 Grid (DataGrid wrapper)
│  └─ {PascalCase}{Detail}Grid.tsx  (유형 B/C — 상세 Grid N개)
└─ utils/                           (선택 — 화면 특화 로직)
   └─ {kebab-case}.util.ts
```

명명 규약 상세 = `_tobe/01 §1.2`. 폴더=kebab-case, 메인=PascalCase, store=`use{Pascal}Store.ts`, 폴더명=MENU_ID의 영문 의미(DMF0006=`customer-model-mapping`).

---

## §2 화면 유형 3종 결정 매트릭스

신규 화면은 먼저 유형을 결정한다. (혼합 가능 — 마스터+멀티탭 등)

| 유형 | 기준 | 레이아웃 | gridRef | filters | 대표 |
|---|---|---|---|---|---|
| **A. 단일시트** | 시트 1개, 상세/drill-down 없음 | Grid 단독 | `useRef` 단일 | `filters?` 단일 | **DMF0006** |
| **B. 마스터-상세(Panel)** | 마스터 1 + 조건부 상세 1, drill-down 있음 | `PanelGroup orientation='vertical'` + 조건부 `Panel` | `gridRefs[2]` 배열 | `{ [SHEET]?: }` 매핑 | **DMF0005** |
| **C. 마스터-멀티탭(Tab)** | 마스터 1 + 상세 N탭 | `div.upperGrid` + `div.lowerGrid > TabWrapper persist` | `gridRefs[N]` 배열 | 마스터·상세 키 매핑 | **DMF0004** |

> 결정 신호: **상세 그리드 수** = 0(A) / 1(B) / 2+(C). drill-down(셀 dblClick→상세 필터)은 B·C에서 store action(`setXxxFilter`)으로.

---

## §3 파일별 내부 코딩 순서 (틀 — 고정)

### 3.1 `constants.ts` (export 순서 고정) — [DMF0004 ref](../../../nscm-fe/features/master/src/pages/sales-site/sales-site.constants.ts)
```
1) MENU_ID 듀얼 export   : export const MENU_ID = 'DMF000X' as const; export type MENU_ID = typeof MENU_ID;
2) SHEETS (enum)          : API sheetName 값 (단일도 enum)
3) SHEET_INDEX (enum)     : 유형 B/C 만 — gridRefs 배열 인덱싱 (값=순번)
4) RESPONSE_SET (enum)    : 응답 필드명. 다중커서=의미명('salesSite') / 단일커서='o_rc1'
5) VALIDATION_MSG (선택)  : AS-IS .cs MSG 코드 매핑
```

### 3.2 `useXxxStore.ts` (블록 순서 고정) — [DMF0004 ref](../../../nscm-fe/features/master/src/pages/sales-site/useSalesSiteStore.ts)
```
1) SearchParamProps interface   (또는 types.ts import)
2) State interface              : initialized / filters / searchParams / staticColumns / openSearchArea / (loading,error)
3) Action interface             : reset / setXxxFilters / setDetailFilters(B·C) / setSearchParams / fetchStaticColumns / setOpenSearchArea
4) initSearchParams             : divisionId = useSessionStore.getState().session.div ?? '40'   ← 하드코딩 금지
5) initState
6) createPersistedStoreWithTab(creator, 'kebab-case-name')
   - setSearchParams: divisionId 변경 시 fetchStaticColumns() 재호출 + filters 초기화 (sales-site L82-90)
   - setXxxFilters : searchParams → filters[MASTER], 상세 filter undefined 초기화 (L71-76)
   - setDetailFilters : drill-down 셀값 → filters[DETAIL] (L77-81)
   - fetchStaticColumns: Promise.all(시트별 /admin/menu/{MENU_ID}/column) → staticColumns 저장
                         → initialized 아니면 /search-conditions 복원 → initialized=true (L91-132)
```
핵심 불변: **`searchParams`(폼 입력) 와 `filters`(API 파라미터) 분리**. `filters` 설정 시에만 조회 트리거.

### 3.3 `Xxx.tsx` 메인 (블록 순서 고정) — [DMF0004 ref](../../../nscm-fe/features/master/src/pages/sales-site/SalesSite.tsx)
```
import 그룹    : 외부(@mescius, react) → @foundation → @shared → 로컬(./components, ./constants, ./store, styles)
─ 함수 본문 ─
1) (useTranslation 자동주입 — import 금지)            sales-site L21
2) refs        : gridRefs / gridFilterRefs (B·C=배열, A=단일)   L23-29
3) store selector (atomic, 1줄씩)                              L31-38
4) local state : activeTab(B·C) / openDetailGrid 등            L40-41
5) useSaveWithValidation()                                     L43
6) useTabProcQuery(시트별, enabled=!!filters[...])             L45-59
7) useProcMutation(시트별)                                     L61-91
8) 파생 useMemo/Record : dataCount 등                          L93-98
9) handlers   : handleInsert → handleDelete → handleSave       L100-141
10) hotkeyConfig: HotkeyConfig (insert/save/delete/search + manual:false/upload:false)  L143-153  ← useEffect 보다 먼저
11) useEffect : if(!initialized) void fetchStaticColumns(); [tabId]   L155-157
12) return JSX: MainTitle → Form → SubTitle → (Grid | Panel | Tab)    L159-222
```
- `handleSave` 정준: `data?.filter(CRUD_TYPE)` → `saveWithValidation(saveData, staticColumn, mutate)` (B·C는 activeTab 분기). sales-site L114-141.
- `handleInsert/Delete` = `GridAction.addRow/removeRow(grid, true)`.

### 3.4 `XxxForm.tsx` (블록 순서) — components/
```
1) props interface (유형별: A=props 없음 / B=onSubmit,setActiveTab / C=setActiveTab,openDetail,setOpenDetail)
2) store selector (searchParams/setSearchParams/openSearchArea + setXxxFilters or onSubmit)
3) useTabComboQueries({ filters:[...] })   ← 1 RT 다중 콤보 (cascade-combo-filter #59)
4) modal open state (useState<boolean> 분리)
5) <SearchArea onSearch={...} isHidden={!openSearchArea} conditions={searchFields...} extraConditions={...} />
6) 공용 Modal (ProjectByDivisionModal / ItemByDivisionModal / OwnerByDivisionModal ...)
```
검색 필드는 `@master/searchFields` 카탈로그 우선 사용(#69). onSearch = `setXxxFilters()`(+ 필요시 `fetchStaticColumns()`).

### 3.5 `XxxGrid.tsx` (블록 순서) — components/
```
1) props : gridRef / gridFilterRef / data: ResponseData<MENU_ID, SHEETS, RESPONSE_SET>[] / (setActiveTab: B·C)
2) editTrackerRef = useRef<EditTracker<...>>()
3) store selector (staticColumns + setDetailFilters 등)
4) modal/clickedRow local state
5) modal 콜백 setXxx : editTracker.storeChange(item,binding,old,new) ×N + gridRef.refreshRange()
6) grid 핸들러:
   - gotFocus  → setActiveTab(SHEET_INDEX.X)        (B·C)
   - dblClick  → grid.hitTest → CellType.Cell → binding 분기 → modal open | drill-down(setDetailFilter)
   - cellEditEnded → 자동계산/검증 (필요 화면만; util 함수로 추상화 — sales-site.util applySalesSite)
   - beginningEdit → 동적컬럼 편집 강제 등 (#70 P7)
7) <DataGrid staticColumns={...} editTrackerRef={...} allowMerging={Cells|All} ... /> + <Modal .../>
```
DataGrid/edit/merge 상세 = #60 / #66 / #70. **FlexGrid 직접 사용 금지**(DataGrid wrapper만).

---

## §4 데이터 흐름 (불변)

```
[검색] Form 입력 → setSearchParams (divisionId 변경 시 fetchStaticColumns 재호출)
      → onSearch: setXxxFilters() → store.filters[MASTER] 설정
[조회] filters 변경 → useTabProcQuery(enabled=!!filters) → ResponseData
[표시] <DataGrid itemsSource={data} staticColumns={staticColumns[RESPONSE_SET.X]} editTrackerRef>
[편집] 셀 편집 → EditTracker 자동 CRUD_TYPE(I/M/D) 마킹 (+ cellEditEnded 자동계산)
[drill] 마스터 셀 dblClick → setDetailFilters(셀값) → 상세 useTabProcQuery 재조회   (B·C)
[저장] handleSave → data.filter(CRUD_TYPE) → useSaveWithValidation(필수값 검증) → mutate → 성공 시 캐시 무효화
```

---

## §5 스켈레톤 템플릿 (복붙용)

> 각 블록 끝 주석은 실제 근거 라인. 유형에 맞는 것 하나를 복사 후 `Xxx`/`SHEETS`/필드 치환.

### 유형 A — 단일시트 (ref: DMF0006)
```tsx
// constants.ts
export const MENU_ID = 'DMF00XX' as const;
export type MENU_ID = typeof MENU_ID;
export enum SHEETS { MAIN = 'main' }
export enum RESPONSE_SET { DATA = 'o_rc1' }          // 단일커서

// Xxx.tsx (요지)
export const Xxx = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const openSearchArea = useXxxStore(s => s.openSearchArea);   // ⭐ 정준명
  const setOpenSearchArea = useXxxStore(s => s.setOpenSearchArea);
  const filters = useXxxStore(s => s.filters);
  const setFilters = useXxxStore(s => s.setFilters);
  const initialized = useXxxStore(s => s.initialized);
  const fetchStaticColumns = useXxxStore(s => s.fetchStaticColumns);
  const staticColumns = useXxxStore(s => s.staticColumns);     // ⭐ 정준: 복수
  const searchParams = useXxxStore(s => s.searchParams);
  const { saveWithValidation } = useSaveWithValidation();
  const { data } = useTabProcQuery<MENU_ID>({ menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId, filters, enabled: !!filters });
  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({ menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId });
  const handleInsert = () => { /* GridAction.addRow */ };
  const handleDelete = () => { /* GridAction.removeRow(grid, true) */ };
  const handleSave = () => { saveWithValidation(data?.o_rc1.filter(r => r.CRUD_TYPE), staticColumns[RESPONSE_SET.DATA], mutate); };
  const hotkeyConfig: HotkeyConfig = { insert: handleInsert, delete: handleDelete, search: setFilters, save: handleSave, manual: false, upload: false }; // ⭐ useEffect 보다 먼저
  useEffect(() => { if (!initialized) void fetchStaticColumns(); }, [tabId]);
  return (<><MainTitle .../><XxxForm /><SubTitle .../><XxxGrid gridRef={gridRef} ... /></>);
};
```

### 유형 B — 마스터-상세 Panel (ref: DMF0005)
```tsx
// 메인 요지 — gridRefs[2], filters[SHEET] 매핑, PanelGroup + 조건부 Panel
const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()];
const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.PRODUCTION);
const { data: prodData } = useTabProcQuery<MENU_ID, SHEETS.PRODUCTION>({ ..., filters: filters[SHEETS.PRODUCTION], enabled: !!filters[SHEETS.PRODUCTION] });
const { data: purcData } = useTabProcQuery<MENU_ID, SHEETS.PURCHASE>({ ..., filters: filters[SHEETS.PURCHASE], enabled: !!filters[SHEETS.PURCHASE] });
const { mutate: mutatePurchase } = useProcMutation<MENU_ID, SHEETS.PURCHASE>({ menuId: MENU_ID, sheetName: SHEETS.PURCHASE, tabId }); // ⭐ as-cast 금지(정준)
const handleSubmit = () => { setProductionFilter(); void fetchStaticColumns(); setActiveTab(SHEET_INDEX.PRODUCTION); };
const handleSave = () => { /* activeTab 분기: PRODUCTION | PURCHASE */ };
return (<><MainTitle/><XxxForm onSubmit={handleSubmit} setActiveTab={setActiveTab}/><SubTitle/>
  <PanelGroup orientation='vertical'>
    <Panel><MasterGrid setActiveTab={setActiveTab} .../></Panel>
    {openPurchaseGrid && cond && <Panel><DetailGrid setActiveTab={setActiveTab} .../></Panel>}
  </PanelGroup></>);
// 마스터 Grid dblClick → setPurchaseFilter({divisionId, salesSite, projectCode, activeFlag})  (drill-down)
```

### 유형 C — 마스터-멀티탭 Tab (ref: DMF0004)
```tsx
const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>()];
const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.SITE);
const [openDetailGrid, setOpenDetailGrid] = useState(true);
// useTabProcQuery(master) + useTabProcQuery(detail; 상세 N개는 detailData 한 응답에 포함)
// useProcMutation × N (시트별)
const detailDataCountByTab: Record<number, number> = { [SHEET_INDEX.SITE]: master?.salesSite.length ?? 0, ... };
const handleSave = () => { switch(activeTab){ case SHEET_INDEX.SITE: saveWithValidation(master?.salesSite.filter(CRUD_TYPE), staticColumns.salesSite, mutateSite); ... } };
return (<><MainTitle/><XxxForm setActiveTab={setActiveTab} openDetailGrid={openDetailGrid} setOpenDetailGrid={setOpenDetailGrid}/>
  <SubTitle grid={gridRefs[activeTab]} dataCount={detailDataCountByTab[activeTab] ?? 0} .../>
  <div className={styles.upperGrid}><MasterGrid gridRef={gridRefs[SHEET_INDEX.SITE]} setActiveTab={setActiveTab} .../></div>
  {openDetailGrid && <div className={styles.lowerGrid}><TabWrapper persist>
    <TabItem label={t('LBL...')}><DetailGrid gridRef={gridRefs[SHEET_INDEX.CUSTOMER]} setActiveTab={setActiveTab} .../></TabItem>
    ... (N탭)
  </TabWrapper></div>}</>);
// 마스터 Grid dblClick → setDetailFilters({divisionId, salesSite, activeFlag})  (drill-down)
```

---

## §6 불변(Invariant) vs 가변(Variant) 매트릭스

| 항목 | 불변 (항상 동일) | 가변 (유형/특성별) |
|---|---|---|
| 파일 구성 | index/constants/store/Xxx/components 의무 | utils·types·module.scss 선택 |
| import 순서 | 외부→@foundation→@shared→로컬 | — |
| store 골격 | State/Action 분리, searchParams↔filters 분리, fetchStaticColumns(Promise.all+복원+initialized) | filters 단일(A) vs 매핑(B·C), staticColumns 키 수 |
| 메인 블록 순서 | refs→selector→state→hooks(query/mutation)→derived→handlers→hotkeyConfig→useEffect→JSX | gridRef 단일(A) vs 배열(B·C), activeTab 유무 |
| handler | insert/delete/save + hotkeyConfig(manual:false/upload:false) | save 분기(switch/if) 유무 |
| 셸 JSX | MainTitle→Form→SubTitle→(본문) | 본문: Grid(A) / PanelGroup(B) / div+TabWrapper(C) |
| Grid | DataGrid wrapper + editTrackerRef + (gotFocus/dblClick) | cellEditEnded·drill-down·Modal 유무, `AllowMerging` 종류 |
| Form | SearchArea + useTabComboQueries | props(A 없음 / B·C 있음), extraConditions 유무 |

---

## §7 공용 부품 재사용 (단일 출처 = 해당 hook/룰)

| 분류 | 부품 | import | 상세 |
|---|---|---|---|
| 셸 | `MainTitle` `SubTitle` `TabWrapper/TabItem` | `@shared/components` | #61 / #64 |
| 셸 | `Panel` `PanelGroup` | `@shared/panel` | #61 |
| 검색 | `SearchArea` `CustomDropdown` `InputField` | `@shared/components` / `@shared/lges` | #69 / `_tobe/06` |
| 검색필드 | `DivisionField`/`TeamField`/... | `@master/searchFields` | #69 |
| 그리드 | `DataGrid` | `@shared/components` | #60 / `_tobe/07` |
| 모달 | `CustomDialog` + 공용 *Modal | `@shared/components` / `@master/...Modal` | #67 |
| hooks | `useTabProcQuery`/`useProcMutation`/`useTabComboQueries`/`useSaveWithValidation`/`useTabBtnPermissions` | `@shared/hooks` | `_tobe/03` |
| store | `createPersistedStoreWithTab` `useSessionStore` | `@shared/stores` | `_tobe/04` |
| utils | `GridAction`/`EditTracker`/`CustomMergeManager`/`GridUtils` | `@foundation/utils` | #60 |
| const | `CRUD_TYPE`/`CELL_INPUT_EDIT_TYPE`/`BUTTON_TYPE` | `@foundation/constants` | #63 |
| 글로벌타입 | `PageProps`/`ResponseData`/`ProcRequest`/`HotkeyConfig`/`RawFlexGridColumnConfig` | 자동주입 / `@foundation/models` | #63 |

---

## §8 정준형(canonical) 결정 (신규/수정요청 화면에만 적용 · 기존 화면 보존)

> 세 master 화면이 서로 다른 지점. **신규 화면 + 수정 요청받은 화면은 정준형만 사용.**
> 아래 "기존 일탈" 열은 **참고용(현황)** 이며, 기존 화면을 본 문서 근거로 사전 수정하지 않는다(§0 Scope). 해당 화면을 작업(수정 요청)할 때 정준형으로 맞춘다.

| # | 항목 | 정준형 (신규/수정 시 사용) | 기존 일탈 (현황 — 보존, 사전수정 X) |
|---:|---|---|---|
| 1 | 컴포넌트 폴더 | `components/` | DMF0005 `componenets/` (오타) |
| 2 | 검색영역 토글 store 필드 | `openSearchArea` | DMF0006 `isOpenSearchArea` |
| 3 | staticColumns | `staticColumns` (RESPONSE_SET 키 객체), `staticColumns[RESPONSE_SET.X]` | DMF0006 `staticColumn` 단수 |
| 4 | initSearchParams.divisionId | `useSessionStore.getState().session.div ?? '40'` | DMF0006 `'40'` 하드코딩 |
| 5 | hotkeyConfig 위치 | `useEffect` **보다 먼저** | DMF0006 useEffect 뒤 |
| 6 | useProcMutation 타입 | `sheetName: SHEETS.PURCHASE` | DMF0005 `SHEETS.PRODUCTION as SHEETS.PURCHASE` |
| 7 | RESPONSE_SET 값 | 다중커서=의미명(`salesSite`) / 단일커서=`o_rc1` | (규칙 — 위반 아님) |
| 8 | FlexGrid 사용 | `DataGrid` wrapper만 | FlexGrid 직접 사용 금지(#60) |

---

## §9 PRE-WRITE 체크리스트 (골격 누락 0)

```
[ ] 유형(A/B/C) 결정 — §2
[ ] 폴더=kebab-case, components 폴더명 정확(오타 X) — §1 / §8-1
[ ] constants export 순서 (MENU_ID 듀얼/SHEETS/SHEET_INDEX/RESPONSE_SET) — §3.1
[ ] store: State/Action 분리 + searchParams↔filters 분리 + fetchStaticColumns(Promise.all+복원+initialized) — §3.2
[ ] store 필드 정준명: openSearchArea / staticColumns(복수) / divisionId=session.div — §8
[ ] 메인 블록 순서 (refs→selector→state→hooks→derived→handlers→hotkeyConfig→useEffect→JSX) — §3.3
[ ] handleSave = filter(CRUD_TYPE)→saveWithValidation→mutate — §3.3
[ ] 셸: MainTitle→Form→SubTitle→(Grid|Panel|Tab) — §5
[ ] Grid: DataGrid wrapper + editTrackerRef (+gotFocus/dblClick/drill-down) — §3.5 / #60·#66
[ ] Form: SearchArea + useTabComboQueries + searchFields 카탈로그 — §3.4 / #69
[ ] 공용 부품만 사용 (FlexGrid/fetch/axios/window.alert 직접 금지) — §7 / #60·#62·#69
[ ] cross-ref hook 통과 (#60~#70 + screen-conventions) — §0
```

---

## §10 변경 이력
- 2026-06-25: 신규. DMF0004/0005/0006 소스 정밀 분석 기반 골격 청사진 + 정준형 §8.
- 2026-06-25: **적용 범위 정책 확정** — 정준형은 신규 + 수정요청 화면에만 적용. **기존 화면 일괄 정렬(리팩토링) 미수행** (사용자 명시). §0 Scope / §8 반영.
