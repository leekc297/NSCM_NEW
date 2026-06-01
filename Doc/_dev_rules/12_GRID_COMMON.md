# 12. Wijmo Grid 공통 운영 패턴

> NSCM 의 모든 화면 Grid 가 공통으로 따르는 운영 패턴.
> Wijmo FlexGrid / FlexSheet 의 라이브러리 선택, 표준 래퍼, EditTracker, GridAction, 안전 조작 규칙.
>
> ⭐ **선행 룰**: [`03_FE_RULES.md`](03_FE_RULES.md) §그리드, [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) (Grid 데이터 소스)
> ⭐ **자매 룰**: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md) (As-Is 마이그레이션 매핑 — 본 문서와 영역 분리)
> ⭐ **연관**: [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md) §3 (finishEditing 에러), §9 (Wijmo 모듈 중복 / PivotGrid)
> ⭐ **2026-05-28 추가**: [`27_WIJMO_PIVOT_AND_MODULE.md`](27_WIJMO_PIVOT_AND_MODULE.md) — module duplication 검출 (`node_modules/node_modules/` 잔존 → `mergeManager === null`), column header 머지 발동 조건 (TWO_DEPTH + group.header == leaf.header), PivotGrid React 사용 패턴 (useMemo + 1회 fields 설정 가드), 신규 sheet 등록 5종 매핑
>
> **09 vs 12 분리**: 09 = As-Is GSCM Spread/Grid → Wijmo 마이그레이션 룰 (한시적). 12 = 신규 화면 포함 모든 Wijmo 운영 룰 (영구).

---

## 1. 라이브러리 선택 기준

| 케이스 | 라이브러리 | 근거 |
|---|---|---|
| 일반 화면 (검색 + 그리드 + 저장) | **FlexGrid** | 대량 데이터 가상화, 메타 컬럼 정의 호환 |
| As-Is `Cell.Formula` 사용 화면 | **FlexSheet** | Excel-like 수식 평가 (`SUM(A1:A10)` 등) |
| Pivot / OLAP | FlexPivot | (현재 사용 없음) |
| Tree / Hierarchical | FlexGrid + `childItemsPath` | FlexGrid 로 충분 |

❌ **금지**: AG-Grid / DataGrid (MUI) / React-Table 등 다른 그리드 라이브러리. **Wijmo 전용**.

> 참고: As-Is 화면 마이그레이션 시 `Cell.Formula` 가 1건이라도 있으면 FlexSheet 선택. 상세: `09_WIJMO_VALIDATION_EXPRESSION.md`.

---

## 2. 표준 래퍼: `DataGrid` 컴포넌트

NSCM 의 모든 화면은 `@shared/components` 의 `DataGrid` 래퍼를 사용:

```ts
import { DataGrid } from '@shared/components';

<DataGrid
  ref={gridRef}
  filterRef={gridFilterRef}
  data={data?.o_rc ?? []}
  columns={staticColumns}      // SCM_MST_SHEET_COLUMNS 조회 결과
  menuId={MENU_ID}
  sheetName={SHEETS.MAIN}
  hotkeyConfig={hotkeyConfig}
/>
```

> 위치: `nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx`

❌ `@mescius/wijmo.grid` 의 `FlexGrid` 를 페이지에서 직접 사용 금지 (래퍼가 자동으로 EditTracker, GridAction hotkey, 컬럼 메타 매핑 적용).

---

## 3. EditTracker — CRUD_TYPE 행 추적

페이지에서 변경된 행만 저장하기 위한 표준 패턴. `DataGrid` 가 내부적으로 `EditTracker` 인스턴스 생성.

### 3.1 CRUD_TYPE 값
```ts
// @foundation/constants/row-crud.ts
export const CRUD_TYPE = {
  CREATE: 'C',
  UPDATE: 'U',
  DELETE: 'D',
} as const;
```

### 3.2 저장 시 변경된 행만 추출
```ts
const onSave = () => {
  const saveData = data?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
  saveWithValidation(saveData, staticColumns, mutate);
};
```

### 3.3 EditTracker API
```ts
const tracker = gridRef.current?.editTracker;
tracker?.hasChanges();     // 변경 여부
tracker?.getChanges();     // 변경 행 배열
tracker?.clearChanges();   // 초기화 (검색 직후 호출)
```

> 구현: `nscm-fe/packages/foundation/src/utils/editTracker.ts`

### 3.4 사용 패턴
```
[ ] 셀 편집 → EditTracker 가 _originalValue 저장 + cellChanged 시 비교
[ ] 값이 원래대로 돌아가면 CRUD_TYPE 자동 해제
[ ] 새 행 추가 (GridAction.addRow) → CRUD_TYPE = 'C'
[ ] 행 삭제 (GridAction.deleteRow) → CRUD_TYPE = 'D' (실제 행은 표시 유지)
[ ] 검색 직후 → tracker.clearChanges() + setEditTracker(false)
```

---

## 4. gridRef 안전 조작 ⭐ (사고 예방)

**가장 잦은 사고**: 검색/저장 핸들러에서 `gridRef.current.invalidate()` 직접 호출 → `Cannot read properties of null (reading 'finishEditing')` (DMF0007 사례, 2026-05-19).

### 4.1 원인
- `gridRef.current` 가 React 리렌더 사이에 일시적으로 null 일 수 있음
- 또는 `hostElement` 가 unmount 직후 null
- `invalidate()` 가 내부적으로 `finishEditing()` 호출 → NullPointer

### 4.2 안전 패턴 (둘 중 하나 선택)

**패턴 A — null 가드**:
```ts
if (gridRef.current?.hostElement) {
  gridRef.current.finishEditing(true);
  gridRef.current.invalidate();
}
```

**패턴 B — 마이크로태스크 디퍼**:
```ts
queueMicrotask(() => gridRef.current?.invalidate());
```

### 4.3 일반 원칙
```
[ ] handleSearch / handleSave 에서 gridRef.current?.invalidate() 직접 호출 금지
    → React re-render 가 처리해야 함
[ ] dynamicColumns (예: dateColumns) setState 변경 핸들러 순서:
    1) dynamicColumns 갱신 → 2) filters/data 갱신 → 3) (필요 시) editTracker.clearChanges()
[ ] optional chaining 2단: data?.o_rc1?.length (단계 단축 X)
[ ] gridRef.current 접근 시 항상 ?. 또는 if 가드
```

→ 상세: [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md) §3 + [`hooks/post-write.md`](hooks/post-write.md) §11

---

## 5. GridAction — 표준 단축키 / 액션

`GridAction` 은 F1~F12 단축키와 그리드 액션의 표준 구현. 페이지에서 import 해서 hotkeyConfig 에 연결.

```ts
import { GridAction } from '@foundation/utils';

const hotkeyConfig: HotkeyConfig = {
  save: onSave,
  search: onSearch,
  addRow: () => GridAction.addRow(gridRef.current, defaultRow, 'above'),
  deleteRow: () => GridAction.deleteRow(gridRef.current),
  excelExport: () => GridAction.excelExport(gridRef.current, fileName),
  toggleFilter: () => GridAction.toggleColumnFilter(gridRef.current, gridFilterRef.current),
  toggleSort: () => GridAction.toggleColumnSort(gridRef.current),
  clear: () => GridAction.clear(setGridData, setDataCount, gridRef.current, gridFilterRef.current),
};
```

표준 액션 목록 (`packages/foundation/src/utils/gridAction.ts`):

| 단축키 | 액션 | 메서드 |
|---|---|---|
| F1 | 매뉴얼 열기 | `getManual` |
| F3 | 정렬 토글 | `toggleColumnSort` |
| F4 | 필터 토글 | `toggleColumnFilter` |
| F6 | 조건 개인화 | `personalizeCondition` |
| F7 | 검색 | (페이지 onSearch) |
| F8 | 행 추가 | `addRow` |
| F9 | 행 삭제 | `deleteRow` |
| F10 | 저장 | (페이지 onSave) |
| F11 | 엑셀 내보내기 | `excelExport` |
| Ctrl+L | 초기화 | `clear` |

❌ 페이지에서 직접 `grid.itemsSource.push(...)` 같은 mutation 금지 — `GridAction.addRow` 경유.

---

## 6. 컬럼 메타 → cellTemplate 매핑

`SCM_MST_SHEET_COLUMNS` 의 컬럼 정의 (`CELL_TP_CD` 등) 가 Wijmo 컬럼으로 매핑됨.

| `CELL_TP_CD` (As-Is) | Wijmo dataType / cellTemplate | 비고 |
|---|---|---|
| `FPText` | `dataType: 'String'` | 일반 텍스트 |
| `FPNumber` | `dataType: 'Number'` + `format: 'N0'/'N2'` | 숫자, 천단위 콤마 |
| `FPDate` | `dataType: 'Date'` + `format: 'yyyy-MM-dd'` | 날짜 |
| `FPCombo` | `dataMap: new DataMap(...)` | 콤보박스 |
| `FPCheck` | `dataType: 'Boolean'` | 체크박스 |
| `FPButton` | `cellTemplate: customButtonRenderer` | 버튼 셀 |
| (HTML link) | `cellTemplate: linkRenderer` | 링크 (`<a href>`) |

> 매핑 구현: `nscm-fe/packages/foundation/src/utils/columnMapping.ts` + `gridColumns.ts`

### 6.1 dynamic columns (기간형 화면)
검색 조건 (YYYYMM 등) 에 따라 컬럼 개수가 달라지는 경우:

```ts
// useStore: dynamicColumns 별도 state
const [dynamicColumns, setDynamicColumns] = useState<RawFlexGridColumnConfig[]>([]);

// 검색 직후 → dynamic 컬럼 먼저 갱신 → 그 다음 data 갱신
const onSearch = async () => {
  const newDateCols = generateDateColumns(filters.fromYYYYMM, filters.toYYYYMM);
  setDynamicColumns(newDateCols);  // 1) 컬럼
  setFilters({...});                // 2) 데이터 트리거
};
```

순서 어기면 그리드가 빈 컬럼으로 렌더링 후 재렌더링 — 시각적 깜박임 + EditTracker 오작동.

### 6.2 ⭐ 동적 컬럼 메타 SP 호출 (2026-05-22 추가 — DMF0020 패턴)

`dynamicColumns` 는 As-Is `GET_SPREAD_TITLE_DATE` 같은 메타 SP 의 결과. 다음 패턴:

```ts
// store
fetchDynamicColumns: async () => {
  const { searchParams } = get();
  if (!searchParams.periodFrom || !searchParams.periodTo) return;
  const result = await apiClient.post<DynamicColumn[]>(
    `/${MENU_ID}/${SHEETS.MAIN}/SPREAD_TITLE_DATE/call-proc`,    // 커스텀 BTN_CD
    {
      periodFrom: searchParams.periodFrom,
      periodTo: searchParams.periodTo,
      bucketType: searchParams.bucketType,
    }
  );
  set(state => {
    state.dynamicColumns = (result.data.result ?? []).map(c => ({
      ...c,
      // bucketType (Weekly/Monthly) 에 따라 W_* 또는 M_* 만 visible
      visible: searchParams.bucketType === 'W'
        ? c.binding.startsWith('W_') : c.binding.startsWith('M_'),
    }));
  });
},
```

```ts
// page: filters 변경 시 dynamicColumns 재조회
useEffect(() => {
  if (filters) void fetchDynamicColumns();
}, [filters, fetchDynamicColumns]);
```

**메타 SP 등록**: `SCM_ADM_API_M` 에 별도 API_ID (예: `DMF0020_main_SPREAD_TITLE_DATE`) + `SCM_ADM_MNU_BTN_MPG_M` 에 `MNU_BTN_CD='SPREAD_TITLE_DATE'` 라우팅. 상세: `08_SCREEN_REGISTRATION.md` §4.6.1.

### 6.3 ⭐ 3-tier 동적 헤더 (YYYY-MM > Wxx > MMDD, DMF0020 패턴)

동적 컬럼을 3단 헤더로 그룹화:

```ts
// hooks/useXxxExpression.ts
const buildLargeSumHeader = useCallback((dynamicCols: DynamicColumn[]): RawFlexGridColumnConfig[] => {
  if (dynamicCols.length === 0) return [];
  // YYYY-MM 단위로 그룹화 → 3단 헤더
  const yymMap = new Map<string, DynamicColumn[]>();
  dynamicCols.forEach(c => {
    const arr = yymMap.get(c.basisYYYYMM) ?? [];
    arr.push(c);
    yymMap.set(c.basisYYYYMM, arr);
  });
  const result: RawFlexGridColumnConfig[] = [];
  yymMap.forEach((cols, yym) => {
    result.push({
      header: yym,                  // Row 0: '2026-05'
      align: 'center',
      columnGroup: cols.map(c => ({
        binding: c.binding,
        header: c.header,           // Row 2: '0511' (MMDD)
        width: 120,
        align: 'right',
        format: 'n2',
        visible: c.visible,
      })),
    } as RawFlexGridColumnConfig);
  });
  return result;
}, []);

// page: staticColumns + 3-tier 헤더 합성
const columns = useMemo(() => {
  const dyn = dynamicColumns.filter(c => c.visible);
  return [...staticColumns, ...buildLargeSumHeader(dyn)];
}, [staticColumns, dynamicColumns, buildLargeSumHeader]);
```

**Wijmo `<FlexGridColumnGroup>` JSX 구성** (3-tier):

```tsx
<FlexGrid frozenColumns={11} allowMerging='Cells'>
  {/* 좌측 고정 11 컬럼 */}
  {headerTree.map(yym => (
    <FlexGridColumnGroup key={yym.key} header={yym.label}>       {/* Row 0: YYYY-MM */}
      {yym.weeks.map(w => (
        <FlexGridColumnGroup key={w.key} header={w.label}>       {/* Row 1: Wxx */}
          {w.days.map(d => (
            <FlexGridColumnGroup key={d.binding}
              binding={d.binding} header={d.label}               {/* Row 2: MMDD */}
              width={120} align='right' format='n2' />
          ))}
        </FlexGridColumnGroup>
      ))}
    </FlexGridColumnGroup>
  ))}
</FlexGrid>
```

---

## 7. FlexSheet (As-Is `Cell.Formula` 화면)

### 7.1 언제 FlexSheet 사용?
As-Is GSCM 의 `expressions.md` 에서 `Cell.Formula` 패턴이 1건이라도 있으면 FlexSheet:

```cs
// As-Is C#
ws.Cells[row, col].Formula = "=SUM(A1:A10)";
```

### 7.2 FlexSheet 패턴
```ts
import { FlexSheet } from '@mescius/wijmo.grid.sheet';

// 셀에 수식 설정
sheet.setCellData(row, col, '=SUM(A1:A10)', false /* asFormula */, true);

// 평가된 값 읽기
const evaluated = sheet.evaluate(row, col);
```

### 7.3 FlexSheet 와 FlexGrid 분기
한 화면에 FlexGrid + FlexSheet 둘 다 두지 않습니다. 화면 단위로 1개 선택.

→ 상세: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md) §4.5

---

## 8. 성능 가이드

```
[ ] 행 1만 건 이상 → autoGenerateColumns=false + frozenColumns 적용
[ ] 빈번한 setItemsSource 호출 금지 → CollectionView 1번 생성 후 .source = data
[ ] columnGroups 사용 시 mergeCells = 'ColumnHeaders'
[ ] 셀렉터 (data?.o_rc) 변경마다 EditTracker.clearChanges 호출하지 않음 (의도된 변경만)
[ ] cellTemplate 안에서 무거운 연산 금지 → useMemo 또는 미리 계산
[ ] 검증 함수는 useXxxValidation hook 으로 분리 (re-render 최소화)
```

---

## 9. 자기 점검 체크리스트

페이지 작성 직후:

```
[ ] @shared/components 의 DataGrid 래퍼 사용 (FlexGrid 직접 사용 X)
[ ] EditTracker / GridAction 사용 (직접 itemsSource mutation X)
[ ] gridRef.current.invalidate() 핸들러 직접 호출 0건 (또는 null 가드)
[ ] data?.o_rc?.length (optional chaining 2단) 사용
[ ] dynamicColumns 갱신 → filters 갱신 순서 준수
[ ] CRUD_TYPE 마킹된 행만 저장 (.filter(item => item.CRUD_TYPE))
[ ] hotkeyConfig 에 표준 액션 (search/save/addRow/deleteRow/excelExport) 연결
[ ] 컬럼 정의는 SCM_MST_SHEET_COLUMNS 메타 기반 (하드코딩 X)
[ ] Cell.Formula 사용 As-Is 화면이라면 FlexSheet 선택
[ ] 동적 컬럼 화면이면 fetchDynamicColumns 가 별도 메타 SP 호출 (§6.2)
[ ] 그룹 동시 선택 화면이면 GROUP_KEY_COLUMNS + formatItem 적용 (§10)
[ ] As-Is POPUP 통합 화면이면 components/modals/ 구조 (§11)
```

---

## 10. ⭐ 그룹 키 동시 선택 / 하이라이트 (2026-05-22 추가 — DMF0020 패턴)

As-Is `Raw_CellClick` 같은 패턴: 한 행 선택 시 같은 키 (Division/Team/EndCustomer 조합) 의 다른 Measure 행도 함께 하이라이트.

### 10.1 GROUP_KEY_COLUMNS 상수

```ts
// {page-name}.constants.ts
/** 그룹 키 컬럼 (Measure 제외, 동시 선택용) — AS-IS: Raw_CellClick (L3707~3743) */
export const GROUP_KEY_COLUMNS = [
  'DIVISION_ID',
  'TEAM_INCHARGE',
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'ITEM_ID',
  'INCOTERMS',
  'FCST_TYPE',
  'DOM_EXP',
  'CURRENCY',
] as const;
```

### 10.2 그룹 키 산출 + store

```ts
/** 그룹 키 산출 — AS-IS: {파일명}.cs:Raw_CellClick */
const groupKeyOf = (row: Record<string, unknown>) =>
  GROUP_KEY_COLUMNS.map(c => row[c] ?? '').join('|');

// store
interface State {
  selectedGroupKey?: string;
}
interface Action {
  setSelectedGroupKey: (key?: string) => void;
}
```

### 10.3 같은 그룹 행 배경 (formatItem)

```tsx
// components/{PageName}Grid.tsx
const handleFormatItem = (s: FlexGrid, e: FormatItemEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
  if (row && selectedGroupKey && groupKeyOf(row) === selectedGroupKey) {
    e.cell.classList.add('selected-group');   // SCSS 에서 background-color 정의
  }
};

const handleCellClick = (s: FlexGrid, e: CellRangeEventArgs) => {
  if (!e || s == null) return;
  const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
  if (!row) return;
  setSelectedGroupKey(groupKeyOf(row));   // 클릭 시 그룹 키 갱신
};

<DataGrid
  formatItem={handleFormatItem}
  cellClick={handleCellClick}
/>
```

### 10.4 그룹 단일 컬럼 일괄 입력 (paste in group)

같은 그룹의 모든 행에 한 값을 일괄 적용 (예: Currency 변경):

```ts
const onPasteCellInGroup = (row: Record<string, unknown>, colBinding: string, value: unknown) => {
  const groupKey = groupKeyOf(row);
  data.filter(r => groupKeyOf(r) === groupKey).forEach(r => {
    r[colBinding] = value;
    if (r.CRUD_TYPE !== CRUD_TYPE.INSERT && r.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      r.CRUD_TYPE = CRUD_TYPE.MODIFY;
    }
  });
};
```

### 10.5 SCSS

```scss
:global(.selected-group) {
  background-color: #e3f2fd !important;
}
```

---

## 11. ⭐ POPUP → Modal 통합 패턴 (2026-05-22 추가 — DMF0020 패턴)

As-Is GSCM `Form` 으로 작성된 POPUP 화면들을 To-Be 에서는 메인 화면의 **Modal 컴포넌트** 로 통합.

### 11.1 POPUP 분류 (As-Is 분석 단계에서 결정)

| 분류 | 정의 | To-Be 위치 | 매트릭스 표기 |
|---|---|---|---|
| **(A) 전용 POPUP** | 본 화면 전용 (다른 화면에서 호출 X) | `components/modals/{ModalName}Modal.tsx` | ✅ (이번 PR 범위) |
| **(B) 공통 POPUP** | 다른 화면도 호출 (Owner / GridColumnSetting / Version 등) | `@shared/components` 의 공통 컴포넌트 또는 별도 화면 ID | ⚠ (follow-up) |

> 분석자료 (`analysis.md` / `source_links.md`) 의 POPUP 목록을 분류하여 매트릭스 §3 에 ✅/⚠ 표기.
> 상세: `09_WIJMO_VALIDATION_EXPRESSION.md` §3.4 POPUP 매핑 룰.

### 11.2 표준 Modal 시그니처

```tsx
// components/modals/{ModalName}Modal.tsx

interface {ModalName}ModalProps {
  open: boolean;
  modalClose: () => void;
  // 메인 화면에서 전달하는 컨텍스트 (필요 시)
  defaultDivision?: string;
  baseFilter?: BaseFilter;
  onApply?: (result: unknown) => void;
}

export const {ModalName}Modal = ({ open, modalClose, ...ctx }: {ModalName}ModalProps) => {
  const { t } = useTranslation();
  const { setAlert, setConfirm } = useMessageStore();
  const gridRef = useRef<FlexGrid<Record<string, unknown>>>();
  const editTrackerRef = useRef<EditTracker<Record<string, unknown>>>();

  // 자체 SHEET_NM 정의 (메인과 다른 sheet 로 메타 등록)
  const SHEET_NM = 'exchangeRate' as const;   // 예시

  const [filter, setFilter] = useState({...});
  const { data, refetch } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEET_NM as never,
    tabId: '{modal-name}',   // 메인 tabId 와 분리하여 격리
    filters: filter,
    enabled: open,
  });

  const { mutate } = useProcMutation<MENU_ID>({ ... });

  return (
    <Dialog open={open} onClose={modalClose} title={t('LBL...')} maxWidth='lg' fullWidth>
      <div className={styles.modalContent}>
        <div className={styles.filterBar}>{/* 검색 영역 */}</div>
        <DataGrid<...> gridRef={gridRef} editTrackerRef={editTrackerRef}
                      itemsSource={data?.o_rc ?? []} staticColumns={[]} />
        <div className={styles.actionBar}>
          <Button onClick={onSave}>{t('LBL00057', '_Save')}</Button>
          <Button onClick={modalClose}>{t('LBL00103', '_Close')}</Button>
        </div>
      </div>
    </Dialog>
  );
};
```

### 11.3 메인 화면에서 Modal 호출

```tsx
// {PageName}.tsx
const modals = useStore(state => state.modals);
const setOpenExchangeRate = useStore(state => state.setOpenExchangeRate);

return (
  <>
    <MainTitle ... />
    <Form onOpenExchangeRate={() => setOpenExchangeRate(true)} ... />
    <SubTitle ... />
    <Grid ... />

    {/* Modal 4 (DMF0020 예시) */}
    <ExchangeRateModal open={modals.openExchangeRate}
                       modalClose={() => setOpenExchangeRate(false)}
                       defaultDivision={searchParams.divisionId} />
    <SalesPriceRangeModal open={modals.openSalesPriceRange} ... />
    <PriceBatchInputModal open={modals.openPriceBatchInput} baseFilter={searchParams} />
    <SalesPriceTemplateModal open={modals.openSalesPriceTemplate} ... />
  </>
);
```

### 11.4 store 의 modalState

```ts
interface ModalState {
  openExchangeRate: boolean;
  openSalesPriceRange: boolean;
  openPriceBatchInput: boolean;
  openSalesPriceTemplate: boolean;
}

interface State {
  modals: ModalState;
}
interface Action {
  setOpenExchangeRate: (value: boolean) => void;
  // ... 각 modal 별 setter
}
```

### 11.5 Modal 별 sheet 메타 등록

각 Modal 은 메인과 다른 `SHT_NM` 으로 SCM_ADM_MNU_BTN_MPG_M 라우팅 등록:

```sql
-- BLOCK 5 (SCM_ADM_MNU_BTN_MPG_M)
VALUES ('DMF0020', 'main',            'SEARCH', 'DMF0020_main_SEARCH', ...)
VALUES ('DMF0020', 'exchangeRate',    'SEARCH', 'DMF0020_exchangeRate_SEARCH', ...)
VALUES ('DMF0020', 'salesPriceRange', 'SEARCH', 'DMF0020_salesPriceRange_SEARCH', ...)
-- ...
```

→ 상세: `08_SCREEN_REGISTRATION.md` §4.5.

### 11.6 공통 POPUP 호출 (분류 B)

공통 POPUP 3종 예시 (DMF0020):
- `DM0020_OwnerbyDivisionPopup` → `@shared/components` 의 `OwnerPicker` 또는 SYS0010 lookup
- `DM0002_TitleSetForm_Popup` → `GridAction.toggleColumnVisibility` (이미 존재)
- `DMF0073_VersionBySalesPricePopup` → 별도 화면 DMF0073 (별도 PR)

→ 이번 화면 작업에서는 **호출만** 작성, 구현은 follow-up.

### 11.7 자기 점검

```
[ ] As-Is POPUP 목록을 분석자료에서 추출 (analysis.md / source_links.md)
[ ] 각 POPUP 을 (A) 전용 / (B) 공통 으로 분류
[ ] (A) 전용 POPUP 만 components/modals/{ModalName}Modal.tsx 작성
[ ] (B) 공통 POPUP 은 호출만 + 매트릭스에 ⚠ 표기
[ ] Modal 의 sheetName 은 메인과 별도 (SCM_ADM_MNU_BTN_MPG_M 각 행 등록)
[ ] Modal 의 tabId 는 메인 tabId 와 분리 (cache 격리)
[ ] modalState 는 store 의 modals: { open... } 에 통합 (개별 useState X)
[ ] Modal 내부에도 DataGrid 래퍼 + EditTracker 사용 (FlexGrid 직접 사용 X)
```

---

## ⭐ 11.5 PIVOT / 동적 컬럼 화면 — `frozenColumns` 자동 설정 (2026-06-01 신규)

**원칙**: SP 에서 PIVOT 으로 동적 컬럼을 생성하는 화면은 **동적 컬럼 직전의 마지막 정적 컬럼까지 좌측 고정** (`frozenColumns`) 의무. 가로 스크롤 시 핵심 dimension 항상 표시.

### 11.5.1 트리거

다음 1개 이상 해당 시 → `frozenColumns` 명시 의무:
- SP 가 PIVOT 또는 동적 SQL 로 컬럼 생성 (Y# / M# / dynamic period × dimension 등)
- Grid 가 BASE 컬럼 + 동적 컬럼 두 영역으로 구성
- 컬럼 50개 이상으로 가로 스크롤 필수

### 11.5.2 표준 구현 패턴

```tsx
const BASE_COLUMNS = [
  { binding: 'DEPT_NAME', header: '부문', ... },
  { binding: 'TEAM_NAME', header: '팀', ... },
  ...
  { binding: 'DM_BIZ_TYPE', header: '형태', ... },  // ← 동적 컬럼 직전 마지막 정적
];

<FlexGrid
  initialized={(g) => {
    // PIVOT/동적 컬럼 직전까지 좌측 고정
    g.frozenColumns = BASE_COLUMNS.length;
  }}
  ...
/>
```

### 11.5.3 cross-check (PR 머지 게이트)

```bash
# PIVOT/동적 SP 화면인지 확인
grep -rE "PIVOT.*FOR.*COLUMN_NAME|v_ColumnDataPivot|v_ColumnData2" To-be_v2_converted/06_Packages/ \
  | awk -F: '{print $1}' | sort -u

# 해당 화면 FE 코드에 frozenColumns 존재 확인
grep -nE "frozenColumns\s*=" features/<domain>/src/pages/<screen>/components/*Grid.tsx
# 누락 시 → PR Reject
```

### 11.5.4 적용 사례

| 화면 | BASE 컬럼 | 동적 컬럼 | frozenColumns |
|---|---|---|---|
| DMF0043 Contribute Main | 6 (부문/팀/고객군/판매처/제품군/형태) | 108 (12 월 × 9 RBU) | 6 |
| DMF0007 Customer FCST (예상) | dim 컬럼 | 동적 기간 | dim 끝 |

### 11.5.5 자기 점검

- [ ] PIVOT SP 결과 cursor 컬럼 수가 BASE + 동적 합과 일치
- [ ] `frozenColumns = BASE_COLUMNS.length` 명시
- [ ] 가로 스크롤 시 BASE 컬럼 항상 visible (시각 검증)

상세 hook: [`hooks/pivot-frozen-columns.md`](hooks/pivot-frozen-columns.md)

---

## 12. 관련 문서

| 룰 | 주제 |
|---|---|
| [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md) | As-Is Validation/Expression → Wijmo 매핑 (마이그레이션 한정) |
| [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) | Grid 데이터 소스 (data?.o_rc) |
| [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) | 422 onError → setError (필드별 인라인) |
| [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md) §3 | Wijmo finishEditing / invalidate 에러 |
| [`hooks/post-write.md`](hooks/post-write.md) §11 | FE Wijmo Grid 안전 패턴 (포스트 작성 검증) |
