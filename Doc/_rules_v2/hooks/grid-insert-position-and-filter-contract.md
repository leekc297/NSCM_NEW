# Hook #144 — 그리드 신규행 Insert 위치 · 컬럼 필터 규약

> 신설 2026-08-22 (사용자 제시 규약). 계기 = DMF0044(sales-reports) · DMF0049(etc-sales-reports)
> 2026-08-21~22 신고 3건. **AI 로 생산한 화면에서 같은 형태로 반복**되고 있어 규칙으로 묶는다.
>
> 적용 범위: **행 Insert 또는 컬럼 필터를 쓰는 모든 그리드 화면**. 카테고리 = `03_grid_column_meta`.
> 짝 룰: [[grid-insert-and-modal-derived-parity]](#143 — Insert **데이터** 복사·모달 파생) ·
> [[wijmo-merge-row-data-only]](#141 — 병합 판정) · hook #133 `COMMON:UC-01`(Insert 시 필터 유지).
> #143 이 "새 행에 **무엇을 담나**" 라면 본 룰은 "새 행이 **어디에 놓이고 어떻게 보이나**" 다.

---

## §0. 증상 → 원인 → 조항

| 증상 | 원인 | 조항 |
|---|---|---|
| Insert 한 행이 포커스 행 위가 아니라 **맨 첫줄**에 생긴다 | 신규행을 배열 맨 앞에 붙임 — 위치 개념이 없음 | §1 |
| 필터를 걸고 Insert 하면 **필터가 풀린다** | 화면이 `FlexGridFilter` 를 직접 만들어 `DataGrid` 보존 장치가 무력화 | §2 |
| 필터를 유지시키면 이번엔 **신규행이 안 보인다** | 값이 빈 신규행이 필터 조건에 걸림 | §3 |

세 증상은 한 덩어리다. §2 만 고치면 §3 이 터지고, §3 만 고치면 §2 가 남는다.

---

## §1. Insert 위치 — 포커스 행이 속한 **세트 바로 위**

AS-IS `InsertRow` 는 `SetActiveCell(세트 첫 행)` → `Insert(n)` 이라 신규 세트가 **포커스 행이 속한
세트 바로 위**에 들어간다 (DMF0044 `.cs:931~933`, DMF0049 `.cs:890~892`). **맨 위가 아니다.**

### 나쁜 예 — 위치 개념이 없다

```tsx
const [insertedRows, setInsertedRows] = useState<Row[]>([]);
const rows = useMemo(() => [...insertedRows, ...spRows], [insertedRows, spRows]);

const handleInsert = () => {
  setInsertedRows(prev => [...block, ...prev]);   // 언제나 맨 첫줄
};
```

### 좋은 예 — 블록마다 anchor 를 들고, 화면 행은 매번 계산한다

```tsx
// anchor = "이 SP 행 바로 앞에 붙는다". null = 맨 위.
interface InsertBlock { gid: string; anchor: Row | null; rows: Row[] }
const [insertBlocks, setInsertBlocks] = useState<InsertBlock[]>([]);

const rows = useMemo<Row[]>(() => {
  if (insertBlocks.length === 0) return spRows;
  const spSet = new Set(spRows);
  const byAnchor = new Map<Row | null, Row[]>();
  insertBlocks.forEach(b => {
    // anchor 가 사라진 블록(재조회 직전 등)은 맨 위로 — 조용히 증발하지 않게 한다
    const key = b.anchor && spSet.has(b.anchor) ? b.anchor : null;
    byAnchor.set(key, [...(byAnchor.get(key) ?? []), ...b.rows]);
  });
  const out: Row[] = [...(byAnchor.get(null) ?? [])];
  spRows.forEach(r => {
    const ins = byAnchor.get(r);
    if (ins) out.push(...ins);
    out.push(r);
  });
  return out;
}, [spRows, insertBlocks]);

// 포커스 행 — 병합 셀은 블록 top 이 선택되므로 그 행이 곧 세트 대표다
const focusedRow = (): Row | undefined => {
  const g = gridRef.current;
  const r = g?.selection?.row ?? -1;
  if (!g || r < 0) return undefined;
  return g.rows[r]?.dataItem as Row | undefined;
};

const handleInsert = () => {
  const target = focusedRow();

  // 포커스가 이미 pending 신규 블록이면 그 블록과 같은 자리에서 바로 앞에 끼운다
  if (target?.CRUD_TYPE === 'I') {
    setInsertBlocks(prev => {
      const i = prev.findIndex(b => b.rows.includes(target));
      if (i < 0) return [...prev, { gid, anchor: null, rows: block }];
      return [...prev.slice(0, i), { gid, anchor: prev[i].anchor, rows: block }, ...prev.slice(i)];
    });
    return;
  }

  // 세트 중간 행을 찍었어도 세트 머리로 올린다
  const anchor = spRows[setHeadIndexOf(spRows, target, setKeys)] ?? null;
  setInsertBlocks(prev => [...prev, { gid, anchor, rows: block }]);
};
```

`setHeadIndexOf` 는 세트키 맵으로 위쪽을 훑어 세트 머리 index 를 돌려준다.

```ts
export const setHeadIndexOf = (rows, focused, setKeys): number => {
  if (!focused) return 0;                       // 포커스 없음 = 맨 위
  const idx = rows.indexOf(focused);
  if (idx < 0) return 0;
  const key = setKeys?.get(focused);
  if (!key) return idx;                         // 세트키를 모르면 그 행 위에 그대로
  let head = idx;
  while (head > 0 && setKeys?.get(rows[head - 1]) === key) head--;
  return head;
};
```

### 금지

- `setInsertedRows(prev => [...block, ...prev])` — "맨 첫줄에 추가" 의 직접 원인이다.
- anchor 를 **행 인덱스(숫자)** 로 들기. 다른 Insert·재조회로 인덱스가 밀리면 엉뚱한 자리에 들어간다.
  **행 객체 참조**로 든다(위 `byAnchor` 가 Map 키로 객체를 쓰는 이유).
- 합쳐진 행 배열(SP 결과 + 신규행)을 `useState` 로 들기. 재조회가 캐시 히트면 `data` identity 가
  그대로라 동기화 effect 가 돌지 않아 **그리드가 빈 채로 남는다**(division A→B→A + Search 로 재현).
  `spRows` 와 `insertBlocks` 로 **매 렌더 계산**한다.
- 포커스 행을 `g.selectedItems[0]` 로 잡기. 병합 셀에서는 기대와 다르게 잡힌다 —
  `g.rows[g.selection.row].dataItem` 을 쓴다.

### 세부

- 세트(2행 Measure 블록 등) **중간 행**을 찍었어도 세트 머리로 올려야 한다. 안 그러면 신규 세트가
  기존 세트 사이에 낀다.
- 포커스가 없으면(`selection.row < 0`) anchor = null = 맨 위. **정상 동작이지 버그가 아니다.**
- 재조회하면 `setInsertBlocks([])` 로 pending 신규행을 버린다(EditTracker `clearChanges()` 와 한 쌍).

---

## §2. `FlexGridFilter` 는 화면이 만들지 않는다

`gridFilterRef` 를 **`DataGrid` 에 넘겨** 공용 컴포넌트가 만들게 하고, 화면은 그 인스턴스에
핸들러만 붙인다.

```tsx
// 나쁜 예 — 화면 effect 가 직접 만들고, DataGrid 에는 안 넘긴다
useEffect(() => {
  let f = gridFilterRef.current;
  if (!f || f.grid !== g) {
    f = new FlexGridFilter(g);          // 이 필터를 DataGrid 는 모른다
    gridFilterRef.current = f;
  }
  f.filterChanging.addHandler(onFilterChanging);
  return () => f.filterChanging.removeHandler(onFilterChanging);
}, [...]);

<DataGrid gridRef={gridRef} ... />      // gridFilterRef 누락
```

```tsx
// 좋은 예 — 생성은 DataGrid, 화면은 핸들러만
<DataGrid gridRef={gridRef} gridFilterRef={gridFilterRef} ... />

useEffect(() => {
  const f = gridFilterRef.current;
  if (!f) return;
  f.filterChanging.addHandler(onFilterChanging);
  return () => f.filterChanging.removeHandler(onFilterChanging);
}, [...]);
```

기존 화면의 `if (!f || f.grid !== g) { ...create... }` 가드는 **그대로 둬도 된다** —
`DataGrid` 가 먼저 만들어 넣으므로 `f.grid === g` 가 되어 재생성 분기를 타지 않는다.

### 이유 — 등록 순서가 계약이다 (실코드 확인)

wijmo `FlexGridFilter` 는 **생성자에서** `grid.itemsSourceChanged` 에 자기 `clear()` 를 건다
(`node_modules/@mescius/wijmo.grid.filter` — `itemsSourceChanged.addHandler(this.clear.bind(this))` 실측).
Insert 는 `rows` 를 새 배열로 만들어 `itemsSource` 를 갈아끼우므로 매번 이 `clear()` 가 돈다
(조회·신규행 Delete 도 같다).

공용 `DataGrid.handleInitialized` 는 이걸 막으려고 세 핸들러를 **이 순서로** 건다
(`packages/shared/src/components/organisms/data-grid/DataGrid.tsx:536~556` 실측).

1. `captureGridFilter` — 비우기 **전에** `filterDefinition` 을 떠 둔다 (`:538`)
2. `new FlexGridFilter(...)` — 여기서 wijmo 의 `clear` 가 등록된다 (`:543`)
3. `restoreGridFilter` — 비워진 직후 새 데이터 위에 되돌린다 (`:553`)

Wijmo `Event` 는 등록 순서대로 호출되므로 `(1) capture → (2) clear → (3) restore` 여야 성립한다.
그런데 `handleInitialized` 는 wijmo 컨트롤 생성 시점(= 화면 `useEffect` 보다 먼저)에 돈다.
화면 effect 에서 만든 필터의 `clear` 는 `restore` **뒤에** 붙는다.

```
capture(no-op)  ->  restore(no-op)  ->  clear      = 필터가 풀린 채 남는다
```

게다가 `gridFilterRef` 를 안 넘기면 `getGridFilter()` 가 항상 `undefined` 라 capture/restore 는
애초에 아무것도 하지 않는다 — `getGridFilter = () => gridFilterRef?.current ?? internalFilterRef.current`
이고 `internalFilterRef` 는 **`scopeId !== null`(팝업)일 때만** 채워지므로, 메인 화면은 내부 생성
분기도 타지 않는다 (`DataGrid.tsx:536·:547` 실측).

`DataGrid` 안에서 필터를 "찾아내는" 식으로는 못 고친다. 찾아내도 `clear` 가 마지막에 등록된 사실은
그대로라 복원이 다시 지워진다. **생성 시점을 `DataGrid` 로 옮기는 것이 유일한 처방이다.**

### 함께 살아나는 것

`DataGrid` 가 필터를 알아야만 동작한다. 지금까지 조용히 죽어 있었다.

- 우클릭 컨텍스트 메뉴의 Filter 항목 — `getFilter()` 가 `undefined` 면 무동작 (`DataGrid.tsx:652`)
- `updatedLayout` 의 `rebindFilterColumns` — `columnGroups` 재대입으로 끊어진 필터 복구 (`:686`)
  (증상: 헤더 필터 아이콘은 꺼졌는데 행은 계속 걸러진 상태 / Clear 를 눌러도 안 풀림)
- 팝업(다이얼로그) 안 그리드의 F3(Sort) / F4(Filter)

---

## §3. 필터 상태의 Insert — 신규행을 필터 예외로 등록한다

필터를 유지시키면 이번엔 값이 빈 신규행이 필터 조건에 걸려 화면에서 사라진다.
`keepRowVisibleUnderFilter` 로 wijmo 예외집합(`_newAddedRowsSet`)에 등록한다.

```tsx
import { keepRowVisibleUnderFilter } from '@foundation/utils';

useEffect(() => {
  const g = gridRef.current;
  if (!g || g.columns.length === 0) return;   // 컬럼 0개에서 refresh 하면 wijmo 가 예외를 던진다
  const inserted = rows.filter(r => r.CRUD_TYPE === 'I');
  if (inserted.length === 0) return;
  inserted.forEach(r => keepRowVisibleUnderFilter(g, r));
  g.collectionView?.refresh();
}, [rows, gridRef]);
```

### 순서 의무

`FlexGridFilter.apply()` 는 `this.excludedRowsSet = null` 로 예외집합을 통째로 비운다.
필터 복원(`set filterDefinition`)도 내부에서 `apply()` 를 부른다.
그래서 등록은 **`itemsSource` 교체(= 필터 복원)가 끝난 뒤**여야 한다 — React effect(렌더 이후)가 그 시점이다.

### ⭐ 등록은 **두 곳**이 필요하다 (2026-08-22 실사고 — DMF0082)

`data` 변경 effect 하나만으로는 부족하다. **필터를 걸거나 바꾸는 행위는 `data` 를 바꾸지 않기 때문**이다.

wijmo 실측 (`@mescius/wijmo.grid.filter`):

```js
apply() { … this.excludedRowsSet = null; e.filter = this._filter.bind(this); … this.onFilterApplied() }

_filter(e) {
  const t = this.excludedRowsSet;
  if (!this.reApplyFilterOnUpdate && t.has(e)) return true;   // ← 예외 통과 지점
  …
}
```

· `apply()` 는 예외집합을 **비운 뒤** `filterApplied` 를 낸다 → 핸들러가 도는 시점엔 등록분이 이미 전멸이다.
· `reApplyFilterOnUpdate` 기본값은 `false`(`_includeUpdatedRowsInFilter=!1`) 라 예외집합 자체는 유효하다 —
  이 값을 `true` 로 켜면 예외가 통째로 무시되므로 **켜지 말 것**.

⇒ 등록 지점은 둘이다.

| 시점 | 트리거 | 이유 |
|---|---|---|
| ① 행 추가 | `data`(행 배열) 변경 effect | `itemsSource` 교체로 필터가 복원된 **뒤** 등록 |
| ② 필터 적용/변경 | `filterApplied` 핸들러 | `apply()` 가 방금 비운 예외집합을 **다시 채운다** |

②의 `refresh()` 는 **반드시 다음 틱**(`queueMicrotask`)에 부른다 — `apply()` 스택 안에서 동기로 부르면
재진입이 되어 wijmo 내부 인덱스가 어긋난다. `refresh()` 는 `apply()` 를 부르지 않으므로 무한루프는 없다.

### 금지

- 신규행을 보이게 하려고 필터를 `clear()` 하는 코드 — 사용자가 건 필터가 풀린다
- `handleInsert` 안에서 동기로 부르는 `keepRowVisibleUnderFilter` — 뒤이은 복원에 지워진다
- `filterApplied` 안에서 **동기** `refresh()` — `apply()` 재진입
- `reApplyFilterOnUpdate = true` — 예외집합 자체가 무력화된다
- ②를 생략하고 ①만 두기 — "필터 후 Insert" 는 되는데 "Insert 후 필터 변경" 에서 행이 사라진다

---

## §4. POST-WRITE 게이트 (Insert·필터 보유 그리드 화면 종료 선언 전)

| # | 점검 | FAIL 시 |
|---|---|---|
| G-P1 | `[...block, ...prev]` / `[...insertedRows, ...spRows]` 형 **맨앞 삽입 0건** | 종료 선언 금지 |
| G-P2 | anchor 를 **행 객체 참조**로 보유 (숫자 인덱스 ⛔) | 동 |
| G-P3 | 화면 행 배열이 `useMemo` 계산 (합친 배열 `useState` 보유 ⛔) | 동 |
| G-P4 | 포커스 행을 `g.rows[g.selection.row].dataItem` 로 취득 (`selectedItems[0]` ⛔) | 동 |
| G-F1 | `gridFilterRef` 를 **`<DataGrid>` 에 전달** | 동 |
| G-F2 | 필터 보유 화면에서 Insert 후 필터 유지 **실화면 확인** | 동 |
| G-F3 | 신규행이 필터 상태에서 **보이는지** 실화면 확인 (`keepRowVisibleUnderFilter` 소비) | 동 |

### grep / 감사 스크립트

```bash
# G-P1
grep -rn "\.\.\.insertedRows, \.\.\.\|\[\.\.\.block, \.\.\.prev\]" --include=*.tsx features | grep -v BACKUP
# G-P4
grep -rn "selectedItems\[0\]" --include=*.tsx features | grep -v BACKUP
```

`G-F1` 은 부모→자식 prop 전달을 타므로 단순 grep 으로 판정하면 **오탐**한다
(`gridFilterRef={gridFilterRef}` 가 `<DataGrid>` 가 아니라 `<XxxGrid>` 에 붙어 있을 수 있다).
**`<DataGrid` 태그의 prop 블록 안**에 있는지로 판정할 것.

---

## §5. ⚠ 현재 적용 현황 (2026-08-22 실측 — 룰이 곧 현행 코드가 아니다)

본 룰은 **목표 계약**이고, 아래는 그 시점의 실제 상태다. 소급 적용은 화면별 작업 시점에 한다(#124 규약).

| 조항 | 정본/준수 | 미준수 |
|---|---|---|
| §1 Insert anchor | **DMF0082 `ForecastPrice.tsx`** — `PendingInsert{row,anchor}`(`:66-68`) · anchor 를 **행 객체**로 쓰는 `rowsByAnchor` Map(`:293-300`) · `groupTopRowOf`(`:426`) · 행 배열 `useMemo` 계산(`:285-314`) | DMF0044 `SalesReports.tsx:439` · DMF0049 `EtcSalesReports.tsx:409` 가 `[...insertedRows, ...spRows]` |
| §2 필터 생성 위치 | `admin/group-user` 1 + `sdm/*` 5 + ⭐ **DMF0082 `forecast-price`**(2026-08-22 적용 — 화면 생성 코드 제거) | **DM/master 그리드 10파일이 화면에서 자체 생성**(business-plan · customer-fcst-upload · demand-manager · etc-sales-reports · metal-link-price · mkt-fcst · sales-monitoring · sales-plan · sales-reports · sales-future-price) |
| §3 필터 예외 | **DMF0082 `ForecastPriceGrid.tsx:841`** — `keepRowVisibleUnderFilter` + `collectionView.refresh()` | 그 외 화면 미소비 |

> ⭐ **2026-08-22 — DMF0082 §2 적용(사용자 지시).** 화면의 `new FlexGridFilter(...)` 를 제거해
> **생성 주체를 `<DataGrid>` 단일로** 정리했다. 이로써 `rebindFilterColumns`(DataGrid.tsx 내장) ·
> 컨텍스트 메뉴 Filter · 팝업 F3/F4 가 한 인스턴스 위에서 동작한다.
>
> 적용 과정에서 **구 진단이 틀렸음**이 드러났다. 화면의 생성 코드는 `if (!gridFilterRef.current)`
> 가드 안에 있었고 `<DataGrid>` 가 `handleInitialized` 에서 **먼저** 만들기 때문에(React 자식 커밋 →
> 부모 effect 순서) **한 번도 실행된 적이 없는 죽은 코드**였다. 즉 "화면이 필터를 만든다" 가 아니라
> **"화면이 만들려던 설정이 통째로 무시되고 있었다"** 가 실제 상태였다.
>
> ⛔ **필터 대상 컬럼 목록을 미리 채우지 말 것 (2026-08-22 실사고 — 되돌림).**
> "동적 컬럼을 필터에서 빼자" 는 취지로 `filterColumns` 에 정적 컬럼 목록을 넘겼더니
> **그 컬럼 전부에 필터 아이콘이 상시 노출**됐다(사용자 신고: 메인·모달 양쪽). wijmo 실측 —
>
> ```
> n = this._filterColumns;
> n && n.length && n.indexOf(col.binding) < 0 && n.indexOf(col.name) < 0 && (filter = null)
> ```
>
> · `['']` = **아무 컬럼도 아님**(기본값) · **빈 배열 `[]` 은 정반대로 전 컬럼**(`n.length`=0 → 가드 skip)
> · 목록을 채우면 그 컬럼들에 아이콘이 붙는다 — 이 프로젝트 UX 는 `GridAction.toggleColumnFilter`
>   (F4 / SubTitle 버튼, `gridAction.ts:326~343`)가 **선택 컬럼을 push/splice** 하는 opt-in 방식이라
>   기본값은 반드시 `['']` 여야 한다. 목록을 미리 채우면 F4 토글의 의미도 사라진다.
> ⇒ §2 의 "동적 컬럼 필터 제외" 는 **목록 지정이 아니라 기본값 `['']` 로 이미 달성**된다.
>
> ⚠ **남은 충돌 1건 (미해소 · 실측 필요)** — `DataGrid` 는 `itemsSourceChanged` 마다 필터를 복원하는데
> (`captureGridFilter`/`restoreGridFilter`), 화면은 **Search 시에는 복원하지 않는다**고 결정해 뒀다
> (`ForecastPriceGrid.tsx` "신규행이 없다 = 조회 결과 교체" 주석, 2026-08-13 — 유령 필터·`Positive number
> expected` 사고 근거). 두 정책이 공존하며 어느 쪽이 이기는지는 **런타임 실측 전까지 단정하지 않는다.**

> ⚠ **`InsertBlock` / `setHeadIndexOf` / `buildSetKeyMap` 은 아직 저장소에 없다**(전수 grep 0건).
> §1 의 코드는 **처방 형태**이고, 현행 등가물은 DMF0082 의 `PendingInsert` / `groupTopRowOf` 다.
> 새 화면은 §1 형태로 쓰고, 공용 유틸로 승격할 때 `@foundation` 에 올린 뒤 본 절의 경로를 갱신한다.
> (룰이 없는 심볼을 가리키면 그 자체가 누락을 만든다 — `rebindFilterColumns` 소급 사고 계보.)

---

## §6. 참고 코드

| 무엇 | 어디 |
|---|---|
| Insert anchor + 행 계산 (**현행 정본**) | `features/demand/src/pages/forecast-price/ForecastPrice.tsx` (`PendingInsert` `:66` / `rows` `:285` / `groupTopRowOf` `:426` / `handleInsert` `:456`) |
| capture/restore 등록 순서 | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx` `handleInitialized` `:536~556` |
| `captureGridFilter` / `restoreGridFilter` / `rebindFilterColumns` / `keepRowVisibleUnderFilter` | `packages/foundation/src/utils/gridAction.ts` (`:133` / `:153` / `:86` / `:44`) |
| 필터 예외 등록 (**현행 정본**) | `features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx:841` |
| `<DataGrid gridFilterRef>` 준수 예 | `features/sdm/src/pages/project-list/components/ProjectListGrid.tsx:435` |
