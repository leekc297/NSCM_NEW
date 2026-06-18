# Hook — Grid Column Setting Popup 통합 패턴 (사용자 column 표시 설정 5 단계)

> ⭐ **신규 화면에 Grid 가 있고 사용자 column 표시 설정 기능이 필요한 경우 의무 적용 패턴**
> ColumnSettingModal (공용 popup) + Store (사용자 visible 상태 영속) + Grid (실시간 반영) + Fallback (BE 메타 미등록 시 안전망) + popup 재진입 복원 통합.

작성: 2026-06-17 (DMF0043_01 ColumnSetting popup 작업 후 — 사용자 명시 룰화 요청)
**갱신: 2026-06-18 — DMF0020 미적용 사고 발생 → 적용 의무 강도 PR 차단 강제로 격상**
관련 hook: `ui-category-setup-column-meta.md`, `ui-dynamic-property-management.md`, `column-meta-rework-checklist.md`
상위 룰: `anti-simplification.md`
Reference 화면: **DMF0043_01** (ContributeView) — 본 패턴 master 표준
적용 화면 (검증 완료): **DMF0020** (SalesFuturePrice, 2026-06-18) / **DMF0043_01** (ContributeView, 2026-06-17 master)

---

## §0-A. ⭐ DMF0020 미적용 사고 (2026-06-18 — 룰 격상 사유)

> "dmf0020 그리드 컬럼 설정 에서 컬럼 왼쪽으로 이동 후 ok 해도 grid 에 계속 column 이 남아 있어요.
> 다시 컬럼 설정 들어가면 이동했던 데이터가 남아있지 않아요."

**원인 (DMF0043_01 사고와 100% 동일 패턴)**:
- `onSave={() => { /* TODO: SCM_USR_TITLE_SET 영구 저장 */ }}` — 빈 callback. settings 사용 X → grid 미반영
- `fallbackColumns={MAIN_COLUMNS.map(c => ({ key, header, width }))}` — `visible` flag 없음 → popup 재진입 시 복원 X
- store 에 `visibleBaseColumns` state 없음
- Grid 의 `visibleColumns` filter 에 store 매칭 없음

→ DMF0043_01 master 5 단계 패턴 그대로 적용으로 해소.

**룰 강도 격상 사유**: ColumnSettingModal 공용 popup 을 import 만 하면 사용자가 동작 정상으로 오인 — 5 단계 wiring 누락 시 silent fail. PRE-WRITE grep 의무로 차단.

---

## §0. 적용 시점 (트리거)

| 트리거 | 적용 |
|---|---|
| T01 신규 화면 + Grid + "사용자 컬럼 표시 설정" / "ColumnSetting" 요구 | 5 단계 전부 적용 |
| T04 기존 화면 Grid 에 column 표시 설정 기능 추가 | 5 단계 전부 적용 |
| T06 ColumnSettingModal 공용 modal 사용 | §3 modal props 의무 + §4 store wiring |

---

## §1. 5 단계 패턴 — DMF0043_01 reference

### 1.1 Store (`useXxxStore.ts`)

`visibleBaseColumns: string[]` state + `setVisibleBaseColumns` action 의무.

```typescript
interface ContributeViewState {
  // ... existing state
  // ⭐ ColumnSettingModal OK 결과 — 사용자가 visible 로 유지한 BASE 컬럼 list.
  //   빈 array = default (모든 base 컬럼 visible) — 첫 진입 시점.
  //   값 있음 = strict mode (list 에 포함된 column 만 표시).
  //   동적 컬럼 (Y#/M#) 은 ColumnSetting 대상 아님 → 영향 없음.
  visibleBaseColumns: string[];
}

interface ContributeViewAction {
  // ... existing actions
  setVisibleBaseColumns: (names: string[]) => void;
}

const initState: ContributeViewState = {
  // ... existing init
  visibleBaseColumns: [],
};

// action 구현
setVisibleBaseColumns: names =>
  set(state => {
    state.visibleBaseColumns = names;
  }),
```

**파일 reference**: `nscm-fe/features/master/src/pages/contribute-view/useContributeViewStore.ts`

### 1.2 Screen (`XxxScreen.tsx`)

(a) title 메타 SP 별도 fetch (react-query cache dedupe — Grid 와 동일 SP 호출 시 자동 cache 공유)
(b) `fallbackColumns` 생성 시 store.visibleBaseColumns 와 매칭하여 visible flag 결정
(c) `onSave` 콜백에서 settings 받아 store 에 visible list 저장 + grid refetch

```typescript
import { BASE_COLUMN_COUNT } from './xxx.constants';

const setVisibleBaseColumns = useXxxStore(s => s.setVisibleBaseColumns);
const visibleBaseColumnsList = useXxxStore(s => s.visibleBaseColumns);

// title 메타 별도 fetch — Grid 가 동일 SP 호출 시 react-query cache 공유
const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.MAIN_TITLE>({
  menuId: MENU_ID,
  sheetName: SHEETS.MAIN_TITLE,
  tabId,
  filters: filters[SHEETS.MAIN_TITLE],
  enabled: !!filters[SHEETS.MAIN_TITLE],
});

// fallbackColumns 생성 — 동적 column 제외 (slice) + visible flag 복원
const fallbackColumns = useMemo(() => {
  const titleRows = (titleData?.o_rc1 ?? []) as Array<{
    COLUMN_NAME?: string;
    COLUMN_LABEL_NAME?: string;
  }>;
  const visibleSet =
    visibleBaseColumnsList.length > 0 ? new Set(visibleBaseColumnsList) : null;
  return titleRows
    .slice(0, BASE_COLUMN_COUNT) // ⭐ 동적 column 제외 — base 만 ColumnSetting 대상
    .filter(r => r.COLUMN_NAME && !r.COLUMN_NAME.includes('B_')) // hidden B_ pattern 제외
    .map(r => ({
      key: r.COLUMN_NAME ?? '',
      header: r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? '',
      // visibleSet null (첫 진입) → 모두 visible. 값 있음 → list 에 포함된 것만 visible.
      visible: visibleSet === null ? true : visibleSet.has(r.COLUMN_NAME ?? ''),
    }));
}, [titleData, visibleBaseColumnsList]);

// popup
<ColumnSettingModal
  open={columnSetPopupOpen}
  modalClose={() => setColumnSetPopupOpen(false)}
  menuId={MENU_ID}
  sheetName={/* SP IN 인자 sheetName 값 — admin SHEET_COLUMNS 의 SHEET_NAME */}
  columnType='C'
  divisionId={searchCondition.divisionId}
  fallbackColumns={fallbackColumns}
  onSave={settings => {
    // ColumnSettingModal 은 USER_FLAG='Y' rows (= 우측 grid = visible) 만 전달.
    // 사용자가 좌측으로 이동한 column = settings 에 미포함 → grid 에서 숨김.
    setVisibleBaseColumns(settings.map(s => s.COLUMN_NAME));
    handleColumnApply(); // refetch 등 후속 처리
  }}
/>
```

**파일 reference**: `nscm-fe/features/master/src/pages/contribute-view/ContributeView.tsx`

### 1.3 Modal (`@shared` 또는 `features/master/src/components/columnSettingModal/`)

공용 ColumnSettingModal 의 의무 prop:

| Prop | 의무 | 비고 |
|---|---|---|
| `menuId` | ✅ | SP IN 인자 `programId` 로 전달 |
| `sheetName` | ✅ | SP IN 인자 `sheetName` 으로 전달 (BE SP `DMF0002_GET_TITLESET_POPUP` 호출) |
| `columnType` | ✅ | SP IN 인자 `columnType` (보통 `'C'`) |
| `divisionId` | ✅ | SP IN 인자 `divisionId` |
| `fallbackColumns` | ✅ ⭐ | BE 결과 빈 시 안전망. **`visible?: boolean` 필드 포함** (popup 재진입 시 복원) |
| `onSave(settings)` | ✅ | USER_FLAG='Y' rows 만 콜백. `settings.map(s => s.COLUMN_NAME)` 로 visible list 추출 |

### 1.4 Grid (`XxxGrid.tsx`)

(a) store.visibleBaseColumns 사용한 baseColumns filter
(b) frozenColumns 동적 갱신 (useRef + useEffect — initialized callback 의 stale closure 회피)
(c) HeaderMergeManager 의 dynStart 도 useRef 로 사용

```typescript
const visibleBaseColumnsList = useXxxStore(s => s.visibleBaseColumns);

const baseColumns = useMemo<ColumnMeta[]>(() => {
  const all = columnMetas.filter(m => m.isBase);
  if (visibleBaseColumnsList.length === 0) return all; // 빈 array = 모두 visible
  const visibleSet = new Set(visibleBaseColumnsList);
  return all.filter(m => visibleSet.has(m.binding));
}, [columnMetas, visibleBaseColumnsList]);

// frozenColumns / dynStart 는 actual baseColumns.length 추적 (BASE_COLUMN_COUNT 상수 X).
const baseCountRef = useRef(BASE_COLUMN_COUNT);
useEffect(() => {
  baseCountRef.current = baseColumns.length;
  const g = internalRef.current;
  if (g) g.frozenColumns = baseColumns.length;
}, [baseColumns.length]);

// HeaderMergeManager 안 ↓
class HeaderMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    const dynStart = baseCountRef.current; // ⭐ 매 호출 시 최신 값
    if (panel.cellType === CellType.ColumnHeader) {
      if (c < dynStart) {
        return new CellRange(0, c, 1, c);
      }
      // ...
    }
  }
}
```

**파일 reference**: `nscm-fe/features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx`

### 1.5 ColumnSettingFallback type (공용)

```typescript
export interface ColumnSettingFallback {
  key: string;
  header: string;
  width?: number;
  // ⭐ popup 재진입 시 이전 visible 상태 복원용.
  // true (default): USER_FLAG='Y' (우측 visible grid).
  // false: USER_FLAG='N' (좌측 hidden grid).
  visible?: boolean;
}
```

**파일 reference**: `nscm-fe/features/master/src/components/columnSettingModal/ColumnSettingModal.tsx`

---

## §2. 절대 금지 (Anti-pattern)

| # | 금지 행위 | 사고 |
|---:|---|---|
| 1 | ❌ ColumnSettingModal 에 `fallbackColumns` 미전달 | BE SP 빈 결과 시 popup 빈 grid (DMF0043_01 사고) |
| 2 | ❌ 동적 column (Y#/M#) 을 ColumnSetting 대상에 포함 | 사용자가 동적 column 을 좌측으로 이동 → grid 안 보임 — 의도 위반 |
| 3 | ❌ `onSave` 콜백에서 settings 무시하고 setFilter() 만 호출 | 사용자가 좌측 이동해도 grid 에 반영 안 됨 |
| 4 | ❌ store `visibleBaseColumns` 없이 grid 에서 직접 처리 | popup 재진입 시 이전 상태 복원 불가 + 다른 컴포넌트 공유 불가 |
| 5 | ❌ Grid 의 `frozenColumns` 를 `BASE_COLUMN_COUNT` 상수로 고정 | 일부 base column 숨김 시 frozen 영역 불일치 → 가로 스크롤 영역 잘림 |
| 6 | ❌ HeaderMergeManager 의 `dynStart` 를 상수로 캡쳐 | baseColumns 변경 시 머지 범위 stale → 머지 깨짐 |
| 7 | ❌ FallBackColumns 의 `visible` flag 누락 | popup 재진입 시 항상 모두 USER_FLAG='Y' → 이전 이동 내역 손실 |
| 8 | ❌ `selectionChanged` 의 `e.row` 를 itemsSource 직접 index 로 사용 | Wijmo 가 자체 sort/filter 적용 시 stale index → selection null → button 동작 안 함 |

---

## §3. PRE-WRITE 체크리스트 (모두 ✓ 필수)

```
[ ] 1. Store 에 visibleBaseColumns: string[] state + setVisibleBaseColumns action 정의?
[ ] 2. Store initState 에 visibleBaseColumns: [] 포함?
[ ] 3. Screen 에 fallbackColumns useMemo + .slice(0, BASE_COLUMN_COUNT) 적용?
[ ] 4. fallbackColumns 의 각 row 에 visible flag (visibleSet 매칭) 결정?
[ ] 5. ColumnSettingModal 에 fallbackColumns prop 전달?
[ ] 6. onSave 콜백에서 settings.map(s => s.COLUMN_NAME) 으로 store 저장?
[ ] 7. Grid 의 baseColumns useMemo 에 visibleBaseColumnsList filter?
[ ] 8. Grid 의 frozenColumns / dynStart 가 baseCountRef.current 사용?
```

---

## §4. POST-WRITE grep 자기 점검

```bash
# 1) visibleBaseColumns store state 누락
grep -L "visibleBaseColumns" features/*/src/pages/<screen>/use*Store.ts

# 2) fallbackColumns 의 visible flag 누락
grep -nE "fallbackColumns\s*=\s*useMemo" features/*/src/pages/<screen>/*.tsx | \
  xargs grep -L "visible:"

# 3) onSave 의 settings 미사용 (단순 refetch 만)
grep -A 3 "onSave={" features/*/src/pages/<screen>/*.tsx | grep -v "setVisibleBaseColumns"

# 4) Grid 의 frozenColumns 가 상수 BASE_COLUMN_COUNT 그대로 사용
grep -nE "g\.frozenColumns\s*=\s*BASE_COLUMN_COUNT" features/*/src/pages/<screen>/components/*Grid.tsx

# 5) selectionChanged 의 e.row 직접 index (panel.rows[e.row].dataItem 미사용)
grep -nE "selectionChanged.*\{.*setUserSel\(userRows\[e\.row\]" \
  packages/*/src/components/**/*.tsx features/*/src/components/**/*.tsx
```

→ 결과 0 row 가 기대값.

---

## §5. 사고 사례 — DMF0043_01 (2026-06-17)

| 단계 | 사고 | fix |
|---|---|---|
| 1차 | popup 데이터 빈 grid | `fallbackColumns` prop 미전달 → `ContributeView` 에서 titleData 별도 fetch 후 전달 |
| 2차 | 동적 column 까지 popup 에 표시 | `.slice(0, BASE_COLUMN_COUNT)` 적용 |
| 3차 | 우측→좌측 이동 button 무동작 | `selectionChanged` 에서 `panel.rows[e.row].dataItem` 직접 추출로 변경 |
| 4차 | OK 클릭 시 grid 미반영 | `onSave` 콜백에서 `setVisibleBaseColumns(settings.map(s => s.COLUMN_NAME))` 호출 + Grid `baseColumns` filter + `frozenColumns` 동적 갱신 |
| 5차 | popup 재진입 시 이전 이동 내역 손실 | `ColumnSettingFallback` 에 `visible?: boolean` 추가 + `fallbackColumns` 생성 시 visibleSet 매칭 |

---

## §6. Cross-ref

### Reference 코드 위치 (DMF0043_01 master)

| 파일 | 핵심 부분 |
|---|---|
| `useContributeViewStore.ts` | visibleBaseColumns state + setVisibleBaseColumns action |
| `ContributeView.tsx` | fallbackColumns useMemo + ColumnSettingModal 호출 |
| `ContributeViewGrid.tsx` | baseColumns useMemo + baseCountRef + HeaderMergeManager dynStart |
| `ColumnSettingModal.tsx` | ColumnSettingFallback interface + initialRows fallback 처리 + selectionChanged |

### 관련 hook

- `ui-dynamic-property-management.md` §4 (Column 동적 fetch — 본 hook 의 상위 master)
- `ui-category-setup-column-meta.md` (admin SCM_MST_SHEET_COLUMNS 동적 fetch 의무)
- `column-meta-rework-checklist.md` (기존 화면 column 재작업 시)
- `sheet-columns-binding-match.md` (BE 응답 alias ↔ FE binding 매칭)
- `runtime-error-prevention.md` (FlexGrid 사용 시 사고 차단)
- `wijmo-flexgrid-entry.md` (Wijmo FlexGrid 작업 진입)

### 관련 메모리

- `feedback_admin_meta_dynamic_fetch.md` (UI Category Setup column 동적 fetch 의무)
- `feedback_grid_no_hardcoded_static_columns.md` (staticColumns 하드코딩 금지)
- `feedback_fe_grid_visible_no_fallback_loss.md` (BE visible='N' row 미리 제거 정책)

---

## §7. 사용자 명시 (2026-06-17)

> "grid column setting 은 dmf0043_01에 적용된 형태로 항상 기능 적용할 수 있도록 rule 적용 요청 합니다."

→ DMF0043_01 의 5 단계 패턴이 신규 화면 Grid + ColumnSetting popup 의 master 표준. 본 hook 이 그 정형화.

위반 시 PR 머지 차단 + 사고 사례 §5 재발 가능 → 즉시 fix 의무.
