# TO-BE 룰 03 — 메인 컴포넌트 (PageName.tsx) 표준

> **추출 reference**: DMF0006 (단순) + DMF0004 (multi-sheet) + DMF0005 (Panel) + DMF0007 (Dynamic)

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 03 |
| 토픽 | 메인 컴포넌트 구조 + hook 사용 + JSX 표준 |
| 적용 trigger | 신규 화면 생성 |
| 관련 hook | `pre-write.md`, `post-write.md`, `asis-button-mapping.md` |

---

## §1 표준 구조 (의무) — 모든 신규 화면 동일 순서

> reference: `CustomerModelMapping.tsx:15-100` (가장 단순), `SalesSite.tsx:20-223` (가장 복잡 multi-sheet)

### §1.1 구조 7 단계 (순서 의무)

```typescript
export const {PascalName} = ({ tabId, title }: PageProps<MENU_ID>) => {
  // [1] Grid ref (single 또는 array)
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  
  // [2] Store selector (개별 selector 의무 — 객체 destructuring 금지)
  const filters = useStore(state => state.filters);
  const setFilters = useStore(state => state.setFilters);
  const initialized = useStore(state => state.initialized);
  const fetchStaticColumns = useStore(state => state.fetchStaticColumns);
  const staticColumn = useStore(state => state.staticColumn);
  const searchParams = useStore(state => state.searchParams);
  const isOpenSearchArea = useStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useStore(state => state.setOpenSearchArea);
  
  // [3] Hook (useTabProcQuery / useProcMutation / useSaveWithValidation)
  const { saveWithValidation } = useSaveWithValidation();
  
  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.X,
    tabId,
    filters,
    enabled: !!filters,
  });
  
  const { mutate } = useProcMutation<MENU_ID, SHEETS.X>({
    menuId: MENU_ID,
    sheetName: SHEETS.X,
    tabId,
  });
  
  // [4] Handler (insert / delete / save)
  const handleInsert = () => { ... };
  const handleDelete = () => { ... };
  const handleSave = () => { ... };
  
  // [5] useEffect (initialized check)
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);
  
  // [6] hotkeyConfig (manual: false, upload: false 의무)
  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    search: setFilters,
    save: handleSave,
    manual: false,
    upload: false,
  };
  
  // [7] JSX (MainTitle → Form → SubTitle → Grid 순서 의무)
  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} openSearchArea={...} toggleOpenSearchArea={...} />
      <{PascalName}Form />
      <SubTitle menuId={MENU_ID} grid={gridRef} gridFilter={gridFilterRef} dataCount={...} excelFileName='...' hotkeyConfig={hotkeyConfig} searchParam={searchParams} />
      <{PascalName}Grid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc1 ?? []} />
    </>
  );
};
```

### §1.2 의무 사항 인벤토리

| # | 의무 항목 | reference |
|---:|---|---|
| 1 | `({ tabId, title }: PageProps<MENU_ID>)` props 시그니처 | 모든 화면 동일 |
| 2 | `gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>()` 타입 명시 | DMF0006:16, DMF0004:23 |
| 3 | Store **개별 selector** (`state => state.x`) | 모든 화면 |
| 4 | `useTabProcQuery<MENU_ID, SHEETS.X>` 제네릭 명시 (Generic 1개 또는 2개) | DMF0004:45-51 |
| 5 | `useProcMutation<MENU_ID, SHEETS.X>` 제네릭 명시 | DMF0004:61-65 |
| 6 | `useEffect(() => { if (!initialized) void fetchStaticColumns(); }, [tabId])` | 모든 화면 |
| 7 | `hotkeyConfig.manual = false` + `hotkeyConfig.upload = false` 의무 | 모든 화면 |
| 8 | JSX 순서: MainTitle → Form → SubTitle → Grid | 모든 화면 |

### §1.3 데이터 흐름

```
[화면 진입]
  → useEffect → fetchStaticColumns()
  → store.staticColumn 갱신 + initialized=true
  → store.searchParams 자동 restore (G1 GET)

[사용자 입력]
  → Form: setSearchParams({ X: Y }) — division 변경 시 fetchStaticColumns 재호출

[조회 (F5)]
  → SubTitle hotkey → hotkeyConfig.search → setFilters() (searchParams → filters 복사)
  → useTabProcQuery filters 변경 감지 → BE re-fetch

[입력 (F8)]
  → SubTitle hotkey → hotkeyConfig.insert → handleInsert
  → GridAction.addRow(gridRef.current, { default 값 })

[삭제 (F9)]
  → SubTitle hotkey → hotkeyConfig.delete → handleDelete
  → GridAction.removeRow(gridRef.current, true)

[저장 (F7)]
  → SubTitle hotkey → hotkeyConfig.save → handleSave
  → data.filter(row => row.CRUD_TYPE) 으로 변경 행만 추출
  → saveWithValidation(saveData, staticColumn, mutate)
```

---

## §2 허용 변형

### §2.1 Multi-sheet (DMF0004 / DMF0005 / DMF0007)

**조건**: 화면에 sheet 가 2개 이상.

**변형**:
- `gridRefs = [useRef, useRef, ...]` (배열)
- `gridFilterRefs = [useRef, ...]` (배열)
- `filters: { [SHEETS.X]: filter, [SHEETS.Y]: filter }` (객체)
- 여러 `useTabProcQuery` (sheet 별)
- 여러 `useProcMutation` (sheet 별)
- `activeTab` state + `SHEET_INDEX` enum
- `handleSave` switch(activeTab) 분기
- SubTitle 의 `grid={gridRefs[activeTab]}` / `gridFilter={gridFilterRefs[activeTab]}` 동적

**reference**: `SalesSite.tsx:23-29` (gridRefs[]), `SalesSite.tsx:45-91` (4 useTabProcQuery + 4 useProcMutation), `SalesSite.tsx:114-141` (handleSave switch).

### §2.2 Tab navigation (DMF0004 + DMF0007)

**조건**: detail sheet 가 tab 으로 표시.

**변형**:
```typescript
<TabWrapper persist activeTabIndex={activeIndex} setActiveTabIndex={setActiveIndex}>
  <TabItem label={t('LBL00xxx')}>
    <Sheet1Grid ... />
  </TabItem>
  <TabItem label={t('LBL00xxx')}>
    <Sheet2Grid ... />
  </TabItem>
</TabWrapper>
```

**reference**: `SalesSite.tsx:193-218`, `CustomerFcstMaster.tsx:213-234`.

### §2.3 Panel 분할 (DMF0005)

**조건**: 두 grid 를 vertical/horizontal 분할로 표시.

**변형**:
```typescript
<PanelGroup className={styles.customPanelGroup} orientation='vertical'>
  <Panel>
    <Grid1 ... />
  </Panel>
  {조건부 && (
    <Panel>
      <Grid2 ... />
    </Panel>
  )}
</PanelGroup>
```

**reference**: `SalesSiteProjectModel.tsx:132-151`.

### §2.4 Dynamic column (DMF0007)

**조건**: 화면에 동적 일자/월 컬럼 생성.

**변형**:
- store 에 `dateColumns` state + `fetchDateColumns` action
- 별도 util (`utils/{purpose}.ts`) 에 동적 컬럼 생성 함수 (`getFcstRangeByBucket`)
- Grid 에 `dynamicColumns={dateColumns}` prop 전달
- handleSave 의 pivot 변환 로직 (`buildPivotedRow`) — wide → long

**reference**: `CustomerFcstMaster.tsx:81-174`, `CustomerFcstMasterDateColumns.ts:1-89`.

### §2.5 EditTracker 명시적 ref (DMF0007 또는 dblClick 처리 필요 화면)

**조건**: cell 편집 추적 + dblClick 시 modal 으로 변경 적용.

**변형**:
```typescript
const editTrackerRef = useRef<EditTracker<RowType>>();

// modal 콜백 안
editTrackerRef.current?.storeChange(dataItem, 'FIELD', oldVal, newVal);
dataItem.FIELD = newVal;
gridRef.current?.refreshRange(new CellRange(row, 0, row, -1));

// handleSave 의 editTracker getOriginalValues 활용
const editMap = editTrackerRef.current?.getOriginalValues();
```

**reference**: `CustomerFcstMaster.tsx:28-29`, `CustomerModelMappingGrid.tsx:26`, `CustomerFcstMaster.tsx:142-174`.

### §2.6 handleSearch 의 additional 동작 (DMF0007)

**조건**: 조회 시 EditTracker / Grid invalidate 필요.

**변형**:
```typescript
const handleSearch = () => {
  setFilter();
  fetchDateColumns();   // 동적 컬럼 재생성
  fcstEditTrackerRef.current?.clearChanges();
  psiEditTrackerRef.current?.clearChanges();
  fcstGridRef.current?.invalidate();
  psiGridRef.current?.invalidate();
};
```

**reference**: `CustomerFcstMaster.tsx:72-79`.

### §2.7 Default 값에 sessionStore (DMF0004)

**조건**: searchParams.divisionId 의 default 가 세션 사용자 부서.

**변형**:
```typescript
import { useSessionStore } from '@shared/stores';

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  // ...
};
```

**reference**: `useSalesSiteStore.ts:40-46`.

---

## §3 금지 (anti-pattern)

### §3.1 객체 destructuring Store

**금지**:
```typescript
const { filters, setFilters, ... } = useStore();  ❌
```

**의무**:
```typescript
const filters = useStore(state => state.filters);  ✅
const setFilters = useStore(state => state.setFilters);
```

**사유**: 전자는 모든 state 변경 시 re-render. 후자는 해당 state 만 변경 시 re-render.

### §3.2 useState 로 화면 state 관리

**금지**:
```typescript
const [searchParams, setSearchParams] = useState({...});   ❌
const [data, setData] = useState([]);                      ❌
```

**의무**: Zustand store + `useTabProcQuery` (data 는 react-query 자동).

### §3.3 fetch / axios 직접 호출

**금지**:
```typescript
const handleSearch = async () => {
  const r = await fetch('/api/...');   ❌
  const r = await axios.post(...);     ❌
};
```

**의무**: `useTabProcQuery` (조회) + `useProcMutation` (저장) + `apiClient` (store 의 fetchStaticColumns 안에서만).

### §3.4 `hotkeyConfig` 의 빈 함수 / `() => undefined`

**금지**:
```typescript
const hotkeyConfig: HotkeyConfig = {
  insert: () => undefined,   ❌ (AS-IS 분석 없이 placeholder)
  delete: () => {},          ❌
};
```

**의무**:
- 사용: 정확한 handler 함수
- 미사용: 명시적 `false` (`insert: false` — 버튼 숨김)
- 생략 (자동 활성): Sort / Filter / Condition / ResetCondition (SubTitle 자동)

→ 메모리 `feedback_asis_button_mapping_mandatory.md` 참조.

### §3.5 `manual` / `upload` 누락

**금지**: hotkeyConfig 에 `manual` / `upload` 명시 안 함 → SubTitle 의 기본 동작 (현재 활성) 으로 의도치 않은 버튼 표시.

**의무**:
```typescript
const hotkeyConfig: HotkeyConfig = {
  // ...
  manual: false,  // 의무 (AS-IS 매뉴얼 다운로드 미사용)
  upload: false,  // 의무 (AS-IS 엑셀 업로드 미사용 — Phase 5 G5 후 결정 가능)
};
```

### §3.6 JSX 순서 위반

**금지**: Grid 가 SubTitle 보다 먼저 / Form 이 MainTitle 보다 먼저.

**의무**: **MainTitle → Form → SubTitle → Grid** 순서 (모든 화면 동일).

### §3.7 한 컴포넌트 200 lines 초과

**금지**: 한 .tsx 파일이 200 lines 초과.

**의무**: sub-component 로 분리 (Form / Grid / Modal 등).

**예외**: handleSave 의 pivot 변환 로직 (DMF0007) 같이 분리 가치 낮은 경우는 유지.

---

## §4 자동 검증 (PR 머지 게이트)

```bash
# 1. Store 개별 selector 사용 검증
rg -n "= useStore\(\)" features/{domain}/src/pages/{screen}/{Name}.tsx | wc -l  # = 0 (객체 destructure 금지)

# 2. useState 로 data 관리 검증
rg -n "useState.*\[\]" features/{domain}/src/pages/{screen}/{Name}.tsx | wc -l  # 0 권장 (단, ui state 는 허용)

# 3. fetch / axios 직접 호출 검증
rg -n "fetch\(|axios\." features/{domain}/src/pages/{screen}/{Name}.tsx | wc -l  # = 0

# 4. hotkeyConfig manual/upload 누락 검증
rg -A 10 "hotkeyConfig: HotkeyConfig" features/{domain}/src/pages/{screen}/{Name}.tsx | grep -c "manual:" # ≥ 1
rg -A 10 "hotkeyConfig: HotkeyConfig" features/{domain}/src/pages/{screen}/{Name}.tsx | grep -c "upload:" # ≥ 1

# 5. () => undefined / () => {} 빈 handler 검증
rg -n "=> undefined|=> \{\s*\}" features/{domain}/src/pages/{screen}/{Name}.tsx | wc -l  # = 0

# 6. JSX 순서 (MainTitle 가 SubTitle 보다 먼저)
awk '/<MainTitle/{print NR ": MainTitle"} /<SubTitle/{print NR ": SubTitle"}' features/{domain}/src/pages/{screen}/{Name}.tsx
# MainTitle line < SubTitle line

# 7. 파일 라인 수
wc -l features/{domain}/src/pages/{screen}/{Name}.tsx  # ≤ 250 권장
```

---

## §5 AS-IS 매핑

| AS-IS BaseForm | TO-BE 메인 컴포넌트 |
|---|---|
| `Form_Load + InitForm + InitControls + CreateSpread + InitSpread` | `useEffect + fetchStaticColumns` (`useStore`) |
| `protected override FindButton()` | `hotkeyConfig.search = setFilters` |
| `protected override InsertButton()` | `hotkeyConfig.insert = handleInsert` (GridAction.addRow) |
| `protected override DeleteButton()` | `hotkeyConfig.delete = handleDelete` (GridAction.removeRow) |
| `protected override SaveButton()` | `hotkeyConfig.save = handleSave` (saveWithValidation + mutate) |
| `protected override EditButton()` | (TO-BE 미사용 — column meta 자동) |
| `protected override ExcelButton()` | (SubTitle excelFileName 자동) |
| `cboDivision_SelectedIndexChanged` | `Form 의 setSearchParams({ divisionId })` → store 안에 자동 fetchStaticColumns + filters reset |
| `spdMain.Query(ds)` | `useTabProcQuery` 자동 refetch |
| `FoxDataClient.SaveData2Async` | `useProcMutation.mutate` |
| `IsChange` flag | `useEffect` + `editTracker` (변경 행 추적) |

---

## §6 reference file:line 인용

| 패턴 | reference |
|---|---|
| 최소 구조 (single sheet) | `CustomerModelMapping.tsx` (100 lines) |
| 최대 구조 (4 sheet) | `SalesSite.tsx` (223 lines) |
| Panel 분할 | `SalesSiteProjectModel.tsx:132-151` |
| Tab navigation | `SalesSite.tsx:193-218`, `CustomerFcstMaster.tsx:213-234` |
| Dynamic column | `CustomerFcstMaster.tsx:81-174` |
| EditTracker 명시 ref | `CustomerFcstMaster.tsx:28-29` |
| sessionStore default | `useSalesSiteStore.ts:40-46` |
| hotkeyConfig manual/upload | 모든 화면 동일 (`*.tsx` 의 hotkeyConfig 블록) |

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 메인 컴포넌트 통합 분석 |
