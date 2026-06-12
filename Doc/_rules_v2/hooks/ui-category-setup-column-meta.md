# Hook — UI Category Setup Column 메타 동적 fetch 의무

> ⚠ **신규/수정 화면 작업 시 반드시 적용**
> UI Category Setup (관리자 화면) 에서 사용자가 VISIBLE / FIXED / WIDTH / SCALE / 라벨 등을 변경하면,
> 해당 화면 진입 시 자동 반영되어야 함. 컬럼 메타 하드코딩 절대 금지.

작성: 2026-06-11 (사용자 명시 요구 — DMF0004/0005 표준 패턴 정형화)
상위 룰: `anti-simplification.md`
관련 룰: `_tobe/04_store.md` / `_tobe/07_datagrid.md` / `_tobe/08_column_meta.md`
관련 메모리:
- `feedback_grid_no_hardcoded_static_columns.md`
- `feedback_sheet_columns_binding_must_match_sp.md`
- `feedback_fetchstaticcolumns_no_initialized_guard.md`

---

## §0. 트리거 (작업 키워드 매칭 시 자동 적용)

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 작성 (T01 신규화면) | PRE-WRITE + POST-WRITE |
| Grid 컴포넌트 수정 (T07 Grid) | PRE-WRITE + POST-WRITE |
| Store 신규 / 수정 (T04 store) | PRE-WRITE + POST-WRITE |
| `staticColumns` 키워드 등장 | POST-WRITE 검증 |
| Sheet 추가 / 변경 | PRE-WRITE 의무 |

⚠ **이 hook 은 다른 트리거에 우선**. 신규 화면이라면 화면-별 hook 보다 먼저 본 hook 의 의무 5 단계 통과 후 후속 작업 진행.

---

## §1. WHY — UI Category Setup 의 존재 이유

`SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` SP 가 반환하는 컬럼 메타는 `SCM_MST_SHEET_COLUMNS` 테이블에서 관리됨. 관리자가 admin 화면에서 다음 속성을 변경:

| 메타 컬럼 | RawFlexGridColumnConfig | 영향 |
|---|---|---|
| `VISIBLE_FLAG` | `visible` | 컬럼 노출/숨김 |
| `DISPLAY_FLAG` | `display` | column-mapping 필터 (안 보이면 grid 에서 제외) |
| `FIXED_FLAG` | `fixed` | 좌측 frozen 고정 |
| `COLUMN_LABEL_NAME` | `colLblNm` | 헤더 라벨 (i18n 키) |
| `COLUMN_WIDTH` | `colWth` | 너비 |
| `DATA_SCALE_NUMBER` | `scale` | 소수점 |
| `CELL_CONTROL_OBJECT_TYPE_CODE` | `cellCtrlObjTpCd` | Cell control type (modal/combo/text...) |
| `INPUT_TP_CD` | `inputTpCd` | 입력 가능 여부 + edit type |
| `HORIZONTAL_ALIGN_CODE` | `horzAlgnCd` | 정렬 (L/R/C) |
| `UPPERCASE_APPLY_FLAG` | `uppercase` | 자동 대문자 변환 |
| `USER_SELECTABLE_FLAG` | `personalizable` | 사용자 컬럼 설정 popup 에서 선택 가능 |
| `SMALL_CLASS_LABEL_NAME`, `LARGE_CLASS_LABEL_NAME` | `sClsLblNm`, `lClsLblNm` | 다단 헤더 |
| `ATTRIBUTE1~10` | `attribute1~10` | 모달 키 등 확장 메타 |

→ FE 에서 컬럼 메타를 **하드코딩하면 admin 변경이 전혀 반영 안 됨** → 운영 결정 무효화 → 신뢰성 손상.

---

## §2. 의무 5 단계 패턴 (DMF0004/0005 표준)

### 2.1 [Store] `staticColumns` state + `fetchStaticColumns` action

```ts
// useSalesSiteStore.ts (DMF0004 reference) / useSalesSiteProjectModelStore.ts (DMF0005)
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';

interface State {
  initialized: boolean;
  staticColumns: { [key in RESPONSE_SET]: RawFlexGridColumnConfig[] };
  searchParams: SearchParamProps;
  filters: filtersBySheet;
  /* ... */
}

interface Action {
  fetchStaticColumns: () => Promise<void>;
  /* ... */
}

const initState: State = {
  initialized: false,
  staticColumns: {
    [RESPONSE_SET.SITE]: [],
    [RESPONSE_SET.CUSTOMER]: [],
    /* ... */
  },
  searchParams: initSearchParams,
  /* ... */
};
```

### 2.2 [Store] `fetchStaticColumns` 구현 — Promise.all + 각 sheet POST

```ts
fetchStaticColumns: async () => {
  const division = get().searchParams.divisionId;
  const [site, customer, /* ... */] = await Promise.all([
    apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: RESPONSE_SET.SITE,
      divisionId: division === '40' ? '40' : undefined,   // ⚠ Division 별 메타 분기
    }),
    apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: RESPONSE_SET.CUSTOMER,
    }),
    /* ... */
  ]);
  set(state => {
    state.staticColumns = {
      [RESPONSE_SET.SITE]: site.data.result,
      [RESPONSE_SET.CUSTOMER]: customer.data.result,
      /* ... */
    };
  });

  // 최초 mount 만 search-conditions 복원 (user persisted)
  if (get().initialized) return;
  const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
    `/admin/menu/${MENU_ID}/search-conditions`
  );
  if (param.data.result?.length > 0) {
    const restored = param.data.result.reduce((acc, curr) => {
      acc[curr.paramNm] = curr.paramCtn;
      return acc;
    }, {} as SearchParamProps);
    set(state => { state.searchParams = restored; });
  }
  set(state => { state.initialized = true; });
},
```

⚠ **divisionId 변경 시 자동 refetch** — `setSearchParams` 안에서 호출:
```ts
setSearchParams: searchParams => {
  set(state => {
    state.searchParams = { ...get().searchParams, ...searchParams };
    if (searchParams.divisionId) {
      void state.fetchStaticColumns();           // ⭐ 의무
      state.filters = initState.filters;
    }
  });
},
```

### 2.3 [Component] mount 시 1회 fetch

```tsx
// SalesSite.tsx
const initialized = useSalesSiteStore(s => s.initialized);
const fetchStaticColumns = useSalesSiteStore(s => s.fetchStaticColumns);

useEffect(() => {
  if (!initialized) void fetchStaticColumns();
}, [tabId]);
```

⚠ **`initialized` guard 는 fetchStaticColumns 안의 `search-conditions` 복원 부분에만 적용** (메모리 `feedback_fetchstaticcolumns_no_initialized_guard.md`). staticColumns 자체는 매 호출 마다 refetch — admin 변경 사항 반영 위해.

### 2.4 [Component] Search 버튼 → `setFilter` + `fetchStaticColumns` 동시 호출

```tsx
const hotkeyConfig: HotkeyConfig = {
  search: () => {
    setSiteFilters();
    void fetchStaticColumns();   // ⭐ 의무 — admin 변경 반영 + division 변경 반영
  },
  /* ... */
};
```

또는 SearchArea 의 onSearch:
```tsx
<SearchArea
  onSearch={() => {
    setSiteFilters();
    void fetchStaticColumns();
  }}
  /* ... */
/>
```

### 2.5 [Grid] `DataGrid staticColumns={...}` prop 전달

```tsx
<DataGrid<ResponseData<MENU_ID, SHEETS.SITE>>
  gridRef={gridRef}
  gridFilterRef={gridFilterRef}
  editTrackerRef={editTrackerRef}
  itemsSource={data}
  staticColumns={staticColumns[RESPONSE_SET.SITE]}   // ⭐ 의무
  /* allowMerging, alternatingRowStep, gotFocus, ... */
/>
```

⚠ **하드코딩 절대 금지**:
```tsx
// ❌ 금지
const COLS = [{ binding: 'A', header: 'A' }, /* ... */];
<DataGrid staticColumns={COLS} />

// ❌ 금지 — 직접 FlexGrid + <FlexGridColumn> 나열
<FlexGrid>
  <FlexGridColumn binding='A' header='A' />
</FlexGrid>
```

예외: 동적 헤더 (PIVOT, dynamic Y#/M# columns) 는 DataGrid 직접 사용이 불가 → 화면 별 `useMemo` 동적 column 생성 가능 (DMF0043 ContributeMainGrid 패턴 — 룰 07 §11 참조).

---

## §3. PRE-WRITE 자기 점검 (모두 ✓ 필수)

- [ ] Store 에 `staticColumns: { [key in SHEETS]: RawFlexGridColumnConfig[] }` 정의?
- [ ] Store 에 `fetchStaticColumns: () => Promise<void>` action 정의?
- [ ] `fetchStaticColumns` 가 각 sheet 별 `apiClient.post('/admin/menu/{MENU_ID}/column', {...})` 호출?
- [ ] Division 별 메타 분기 (`divisionId === '40' ? '40' : undefined`) 적용 (DMF0004/0005 표준)?
- [ ] `setSearchParams` 안에서 `divisionId` 변경 감지 시 `fetchStaticColumns` 호출?
- [ ] Component `useEffect(() => { if (!initialized) void fetchStaticColumns(); }, [tabId])` 존재?
- [ ] Search 버튼 / SearchArea onSearch 가 `setFilter()` + `fetchStaticColumns()` 둘 다 호출?
- [ ] DataGrid 에 `staticColumns={staticColumns[SHEET]}` prop 전달?
- [ ] 어떤 column 도 하드코딩되지 않음 (`<FlexGridColumn binding=` 직접 X)?

---

## §4. POST-WRITE 자동 검증 (grep 명령)

다음 grep 명령들을 작성 직후 실행 — 출력 0 건이어야 통과.

### 4.1 ⛔ DataGrid 에 staticColumns prop 누락
```bash
# DataGrid 사용처 중 staticColumns prop 가 없는 경우
grep -L "staticColumns" features/*/src/pages/{NEW_SCREEN}/components/*Grid.tsx
```

### 4.2 ⛔ Store 에 fetchStaticColumns 미정의
```bash
grep -L "fetchStaticColumns" features/*/src/pages/{NEW_SCREEN}/use*Store.ts
```

### 4.3 ⛔ Component mount 에 fetchStaticColumns 호출 누락
```bash
grep -L "fetchStaticColumns" features/*/src/pages/{NEW_SCREEN}/{Screen}.tsx
```

### 4.4 ⛔ Search 액션에 fetchStaticColumns 동반 호출 누락
```bash
# search 핸들러 안에 setFilter / setSiteFilters 만 있고 fetchStaticColumns 없는 경우
grep -A 4 "search:\s*()\s*=>" features/*/src/pages/{NEW_SCREEN}/*.tsx | grep -B 1 -A 3 "setFilter" | grep -v "fetchStaticColumns"
```

### 4.5 ⛔ 하드코딩 column 배열 (binding+header 직접 명세)
```bash
# DataGrid 안 또는 FlexGridColumn 직접 사용
grep -rn "FlexGridColumn binding=" features/*/src/pages/{NEW_SCREEN}/ \
  | grep -v "// 동적\|// dynamic\|// PIVOT"   # 동적 column 만 허용
```

### 4.6 ⛔ apiClient.post 경로 오타
```bash
# 정확한 경로만 허용: /admin/menu/${MENU_ID}/column
grep "apiClient.post.*admin.*column\|apiClient.post.*admin.*measure" features/*/src/pages/{NEW_SCREEN}/use*Store.ts
# 결과 라인이 정확히 /admin/menu/${MENU_ID}/column 또는 /admin/menu/${MENU_ID}/measure 패턴이어야 함
```

---

## §5. anti-pattern 사고 사례

### 5.1 (실제 사례) staticColumns 하드코딩
```tsx
// ❌ admin 의 VISIBLE_FLAG 변경 반영 안 됨
const COLS = [
  { binding: 'DIVISION_ID', header: 'Division', width: 80 },
  { binding: 'SCM_SITE_ID', header: 'Site', width: 120 },
];
<DataGrid staticColumns={COLS} />
```

→ **fix**: store 에 `staticColumns` state + `fetchStaticColumns` 추가, mount + search 시 호출. 메모리 `feedback_grid_no_hardcoded_static_columns.md` 동일.

### 5.2 (실제 사례) `if (!initialized)` 안에서 `fetchStaticColumns` 호출 → 영구 미호출
```tsx
// ❌ initialized=true 가 persist 되어 mount 마다 fetch skip
useEffect(() => {
  if (!initialized) {
    void fetchStaticColumns();
  }
}, []);
```

⚠ `initialized` 는 store persist 됨. mount 시 이미 true → fetch 안 함 → admin 변경 미반영.

→ **fix**: `fetchStaticColumns` 자체는 매 호출 마다 실행 보장. `initialized` guard 는 fetchStaticColumns 안의 search-conditions 복원 부분에만 적용. 메모리 `feedback_fetchstaticcolumns_no_initialized_guard.md` 동일.

### 5.3 (실제 사례) Search 시 setFilter 만 호출, fetchStaticColumns 누락
```tsx
// ❌ 사용자가 Division 을 40 → 81 변경 후 검색 → 컬럼 메타는 40 그대로
const hotkeyConfig = {
  search: () => setSiteFilters(),   // fetchStaticColumns 누락
};
```

→ **fix**: `search: () => { setSiteFilters(); void fetchStaticColumns(); }`.

### 5.4 (실제 사례) `SHEET_COLUMNS.COLUMN_NAME` 이 SP 결과 alias 와 불일치
```sql
-- SP 가 반환하는 컬럼: SCM_SITE_ID (대문자)
-- SHEET_COLUMNS 에 등록된 COLUMN_NAME: scm_site_id (소문자) ← 사고
```

→ **fix**: SHEET_COLUMNS.COLUMN_NAME === SP 결과 case-sensitive 일치 필수. 메모리 `feedback_sheet_columns_binding_must_match_sp.md` 동일.

---

## §6. Cross-ref

- 룰 04 §9/§10 (Store `createPersistedStoreWithTab` 시그니처 + fetchStaticColumns guard)
- 룰 07 §11 (DataGrid staticColumns 출처 표준)
- 룰 08 (Column meta `_inputEditType`/`_ctrlType`/`_modalKey`)
- 룰 12 §13 (SHEET_COLUMNS COLUMN_NAME = SP alias)
- 메모리: feedback_grid_no_hardcoded_static_columns / feedback_sheet_columns_binding_must_match_sp / feedback_fetchstaticcolumns_no_initialized_guard / feedback_createpersistedstorewithtab_signature
- Reference 화면 (canonical): DMF0004 sales-site / DMF0005 sales-site-project-model

---

## §7. 위반 시 대응

- PRE-SUBMIT 시 §3 체크리스트 9 항목 + §4 grep 6 항목 모두 통과 의무
- 1건이라도 위반 = PR 머지 차단
- 사고 사례 §5 중 어느 것이라도 재현 가능하면 즉시 fix
- anti-simplification 위반 (속도/편의 목적의 하드코딩) = 도구 사용 중단

---

## §8. Measure 동적 fetch (PIVOT/measure 사용 화면)

> ⭐ **2026-06-12 사용자 명시 요구 추가** — "UI 생성의 동적 속성관리" 의 Measure 부분.
> PIVOT 화면 (Sales Price / Contribute Ratio / Demand Plan 등) 의 measure 도 admin 관리 + 동적 fetch.

### 8.1 admin UI 관리 속성

| 속성 | 메타 컬럼 (`SCM_MST_SHEET_MEASURE`) | FE 영향 |
|---|---|---|
| Code | `COLUMN_NAME` | measure 코드 (LOC, USD, RTF_SYS_RP, ...) |
| Label | `COLUMN_LABEL_NAME` | 화면 표시 라벨 |
| Sort Order | `SORT_ORDER_NO` | 정렬 순서 |
| Valid | `VALID_YN` | 사용 가능 여부 |

### 8.2 FE 패턴 (Column 5단계와 동일 구조)

```ts
// Store
interface State {
  staticMeasures: { [key in SHEETS]: MeasureMeta[] };
}
interface Action {
  fetchStaticMeasures: () => Promise<void>;
}

fetchStaticMeasures: async () => {
  const result = await apiClient.post<MeasureMeta[]>(
    `/admin/menu/${MENU_ID}/measure`, { sheetNm: SHEETS.MAIN }
  );
  set(state => { state.staticMeasures[SHEETS.MAIN] = result.data.result; });
},
```

```tsx
// Component
useEffect(() => {
  void fetchStaticMeasures();
}, [tabId]);

const hotkeyConfig = {
  search: () => {
    setFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();   // ⭐ Column + Measure 둘 다
  },
};
```

### 8.3 신규 등록 의무 SQL

```sql
INSERT INTO SCM_MST_SHEET_MEASURE (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VALID_YN, CREATED_BY, CREATION_DATE)
SELECT * FROM (
  SELECT '{NEW_MENU_ID}' PROGRAM_ID, 'Sales Price' SHEET_NAME, 'LOC'        COLUMN_NAME, 'Local'        COLUMN_LABEL_NAME, 1 SORT_ORDER_NO, 'Y' VALID_YN, 'admin' CREATED_BY, SYSDATE CREATION_DATE FROM DUAL UNION ALL
  SELECT '{NEW_MENU_ID}',            'Sales Price',            'USD',                    'USD',                            2,               'Y',          'admin',           SYSDATE                   FROM DUAL UNION ALL
  SELECT '{NEW_MENU_ID}',            'Sales Price',            'RTF_SYS_RP',             'RTF System RP',                  3,               'Y',          'admin',           SYSDATE                   FROM DUAL
) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=NEW.PROGRAM_ID AND SHEET_NAME=NEW.SHEET_NAME AND COLUMN_NAME=NEW.COLUMN_NAME);
```

---

## §9. 신규 화면 작성 시 신규 등록 의무 (admin UI 데이터 부재 케이스)

> ⭐ **2026-06-12 사용자 명시 요구 추가** — 신규 UI 작성 시 `SCM_MST_SHEET_COLUMNS` / `SCM_MST_SHEET_MEASURE` 에 데이터 없으면 **반드시 신규 등록**.

### 9.1 PRE-WRITE Step 1 (admin UI 데이터 존재 점검)

```sql
SELECT 'COLUMN' tbl, COUNT(*) cnt FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '{NEW_MENU_ID}'
UNION ALL
SELECT 'MEASURE', COUNT(*) FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID = '{NEW_MENU_ID}';
```

### 9.2 부재 시 deploy SQL BLOCK 6 등록 의무

- **Column** (모든 화면): `SCM_MST_SHEET_COLUMNS` 멱등 INSERT
- **Measure** (PIVOT 화면): `SCM_MST_SHEET_MEASURE` 멱등 INSERT
- NOT EXISTS 패턴 의무 — 사용자 admin UI 에서 후속 조작 시 덮어쓰지 않음

### 9.3 admin UI 변경 → 화면 자동 반영

- 화면 mount + Search 시 fetch
- BE cache 사용 시 SYS0004 (UI Category Setup) SAVE 트리거가 invalidate
- 다른 사용자 영향: 다음 mount fetch 시 반영

---

## §11. Wijmo 직접 사용 시 통합 column meta 패턴 (PoC DMF0020, 2026-06-12)

> ⭐ **2026-06-12 사용자 명시 사고**: DMF0020 PROJECT_STATUS VISIBLE_FLAG='N' 으로 변경했으나 화면 그대로 표시.
> 원인: `<DataGrid staticColumns={...}>` 표준 사용 X, 화면 별 `FlexGrid` + 하드코딩 `MAIN_COLUMNS.map` 사용.
> → 어떤 화면이 Wijmo 를 직접 사용한다면 **통합 column meta useMemo + visibleColumns 필터링 패턴 의무**.

### 11.1 의무 패턴 (3 단계)

```tsx
// Step 1: Props 확장 — admin 메타 받기
interface Props {
  rows: Row[];
  staticColumns?: RawFlexGridColumnConfig[];   // ⭐ admin 동적 메타
  staticMeasures?: MeasureMeta[];              // ⭐ PIVOT/measure 화면만
}

// Step 2: 통합 column meta useMemo (staticColumns 우선, MAIN_COLUMNS fallback)
interface MergedColumnMeta {
  binding: string; header: string; width: number; align: 'L' | 'R' | 'C';
  visible: boolean; fixed: boolean; scale?: number;
  _ctrlType?: ...; _inputEditType?: ...; _modalKey?: string; _comboKey?: string;
}

const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
  if (!staticColumns || staticColumns.length === 0) {
    // BE 실패 시 fallback — 화면 작동 보장
    return MAIN_COLUMNS.map(c => ({ binding: c.key, header: c.header, width: c.width, ... }));
  }
  return staticColumns.map(sc => {
    const fb = MAIN_COLUMNS.find(m => m.key === sc.colNm);
    return {
      binding: sc.colNm,
      header: sc.colLblNm || fb?.header || sc.colNm,
      width: sc.colWth ?? fb?.width ?? 100,
      align: (sc.horzAlgnCd ?? fb?.align ?? 'C'),
      visible: sc.visible !== false,
      fixed: sc.fixed === true,
      scale: sc.scale,
      _ctrlType: sc.cellCtrlObjTpCd ?? fb?._ctrlType,
      _inputEditType: sc.inputTpCd ?? fb?._inputEditType,
      _modalKey: sc.attribute1 ?? fb?._modalKey,
      _comboKey: sc.attribute2 ?? fb?._comboKey,
    };
  });
}, [staticColumns]);

// Step 3: visible=true 만 렌더링
const visibleColumns = useMemo(() => mergedColumns.filter(c => c.visible), [mergedColumns]);

// FlexGridColumn 렌더링 — visibleColumns 사용
{visibleColumns.map(c => (
  <FlexGridColumn key={c.binding} binding={c.binding} header={c.header} width={c.width} ... />
))}
```

### 11.2 반영 속성 매트릭스

| 속성 | DB 컬럼 | RawFlexGridColumnConfig 키 | FlexGridColumn prop |
|---|---|---|---|
| visible | `VISIBLE_FLAG` | `visible` | (filter — 렌더링 skip) |
| header | `COLUMN_LABEL_NAME` | `colLblNm` | `header` |
| width | `COLUMN_WIDTH` | `colWth` | `width` |
| align | `HORIZONTAL_ALIGN_CODE` | `horzAlgnCd` | `align` |
| scale | `DATA_SCALE_NUMBER` | `scale` | `format='nN'` |
| fixed | `FIXED_FLAG` | `fixed` | `frozenColumns` count |
| cellCtrlObjTpCd | `CELL_CONTROL_OBJECT_TYPE_CODE` | `cellCtrlObjTpCd` | (formatItem cell type) |
| inputTpCd | `INPUT_TP_CD` | `inputTpCd` | `isReadOnly` (S=true) |
| modalKey | `ATTRIBUTE1` | `attribute1` | (popup dblClick) |
| comboKey | `ATTRIBUTE2` | `attribute2` | (DataMap) |
| uppercase | `UPPERCASE_APPLY_FLAG` | `uppercase` | (formatItem 변환) |
| personalizable | `USER_SELECTABLE_FLAG` | `personalizable` | (column setting popup) |

### 11.3 Measure 동적 (PIVOT/Insert measure 다중 row 화면)

```tsx
// SalesFuturePrice.tsx handleInsert — admin SCM_MST_SHEET_MEASURE 동적
const handleInsert = () => {
  const validMeasures = (staticMeasures[SHEETS.MAIN] ?? [])
    .filter(m => m.VALID_YN !== 'N')
    .sort((a, b) => (a.SORT_ORDER_NO ?? 0) - (b.SORT_ORDER_NO ?? 0))
    .map(m => m.COLUMN_NAME);
  const measures = validMeasures.length > 0 ? validMeasures : MEASURE_4;  // fallback
  // ...
};
```

⚠ `MEASURE_4 = ['RTF','KRW','USD','LOC']` 하드코딩 절대 금지. admin 이 measure 추가/제거 시 즉시 반영 불가.

### 11.4 anti-pattern 사고 (DMF0020 PROJECT_STATUS VISIBLE_FLAG='N' 미반영, 2026-06-12)

- 화면 별 FlexGrid 직접 + `<FlexGridColumn binding={c.key} ...>` 하드코딩 map
- staticColumns prop 받았으나 사용 안 함
- → admin VISIBLE_FLAG 변경 전혀 반영 안 됨

→ **fix**: 본 §11.1 의 3 단계 패턴 의무 적용.

### 11.5 PRE-WRITE 체크리스트 (Wijmo 직접 사용 화면)

- [ ] Props 에 `staticColumns` + `staticMeasures` (PIVOT 시) 추가?
- [ ] `MergedColumnMeta` interface 정의?
- [ ] `mergedColumns` useMemo — staticColumns 있으면 그것 우선, 없으면 MAIN_COLUMNS fallback?
- [ ] `visibleColumns = mergedColumns.filter(c => c.visible)` ?
- [ ] FlexGridColumn map 이 `visibleColumns` 사용 (`MAIN_COLUMNS` 직접 X)?
- [ ] formatItem / beginningEdit 안의 column meta find 가 `visibleColumns.find(c => c.binding === ...)` 사용?
- [ ] handleInsert 의 MEASURE 도 `staticMeasures` 동적 (`MEASURE_4` 직접 X)?

### 11.6 POST-WRITE grep

```bash
# 1) MAIN_COLUMNS.map(c => <FlexGridColumn key={c.key} ...>) 잔존 검출
grep -n "MAIN_COLUMNS\.map.*FlexGridColumn" features/*/src/pages/{SCREEN}/components/*Grid.tsx

# 2) MEASURE_4.map 잔존 검출 (handleInsert)
grep -n "MEASURE_4\.map" features/*/src/pages/{SCREEN}/*.tsx
```

---

## §10. Cross-ref (확장)

- 상위: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md`
- 동급: `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md` (Button)
- 룰 04 §9/§10 — Store 패턴
- 룰 07 §11 — DataGrid `staticColumns` 출처
- 룰 08 — Column meta `_inputEditType`/`_ctrlType`/`_modalKey`
- 룰 12 §13/§14 — SHEET_COLUMNS / SHEET_MEASURE 등록 표준
- 메모리: `feedback_admin_meta_dynamic_fetch.md` / `feedback_grid_no_hardcoded_static_columns.md` / `feedback_sheet_columns_binding_must_match_sp.md` / `feedback_fetchstaticcolumns_no_initialized_guard.md` / `feedback_createpersistedstorewithtab_signature.md`
