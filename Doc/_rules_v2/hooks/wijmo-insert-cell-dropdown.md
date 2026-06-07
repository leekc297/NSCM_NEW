# Hook — Wijmo Insert Cell Dropdown 적용 패턴

> ⚠ **신규 화면의 Insert row 에 cell dropdown / popup 적용 시 의무 hook**
> DMF0003 (MKT FCST) 작업 (2026-06-07) 에서 누적된 12 단계 보완사항을 1-pass 적용.
> 자매 DMF0020 SalesFuturePriceFlexGrid 검증된 패턴 동등.

작성: 2026-06-07 (DMF0003 누적 보완사항 일반화)
관련 룰: `_tobe/07_datagrid.md` §12 / `_tobe/08_column_meta.md` / `_tobe/12_metadata_sql.md`
상위 룰: `anti-simplification.md`

---

## §0. 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** | 신규 Grid 작성 직전 — §1~§4 의무 적용 |
| **POST-WRITE** | Grid + Master 작성 직후 — §5 자동 grep 검증 |
| **PRE-SUBMIT** | PR 직전 — §6 lint + type-check + 화면 동작 검증 |

---

## §1. PRE-WRITE 의무 7 단계 (사고 #N → 룰화)

### 1.1 ❌ `selectionMode='Row'` 사용 금지 (default = `'MultiRange'`)

**사고**: DMF0003 Insert cell click 시 dropdown 안 펼침. 원인: `selectionMode='Row'` 가 single click 시 row 만 선택 → cell editor 진입 차단.

```tsx
// ❌ Insert/Edit grid 에 'Row' 명시 — cell editor 차단
<FlexGrid selectionMode='Row' ... />

// ✅ 미명시 (default 'MultiRange') — cell focus + edit 가능
<FlexGrid ... />
```

### 1.2 ❌ Imperative `columnLayout` JSON 금지 → JSX `<FlexGridColumn>` 평면

**사고**: `g.columnLayout = JSON.stringify({columns: [...]})` 매번 columns 재생성 → wijmo 가 column.dataMap reset → dropdown 미적용 근본 원인.

```tsx
// ❌ imperative columnLayout
g.columnLayout = JSON.stringify({ columns: [...] });

// ✅ JSX FlexGridColumn 평면 (자매 DMF0020 SalesFuturePriceFlexGrid:410-432 동등)
{fixedColumns.map(c => (
  <FlexGridColumn
    key={c.key}
    binding={c.key}
    header={c.header}
    width={c.width}
    align={...}
    isReadOnly={c._inputEditType === 'S'}
    dataMap={dataMaps[c.key] ?? undefined}  // ← React wrapper 자동 매핑
  />
))}
```

### 1.3 ✅ DataMap 객체 useMemo memoize 의무

**사고**: useEffect 안 `new DataMap(...)` 매번 생성 → wijmo column stale state.

```tsx
// ✅ DataMap 자체 memoize — reference 안정
const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
  const make = (q: ComboItem[] | undefined): DataMap | null => {
    const arr = q ?? [];
    if (arr.length === 0) return null;
    return new DataMap(arr, 'CODE', 'NAME');
  };
  const obj: Record<string, DataMap | null> = {};
  for (const [k, v] of Object.entries(comboData)) obj[k] = make(v);
  return obj;
}, [comboData]);
```

### 1.4 ✅ 3-row column header 패턴 (PIVOT 화면)

```tsx
// columnLayout nested group 대신 columnHeaders.rows.push
initialized={(g) => {
  if (g.columnHeaders.rows.length === 1) {
    g.columnHeaders.rows.push(new Row());
    g.columnHeaders.rows.push(new Row());
  }
  g.columnHeaders.rows.defaultSize = 24;
}}

// formatItem 의 ColumnHeader 분기에서 row 0/1/2 textContent 직접 설정
formatItem={(_g, e) => {
  if (e.panel.cellType === CellType.ColumnHeader) {
    const dyn = getDynKey(binding);
    if (dyn.kind) {
      if (e.row === 0) e.cell.textContent = dyn.ym.slice(0, 4);   // Year
      else if (e.row === 1) e.cell.textContent = dyn.ym.slice(5, 7); // Month
      else if (e.row === 2) e.cell.textContent = dyn.wk;            // Day/Week
    } else {
      // fixed col — mergeManager 가 row 0-2 머지 + row 0 textContent
      const meta = COL_META.get(binding);
      e.cell.textContent = meta?.header ?? binding;
    }
  }
}}
```

### 1.5 ✅ `g.invalidate(true)` 강제 redraw

```tsx
useEffect(() => {
  const g = gridInstanceRef.current;
  if (!g) return;
  for (const col of g.columns) {
    const dm = dataMaps[col.binding ?? ''];
    if (dm) col.dataMap = dm;
  }
  g.invalidate(true);  // ← 강제 redraw 의무
}, [dataMaps]);
```

### 1.6 ✅ `handleInsert` 의 startEditing → 첫 editable col 자동 focus

**사고**: `g.startEditing(true, 0, 0)` 호출 시 col 0 = read-only column (e.g. DIVISION_ID `_inputEditType: 'S'`) → editor 진입 안 됨.

```tsx
const handleInsert = () => {
  setInsertedRows(prev => [newRow, ...prev]);
  setTimeout(() => {
    const g = gridRef.current;
    if (!g) return;
    g.scrollIntoView(0, 0);
    // 첫 editable col (IM/IO type) 찾기
    let firstEditableCol = 0;
    for (let i = 0; i < g.columns.length; i++) {
      const binding = g.columns[i].binding ?? '';
      const meta = MAIN_COLUMNS.find(m => m.key === binding);
      if (meta && (meta._inputEditType === 'IM' || meta._inputEditType === 'IO')) {
        firstEditableCol = i;
        break;
      }
    }
    g.select(0, firstEditableCol);
    g.startEditing(true, 0, firstEditableCol);
  }, 50);
};
```

### 1.7 ✅ FlexGridFilter F4 버튼 누름 시 attach (자동 attach 금지)

**사고**: `initialized` 에서 `new FlexGridFilter(g)` 호출 시 column header 의 filter icon 이 항상 표시 → 사용자 의도와 안 맞음.

```tsx
// ❌ Grid initialized 자동 attach
initialized={(g) => { gridFilterRef.current = new FlexGridFilter(g); }}

// ✅ F4 button 누름 시에만 attach
const handleFilter = () => {
  const g = gridRef.current;
  if (!g) return;
  if (!gridFilterRef.current) {
    gridFilterRef.current = new FlexGridFilter(g);
    return;
  }
  GridAction.toggleColumnFilter(g, gridFilterRef.current);
};
```

---

## §2. CMBO_SQL_M 의무 (BE side)

### 2.1 `@varName` BE 자동 채움 표

BE 가 SQL_DTL_CTN 의 `@varName` 을 자동 치환하는 **시스템 키만**:

| `@varName` | BE 자동 채움 | 비고 |
|---|---|---|
| `@sesUserId` | ✓ | session 의 USER_ID |
| `@sesLangCd` | ✓ | session 의 LANG_CD |
| `@mnuId` | ✓ | 호출 화면 MENU_ID |
| **`@divisionId`** | ❌ | **객체 filter `{ comboId, divisionId: ... }` 필수** |
| **`@endCustomer`** | ❌ | 객체 filter 필수 |
| 기타 | ❌ | 객체 filter 명시 의무 |

### 2.2 useTabComboQueries filter 패턴

```tsx
// ✅ 변수 없는 SQL (또는 @sesUserId 만 사용) — string
filters: ['EndCustomer', 'Incoterms', 'BizType', 'Measure', 'PlantSite']

// ✅ @divisionId 사용 SQL — 객체 명시
filters: [
  { comboId: 'FcstType', divisionId: sc.divisionId },
  { comboId: 'CustomsHandbook', divisionId: sc.divisionId },
  { comboId: 'SiteByEndCustomer', divisionId: sc.divisionId, endCustomer: 'ALL' },
]
```

### 2.3 CMBO SQL 결과 컬럼 표준

| 컬럼 | 의무 | 비고 |
|---|---|---|
| `CODE` | ✓ | `DataMap(items, 'CODE', 'NAME')` 의 selectedValuePath |
| `NAME` | ✓ | displayMemberPath |
| `DIVISION_ID` | option | 있으면 FE 가 `toOptions(rows, division)` 로 filter |

### 2.4 자매 검증된 SQL_ID 인벤토리 (재사용 우선)

| SQL_ID | 용도 | 변수 |
|---|---|---|
| `MyDivision` | Division | `@sesUserId` |
| `TeambyDivision` | Team | `@sesUserId`, `@langCd` |
| `EndCustomer` | End Customer | `@sesUserId` |
| `EndCustomerByDivisionDept` | End Customer | (변수 없음) |
| `SalesSite` | Sales Site | `@sesUserId` |
| `SiteByEndCustomer` | Sales Site by EC | `@divisionId`, `@endCustomer` |
| `BizType` | Biz Type | (변수 없음 권장 — `@divisionId` 사용 시 DIVISION_ID 결과 컬럼 + FE filter) |
| `Incoterms` | Incoterms | (변수 없음) |
| `FcstType` | Fcst Type | `@divisionId` |
| `CustomsHandbook` | Customs Handbook | `@divisionId` |
| `PlantSite` | Plant Site | `@sesUserId` |
| `Measure` | Measure | (변수 없음) |
| `CurrencyList` | Currency | (변수 없음) |

---

## §3. POST-WRITE 자동 grep 검증

```bash
# 1. selectionMode='Row' 검출
grep -rn "selectionMode=['\"]Row['\"]" features/{domain}/src/pages/{screen}/components/*.tsx

# 2. imperative columnLayout 검출
grep -rn "g\.columnLayout\s*=" features/{domain}/src/pages/{screen}/components/*.tsx

# 3. DataMap 매번 new 검출 (useMemo 밖)
grep -rn "new DataMap" features/{domain}/src/pages/{screen}/components/*.tsx

# 4. startEditing col 0 hardcoded 검출
grep -rn "startEditing.*0,\s*0" features/{domain}/src/pages/{screen}/*.tsx

# 5. FlexGridFilter 자동 attach 검출
grep -rn "new FlexGridFilter" features/{domain}/src/pages/{screen}/components/*.tsx
```

---

## §4. PRE-SUBMIT 동작 검증 (cell click → dropdown 펼침)

1. start-all.ps1 → BE / FE / Docker 기동
2. 화면 진입 → F8 Insert → 신규 row 최상단 + 첫 editable cell auto-focus
3. End Customer / Sales Site / Incoterms / Fcst Type / Customs Handbook / Plant Site / Measure cell click → **ComboBox dropdown 즉시 펼침**
4. Project Code / Model double click → **popup modal 정상 오픈** (preSearchParams 의 divisionId 전달)
5. F4 → column header filter icon 표시 → 두번째 F4 → filter editor toggle
6. F3 → column 정렬 toggle

---

## §5. cross-ref

- `_tobe/07_datagrid.md §12` (Insert cell dropdown 패턴)
- `_tobe/08_column_meta.md` (`_ctrlType` / `_inputEditType` / `_comboKey` / `_modalKey`)
- `_tobe/12_metadata_sql.md §15` (CMBO_SQL_M `@varName` BE 자동 채움 표)
- `hooks/grid-column-meta.md` (column meta 표준)
- `hooks/runtime-error-prevention.md` (Wijmo column 사고 패턴)
- `hooks/asis-button-mapping.md` (10 button + Sort/Filter hotkeyConfig)
- 자매 검증 화면: `features/master/src/pages/sales-future-price/components/SalesFuturePriceFlexGrid.tsx`
