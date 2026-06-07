# TO-BE 룰 07 — DataGrid (Wijmo FlexGrid wrapper) 표준

> **추출 reference**: DMF0006 (단순) + DMF0004 (modal cell + cascade) + DMF0007 (dynamicColumns)

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 07 |
| 토픽 | DataGrid wrapper + EditTracker + dblClick + cellEditEnded |
| 적용 trigger | grid 컴포넌트 작성 |
| 관련 hook | `pre-write.md`, `grid-column-meta.md` (룰 08 cross-ref) |

---

## §1 표준 구조 (의무)

> reference: `CustomerModelMappingGrid.tsx` (157 lines, baseline) / `SalesSiteGrid.tsx` (140 lines, modal cell + cascade)

### §1.1 구조 6 단계

```typescript
import { CellRange, type FlexGrid, CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';
import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { ProjectByDivisionModal, ItemByDivisionModal } from '../../../components';
import { useStore } from '../use{Name}Store';

interface GridProps {
  // [1] Props 표준 시그니처
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.X>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.X>[];
  // (선택) setActiveTab — multi-sheet 화면
  // (선택) editTrackerRef — parent 가 ref 보유 시 (DMF0007)
}

export const {Name}Grid = ({ gridRef, gridFilterRef, data }: GridProps) => {
  // [2] EditTracker ref (local 또는 parent prop)
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.X>> | undefined>();
  
  // [3] Store selector (staticColumns + setDetailFilters 등)
  const staticColumn = useStore(state => state.staticColumn);
  
  // [4] Modal state (cell 더블클릭 시 modal 열기)
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);
  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);
  
  // [5] Handler (dblClick / cellEditEnded / modal callback)
  const handleProjectSelected = (projects: string, projectsNames?: string) => {
    if (!clickedDataItem || !projects) return;
    const projectCode = projects?.split(',')[0] ?? '';
    const projectsName = projectsNames?.split(',')[0] ?? '';
    
    editTrackerRef.current?.storeChange(clickedDataItem, 'PROJECT_CODE', clickedDataItem.PROJECT_CODE, projectCode);
    editTrackerRef.current?.storeChange(clickedDataItem, 'PROJECT_NAME', clickedDataItem.PROJECT_NAME, projectsName);
    clickedDataItem.PROJECT_CODE = projectCode;
    clickedDataItem.PROJECT_NAME = projectsName;
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };
  
  const handleGridDblclick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const editable = GridUtils.isEditableCell(grid, ht.row, ht.col);
    if (!editable) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem || !binding) return;
    
    if (binding === 'PROJECT_CODE') {
      setClickedRow(ht.row);
      setOpenProjectModal(true);
    } else if (binding === 'ITEM_ID' || binding === 'ITEM_CLASS_NAME') {
      setClickedRow(ht.row);
      setOpenItemModal(true);
    }
  };
  
  // [6] JSX: DataGrid + Modal
  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.X>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumn ?? []}
        dblClick={handleGridDblclick}
      />
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={handleProjectSelected}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          // ... clicked row 기반 default
        }}
        callFromCell={false}
      />
    </>
  );
};
```

### §1.2 의무 사항 인벤토리

| # | 의무 | reference |
|---:|---|---|
| 1 | `<DataGrid>` (FlexGrid 직접 사용 금지) | 모든 화면 |
| 2 | Props: `gridRef + gridFilterRef + editTrackerRef + itemsSource + staticColumns` 5 기본 | 모든 화면 |
| 3 | Generic 타입: `<DataGrid<ResponseData<MENU_ID, SHEETS.X>>>` | 모든 화면 |
| 4 | `editTrackerRef = useRef<EditTracker<T>>()` (local 또는 parent prop) | DMF0006:26-28 / DMF0007 parent |
| 5 | dblClick handler 표준: `grid.hitTest(mouseEvent)` → `GridUtils.getBinding/getRow/isEditableCell` → binding 별 modal | DMF0006:92-110 |
| 6 | Modal callback 의 3 단계: `editTrackerRef.storeChange + dataItem[X] = newVal + refreshRange` | DMF0006:38-61 |

---

## §2 허용 변형

### §2.1 multi-sheet (DMF0004)

```typescript
interface GridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SITE>> | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SITE, RESPONSE_SET.SITE>[];   // ⭐ Generic 3개
  setActiveTab: (tab: SHEET_INDEX) => void;   // ⭐ parent tab 전환
}

const handleFocus = () => setActiveTab(SHEET_INDEX.SITE);   // grid focus 시 active 갱신

<DataGrid<ResponseData<MENU_ID, SHEETS.SITE>>
  // ...
  staticColumns={staticColumns[RESPONSE_SET.SITE]}   // ⭐ sheet 별 column
  allowMerging={AllowMerging.Cells}                  // ⭐ cell merge
  alternatingRowStep={0}                             // ⭐ 행 색상 단일
  gotFocus={handleFocus}                             // ⭐ focus event
  cellEditEnded={handleAutoSalesSite}                // ⭐ 자동 sync
  dblClick={handleGridDblClick}
/>
```

**reference**: `SalesSiteGrid.tsx:22-138`.

### §2.2 dynamic column (DMF0007)

```typescript
const staticColumns = useStore(state => state.staticColumns[SHEETS.X]);
const dateColumns = useStore(state => state.dateColumns);

<DataGrid<ResponseData<MENU_ID, SHEETS.X>>
  // ...
  staticColumns={staticColumns ?? []}
  dynamicColumns={dateColumns ?? []}   // ⭐ 동적 컬럼 prop
  cellEditEnded={handleActiveChange}   // ⭐ cascade (VALID_YN='N' → 모든 D_ 'N')
/>
```

**reference**: `CustomerFcstMasterFcstGrid.tsx:62-65`.

### §2.3 EditTracker ref 가 parent 에 있는 경우 (DMF0007)

```typescript
interface GridProps {
  editTrackerRef: MutableRefObject<EditTracker<T> | undefined>;   // ⭐ parent prop
  // ...
}

// 본 Grid 컴포넌트는 useRef 하지 않음. parent (CustomerFcstMaster.tsx) 가 정의.
// parent 의 handleSave 에서 editTrackerRef.current?.getOriginalValues() 사용
```

**reference**: `CustomerFcstMasterFcstGrid.tsx:14-19, 24, 60`.

### §2.4 cellEditEnded cascade update

```typescript
// DMF0007: VALID_YN='N' 시 모든 D_ 컬럼 일괄 'N'
const handleActiveChange = (sender, cellRangeEventArgs) => {
  if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;
  const row = cellRangeEventArgs.row;
  const col = cellRangeEventArgs.col;
  const binding = GridUtils.getBinding(sender, col);
  const dataItem = GridUtils.getRow(sender, row);
  
  if (binding !== 'VALID_YN' || !dataItem) return;
  if (dataItem[binding] !== 'N') return;
  
  Object.keys(dataItem).forEach(key => {
    if (!key.startsWith('D_')) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
      editTrackerRef.current?.storeChange(dataItem, key, dataItem[key], 'N');
    dataItem[key] = 'N';
  });
};

// DMF0004: SOLDTO_CUSTOMER / COUNTRY / CITY 변경 시 SCM_SITE_ID 자동 생성
const handleAutoSalesSite = (grid, cellRangeEventArgs) => {
  const row = cellRangeEventArgs.row;
  const col = cellRangeEventArgs.col;
  const binding = grid.columns[col]?.binding;
  const dataItem = GridUtils.getRow(grid, row);
  
  if (!binding || !dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;
  if (!['SOLDTO_CUSTOMER', 'COUNTRY', 'CITY'].includes(binding)) return;
  
  applySalesSite(dataItem, editTrackerRef.current);   // utils/sales-site.util.ts
  grid.refreshRange(new CellRange(row, 0, row, -1));
};
```

→ AS-IS Spread 의 `EditChange` event + `SetValue` Auto-Sync 동등.

**reference**: `SalesSiteGrid.tsx:72-86` / `CustomerFcstMasterFcstGrid.tsx:32-54`.

### §2.5 dblClick → setDetailFilters (parent grid row 선택 → child grid refresh)

```typescript
// DMF0004 SalesSiteGrid 안
const handleGridDblClick = (mouseEvent: MouseEvent) => {
  const grid = gridRef.current;
  if (!grid) return;
  const ht = grid.hitTest(mouseEvent);
  if (ht.cellType !== CellType.Cell) return;
  
  const dataItem = GridUtils.getRow(grid, ht.row);
  const binding = GridUtils.getBinding(grid, ht.col);
  if (!dataItem || !binding) return;
  
  // (1) INSERT + 특정 binding → modal
  if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT && (binding === 'COUNTRY_NAME' || binding === 'CITY_NAME')) {
    setClickedRow(ht.row);
    setOpenRegionModal(true);
    return;
  }
  
  // (2) editable cell (편집 cell) → 기본 편집 동작
  if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;
  
  // (3) readonly cell + master row → child grid refresh
  setDetailFilters({
    divisionId: dataItem?.DIVISION_ID,
    salesSite: dataItem?.SCM_SITE_ID,
    activeFlag: dataItem?.VALID_YN,
  });
};
```

**reference**: `SalesSiteGrid.tsx:88-114`.

### §2.6 RegionModal cell (DMF0004 만)

```typescript
<RegionModal
  open={openRegionModal}
  modalClose={() => setOpenRegionModal(false)}
  setSelectedValue={setRegion}   // (country, countryName, city, cityName) callback
  country={GridUtils.getRow(gridRef.current, clickedRow)?.COUNTRY_NAME}
  city={GridUtils.getRow(gridRef.current, clickedRow)?.CITY_NAME}
/>
```

→ Region (country + city) 동시 선택. 다른 modal 과 prop 형식 다름.

**reference**: `SalesSiteGrid.tsx:130-136`.

### §2.7 FlexGrid + FlexGridColumn 직접 사용 (Phase 7 PoC 추가, 2026-06-04)

> ⚠️ **메타-룰 진화** (Phase 7 PoC DMF0008): 룰 07 §1 의 `DataGrid` wrapper 의무가 다음 케이스에서 너무 엄격함:

**조건** (FlexGrid 직접 사용 허용):
- (a) **read-only 화면** — 편집 불필요, EditTracker 미사용 (조회 전용)
- (b) **`initialized` callback 의 grid 직접 제어** 필요 (`g.isReadOnly = true` / `g.itemDoubleClick.addHandler` / 커스텀 `formatItem` 등)
- (c) **`autoGenerateColumns={false}` + 명시적 `<FlexGridColumn>` JSX** — column 정의를 코드에 직접 (`staticColumns` API 미사용)
- (d) **사용자 작업물 보존** — 이미 잘 동작하는 화면을 룰 v2 표준으로 강제 변경 X

**예시 (DMF0008 ErpEdiMaster)**:
```typescript
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { toggleClass } from '@mescius/wijmo';

// 룰 12 §11.7: 조회 전용 grid 의 모든 cell 회색 표시
const applyReadOnlyColoring = (g: FlexGridType<unknown>): void => {
  g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
    if (e.panel.cellType !== CellType.Cell) return;
    toggleClass(e.cell, 'wj-cell-non-editable', true);
  });
};

<FlexGrid<SummaryRow>
  initialized={(g) => {
    summaryGridRef.current = g;
    g.isReadOnly = true;
    g.itemDoubleClick.addHandler(() => handleSummaryDoubleClick());
    applyReadOnlyColoring(g);
  }}
  itemsSource={summaryRows}
  autoGenerateColumns={false}
>
  <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} />
  <FlexGridColumn binding='EDI_SENDER_NAME' header='EDI Sender' width={160} />
  {/* ... 명시적 column 정의 */}
</FlexGrid>
```

**reference**: `ErpEdiMaster.tsx:1-2, 21-26, 265-385`.

### §2.8 명시적 column 정의 (FlexGridColumn JSX) — Phase 7 추가

- BE `staticColumns` API 미사용 (룰 04 의 `fetchStaticColumns` 도 미적용 가능)
- column 메타가 코드에 직접 (소수 column 화면)
- 룰 08 column meta (`_inputEditType`/`_ctrlType`/`_modalKey`) 도 적용 안 됨 (read-only)

→ **DMF0008 같은 조회 전용 master 모니터링 화면에 적합**. 편집 화면 (CRUD) 은 §1 의 `DataGrid` wrapper 의무.

### §2.9 변형 선택 의사결정 표

| 화면 특성 | DataGrid wrapper (§1) | FlexGrid 직접 (§2.7) |
|---|---|---|
| 편집 (Insert/Update/Delete) | ⭐ 의무 | 부적합 |
| read-only 조회 | 가능 (allowEditing=false) | ⭐ 권장 (성능 + 유연성) |
| EditTracker 사용 | ⭐ 의무 | 사용 안 함 |
| column 메타 BE 동적 | ⭐ 의무 | 사용 안 함 |
| `initialized` callback grid 직접 제어 | 어려움 | ⭐ 권장 |
| custom `formatItem` | 어려움 | ⭐ 권장 |

→ **5+ row 의 표 의 기준**: 화면 특성 5+ 항목 중 절반 이상이 §2.7 측 = FlexGrid 직접 사용.

---

### §2.10 cell cascade 5 sub-pattern (Phase 7 PoC 추가, 2026-06-04)

> §2.4 의 정밀 확장. AS-IS DMF0008 의 `shtSALES_SITEDataModel_Changed` + `shtSSPMDataModel_Changed` + `spdSub_Changed` (5 handler) 정밀 분석 (cascade-mapping.md §3~§5) → TO-BE 패턴 5 종 정형화.
>
> **AS-IS source**: `Doc/_rules_v2/_asis/02_screens/DMF0008/cascade-mapping.md`

cascade = "한 cell 변경이 다른 cell 의 값 / 메타 / 또는 staging row 의 cascade 변경" 패턴. AS-IS FpSpread `DataModel.Changed` (CellsUpdated) → TO-BE Wijmo `cellEditEnded`.

#### §2.10.1 sub-pattern #1 — auto-derive (다른 cell 값 자동 생성)

> **reference 2 종**:
> - AS-IS DMF0008 SalesSite Branch (a) — SoldTo+Country+City 모두 입력 시 SCM_SITE_ID 자동 생성 (`_asis/02_screens/DMF0008/cascade-mapping.md` §3.1)
> - **AS-IS DMF0004 Main Branch (a) — 동일 패턴 (TO-BE 구현 사례)** — `SalesSiteGrid.tsx:72~86` `handleAutoSalesSite` + `utils/sales-site.util.ts:39~48` `applySalesSite` ⭐ (`_asis/02_screens/DMF0004/cascade-mapping.md` §1.1)

```typescript
// trigger column: ['SOLDTO_CUSTOMER', 'COUNTRY', 'CITY']
// derive: SCM_SITE_ID = SoldTo + '_' + City.substring(0,2) + '_' + City.substring(2,3)
const handleAutoDerive = (grid: FlexGrid, e: CellRangeEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[e.col]?.binding;
  const dataItem = GridUtils.getRow(grid, e.row);
  if (!['SOLDTO_CUSTOMER', 'COUNTRY', 'CITY'].includes(binding)) return;
  if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

  const so = String(dataItem.SOLDTO_CUSTOMER ?? '');
  const co = String(dataItem.COUNTRY ?? '');
  const ci = String(dataItem.CITY ?? '');
  if (!so || !co || !ci || ci.length < 5) return;

  const newSite = `${so}_${ci.substring(0, 2)}_${ci.substring(2, 5)}`;
  editTrackerRef.current?.storeChange(dataItem, 'SCM_SITE_ID', dataItem.SCM_SITE_ID, newSite);
  dataItem.SCM_SITE_ID = newSite;
  grid.refreshRange(new CellRange(e.row, 0, e.row, -1));
};
```

#### §2.10.2 sub-pattern #2 — 중복 row check (alert + revert)

> AS-IS DMF0008 SalesSite Branch (b) — SCM_SITE_ID 변경 시 grid 전체 중복 check + MSG00060 alert + revert (cascade-mapping.md §3.1)

```typescript
const handleDuplicateCheck = (grid: FlexGrid, e: CellRangeEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[e.col]?.binding;
  if (binding !== 'SCM_SITE_ID') return;

  const dataItem = GridUtils.getRow(grid, e.row);
  const newSite = String(dataItem.SCM_SITE_ID ?? '');
  const dupCount = (grid.itemsSource as ResponseData[]).filter(
    (r, idx) => idx !== e.row && String(r.SCM_SITE_ID ?? '') === newSite
  ).length;

  if (dupCount > 0) {
    void useMessageStore.getState().setAlert({
      type: 'alert',
      content: t('MSG00060', '_중복된 SCM_SITE_ID 입니다.'),
    });
    // revert
    const oldSite = editTrackerRef.current?.getOriginalValue(dataItem, 'SCM_SITE_ID') ?? '';
    editTrackerRef.current?.storeChange(dataItem, 'SCM_SITE_ID', newSite, oldSite);
    dataItem.SCM_SITE_ID = oldSite;
    grid.refreshRange(new CellRange(e.row, e.col, e.row, e.col));
  }
};
```

#### §2.10.3 sub-pattern #3 — cascade clear (parent clear → child clear)

> **reference 2 종**:
> - AS-IS DMF0008 SalesSite Branch (c)(d) — CountryName clear 시 Country + City + CityName cascade clear (`_asis/02_screens/DMF0008/cascade-mapping.md` §3.1)
> - **AS-IS DMF0007 FCST Branch (c-modify) + PSI — ActiveFlag='N' 시 모든 D_ column 'N' cascade** (`_asis/02_screens/DMF0007/cascade-mapping.md` §1.3) — ⭐ **TO-BE 구현 사례** (`CustomerFcstMasterFcstGrid.tsx:32~54` + `CustomerFcstMasterPsiGrid.tsx:32~54`)

```typescript
const handleCascadeClear = (grid: FlexGrid, e: CellRangeEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[e.col]?.binding;
  const dataItem = GridUtils.getRow(grid, e.row);

  // CountryName clear → 3 column cascade clear
  if (binding === 'COUNTRY_NAME' && !dataItem.COUNTRY_NAME) {
    ['COUNTRY', 'CITY', 'CITY_NAME'].forEach(key => {
      editTrackerRef.current?.storeChange(dataItem, key, dataItem[key], '');
      dataItem[key] = '';
    });
    grid.refreshRange(new CellRange(e.row, 0, e.row, -1));
  }

  // CityName clear → CITY cascade clear
  if (binding === 'CITY_NAME' && !dataItem.CITY_NAME) {
    editTrackerRef.current?.storeChange(dataItem, 'CITY', dataItem.CITY, '');
    dataItem.CITY = '';
    grid.refreshRange(new CellRange(e.row, 0, e.row, -1));
  }
};
```

#### §2.10.4 sub-pattern #4 — staging table sync (`dtSubBucket` 동등)

> AS-IS DMF0008 SSPM — `shtSSPMDataModel_Changed` (모든 cell update) → `SetSubSSPMData` 로 dtSubBucket 동기 (cascade-mapping.md §4)
>
> **TO-BE 매핑**: dtSubBucket = client-side staging table → **EditTracker 가 동등 기능 제공** (§2.3 + §3.4). 별도 sub-pattern 코드 불필요 — DataGrid wrapper 사용 시 자동.

```typescript
// AS-IS dtSubBucket 의 NewRow / Modify / AcceptChanges 패턴은 TO-BE 에서
// editTrackerRef.current.storeChange() 한 줄로 대체 + Save 시
// editTrackerRef.current.getChangedItems() 호출하면 dirty row 만 반환.
```

#### §2.10.5 sub-pattern #5 — combo cascade reload (다른 cell 의 combo 옵션 reload)

> **reference 2 종**:
> - AS-IS DMF0008 SSPM `spdSub_Changed` — PROJECT_CODE 또는 TEAM_ID 변경 시 SalesPlant ↔ SalesCompany combo cascade reload (`_asis/02_screens/DMF0008/cascade-mapping.md` §5)
> - **AS-IS DMF0007 `spdMain_ComboSelChange` — DeptId 변경 → CustomerCode + ScmSite 2-level cascade reload** (`_asis/02_screens/DMF0007/cascade-mapping.md` §3) — Division 분기 (40 vs 그 외) 동적 SP 호출

```typescript
// AS-IS 의 row 단위 SetCellTypeCombo 는 Wijmo 기본 미지원 — column 의 dataMap 자체를 store 와 sync.

// store 의 cascade combo state
const salesPlantOptions = useStore(state => state.salesPlantOptions);
const setSalesPlantOptions = useStore(state => state.setSalesPlantOptions);

const handleComboCascade = async (grid: FlexGrid, e: CellRangeEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[e.col]?.binding;
  const dataItem = GridUtils.getRow(grid, e.row);
  if (!['PROJECT_CODE', 'TEAM_ID'].includes(binding)) return;

  // BE SP 호출 (또는 useTabComboQueries 의 동적 filter)
  const newOptions = await apiClient.callQueryProc<MENU_ID, SHEETS.SSPM, 'salesPlant'>(
    MENU_ID, SHEETS.SSPM, {
      divisionId: dataItem.DIVISION_ID,
      projectCode: dataItem.PROJECT_CODE,
      itemId: dataItem.ITEM_ID,
    }
  );
  setSalesPlantOptions(newOptions.o_rc1);

  // column 의 dataMap 갱신 (전체 grid 의 SalesPlant cell 에 적용)
  const salesPlantCol = grid.columns.find(c => c.binding === 'SALES_PLANT');
  if (salesPlantCol) salesPlantCol.dataMap = new DataMap(newOptions.o_rc1, 'CODE', 'NAME');
  grid.refresh();
};
```

⚠️ **주의**: Wijmo column 의 `dataMap` 변경은 **전체 grid 의 해당 column 에 적용** (row 별 X). AS-IS 의 row 단위 `SetCellTypeCombo` 와 의미 차이 있음 — 필요 시 row 별 다른 옵션은 별도 column 의 cellTemplate 또는 별도 화면 redesign 권장.

#### §2.10.6 modal callback cascade (Phase 7 후속, 2026-06-04 — DMF0004 cross-check)

> **reference**: DMF0004 의 3 modal callback (`setRegion` / `setCustomers` / `setSloc`) — `_asis/02_screens/DMF0004/cascade-mapping.md` §5
>
> AS-IS combo cell + `Data.Common` lookup → TO-BE 의 modal cell + setSelectedValue 콜백 변형.

```typescript
// 1) modal cell dblClick (CRUD_TYPE='I' + 특정 binding) → modal 열기
const handleDblClick = (mouseEvent: MouseEvent) => {
  const grid = gridRef.current;
  const ht = grid.hitTest(mouseEvent);
  const dataItem = GridUtils.getRow(grid, ht.row);
  const binding = GridUtils.getBinding(grid, ht.col);
  if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      (binding === 'XXX_CODE' || binding === 'YYY_CODE')) {
    setClickedRow(ht.row);
    setOpenXxxModal(true);
  }
};

// 2) modal 의 setSelectedValue callback — 다중 cell 일괄 cascade (storeChange N 회)
const setSelectedValue = (val1, val2, ...) => {
  const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
  if (!dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;   // ⭐ CRUD_TYPE guard

  editTrackerRef.current?.storeChange(dataItem, 'COL1', dataItem.COL1, val1);
  editTrackerRef.current?.storeChange(dataItem, 'COL2', dataItem.COL2, val2);
  // ... N 회
  dataItem.COL1 = val1; dataItem.COL2 = val2; // ...

  // (선택) auto-derive 호출
  applyXxxDerive(dataItem, editTrackerRef.current);

  gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
};
```

**룰**:
- `CRUD_TYPE === CRUD_TYPE.INSERT` guard 의무 (§3.5 의 룰 동등)
- `storeChange` 다중 호출 (cell 별 1 회 — EditTracker 가 dirty 추적)
- `dataItem.COLn = valn` 동기 (storeChange 후 즉시) — Wijmo 가 refreshRange 까지 보지 못함
- 마지막 `refreshRange(new CellRange(row, 0, row, -1))` — row 전체 갱신
- auto-derive 후속 호출 가능 (예: DMF0004 setRegion → applySalesSite)

→ AS-IS cellEditEnded 직접 cascade vs TO-BE modal callback cascade 는 **architecture 차이** — 사용자 의도 cross-check 후 어느 패턴을 사용할지 결정 (메타-룰 #4 사용자 작업물 우선).

#### §2.10.7 sub-pattern #7 — 다중 row cascade propagate (Phase 7 후속, 2026-06-04 — DMF0005 cross-check)

> **reference**: DMF0005 Main Branch (c) — VMI_LT 변경 시 동일 SCM_SITE_ID + ITEM_ID 의 **모든 row 에 cascade propagate** (`_asis/02_screens/DMF0005/cascade-mapping.md` §1.3)
>
> §2.10.5 combo cascade (전체 grid column.dataMap 변경) 와 다름 — **동일 key 의 다중 row 의 특정 cell** 만 동기.

```typescript
const handleVmiLtCascade = (grid: FlexGrid, e: CellRangeEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const binding = grid.columns[e.col]?.binding;
  if (binding !== 'VMI_LT') return;

  const dataItem = GridUtils.getRow(grid, e.row);
  const items = grid.itemsSource as ResponseData[];
  const divisionId = dataItem.DIVISION_ID;
  const siteIdKey = divisionId === '40' ? 'SCM_SITE_ID40' : 'SCM_SITE_ID';   // Division 분기
  const siteId = String(dataItem[siteIdKey] ?? '');
  const itemId = String(dataItem.ITEM_ID ?? '');
  const newVmiLt = Number(dataItem.VMI_LT);

  grid.deferUpdate(() => {
    items.forEach((other, idx) => {
      if (idx === e.row) return;
      const otherSiteId = String(other[siteIdKey] ?? '');
      const otherItemId = String(other.ITEM_ID ?? '');
      if (otherSiteId === siteId && otherItemId === itemId) {
        editTrackerRef.current?.storeChange(other, 'VMI_LT', other.VMI_LT, newVmiLt);
        other.VMI_LT = newVmiLt;
      }
    });
    grid.refresh();
  });
};
```

**룰**:
- `grid.deferUpdate(() => {...})` 의무 (다중 row 변경 = cascade 재발생 가능)
- 동일 key 식별 — composite key 가 명확해야 함 (예: SCM_SITE_ID + ITEM_ID)
- Division 같은 분기 logic 보존 (AS-IS 의 `SCM_SITE_ID40` vs `SCM_SITE_ID`)
- 각 row 별 `storeChange` 호출 (EditTracker dirty 추적)
- 마지막 `grid.refresh()` — 다중 row UI 갱신

→ §2.10.5 combo cascade 의 변형이 아닌 **독립 sub-pattern** — column 의 dataMap 이 아닌 row 의 cell 값 sync.

#### §2.10.8 cascade 안 cascade 방지 (`deferUpdate`)

```typescript
const handleEdit = (grid: FlexGrid, e: CellRangeEventArgs) => {
  grid.deferUpdate(() => {
    handleAutoDerive(grid, e);
    handleDuplicateCheck(grid, e);
    handleCascadeClear(grid, e);
    void handleComboCascade(grid, e);
  });
};

// or 명시적 batch:
grid.beginUpdate();
try { /* cascade ... */ } finally { grid.endUpdate(); }
```

→ cascade 안 cascade 발생 시 `grid.refresh()` 가 무한 루프 + `cellEditEnded` 재귀 발생. `deferUpdate` 가 1 batch 안에서 cascade 묶음.

#### §2.10.7 변형 선택 의사결정 표

| AS-IS handler 패턴 | TO-BE sub-pattern | 룰 cross-ref |
|---|---|---|
| DataModel.Changed (CellsUpdated) | `cellEditEnded` | §2.4 |
| 다른 cell 값 자동 생성 | §2.10.1 auto-derive | EditTracker.storeChange |
| 중복 row check + MSG | §2.10.2 duplicate-check | useMessageStore.setAlert + revert |
| parent clear → child clear | §2.10.3 cascade-clear | 다중 storeChange |
| staging table (dtSubBucket) | §2.10.4 staging | EditTracker 가 자동 (별도 코드 X) |
| SetCellTypeCombo (row 단위 combo) | §2.10.5 combo-cascade | column.dataMap (전체 grid) + 의미 차이 주의 |
| cascade 안 cascade | §2.10.6 deferUpdate | beginUpdate/endUpdate |

→ **검증**: AS-IS DataModel.Changed (CellsUpdated) handler 가 발견되면 §2.10.1~5 중 어느 sub-pattern 인지 분류 후 TO-BE 적용.

#### §2.10.8 PR 머지 게이트 grep

```bash
# AS-IS 의 DataModel.Changed handler 발견 시 TO-BE cellEditEnded + sub-pattern 구현 확인
rg -nU "DataModel\.Changed|SetCellTypeCombo|GetMaxRowIndex.*for|SetValue.*\.SetText" {asis-cs} | head -50
rg -nU "cellEditEnded|storeChange|deferUpdate" {tobe-tsx}
```

→ AS-IS handler 수 vs TO-BE cellEditEnded 수 cross-check (PR 머지 게이트 권장).

---

## §3 금지 (anti-pattern)

### §3.1 FlexGrid 직접 import / 사용

**금지**:
```typescript
import { FlexGrid } from '@mescius/wijmo.react.grid';   ❌
<FlexGrid itemsSource={data} columns={...} />
```

**의무**:
```typescript
import { type FlexGrid } from '@mescius/wijmo.grid';   ✅ (type only, ref 용도)
<DataGrid<T> gridRef={...} itemsSource={data} staticColumns={...} />
```

**사유**: `DataGrid` (`@shared/components`) wrapper 가 EditTracker / 필터 / 편집 추적 / 머지 / 컬럼 메타 자동 처리. FlexGrid 직접 사용 시 모든 패턴 수동 작성 = 사고 다수.

### §3.2 FlexGridColumnGroup JSX single-child

**금지** (메모리 `feedback_wijmo_columngroup_jsx_avoid.md`):
```typescript
<FlexGridColumnGroup header="YYYY">
  <FlexGridColumn binding="MM" />   ❌ single leaf
</FlexGridColumnGroup>
```

**대안**:
- leaf 2 개 이상 두기
- 또는 group 제거 + leaf 헤더에 group 정보 명시
- 또는 imperative API (`grid.columnGroups.push(new ColumnGroup({...}))`)

→ React 19 + wijmo.react.grid wrapper 의 single-child 폭발 사고 (DMF0043). PR 직전 grep 검출.

### §3.3 console.log / inline style 잔존

**금지**:
- `console.log` (lint fail)
- `style={{...}}` inline (SCSS Module 사용)

### §3.4 cellEditEnded 의 storeChange 누락

**금지**:
```typescript
const handleEdit = (grid, e) => {
  dataItem.FIELD = newVal;   ❌ EditTracker 추적 없음 → save 시 누락
  grid.refreshRange(...);
};
```

**의무**:
```typescript
editTrackerRef.current?.storeChange(dataItem, 'FIELD', oldVal, newVal);   ✅
dataItem.FIELD = newVal;
grid.refreshRange(new CellRange(row, 0, row, -1));
```

### §3.5 CRUD_TYPE 가드 누락 (Modal cell)

**금지**:
```typescript
if (binding === 'COUNTRY_NAME') {   ❌ CRUD_TYPE 가드 없음 → 조회 row 도 modal 열림
  setOpenRegionModal(true);
}
```

**의무**:
```typescript
if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT && binding === 'COUNTRY_NAME') {   ✅
  setOpenRegionModal(true);
}
```

→ 메모리 `feedback_grid_popup_cell_mandatory.md`.

### §3.6 NUMBER → string 변환 누락 (메모리 사고 사례)

**금지** (DMF0043 YEAR 콤보 사고):
```typescript
// Oracle NUMBER 컬럼을 JS number 그대로 전달
<CustomDropdown value={row.YEAR} ... />   ❌ value.trim() 폭발
```

**의무**:
```typescript
<CustomDropdown value={String(row.YEAR)} ... />   ✅
```

→ 메모리 `feedback_no_type_cast_around_runtime.md`.

### §3.7 PIVOT 화면의 frozenColumns 누락

**금지** (메모리 `feedback_pivot_frozen_columns.md`):
- 동적 컬럼 화면 (DMF0007 dateColumns) 에서 BASE 정적 컬럼 frozen 누락 → 가로 스크롤 시 BASE dimension 사라짐

**의무**:
```typescript
<DataGrid
  staticColumns={baseColumns}
  dynamicColumns={dateColumns}
  // (DataGrid 안에서 자동) g.frozenColumns = BASE_COLUMNS.length
/>
```

→ Wijmo merge sticky content 와 함께 룰 12 §11.6 참조.

### §3.8 useMemo 누락 (modal preSearchParams)

**금지**:
```typescript
<Modal preSearchParams={{ ...searchParams }} />   ❌ 매 render 새 객체 → refetch loop
```

**의무**:
```typescript
const preSearchParams = useMemo(() => ({ ...searchParams }), [searchParams]);
<Modal preSearchParams={preSearchParams} />   ✅
```

→ 메모리 `feedback_popup_dialog_layout.md` Refetch loop (DMF0020).

---

## §4 자동 검증 (PR 머지 게이트)

```bash
GRID="features/{domain}/src/pages/{screen}/components/{Name}Grid.tsx"

# 1. DataGrid 사용 + FlexGrid 직접 사용 금지
grep -c "<DataGrid" "$GRID"  # ≥ 1
grep -c "from '@mescius/wijmo.react.grid'" "$GRID"  # = 0

# 2. EditTracker.storeChange + refreshRange 표준
grep -c "editTrackerRef.current?.storeChange" "$GRID"  # ≥ 1 (modal callback 시)
grep -c "refreshRange(new CellRange" "$GRID"  # ≥ 1

# 3. dblClick handler 표준 (hitTest + getRow + getBinding)
grep -c "grid.hitTest" "$GRID"  # ≥ 1 (modal cell 시)
grep -c "GridUtils.getBinding" "$GRID"  # ≥ 1
grep -c "GridUtils.getRow" "$GRID"  # ≥ 1

# 4. CRUD_TYPE 가드 의무 (modal cell)
awk '/setOpenModal/,/return/' "$GRID" | grep -c "CRUD_TYPE"  # ≥ 1 (modal open 시 CRUD_TYPE 가드)

# 5. FlexGridColumnGroup single-child 검출
awk '/<FlexGridColumnGroup/,/<\/FlexGridColumnGroup>/' "$GRID" | grep -c "<FlexGridColumn "  # ≥ 2 또는 그룹 사용 안 함

# 6. console.log / inline style 검출
grep -nE "console\.log|style=\{\{" "$GRID" | wc -l  # = 0

# 7. NUMBER → String 변환 (cross-check Form / Grid 의 value prop)
# (수동 검토 — Oracle NUMBER 컬럼이 value 로 직접 전달 안 되도록)

# 8. useMemo preSearchParams (Modal)
grep -A 3 "<.*Modal\b" "$GRID" | grep -n "preSearchParams=\{\{ \.\.\." # 사용 시 useMemo 권장
```

---

## §5 AS-IS 매핑

| AS-IS Spread (FpSpread) | TO-BE DataGrid |
|---|---|
| `siMain = AddSheet(spdMain, "Main", 1, N, ...)` | `<DataGrid gridRef itemsSource staticColumns />` |
| `spdMain.CellDoubleClick` event | `dblClick={handleGridDblClick}` |
| `spdMain.EditChange` event | `cellEditEnded={handleX}` |
| `spdMain.ComboSelChange` | (TO-BE column meta DataMap 자동) |
| `siMain.LockColumn / LockRange` | column meta `_inputEditType` (룰 08) |
| `siMain.SetBGColor / SetBGColor2` | `.wj-cell-editable / .wj-cell-non-editable` CSS (DataGrid 자동) |
| `siMain.SetValue` (Auto-Sync) | `cellEditEnded` handler + `editTrackerRef.storeChange` |
| `siMain.AllowMerging = MergePolicy.Cells` | `allowMerging={AllowMerging.Cells}` |
| `siMain.SmartColMerge` | `HierarchicalMergeManager` (룰 12 §11.6) |
| `cellTypeImage` (popup icon) | column meta `_ctrlType: 'FPModal'` + dblClick handler |
| `spdMain.HitTest(e.X, e.Y)` | `grid.hitTest(mouseEvent)` |
| `siMain.GetValue(row, "BINDING")` | `GridUtils.getRow(grid, row).BINDING` |
| `siMain.Query(ds)` (조회) | `useTabProcQuery` 자동 refetch |
| `IsChange = true` (변경 추적) | `EditTracker` 자동 |

---

## §6 reference file:line 인용

| 패턴 | reference |
|---|---|
| 표준 Grid (modal cell + EditTracker) | `CustomerModelMappingGrid.tsx` (157 lines) |
| Grid + AllowMerging + cellEditEnded cascade | `SalesSiteGrid.tsx` (140 lines) |
| Grid + dynamicColumns + cascade D_ | `CustomerFcstMasterFcstGrid.tsx` (67 lines) |
| Modal callback 3 단계 (storeChange + dataItem[X] + refreshRange) | `CustomerModelMappingGrid.tsx:38-61` |
| dblClick handler 표준 | `CustomerModelMappingGrid.tsx:92-110`, `SalesSiteGrid.tsx:88-114` |
| CRUD_TYPE.INSERT 가드 (Modal cell) | `SalesSiteGrid.tsx:99-101` |
| cellEditEnded cascade VALID_YN='N' → D_ | `CustomerFcstMasterFcstGrid.tsx:32-54` |
| cellEditEnded auto sync SOLDTO/COUNTRY/CITY | `SalesSiteGrid.tsx:72-86` |
| dblClick → setDetailFilters | `SalesSiteGrid.tsx:107-113` |
| EditTracker ref parent prop | `CustomerFcstMasterFcstGrid.tsx:14-19` |

---

## §8 selectionMode + useCheckbox 표준 (2026-06-06 신규)

### §8.1 매트릭스

| 화면 유형 | selectionMode | useCheckbox | 사유 |
|---|---|---|---|
| 단일 row 선택 (검색/CRUD 대상 1행) | **`SelectionMode.Row` 명시 의무** | (X) | 클릭으로 row 전체 하이라이트 + `grid.selectedRows` populated |
| 다중 row 선택 (체크박스) | (default `MultiRange`) | **`useCheckbox`** | Wijmo Selector 가 `row.isSelected` toggle |
| 셀 편집 | `MultiRange` (default) | (X) | 셀 범위 선택 + 편집 |

### §8.2 표준 import

```typescript
import { SelectionMode } from '@mescius/wijmo.grid';

<DataGrid<MyRow>
  staticColumns={cols}
  selectionMode={SelectionMode.Row}    // ⭐ 단일 row 선택 의무
  isReadOnly
/>
```

### §8.3 anti-pattern

```typescript
// ❌ 단일 row 선택 의도인데 selectionMode 미명시
<DataGrid<AuthorityRow> staticColumns={cols} isReadOnly />
// → default MultiRange → 셀 클릭만 선택, row 전체 하이라이트 안 됨
// → grid.selectedRows.length === 1 이지만 사용자는 "선택 안 됨" 으로 인지
```

### §8.4 사고 사례

| 사례 | 결과 |
|---|---|
| SCM0008 Authority grid (2026-06-06) | selectionMode 미명시 → row 클릭 시 시각 하이라이트 안 됨 → 사용자 보고 "선택 안 됨" → ADD 버튼 클릭 시 selectedAuthority undefined |

### §8.5 cross-ref

- hook `grid-interaction-patterns.md` §1
- 메모리 `feedback_grid_selectionmode_row_for_row_click`

---

## §9 서버 데이터 기반 row.isSelected 자동 setting 금지 (2026-06-06 신규)

### §9.1 원칙

- **Checkbox state = 사용자 의도** (action 대상)
- **Server data (APPROVAL_RESULT / IS_ACTIVE / STATUS etc.) ≠ checkbox state**

### §9.2 anti-pattern

```typescript
// ❌ 금지
useEffect(() => {
  for (...) {
    if (item.APPROVAL_RESULT === 'APPROVED') row.isSelected = true;
  }
}, [data]);
```

→ 페이지 진입 시 다수 row 자동 체크 → 사용자가 추가 row 체크 후 Delete 클릭 시 의도치 않은 row 까지 삭제.

### §9.3 허용

- 사용자 액션 직후 표시 (recently-added 패턴 §10) ✓

### §9.4 cross-ref

- hook `grid-interaction-patterns.md` §3
- 메모리 `feedback_no_auto_check_on_server_state`

---

## §10 Recently-Added row 표시 (loadedRows event + ref) (2026-06-06 신규)

### §10.1 사고

useEffect 단독으로 row.isSelected 갱신 시 grid.rows 가 OLD data → 매칭 0건. Wijmo grid 가 새 data 처리 후 row 갱신은 다음 frame.

### §10.2 표준 패턴 (3 요소)

```typescript
import { useEffect, useRef, type MutableRefObject } from 'react';
import type { FlexGrid } from '@mescius/wijmo.grid';

const recentKeysRef = useRef<Set<string> | undefined>(recentlyAddedKeys);
recentKeysRef.current = recentlyAddedKeys;                  // ← 매 render 마다 ref.current 갱신
const handlerInstalledRef = useRef(false);

const applyRowSelection = (grid: FlexGrid) => {
  const recent = recentKeysRef.current;
  for (let i = 0; i < grid.rows.length; i += 1) {
    const row = grid.rows[i];
    if (!row?.dataItem) continue;
    const key = `${item.PK1}::${item.PK2}`;
    row.isSelected = recent ? recent.has(key) : false;
  }
};

useEffect(() => {
  const grid = gridRef.current;
  if (!grid) return;
  if (!handlerInstalledRef.current) {
    grid.loadedRows.addHandler((s: FlexGrid) => applyRowSelection(s));  // ⭐ Wijmo event
    handlerInstalledRef.current = true;
  }
  applyRowSelection(grid);                                              // 즉시 호출 + 다음 loadedRows 도
}, [data, recentlyAddedKeys]);
```

**3 요소**:
1. `recentKeysRef.current = recentlyAddedKeys` 매 render 갱신
2. `grid.loadedRows.addHandler` — Wijmo grid 가 새 row 로딩 후 발화
3. `handlerInstalledRef` — handler 1 회만 install

### §10.3 부모 onSuccess

```typescript
mutateXxx(rows, {
  onSuccess: () => {
    setRecentlyAddedKeys(new Set(addedKeys));
    void queryClient.invalidateQueries({ queryKey: [tabId] });  // refetch → loadedRows 발화
    setToast({ ... });
  },
});
```

### §10.4 cross-ref

- hook `grid-interaction-patterns.md` §4
- hook `mutation-onsuccess-defaults.md`
- 메모리 `feedback_recently_added_loadedrows_pattern`

---

## §11 staticColumns 출처 표준 (2026-06-09 신규)

### §11.1 의무 매트릭스

| 화면 유형 | staticColumns 출처 |
|---|---|
| 표준 조회 grid (SHEET_COLUMNS 메타 있음) | **store fetchStaticColumns** (`RawFlexGridColumnConfig[]`) |
| 동적 column (사용자 SQL 실행 결과 등) | **useMemo + data[0] keys** |
| 하드코딩 `[{binding, header, width}]` | ❌ **금지** |

### §11.2 표준 #1: store fetchStaticColumns

```typescript
const staticColumns = useStore(s => s.staticColumns[SHEETS.MAIN]);

<DataGrid staticColumns={staticColumns} ... />
```

→ `useStore` 가 BE `/admin/menu/{menuId}/column` 호출 결과 (`RawFlexGridColumnConfig[]`) 반환.

### §11.3 표준 #2: 동적 column (data[0] keys)

```typescript
import { useMemo } from 'react';
import type { RawFlexGridColumnConfig } from '@foundation/models';

const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
  if (!data || data.length === 0) return [];
  const first = data[0] as Record<string, unknown>;
  return Object.keys(first).map((key, idx) => ({
    COLUMN_NAME: key,
    COLUMN_LABEL_NAME: key,
    SORT_ORDER_NO: (idx + 1) * 10,
    COLUMN_WIDTH: 120,
    FIXED_FLAG: 'N',
    VISIBLE_FLAG: 'Y',
    HORIZONTAL_ALIGN_CODE: 'Left',
    CELL_CONTROL_OBJECT_TYPE_CODE: 'S',
    VALID_YN: 'Y',
    DISPLAY_FLAG: 'Y',
  })) as RawFlexGridColumnConfig[];
}, [data]);

<DataGrid staticColumns={staticColumns} ... />
```

→ 사용자 SQL 실행 결과처럼 컬럼 shape 가 동적인 경우. **DISPLAY_FLAG='Y' 의무** (DataGrid wrapper 의 `.filter(c => c.display)` 통과 위해).

### §11.4 anti-pattern (절대 금지)

```typescript
// ❌ SCM0005 초기 사고 — 하드코딩 {binding, header, width}
<DataGrid staticColumns={[
  { binding: 'QUERY_ID', header: 'Query ID', width: 100 },
  ...
]} />
```

→ DataGrid wrapper 의 `mapRawColumnsToWijmoColumns(staticColumns.filter(c => c.display))` 가 `display='Y'` 인 row 만 통과 → 하드코딩 형식 (display 필드 없음) → **column 0개 렌더**.

### §11.5 PRE-WRITE 자기 점검

```
☐ 화면이 표준 조회 grid 인가? → store fetchStaticColumns
☐ 사용자 SQL/동적 query 결과인가? → useMemo + data[0] keys 패턴 (DISPLAY_FLAG='Y' 의무)
☐ 하드코딩 {binding, header} 사용 0건?
```

### §11.6 POST-WRITE grep

```bash
# 하드코딩 staticColumns 검출 (위반 패턴)
grep -rE "staticColumns=\{\[\s*\{\s*binding:" nscm-fe/features/
# = 0 의무
```

### §11.7 cross-ref

- hook `sheet-columns-binding-match.md`
- 메모리 `feedback_grid_no_hardcoded_static_columns`, `feedback_dynamic_grid_columns_pattern`
- 사고: SCM0005 5 grid (2026-06-09)

---

## §12 Insert cell ComboBox dropdown 표준 (2026-06-07 신규, DMF0003)

> **DMF0003 (MKT FCST) 누적 보완사항 일반화** — Insert row 의 dropdown cell 적용 시 12 단계 보완사항을 1-pass 의무.
> 자매 reference: `features/master/src/pages/sales-future-price/components/SalesFuturePriceFlexGrid.tsx`
> 상세: hook `wijmo-insert-cell-dropdown.md`

### §12.1 ❌ 절대 금지 (Anti-pattern, DMF0003 사고 5건)

| # | 금지 | 사고 | 정확 패턴 |
|---:|---|---|---|
| 1 | `<FlexGrid selectionMode='Row'>` | single click cell 진입 차단 → dropdown 미표시 | 미명시 (default `'MultiRange'`) |
| 2 | `g.columnLayout = JSON.stringify(...)` imperative | columns 재생성 시 column.dataMap reset | JSX `<FlexGridColumn>` 평면 |
| 3 | useEffect 안 `new DataMap(...)` 매번 | wijmo column stale state | `dataMaps = useMemo(...)` memoize |
| 4 | `g.startEditing(true, 0, 0)` (col 0 read-only) | editor 진입 안 됨 | 첫 editable col (`_inputEditType: 'IM'\|'IO'`) 자동 찾기 |
| 5 | `initialized` 에서 `new FlexGridFilter(g)` 자동 attach | column header filter icon 항상 표시 | F4 button 누름 시에만 attach |

### §12.2 ✅ 정확한 패턴 (자매 DMF0020 동등)

```tsx
// Master.tsx
const [endCustomersData, sitesData, ...] = useTabComboQueries({
  filters: [
    'EndCustomerByDivisionDept',   // 자매 검증 SQL (변수 없거나 @sesUserId 만)
    'SiteByEndCustomer',
    'Incoterms',
    { comboId: 'FcstType', divisionId: sc.divisionId },        // @divisionId 사용 SQL = 객체
    { comboId: 'CustomsHandbook', divisionId: sc.divisionId },
    'PlantSite',
    'Measure',
  ],
});

// comboData → column binding (UPPER) 별 직접 매핑
const comboData: Record<string, ComboItem[]> = useMemo(() => ({
  END_CUSTOMER:   (endCustomersData ?? []) as ComboItem[],
  SCM_SITE_ID:    (sitesData ?? []) as ComboItem[],
  INCOTERMS:      (incotermsData ?? []) as ComboItem[],
  FCST_TYPE:      (fcstTypeData ?? []) as ComboItem[],
  DOM_EXP:        (customsHandbookData ?? []) as ComboItem[],
  PLANT_SITE_ID:  (plantSiteData ?? []) as ComboItem[],
  MEASURE:        (measureData ?? []) as ComboItem[],
}), [endCustomersData, sitesData, incotermsData, fcstTypeData, customsHandbookData, plantSiteData, measureData]);
```

```tsx
// Grid.tsx
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

return (
  <FlexGrid
    itemsSource={collectionView}
    autoGenerateColumns={false}
    allowSorting={true}
    headersVisibility='Column'
    // selectionMode 미명시 (default 'MultiRange')
    frozenColumns={FROZEN_COL_COUNT}
    beginningEdit={beginningEdit}
    formatItem={formatItem}
    initialized={(g) => {
      gridInstanceRef.current = g;
      // 3-row header (자매 DMF0020 패턴)
      if (g.columnHeaders.rows.length === 1) {
        g.columnHeaders.rows.push(new Row());
        g.columnHeaders.rows.push(new Row());
      }
      g.columnHeaders.rows.defaultSize = 24;
      g.mergeManager = mergeManager;
    }}
  >
    {fixedColumns.map(c => (
      <FlexGridColumn
        key={c.key}
        binding={c.key}
        header={c.header}
        width={c.width}
        align={...}
        isReadOnly={c._inputEditType === 'S'}
        dataMap={dataMaps[c.key] ?? undefined}   // ← React wrapper 자동 매핑
      />
    ))}
    {dynamicColumns.map(c => (
      <FlexGridColumn key={c.key} binding={c.key} header={c.key} width={60} align='right' />
    ))}
  </FlexGrid>
);

// 보완: useEffect 안 imperative dataMap 적용 + invalidate (이중 보장)
useEffect(() => {
  const g = gridInstanceRef.current;
  if (!g) return;
  for (const col of g.columns) {
    const dm = dataMaps[col.binding ?? ''];
    if (dm) col.dataMap = dm;
  }
  g.invalidate(true);
}, [dataMaps, fixedColumns, dynamicColumns]);
```

### §12.3 handleInsert 표준

```tsx
const handleInsert = () => {
  const newRow = markRowAsInserted({ DIVISION_ID: sc.divisionId, ... });
  setInsertedRows(prev => [newRow, ...prev]);
  setTimeout(() => {
    const g = gridRef.current;
    if (!g) return;
    g.scrollIntoView(0, 0);
    // 첫 editable col 자동 찾기 (DIVISION_ID 등 read-only 회피)
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
    g.startEditing(true, 0, firstEditableCol);  // ComboBox 즉시 펼침
  }, 50);
};
```

### §12.4 Sort / Filter button hotkeyConfig

```tsx
const handleSort = () => {
  const g = gridRef.current;
  if (g) GridAction.toggleColumnSort(g);
};
const handleFilter = () => {
  const g = gridRef.current;
  if (!g) return;
  if (!gridFilterRef.current) {
    gridFilterRef.current = new FlexGridFilter(g);  // 첫 누름 — attach
    return;
  }
  GridAction.toggleColumnFilter(g, gridFilterRef.current);  // 이후 — toggle
};

const hotkeyConfig: HotkeyConfig = {
  search: handleSearch, insert: handleInsert, save: handleSave, delete: handleDelete,
  sort: handleSort, filter: handleFilter,  // ← 명시 의무 (button click 동작 보장)
};
```

### §12.5 자동 검증 grep (PR 머지 게이트)

```bash
# 5 anti-pattern 검출 (모두 0 의무)
grep -rn "selectionMode=['\"]Row['\"]" features/*/src/pages/*/components/*.tsx
grep -rn "\.columnLayout\s*=" features/*/src/pages/*/components/*.tsx
grep -rn "new DataMap" features/*/src/pages/*/components/*.tsx | grep -v useMemo
grep -rn "startEditing.*,\s*0,\s*0)" features/*/src/pages/*/*.tsx
grep -rn "new FlexGridFilter" features/*/src/pages/*/components/*.tsx | grep "initialized"
```

### §12.6 cross-ref

- hook `wijmo-insert-cell-dropdown.md` (12 단계 상세)
- hook `localstorage-persist-pattern.md` (Measure 등 화면 close 후에도 유지 필요한 state)
- 메모리: `feedback_wijmo_jsx_over_columnlayout`, `feedback_wijmo_selection_mode_default`, `feedback_cmbo_sql_at_division_param`, `feedback_localstorage_persist_callback`
- 자매 reference: `features/master/src/pages/sales-future-price/components/SalesFuturePriceFlexGrid.tsx:65-432`

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 Grid 통합 분석 + 사고 사례 (Wijmo group / NUMBER cast / refetch loop) 반영 |
| 2026-06-06 | §8 selectionMode + useCheckbox / §9 자동 체크 금지 / §10 Recently-Added loadedRows 패턴 신설 | SCM0008 Auth Request 4 사고 묶음 |
| 2026-06-09 | §11 staticColumns 출처 표준 (store fetchStaticColumns + 동적 column useMemo + 하드코딩 금지) 신설 | SCM0005 DynamicQuery 5 grid column 0개 사고 |
| 2026-06-07 | §12 Insert cell ComboBox dropdown 표준 (12 단계 보완사항) | DMF0003 MKT FCST Insert dropdown 5 사고 묶음 |
