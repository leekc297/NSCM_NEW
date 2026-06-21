# Hook — Screen Additional Skills (DMF0004/0005/0006 cross-check 누락 보강)

> **Trigger**: T01 (신규 화면 / 화면 수정)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #26, 사용자 명시 — "DMF0004/0005/0006 사용 skill 중 룰 누락 cross-check 추가")
> **세트 hook**: #60 (Grid) + #61 (Shell) + #62 (Regression Zero) + #63 (Conventions) + #64 (Buttons) + **#65 (Additional Skills, 본 hook)**

## 0. 원칙

DMF0004/0005/0006 cross-check 결과 누락 발견된 9 skill 모두 신규 화면에서 동일하게 적용.

---

## 1. `useTranslation()` 자동 inject (eslint config / vite plugin)

```tsx
export const Xxx = (...) => {
  const { t } = useTranslation();    // ⭐ import 없이 자동 사용
  return <FormItem label={t('LBL00001', '_Div.')} ... />;
};
```

### 1.1 의무 / 금지

| 항목 | 정책 |
|---|---|
| `import { useTranslation } from 'react-i18next'` 직접 작성 | ⛔ **금지** — auto-inject 되어 lint warning |
| `const { t } = useTranslation()` 본문 사용 | ✅ 의무 |
| `t('LBL00001', '_Div.')` 2 인자 형식 | ✅ 의무 (key + fallback) |
| `i18next.t(...)` 글로벌 호출 | ⛔ 금지 — hook 형태만 |

> 검증: `grep -nE "from 'react-i18next'" features/{screen}/` = 0

---

## 2. `clsx` 다중 className 조합 (`@shared/clsx`)

```tsx
import { clsx } from '@shared/clsx';

<InputField className={clsx(styles.inputWithSearch, styles.input)} />
```

### 2.1 의무 사항
- 2 이상 className 조합 시 `clsx` 사용 의무 — 직접 string concatenation (`${A} ${B}`) 금지
- import 경로: **`@shared/clsx`** (NSCM alias) — `clsx` 패키지 직접 import 금지
- 조건부 className: `clsx(styles.A, isActive && styles.B)` 표준

---

## 3. Store immer set state + atomic selector

### 3.1 immer draft mutate 패턴 (DMF0004/0005/0006 표준)

```ts
// ✅ 의무 — set(state => { ... }) 안에서 state 직접 mutate (immer draft)
setSearchParams: searchParams => {
  set(state => {
    state.searchParams = { ...get().searchParams, ...searchParams };
    if (searchParams.divisionId) {
      void state.fetchStaticColumns();
      state.filters = initState.filters;
    }
  });
},

// ❌ 금지 — set({ ... }) 즉시 객체 교체 (createPersistedStoreWithTab 는 immer 적용 중)
setSearchParams: searchParams => {
  set({ searchParams: { ...get().searchParams, ...searchParams } });
},
```

### 3.2 atomic selector 패턴 (객체 selector 금지)

```tsx
// ✅ 의무 — selector 하나당 atomic 1 항목
const searchParams = useXxxStore(state => state.searchParams);
const setSearchParams = useXxxStore(state => state.setSearchParams);
const filters = useXxxStore(state => state.filters);

// ❌ 금지 — 객체 selector → 매 render 마다 새 객체 → re-render 폭증
const { searchParams, setSearchParams, filters } = useXxxStore(state => ({
  searchParams: state.searchParams,
  setSearchParams: state.setSearchParams,
  filters: state.filters,
}));
```

---

## 4. `storageName` = 폴더명 (createPersistedStoreWithTab 2 인자)

```ts
export const useSalesSiteStore = createPersistedStoreWithTab<...>(
  (set, get) => ({ ... }),
  'sales-site'   // ⭐ 폴더명 = storageName (kebab-case)
);
```

| 화면 | 폴더 | storageName |
|---|---|---|
| DMF0004 | `sales-site` | `'sales-site'` |
| DMF0005 | `sales-site-project-model` | (해당) |
| DMF0006 | `customer-model-mapping` | `'customer-model-mapping'` |

- sessionStorage key = `${storageName}` → 다른 화면과 충돌 0
- 폴더명 ↔ storageName 1:1 의무

---

## 5. `InputField` Popup trigger — 2 가지 패턴

### 5.1 endAdornment Button (DMF0005 SalesSiteProjectModelForm 표준)

```tsx
<InputField
  fullWidth
  value={searchParams.projectCode}
  InputProps={{
    endAdornment: (
      <Button appearance='outlined' priority='normal'
        iconComponent={
          <FunctionSearchIcon appearance='lined'
            onClick={() => setOpenProjectModal(true)} />
        } />
    ),
  }}
  onChange={e => setSearchParams({ projectCode: e.target.value })}
/>
```

### 5.2 onDoubleClick (DMF0006 CustomerModelMappingForm 보강 표준)

```tsx
<InputField
  fullWidth
  value={searchParams.projectCode}
  InputProps={{ endAdornment: <Button ... onClick={() => setOpenProjectModal(true)} /> }}
  onChange={e => setSearchParams({ projectCode: e.target.value })}
  onDoubleClick={() => setOpenProjectModal(true)}   // ⭐ 더블클릭으로도 popup 호출
/>
```

> **표준**: 둘 다 적용. 사용자 UX 향상 — 검색 아이콘 클릭 OR 입력 필드 더블클릭 둘 다 popup 호출.

---

## 6. `preSearchParams` 동적 매핑 — Form 호출 vs Grid Cell 호출

### 6.1 Form 호출 (`{ ...searchParams }` 단순 spread, DMF0005/0006 Form)
```tsx
<ProjectByDivisionModal
  open={openProjectModal}
  modalClose={() => setOpenProjectModal(false)}
  setSelectedValue={(projects) => setSearchParams({ projectCode: projects })}
  preSearchParams={{ ...searchParams }}   // ⭐ Form 의 현재 searchParams 그대로
  callFromCell={false}
/>
```

### 6.2 Grid Cell 호출 (clickedDataItem 값 매핑, DMF0006 Grid 표준)
```tsx
const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

<ProjectByDivisionModal
  open={openPrjByDivisionModal}
  modalClose={() => setOpenPrjByDivisionModal(false)}
  setSelectedValue={(projects, projectsNames) => handleProjectSelected(projects, projectsNames)}
  preSearchParams={{                       // ⭐ row 값으로 동적 구성
    divisionId: clickedDataItem?.DIVISION_ID,
    deptId: clickedDataItem?.DEPT_ID || 'ALL',         // ← 빈 값 'ALL' fallback
    endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
    salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
    projectCode: clickedDataItem?.PROJECT_CODE,
  }}
  callFromCell={false}                     // 또는 true (의미상 cell 호출이면)
/>
```

### 6.3 의무
- Form 호출: `{ ...searchParams }` 한 줄
- Grid Cell 호출: `clickedDataItem?.X || 'ALL'` 빈 값 fallback + popup 가 받는 6 필드 명시 매핑
- Grid 셀 값 매핑 시 `clickedDataItem` 을 `useState clickedRow` 와 `GridUtils.getRow` 로 동기 추출

---

## 7. Cell `cellEditEnded` validation guard (DMF0006 `handleNegativeGuard` master)

특정 컬럼에 값 입력 후 자동 보정 (음수 → 0, 대문자 변환 등):

```tsx
import { CellType, type CellRangeEventArgs } from '@mescius/wijmo.grid';

// ⭐ AS-IS reference 주석 의무 (#63 §4)
// AS-IS DMF0006_CustomerModelMapping.cs L1147~1156:
//   CONVERT_QTY_CELL / CONVERT_QTY_MODULE / CONVERT_QTY_PACK 음수 입력 시 "0" 보정.
const handleNegativeGuard = (
  grid: FlexGrid<ResponseData<MENU_ID, SHEETS.X>>,
  cellRangeEventArgs: CellRangeEventArgs
) => {
  if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[cellRangeEventArgs.col]?.binding;
  if (!['CONVERT_QTY_CELL', 'CONVERT_QTY_MODULE', 'CONVERT_QTY_PACK'].includes(binding ?? '')) return;

  const dataItem = GridUtils.getRow(grid, cellRangeEventArgs.row);
  if (!dataItem) return;

  const raw = (dataItem as Record<string, unknown>)[binding];
  const value = Number(raw ?? 0);
  if (value >= 0) return;

  editTrackerRef.current?.storeChange(dataItem, binding, raw, 0);   // ⭐ storeChange 의무
  (dataItem as Record<string, unknown>)[binding] = 0;
  grid.refreshRange(new CellRange(
    cellRangeEventArgs.row, cellRangeEventArgs.col,
    cellRangeEventArgs.row, cellRangeEventArgs.col
  ));
};

// DataGrid 주입
<DataGrid<...>
  ...
  cellEditEnded={handleNegativeGuard}
/>
```

### 7.1 의무
- AS-IS reference 주석 (`.cs` 파일 + line 번호 + 변환 의미)
- `panel.cellType !== CellType.Cell` early return
- 특정 binding 매칭 early return
- `editTracker.storeChange` 의무 (#63 §4)
- `dataItem[binding] = value` 직접 할당
- `grid.refreshRange(new CellRange(row, col, row, col))` 단일 셀 refresh

---

## 8. 화면 의미별 `activeFlag` default 분기

| 화면 의미 | default | 예 |
|---|---|---|
| 전체 조회 / 마스터 화면 | `'ALL'` | DMF0004 SalesSite, DMF0005 SalesSiteProjectModel |
| Active row 만 default 표시 | `'Y'` | DMF0006 CustomerModelMapping |
| Pending row 만 (특수) | `'P'` | (해당 시) |

```ts
const initSearchParams: SearchParamProps = {
  ...,
  activeFlag: 'ALL',  // 또는 'Y' — 화면 의미에 따라
};
```

> 화면 작성 직전 AS-IS .cs 의 초기 query 분석으로 default 결정 의무. 임의 'ALL' 채택 금지.

---

## 9. 단일 sheet 화면의 `filters?: ProcRequest<MENU_ID, SHEETS>` (DMF0006 패턴)

다중 sheet:
```ts
type filtersBySheet = { [key in SHEETS]?: ProcRequest<MENU_ID, key> };
filters: filtersBySheet;
```

단일 sheet:
```ts
filters?: ProcRequest<MENU_ID, SHEETS>;   // ⭐ optional + SHEETS 인자 1 (enum 전체 유니온)

// 사용
const { data } = useTabProcQuery<MENU_ID>({   // ⭐ 제네릭 인자 1
  menuId, sheetName: SHEETS.X, tabId, filters, enabled: !!filters
});
const rows = data?.o_rc1 ?? [];   // RESPONSE_SET.DATA = 'o_rc1'
```

> 단일 sheet 화면에서 `filtersBySheet` 패턴 적용 시 over-engineering — DMF0006 패턴 권장.

---

## 10. `dblClick` editable cell guard 패턴 (DMF0006 표준)

```tsx
const handleDblclick = (mouseEvent: MouseEvent) => {
  const grid = gridRef.current;
  if (!grid) return;
  const ht = grid.hitTest(mouseEvent);
  const editable = GridUtils.isEditableCell(grid, ht.row, ht.col);   // ⭐ editable 확인 의무
  if (!editable) return;   // ← 편집 불가 cell 에서 popup 안 열기

  const binding = GridUtils.getBinding(grid, ht.col);
  const dataItem = GridUtils.getRow(grid, ht.row);
  if (!dataItem) return;

  if (binding === 'PROJECT_CODE') {
    setClickedRow(ht.row);
    setOpenPrjModal(true);
  } else if (...) { ... }
};
```

### 10.1 의무 사항
- `GridUtils.isEditableCell(grid, row, col)` early return (편집 불가 cell 무시)
- binding 다중 분기 시 if-else if 명시 — switch case 사용도 허용
- `setClickedRow(ht.row) + setOpenModal(true)` 2 set 순서 의무 (#63 §7)
- DMF0004 SalesSite 패턴은 `CRUD_TYPE === INSERT` 분기 우선 — DMF0006 은 `isEditableCell` 만 (read-only 셀 자동 차단)

---

## 11. `error: string | null` Store state (DMF0004 표준)

```ts
interface XxxState {
  initialized: boolean;
  loading: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: { [k in RESPONSE_SET]: RawFlexGridColumnConfig[] };
  openSearchArea: boolean;
  error: string | null;   // ⭐ 표준 (DMF0004 master)
}
```

- BE 에러 캐치 시 `state.error = errorMsg` set
- 화면 진입 시 error 표시는 useMessageStore.setAlert 사용 (직접 표시 금지)

---

## 12. `as const` + global `as RawFlexGridColumnConfig[]` 캐스팅 패턴

```ts
const initState: XxxState = { ... } as const;   // ✅ readonly literal narrowing

// SP 응답 → RawFlexGridColumnConfig[] 변환
const result = await apiClient.post<RawFlexGridColumnConfig[]>(
  `/admin/menu/${MENU_ID}/column`,
  { sheetNm: ... }
);
state.staticColumn = result.data.result;   // ⭐ 별도 cast 불필요 (apiClient 제네릭 자동)
```

- `as const` = const assertion (readonly literal type 보존)
- `as Type` 명시 캐스팅은 `apiClient<T>` 제네릭 누락 시에만 — 가능하면 제네릭으로 처리

---

## 13. 추가 PRE-WRITE 체크리스트 (9 항목)

```
[ ] 1.  useTranslation auto-inject — `import from 'react-i18next'` 0?
[ ] 2.  clsx 다중 className → @shared/clsx 의 clsx 사용?
[ ] 3.  immer draft mutate (`set(state => { state.X = ... })`) — 즉시 객체 교체 0?
[ ] 4.  store atomic selector (selector 1 항목) — 객체 selector 0?
[ ] 5.  createPersistedStoreWithTab 2 인자 storageName = 폴더명 (kebab-case)?
[ ] 6.  InputField popup trigger — endAdornment Button + onDoubleClick 둘 다 적용?
[ ] 7.  preSearchParams — Form 호출 spread / Grid Cell 호출 동적 매핑 분기?
[ ] 8.  특정 cell 값 보정 시 cellEditEnded handler + AS-IS reference 주석?
[ ] 9.  화면 의미별 activeFlag default ('ALL' vs 'Y') AS-IS .cs 분석 후 결정?
```

---

## 14. POST-WRITE grep (작성 직후 의무)

```bash
SCREEN="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. react-i18next 직접 import
grep -nE "from 'react-i18next'" "$SCREEN"
# 결과 = 0

# 2. clsx 직접 import (NSCM alias 사용 의무)
grep -nE "from 'clsx'" "$SCREEN"
# 결과 = 0 — `from '@shared/clsx'` 만

# 3. immer 안티 패턴 (set({...}) 즉시 객체 교체)
grep -nE "set\\(\\{" "$SCREEN/use*Store.ts"
# 결과 = 0 — set(state => { ... }) 만

# 4. 객체 selector
grep -nE "useState =>.*\\(\\{$" "$SCREEN" | head
# 결과 = 0 — atomic selector 만

# 5. storageName 누락 검출
grep -nE "createPersistedStoreWithTab.*,\\s*'[a-z][a-z-]+'\\)" "$SCREEN/use*Store.ts"
# 결과 ≥ 1 (kebab-case)
```

---

## 15. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 대체 |
|---:|---|---|
| 1 | `import { useTranslation } from 'react-i18next'` 직접 | auto-inject 사용 (lint warning) |
| 2 | `import { clsx } from 'clsx'` 직접 | `from '@shared/clsx'` |
| 3 | `set({ searchParams: {...} })` 즉시 객체 교체 | `set(state => { state.searchParams = ... })` immer draft |
| 4 | `useXxxStore(state => ({ a: state.a, b: state.b }))` 객체 selector | atomic selector 각 항목 분리 |
| 5 | `createPersistedStoreWithTab(creator)` 인자 1 (storageName 누락) | 2 인자 + kebab-case storageName |
| 6 | `<InputField>` popup 없이 단독 사용 | endAdornment Button + onDoubleClick 둘 다 |
| 7 | Grid Cell 호출 `preSearchParams={{ ...searchParams }}` (Form 패턴 잘못 적용) | clickedDataItem 값 매핑 + 'ALL' fallback |
| 8 | cell 값 보정 없이 SAVE 시 BE validation 위반 | cellEditEnded validation guard + storeChange |
| 9 | `activeFlag: 'ALL'` 무조건 — AS-IS 화면 의미 미반영 | .cs 초기 query 분석 후 'ALL' / 'Y' 결정 |
| 10 | 단일 sheet 화면에 `filtersBySheet` 패턴 | `filters?: ProcRequest<MENU_ID, SHEETS>` 단순 패턴 |
| 11 | `isEditableCell` guard 없이 read-only cell 에서 modal 열림 | `if (!editable) return;` 우선 분기 |
| 12 | `error: string \| null` state 누락 | DMF0004 master 표준 적용 |

---

## 16. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Page Shell + Form + Hook + Store | hook `screen-shell-composition-mandatory.md` (#61) |
| 폴더 구조 / 명명 / Conventions | hook `screen-conventions-mandatory.md` (#63) |
| Grid 영역 + Cell→Popup 4 단계 | hook `datagrid-shared-component-mandatory.md` (#60) + `screen-conventions-mandatory.md` (#63) §7 |
| SubTitle 공통 버튼 | hook `subtitle-button-actions-mandatory.md` (#64) |
| Type/Lint 0 + Hard Boundary | hook `regression-zero-mandatory.md` (#62) |
| FE Import 인벤토리 | `fe-import-check.md` (auto-attach) |
| SearchArea extraConditions | hook `search-area-extra-conditions.md` |
| Cascade Combo Filter | hook `cascade-combo-filter.md` (#59) |
| Master reference 경로 | `nscm-fe/features/master/src/pages/{sales-site, sales-site-project-model, customer-model-mapping}/` |
| 메모리 (i18n LBL / SHEETS / 'IM' / MNU_URL) | hook #63 §18 |

---

## 17. 검증 — PR 차단 강도

§13 PRE-WRITE 9 + §14 POST-WRITE grep 5 + §15 안티패턴 12 모두 PR 차단.
사용자 결정 (2026-06-18 cross-check 보강 요청).
