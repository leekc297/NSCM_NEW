# TO-BE 룰 04 — Store (Zustand) 표준

> **추출 reference**: DMF0006 (단순 store) + DMF0004 (multi-sheet filters) + DMF0007 (dateColumns 동적)

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 04 |
| 토픽 | Zustand store (createPersistedStoreWithTab) |
| 적용 trigger | 신규 화면 store 작성 |
| 관련 hook | `pre-write.md` |

---

## §1 표준 구조 (의무) — 단일 sheet (DMF0006 baseline)

> reference: `useCustomerModelMappingStore.ts` (100 lines, 단순한 표준)

### §1.1 5 섹션 구조

```typescript
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './{kebab-name}.constants';
import type { SearchParamProps } from './{kebab-name}.types';

// [1] State interface
interface {Name}State {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS>;
  staticColumn: RawFlexGridColumnConfig[];
}

// [2] Action interface
interface {Name}Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

// [3] Initial state
const init{Name}State: {Name}State = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: '40',   // 또는 useSessionStore.getState().session.div ?? '40'
    // ... 다른 default
  },
  staticColumn: [],
};

// [4] Store create
export const use{Name}Store = createPersistedStoreWithTab<
  {Name}State & {Name}Action
>(
  (set, get) => ({
    ...init{Name}State,
    reset: () => set(init{Name}State),
    setOpenSearchArea: open => set(state => {
      state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
    }),
    setSearchParams: searchParams => set(state => {
      state.searchParams = { ...get().searchParams, ...searchParams };
      if (searchParams.divisionId) {
        void state.fetchStaticColumns();
        state.filters = init{Name}State.filters;
      }
    }),
    setFilters: () => set(state => {
      state.filters = { ...state.searchParams };
    }),
    fetchStaticColumns: async () => {
      // [5] BE 2 API 호출
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.X }
      );
      set(state => { state.staticColumn = result.data.result; });
      
      if (get().initialized) return;
      void (async () => {
        const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        if (param.data.result?.length > 0) {
          const searchParams = param.data.result.reduce((acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          }, {} as SearchParamProps);
          set(state => { state.searchParams = searchParams; });
        }
      })();
      set(state => { state.initialized = true; });
    },
  }),
  '{kebab-name-slug}',   // persistent key
);
```

### §1.2 의무 사항

| # | 의무 | reference |
|---:|---|---|
| 1 | `State` + `Action` interface 분리 | DMF0006:8-22 |
| 2 | `initState` 별도 const 정의 + reset action 에서 재사용 | DMF0006:24-39 |
| 3 | `createPersistedStoreWithTab<State & Action>((set, get) => ({...}), 'slug')` | DMF0006:41-100 |
| 4 | `set(state => { ... })` 형태 사용 (immer mutation) — 직접 mutation 가능 | DMF0006:48-49 |
| 5 | `setSearchParams` 안에 `divisionId` 변경 시 `fetchStaticColumns + filters reset` | DMF0006:52-60 |
| 6 | `fetchStaticColumns` 첫 호출 시 `apiClient.get('/admin/menu/{menuId}/search-conditions')` → searchParams 자동 restore (G1 GET) | DMF0006:77-93 |
| 7 | persistent slug = kebab-case 폴더명 | DMF0006:99 (`'customer-model-mapping'`) |

---

## §2 허용 변형

### §2.1 Multi-sheet (DMF0004 / DMF0005 / DMF0007)

**조건**: 화면 sheet ≥ 2.

**변형**:
```typescript
// filters: 객체 (sheet 별 별도)
type filtersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface State {
  filters: filtersBySheet;
  staticColumns: { [key in RESPONSE_SET]: RawFlexGridColumnConfig[] };  // (s 복수)
}

// setSiteFilters / setDetailFilters / setProductionFilter 등 sheet 별 setter
setSiteFilters: () => set(state => {
  state.filters[SHEETS.SITE] = { ...state.searchParams };
  state.filters[SHEETS.CUSTOMER] = undefined;  // detail reset
}),

// fetchStaticColumns: Promise.all 로 모든 sheet column 병렬 fetch
fetchStaticColumns: async () => {
  const [a, b, c, d] = await Promise.all([
    apiClient.post(`/admin/menu/${MENU_ID}/column`, { sheetNm: RESPONSE_SET.X }),
    apiClient.post(`/admin/menu/${MENU_ID}/column`, { sheetNm: RESPONSE_SET.Y }),
    // ...
  ]);
  set(state => {
    state.staticColumns = {
      [RESPONSE_SET.X]: a.data.result,
      [RESPONSE_SET.Y]: b.data.result,
      // ...
    };
  });
  // (이하 G1 GET 동일)
};
```

**reference**: `useSalesSiteStore.ts:15-29, 91-114`.

### §2.2 Division 별 column 조건부 fetch (DMF0004)

```typescript
apiClient.post(`/admin/menu/${MENU_ID}/column`, {
  sheetNm: RESPONSE_SET.SITE,
  divisionId: get().searchParams.divisionId === '40' ? '40' : undefined,
}),
```

→ Division 40 시 추가 query param. 그 외에는 default.

**reference**: `useSalesSiteStore.ts:94-95`.

### §2.3 추가 state (UI 토글 / 동적 데이터)

| 추가 state 예 | 용도 | reference |
|---|---|---|
| `openSearchArea: boolean` | 검색 영역 토글 | 모든 화면 |
| `loading: boolean` | 로딩 표시 | DMF0004 |
| `error: string \| null` | 에러 표시 | DMF0004 |
| `openPurchaseGrid: boolean` | DMF0005 Purchase grid 토글 | DMF0005 |
| `dateColumns: FlexGridColumnConfig[]` | 동적 일자 컬럼 | DMF0007 |

→ 화면 특화 state 는 자유롭게 추가. 다만 표준 (initialized / filters / searchParams / staticColumn(s) / isOpenSearchArea) 은 의무.

### §2.4 추가 action (동적 fetch / clear)

| 추가 action | 용도 | reference |
|---|---|---|
| `fetchDateColumns` | DMF0007 의 동적 일자 컬럼 갱신 | useCustomerFcstMasterStore |
| `setOpenPurchaseGrid` | DMF0005 의 Purchase toggle | useSalesSiteProjectModelStore |

### §2.5 SHEETS = RESPONSE_SET 동등 (single-sheet)

**조건**: SHEETS 가 하나 + BE response 가 `o_rc1` (기본).

**변형 (DMF0006)**:
```typescript
filters?: ProcRequest<MENU_ID, SHEETS>;  // SHEETS = 단일 enum
staticColumn: RawFlexGridColumnConfig[]; // 배열 (객체 아님)
```

→ DMF0006 는 RESPONSE_SET 정의 안 함 (data.o_rc1 직접 사용).

### §2.6 명명 자유도 (Phase 7 PoC 추가, 2026-06-04)

> ⚠️ **메타-룰 진화** (Phase 7 PoC DMF0008): 룰 04 §1.1 의 표준 명명 (`searchParams`, `setSearchParams`, `setMainFilter`) 외 다른 명명도 허용. **의미 동등성** 기준.

**허용 변형 — DMF0008 ErpEdiMaster 사례**:

| 룰 04 §1.1 표준 | 변형 (의미 동등) | 사용 |
|---|---|---|
| `searchParams: SearchParamProps` | `searchCondition: SearchCondition` | DMF0008 |
| `setSearchParams(partial)` | `setSearchCondition(partial)` | 동일 |
| `setMainFilter()` | `setFilter()` (Main + Repair 통합 set) | 동일 |
| `setBodItemFilter(filter)` | `setSubFilter()` (Sales_Site + SSPM 통합 set) | 동일 |

**조건**:
- (a) **의미 동등** (state 의 역할 동일 — 조회조건 / filter 등)
- (b) **AS-IS reference 인용** — `// AS-IS DMF0008_ErpEdiMaster .cs Lxxx 참조` 주석 명시
- (c) **API 표준 (apiClient 호출 / useTabProcQuery 사용 등) 은 §1.1 의무**

→ **anti-simplification 의 반대편**: 잘 동작하는 사용자 작업물의 이름을 룰 v2 표준으로 강제 변경 X.

### §2.7 fetchStaticColumns 의 선택적 적용 (Phase 7 추가)

> ⚠️ 룰 04 §1.2 #6 의 `fetchStaticColumns` + G1 GET 자동 restore 는 **조건부 의무**:

| 화면 종류 | fetchStaticColumns | G1 GET | 사유 |
|---|---|---|---|
| 편집 (Insert/Update) | ⭐ 의무 | ⭐ 의무 | column 메타 + 검색조건 restore |
| 동적 column (`dynamicColumns`) | ⭐ 의무 | ⭐ 의무 | 동일 |
| **read-only + 명시적 FlexGridColumn JSX** (룰 07 §2.7) | 선택 (생략 가능) | 선택 (생략 가능) | column 메타 BE fetch 불필요 |
| **사용자 작업물** (이미 동작) | 강제 변경 X | 강제 추가 X | 보존 + 후속 보강 |

→ DMF0008 ErpEdiMaster (read-only 조회 화면) 는 `fetchStaticColumns` 생략 + 명시적 column 정의 패턴 허용.

---

## §3 금지 (anti-pattern)

### §3.1 외부 mutation (set 외부에서 직접 변경)

**금지**:
```typescript
const state = useStore.getState();
state.filters = newFilters;   ❌ (mutation 외부 실행 — react 가 모름)
```

**의무**:
```typescript
useStore.setState(state => { state.filters = newFilters; });
// 또는 (권장)
useStore.getState().setFilters();  // action 사용
```

### §3.2 fetchStaticColumns 의 의무 누락

**금지**: `fetchStaticColumns` 안에 `apiClient.get('/search-conditions')` 누락 → G1 GET 자동 restore 작동 안 함.

**의무**: 모든 화면 동일 패턴 사용 (DMF0006 안의 line 77-93 의 G1 GET 부분 복사).

### §3.3 persistent slug 누락 / 중복

**금지**:
- `createPersistedStoreWithTab(...)` 두 번째 인자 누락 (default 동작 안 함)
- 다른 화면과 동일 slug 사용 (충돌)

**의무**: kebab-case 폴더명 = slug.

### §3.4 reset 함수 누락

**금지**: `reset` action 정의 안 함 → 화면 닫고 다시 열 때 잔존 state.

**의무**: `reset: () => set(initState)` 항상 정의.

→ TabWrapper close 시 자동 호출. 사용자가 명시 호출 가능.

### §3.5 set 안에 async

**금지**:
```typescript
setX: async () => {
  const r = await ...;
  set(state => { state.x = r; });   ✅ 이건 OK
  
  set(async (state) => {            ❌ set 자체가 async 면 안 됨
    state.x = await ...;
  });
};
```

**의무**: `set` 콜백은 sync. async 작업은 set 호출 외부에서.

---

## §4 자동 검증 (PR 머지 게이트)

```bash
STORE="features/{domain}/src/pages/{screen}/use{Name}Store.ts"

# 1. createPersistedStoreWithTab 사용 + slug 명시
grep -E "createPersistedStoreWithTab<.*>\(" "$STORE" | wc -l  # = 1
grep -E "'\S+',\s*\)" "$STORE" | wc -l  # ≥ 1 (slug 명시)

# 2. State + Action interface 분리
grep -cE "^interface \w+(State|Action)" "$STORE"  # = 2 (State + Action)

# 3. initialized + searchParams + filters + staticColumn(s) 표준 state 의무
grep -c "initialized:" "$STORE"  # ≥ 1
grep -c "searchParams:" "$STORE"  # ≥ 1
grep -c "filters" "$STORE"  # ≥ 1
grep -cE "staticColumn(s)?:" "$STORE"  # ≥ 1

# 4. G1 GET 의무 — apiClient.get('/search-conditions')
grep -c "apiClient.get.*search-conditions" "$STORE"  # ≥ 1

# 5. setFilters / fetchStaticColumns / reset 표준 action
grep -c "setSearchParams" "$STORE"  # ≥ 1
grep -c "fetchStaticColumns" "$STORE"  # ≥ 1
grep -c "reset:" "$STORE"  # ≥ 1

# 6. setSearchParams 안의 divisionId fetchStaticColumns 의무
awk '/setSearchParams:/,/^\s*\},?\s*$/' "$STORE" | grep -c "fetchStaticColumns"  # ≥ 1

# 7. external mutation 금지
grep -nE "useStore\.getState\(\)\." "$STORE" | grep -v "\.setX\|\.actions"  # 가능 0 (단, getState().action() 은 허용)
```

---

## §5 AS-IS 매핑

| AS-IS BaseForm | TO-BE Store |
|---|---|
| `dsSearchCondition` (사용자별 저장 검색조건) | Store `searchParams` + G1 GET auto-restore |
| `ManualSearchCondition` (수동 전달) | `useNavigate` state 또는 store action |
| `IsChange` flag | (TO-BE 는 useEffect + editTracker 자동 추적) |
| `IsEditMode` flag | (TO-BE 는 column meta 자동) |
| `formauth` enum (None/Disable/Inquiry/Update/All) | (TO-BE 폐기 — 메뉴/버튼 권한 2 테이블) |
| `bEnable[7]` array | (TO-BE hotkeyConfig 의 `false`) |
| `IsFilter` / `dtFilterCol2` / `dtFilterVal2` | (TO-BE FlexGridFilter 자동) |
| `_MenuID / _MenuGroup` | `MENU_ID` const + persistent slug |

---

## §6 reference file:line 인용

| 패턴 | reference |
|---|---|
| 최소 store (단순) | `useCustomerModelMappingStore.ts` (100 lines) |
| Multi-sheet store | `useSalesSiteStore.ts` (140 lines) |
| Panel store | `useSalesSiteProjectModelStore.ts` (147 lines) |
| Dynamic column store | `useCustomerFcstMasterStore.ts` (136 lines) |
| G1 GET 자동 restore | `useCustomerModelMappingStore.ts:77-93` (모든 화면 동일) |
| Promise.all 병렬 column fetch | `useSalesSiteStore.ts:92-106` |
| sessionStore default | `useSalesSiteStore.ts:40-46` |

---

## §7 G1 사양 정정 (Phase 3 발견)

> **중요**: Phase 1 의 G1 격차 분석에서 "검색조건 저장/복원 미구현" 으로 식별됐으나, Phase 3 reference 분석에서 **GET (자동 restore) 은 이미 구현됨** 확인.

**G1 정정 사양**:

| 동작 | AS-IS | TO-BE 현재 | 신규 구현 필요 |
|---|---|---|---|
| GET (자동 restore) | `UP_FX_GetSearchCondition` SP | ✅ `apiClient.get('/admin/menu/{menuId}/search-conditions')` 구현됨 | ❌ 추가 작업 없음 |
| POST (저장 — F6) | `Authentication.SaveSearchCondition` SP | ❌ 미구현 | ✅ 신규: `POST /admin/menu/{menuId}/search-conditions` |
| DELETE (초기화 — F10) | `Authentication.ResetSearchCondition` SP | ❌ 미구현 | ✅ 신규: `DELETE /admin/menu/{menuId}/search-conditions` |

→ G1 의 실제 신규 구현 범위 = **POST + DELETE 2 endpoint** + FE SubTitle 의 condition/resetCondition action default 활성. `_mapping/asis_to_tobe.md` §G1 갱신 의무 (Phase 4).

---

## §9 `createPersistedStoreWithTab` 시그니처 (의무, 2026-06-09 강화)

### §9.1 정확한 시그니처

```typescript
createPersistedStoreWithTab<T extends BaseTabState>(
  stateCreator: PersistedImmerCreator<T & BaseTabState>,
  storageName: string
)
```

→ **제네릭 1개 + 인자 2개**.

### §9.2 표준 호출

```typescript
export const useXxxStore = createPersistedStoreWithTab<XxxState & XxxAction>(
  (set, get) => ({ ...initState, action1: () => {...}, ... }),
  'xxx-store-name'
);
```

### §9.3 anti-pattern (3 제네릭 + 3 인자 — `stateCreator is not a function` 사고)

```typescript
// ❌ 절대 금지 — SCM0009 + SCM0005 동일 사고 반복
export const useStore = createPersistedStoreWithTab<
  MENU_ID,           // 제네릭 1
  XxxState,          // 제네릭 2
  XxxAction          // 제네릭 3
>(
  MENU_ID,           // 인자 1 — string!
  (set, get) => ({...}),  // 인자 2 — stateCreator
  'storage-name'     // 인자 3
);
```

→ 첫 번째 인자가 string (MENU_ID) 이 되어 `stateCreator()` 호출 시 `TypeError: stateCreator is not a function` 발생.

### §9.4 cross-ref

- 메모리 `feedback_createpersistedstorewithtab_signature`
- 사고: SCM0009 (2026-06-06), SCM0005 (2026-06-09)

---

## §10 fetchStaticColumns guard 패턴 (2026-06-09 신규)

### §10.1 사고

```typescript
// ❌ initialized guard 안에 fetchStaticColumns — 사고 패턴
useEffect(() => {
  if (!initialized) {
    void fetchSearchConditions();
    void fetchStaticColumns();   // ← initialized=true (sessionStorage persist) 면 절대 호출 안 됨
  }
}, []);
```

→ persist 된 `initialized=true` 상태로 화면 진입 시 staticColumns fetch 안 됨 → grid column 0 개 (이전에 fetch 한 적 없으면 영구 0개).

### §10.2 표준 패턴

```typescript
// ✅ fetchStaticColumns 는 guard 밖 — 매 mount 시 호출 (gridColumns 갱신 보장)
useEffect(() => {
  if (!initialized) void fetchSearchConditions();
  void fetchStaticColumns();   // ← guard 밖
  if (!filters[SHEETS.MAIN]) setFilter();
}, []);
```

또는 별도 `columnsInitialized` flag 사용:

```typescript
useEffect(() => {
  if (!columnsInitialized) void fetchStaticColumns();
  // ...
}, []);
```

### §10.3 cross-ref

- 메모리 `feedback_fetchstaticcolumns_no_initialized_guard`
- 사고: SCM0005 (2026-06-09)

---

## §11 localStorage 별도 persist 패턴 (2026-06-07 신규, DMF0003)

> DMF0003 (MKT FCST) Measure 선택 상태가 화면 close/reopen 후 사라지는 사고.
> 원인: `createPersistedStoreWithTab` 는 sessionStorage (tabId 별) → tab close 시 lost.

### §11.1 sessionStorage vs localStorage 결정 표

| state 종류 | storage | 이유 |
|---|---|---|
| 검색조건 (조회조건 form) | sessionStorage (`createPersistedStoreWithTab`) | F5 새로고침 유지 + tab close 시 reset (다음 진입 시 default) |
| Grid sort/filter 상태 | sessionStorage | 동일 |
| **Column 설정 / Measure 선택** | **localStorage 별도** | **화면 close/reopen 후에도 유지 의무** |
| User 환경설정 | localStorage | 동일 |

### §11.2 ❌ Anti-pattern (사고 발생)

```tsx
// ❌ default 값 덮어쓰기 사고 — useEffect deps [state] 자동 저장
useEffect(() => {
  const saved = localStorage.getItem(KEY);
  if (saved) setMyState(JSON.parse(saved));
}, []);

useEffect(() => {
  // mount 시 closure 의 myState = default → saved 덮어쓰기!
  localStorage.setItem(KEY, JSON.stringify(myState));
}, [myState]);
```

**사고 흐름**:
1. mount → 복원 useEffect → `setMyState(saved)` (async queue)
2. **같은 render** → 저장 useEffect → closure 의 myState = default → `setItem(default)` ← saved 덮어쓰기
3. 다음 render → 복원된 값 반영되지만 localStorage 는 이미 default

### §11.3 ✅ 정확한 패턴

```tsx
const KEY = '{screen-id}-{state-name}';

// ✅ mount 시 1회만 복원
useEffect(() => {
  try {
    const saved = localStorage.getItem(KEY);
    if (saved) {
      const parsed = JSON.parse(saved) as unknown;
      if (Array.isArray(parsed) && parsed.length > 0 && parsed.every(x => typeof x === 'string')) {
        setMyState(parsed as string[]);
      }
    }
  } catch { /* noop */ }
// eslint-disable-next-line react-hooks/exhaustive-deps
}, []);

// ✅ state 변경 callback 안에서 store + localStorage 동시 저장
const handleApply = (newValue: string[]) => {
  setMyState(newValue);                                    // store
  try { localStorage.setItem(KEY, JSON.stringify(newValue)); } catch { /* noop */ }
};

<MyModal onApply={handleApply} />
```

### §11.4 자동 검증 grep

```bash
# 사고 패턴 검출 (deps [state] + setItem)
grep -rn "localStorage\.setItem" features/{domain}/src/pages/{screen}/*.tsx -A 1
# 위 결과에 useEffect deps [stateName] 가 있으면 anti-pattern → 위반
```

### §11.5 cross-ref

- hook `localstorage-persist-pattern.md` (상세)
- 메모리: `feedback_localstorage_persist_callback_pattern`
- 사고: DMF0003 Measure persist (2026-06-07)

---

## §8 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 store 통합 분석 + G1 사양 정정 |
| 2026-06-09 | §9 createPersistedStoreWithTab 시그니처 + §10 fetchStaticColumns guard 신설 | SCM0009/SCM0005 stateCreator 사고 재발 + SCM0005 grid column 0 사고 |
| 2026-06-07 | §11 localStorage 별도 persist 패턴 + 사고 패턴 callback 직접 setItem 의무 신설 | DMF0003 Measure persist 사고 (useEffect deps 덮어쓰기) |
