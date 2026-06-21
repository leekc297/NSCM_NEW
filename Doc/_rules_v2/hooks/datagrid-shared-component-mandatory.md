# Hook — DataGrid 공용 컴포넌트 + Foundation Utils 의무 (Grid 작업 표준)

> **Trigger**: T01 (신규 화면 / 화면 수정) + T04 (Grid / 컬럼 / dropdown / 체크박스 / DataGrid)
> **Master reference**: `nscm-fe/features/master/src/pages/sales-site/` (DMF0004)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등) — 위반 시 머지 차단
> **신설일**: 2026-06-18 (자가 진화 #20, 사용자 명시 — "DMF0004 처럼 이미 만들어진 객체 모든 기능 사용 의무")

## 0. 사고 배경

| 사고 | Root cause | 영향 |
|---|---|---|
| 2026-06-17 DataGrid `autoGenerateColumns={false}` 전역 사고 | 1 화면 fix 목적으로 shared DataGrid 의 default 변경 → 모든 화면 grid 컬럼 0 | 전체 화면 grid 미동작 (메모리 `feedback_shared_global_prop_change_forbidden.md`) |
| 2026-06-12 DMF0020 PROJECT_STATUS 미반영 | FlexGrid 직접 사용 (DataGrid wrap 안 함) → `staticColumns` 동적 fetch + `useTabComboQueries` 인프라 무력화 | 컬럼 admin 변경 무반영 (메모리 `feedback_wijmo_direct_static_columns.md`) |
| 2026-06-12 SYS0014 dropdown editor 미동작 | 화면별 자체 column 정의 → `cellCboDataTp` 메타 무시 | dropdown 영구 차단 (메모리 `feedback_column_lookup_meta_standard.md`) |
| 2026-06-11 DMF0043 columnGroup JSX | `<FlexGridColumnGroup>` 직접 작성 → React 19 + wijmo.react.grid 단일 child 폭발 | `_setOwnerList is not a function` (메모리 `feedback_wijmo_columngroup_jsx_avoid.md`) |

**결론**: shared DataGrid 공용 컴포넌트 + Foundation Utils 가 이미 모든 표준 기능을 제공함에도 화면별 직접 작성 → 인프라 무력화 + 신뢰성 손상 반복.

## 1. 원칙 (불변)

1. **신규 화면 Grid 작성 시 `@shared/components` 의 `DataGrid` 컴포넌트만 사용**. `@mescius/wijmo.react.grid` 의 `<FlexGrid>` / `<FlexGridColumnGroup>` / `<FlexGridColumn>` JSX 직접 사용 절대 금지.
2. **shared/* default 변경 절대 금지** — 새 prop 추가 시에도 기본 동작 보존. 메모리 `feedback_shared_global_prop_change_forbidden.md`.
3. **`@foundation/utils` 4종 (GridUtils / GridAction / EditTracker / CustomMergeManager) 직접 활용**. 화면별 재구현 금지.
4. **화면별 Grid 컴포넌트는 wrap 만** — props 주입 + 이벤트 핸들러 + 화면 전용 로직 (drill-down filter / cell modal) 정도만 작성.
5. **DataGrid 가 제공하지 않는 기능이 필요하면**: shared 추가 prop 으로 추출 → 다른 화면 regression 0 cross-check → PR 분리. 화면 안 ad-hoc 우회 금지.

## 2. 표준 시그니처 (DMF0004 SalesSiteGrid reference)

```tsx
// nscm-fe/features/master/src/pages/sales-site/components/SalesSiteGrid.tsx
import { AllowMerging, type FlexGrid, type CellRangeEventArgs, CellRange } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

interface SalesSiteGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SITE>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SITE, RESPONSE_SET.SITE>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: SalesSiteGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SITE>> | undefined>();
  const staticColumns = useSalesSiteStore(state => state.staticColumns);

  // 화면 전용 핸들러 (drill-down / auto-sync 등) 만 정의
  const handleFocus = () => setActiveTab(SHEET_INDEX.SITE);
  const handleAutoSalesSite = (grid, args) => { /* ... */ };
  const handleGridDblClick = (mouseEvent) => { /* ... */ };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SITE>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.SITE]}  // ← admin 동적 fetch
      allowMerging={AllowMerging.Cells}                  // ← Wijmo 머지
      alternatingRowStep={0}
      gotFocus={handleFocus}
      cellEditEnded={handleAutoSalesSite}
      dblClick={handleGridDblClick}
    />
  );
};
```

> **핵심**: 화면별 컴포넌트는 ~60 lines. DataGrid 가 모든 인프라 처리.

## 3. DataGrid 가 자동 제공하는 14 기능 (재구현 금지)

> Source: `packages/shared/src/components/organisms/data-grid/DataGrid.tsx` + `dataGridUtils.ts`

| # | 기능 | 활성 조건 | 처리 위치 |
|---:|---|---|---|
| 1 | Combo 컬럼 자동 fetch | `cellCtrlObjTpCd === 'COMBO'` + `cellCboDataTp` (SQL_ID) | `useTabComboQueries({ filters: comboIds })` |
| 2 | Raw column → Wijmo column 매핑 | 항상 (staticColumns.filter display) | `mapRawColumnsToWijmoColumns()` |
| 3 | Frozen columns 자동 계산 | `_fixed` flag 마지막 index + 1 | `findLastIndex` |
| 4 | FlexGridFilter 자동 생성 | `gridFilterRef` 주입 시 | `handleInitialized` |
| 5 | EditTracker 자동 생성 | `editTrackerRef` 주입 (또는 미주입) | `new EditTracker(grid)` |
| 6 | CustomMergeManager 자동 적용 | `allowMerging !== None` + `mergeManager` 미주입 | `grid.mergeManager = new CustomMergeManager(grid)` |
| 7 | 편집 가능 셀 시각 표시 | 항상 | `formatEditableColumns` (필수 컬럼 / popup 셀 / CRUD status) |
| 8 | 정렬 컬럼 시각 표시 | `allowSorting` 컬럼 | `formatSortableColumns` (icon span) |
| 9 | 편집 제어 (begin/paste) | 항상 | `setEditableColumns` (MODAL 시 cancel + isEditableCell 분기) |
| 10 | Tab 키 자동 이동 | 항상 | `setMoveCellByTab` |
| 11 | Ctrl+Arrow 이동 | 항상 | `setMoveByMetakey` |
| 12 | 정렬 헤더 클릭 토글 | 항상 | `setSortableColumnHeaderClick` |
| 13 | 대문자 자동 변환 | `_uppercase` flag | `setHandleUppercase` |
| 14 | RowHeader (index + status) | `!isReadOnly` | `rowHeaders.columns.push(new Column)` |

**선택 활성** (prop true 시):
- `useSummaryTooltip` — 다중 셀 선택 시 Count/Avg/Sum tooltip
- `useAggregationRow` — 집계 row (위/아래)
- `useCheckbox` — Selector
- `useResultColumns` — week/month/day 마지막 result 컬럼 강조

## 4. 화면별 주입 슬롯 (props 16종)

```tsx
interface DataGridProps<T extends WijmoRowItem = WijmoRowItem> extends FlexGridProps {
  // ref 4종 — 화면에서 useRef 로 생성 후 주입
  gridRef?: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<T> | undefined>;

  // 데이터 + 컬럼 메타
  itemsSource?: T[];                       // SP 응답
  staticColumns?: RawFlexGridColumnConfig[];   // admin 동적 fetch (store)
  dynamicColumns?: FlexGridColumnConfig[];     // PIVOT 동적 컬럼 (BE SP)

  // 기능 토글
  useSummaryTooltip?: boolean;     // default true
  useCheckbox?: boolean;           // default false
  useResultColumns?: boolean;      // default false
  useAggregationRow?: boolean;     // default false
  aggregationRowPlacement?: 'above' | 'below';  // default 'below'
  allowMerging?: AllowMerging;     // default ColumnHeaders
  selectionMode?: SelectionMode;   // default MultiRange

  // 이벤트 핸들러 (화면 전용 로직)
  dblClick?: (mouseEvent: MouseEvent) => void;
  click?: (mouseEvent: MouseEvent) => void;
  gotFocus?: (sender: Control, args: EventArgs) => void;
  // + FlexGridProps 전체 (cellEditEnded / formatItem / itemsSourceChanged 등)
}
```

> **금지**: `<FlexGridColumnGroup>` + `<FlexGridColumn>` JSX 직접 작성. column 정의는 `staticColumns` (admin DB) + `dynamicColumns` (BE SP) 두 prop 으로만.

## 5. `@foundation/utils` 4종 활용 의무

### 5.1 `GridUtils` (객체 — 항상 import)
```tsx
import { GridUtils } from '@foundation/utils';

GridUtils.getRow(grid, rowIndex)          // 안전 dataItem 추출 (null guard)
GridUtils.getBinding(grid, colIndex)      // column.binding
GridUtils.getColumn(grid, colIndex)       // FlexGridColumnConfig (metadata 포함)
GridUtils.getSelectedRows(grid)           // 선택 row 배열
GridUtils.getNextSortOrd(grid)            // 다음 정렬 순번
GridUtils.isEditableCell(grid, row, col)  // 편집 가능 분기 (CRUD_TYPE + INPUT_TP_CD 4 분기)
```

> 신규 화면에서 row.dataItem 직접 접근 / column.binding 직접 접근 금지 — `GridUtils` 경유 의무 (null safety + metadata 일관성).

### 5.2 `GridAction` (객체 — Subtitle 핫키와 자동 연결)
```tsx
import { GridAction } from '@foundation/utils';

GridAction.addRow(grid, defaultValues)     // CRUD_TYPE='I' row 추가 (Insert 버튼)
GridAction.removeRow(grid, hardDelete)     // CRUD_TYPE='D' 또는 splice (Delete 버튼)
GridAction.clear(grid, editTrackerRef)     // 모든 변경 취소 + EditTracker reset
GridAction.toggleEditMode(grid)            // 편집 모드 토글
GridAction.toggleColumnSort(grid)          // 정렬 토글
GridAction.toggleColumnFilter(grid, filter)// 필터 토글
GridAction.excelDownload(grid, fileName)   // Excel 다운로드 (Subtitle prop 자동 연결)
GridAction.personalizeCondition(menuId, params) // 조회조건 개인화 저장
GridAction.resetPersonalizedCondition(menuId)
GridAction.getManual(menuId)               // Manual URL
```

> Subtitle 컴포넌트의 `hotkeyConfig` (`{ insert, delete, save, search, manual, upload }`) 가 위 GridAction 들과 1:1 매핑. 화면에서 직접 row push/splice 금지.

### 5.3 `EditTracker` (class — `editTrackerRef` 자동 인스턴스화)
```tsx
import type { EditTracker } from '@foundation/utils';

const editTrackerRef = useRef<EditTracker<T>>();
// DataGrid 의 editTrackerRef 주입 → 자동 생성

editTrackerRef.current?.storeChange(dataItem, binding, oldValue, newValue)
                                                  // 셀 외부 수정 시 변경 추적 등록
editTrackerRef.current?.clearChanges()             // 변경 초기화
editTrackerRef.current?.getOriginalValues()        // 원본 값 Map
```

> Modal 에서 row 셀 set 후 `storeChange` 호출 의무 (CRUD_TYPE='U' 자동 + dirty flag). 호출 누락 시 SAVE 시 변경 미감지 → 무반영 사고.

### 5.4 `CustomMergeManager` (class — `allowMerging !== None` 시 자동)
```tsx
import { CustomMergeManager } from '@foundation/utils';

// DataGrid 가 자동 적용. 화면에서 직접 인스턴스화 불필요.
// 단, header merge / dynamic column merge 필요 시 prop 으로 별도 manager 주입:
//   <DataGrid mergeManager={new HeaderMergeManager(grid, dynStart)} />
```

Wijmo viewport sticky v4 (hook `wijmo-merge-sticky-content.md`) 와 동반 의무 — 세로 cell merge 화면.

## 6. 안티 패턴 (PR 차단 강제)

| 패턴 | 사고 | 대체 |
|---|---|---|
| `<FlexGrid itemsSource={data}>` 직접 JSX | staticColumns 동적 fetch 무력화 / combo / 머지 / EditTracker 모두 누락 | `<DataGrid staticColumns={...}>` |
| `<FlexGridColumnGroup>` + `<FlexGridColumn>` JSX | `_setOwnerList is not a function` (React 19 + wijmo.react.grid 단일 child) | `staticColumns` (admin) + `dynamicColumns` (SP) |
| 화면 안 `MAIN_COLUMNS = [{binding, header, ...}]` 하드코딩 | admin VISIBLE/WIDTH/LABEL 변경 무반영 | store `staticColumns` + `fetchStaticColumns` |
| `grid.rows.push(row)` 직접 | CRUD_TYPE 미설정 / EditTracker 누락 / `DEFAULT_VALUE` 무시 | `GridAction.addRow(grid, defaults)` |
| `grid.rows.splice(idx, 1)` 직접 | hard delete 시 history 누락 / CRUD_TYPE='D' 미적용 | `GridAction.removeRow(grid, hardDelete)` |
| `row.CRUD_TYPE = 'U'` 직접 set | EditTracker `_originalValues` 누락 → SAVE diff 손실 | `editTrackerRef.current.storeChange()` |
| `shared/components/.../DataGrid.tsx` default prop 변경 | 전 화면 regression (#17 사고) | 새 prop 추가 + default = 기존 동작 |
| `dataMap` 화면별 자체 fetch | `useTabComboQueries` 인프라 무력화 | `cellCboDataTp` 메타 (SCM_ADM_CMBO_SQL_M 등록) → 자동 |

## 7. 화면별 Wrapper 작성 체크리스트 (PRE-WRITE)

신규 Grid 컴포넌트 작성 직전 6 체크:

```
[ ] 1. @shared/components 의 DataGrid 만 import (FlexGrid JSX 직접 사용 금지)
[ ] 2. gridRef / gridFilterRef / editTrackerRef 3 useRef 생성 + 주입
[ ] 3. staticColumns = store 에서 fetch (admin 동적) — 하드코딩 배열 금지
[ ] 4. allowMerging / selectionMode / use* 토글 prop 만 명시 (default 동작 유지)
[ ] 5. 화면 전용 핸들러 (gotFocus / dblClick / cellEditEnded) 만 정의
[ ] 6. row 추가/삭제는 GridAction.addRow / removeRow 사용 (직접 splice 금지)
```

## 8. POST-WRITE grep (작성 직후 / PR 직전)

```bash
# 1. FlexGrid 직접 사용 (DataGrid wrap 안 된 화면 검출)
grep -nR "from '@mescius/wijmo.react.grid'" nscm-fe/features/ | grep -v dataGridUtils
# 결과 = 0 line 기대 (DataGrid 내부에서만 사용)

# 2. 화면 안 column 하드코딩 (admin 동적 미적용)
grep -nR "binding:\s*'" nscm-fe/features/*/src/pages/ | grep -v __asis-mapping__ | head
# 결과 = wrapper props (CellRange / formatter) 만 — column 정의 시 즉시 store fetch 변경

# 3. row 직접 조작 (GridAction 미사용)
grep -nR "grid.rows\.\(push\|splice\)" nscm-fe/features/
# 결과 = 0 line 기대

# 4. EditTracker 누락 (Modal 으로 셀 set 시)
grep -nR "dataItem\.\w\+ = " nscm-fe/features/*/src/pages/ | grep -v storeChange
# storeChange 호출 동반 여부 검토
```

## 9. 적용 화면 표 (Master / 적용 / 미적용)

| 화면 | 표준 | DataGrid 사용 | GridUtils | GridAction | EditTracker | CustomMergeManager |
|---|---|:-:|:-:|:-:|:-:|:-:|
| **DMF0004 SalesSite** ⭐ master | ✅ | ✅ | ✅ | ✅ | ✅ (Cells) |
| **DMF0005 SalesSiteProjectModel** ⭐ master | ✅ | ✅ | ✅ | ✅ | ✅ (ColumnHeaders) |
| **DMF0006 CustomerModelMapping** ⭐ master | ✅ | ✅ | ✅ | ✅ | ✅ (ColumnHeaders) |

> ⚠️ **2026-06-18 사용자 정책**: DMF0004/0005/0006 **3 화면만 master**. 다른 화면들 (DMF0003/0007/0008/0020/0043/0043_01/0072 등) 은 사용자 작성/마이그레이션 화면이므로 master/reference 에서 제외.

> **신규 화면**: 모두 DMF0004 SalesSiteGrid 패턴 따라 작성. 기존 화면 중 ⚠️ partial 표시는 후속 fix 대상.

## 10. 사용자 추가 prop 필요 시 (예외 처리)

DataGrid 가 제공하지 않는 신규 기능 발견 시:

1. **shared 추가 prop 형태** — `<DataGrid customXxx={...}>` 식으로 명시 주입. **default = 기존 동작 보존** (기존 화면 영향 0).
2. **PR 분리** — Grid 인프라 변경 PR ↔ 화면 적용 PR 별도. shared 변경 PR 에 다른 화면 regression 0 cross-check (admin / authority / demand 최소 3 도메인 진입 검증).
3. **메모리 `feedback_shared_global_prop_change_forbidden.md` 의무 준수** — default 변경 절대 금지.

## 11. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Wijmo viewport sticky 머지 | `wijmo-merge-sticky-content.md` (v4) |
| 컬럼 메타 admin 동적 fetch | `ui-category-setup-column-meta.md` |
| Combo lookup 표준 위치 (`CELL_COMBO_DATA_TYPE`) | `column-lookup-meta-standard.md` |
| Grid Column Setting Popup | `grid-column-setting-popup-pattern.md` (#58) |
| Cascade Combo Filter | `cascade-combo-filter.md` (#59) |
| FlexGrid 사용자 가이드 2 파일 | `wijmo-flexgrid-entry.md` (#57) |
| Wijmo direct static columns 사고 | 메모리 `feedback_wijmo_direct_static_columns.md` |
| shared/* prop 변경 금지 | 메모리 `feedback_shared_global_prop_change_forbidden.md` |
| DataGrid 전역 default 사고 | 메모리 `feedback_shared_global_prop_change_forbidden.md` + #17 |

## 12. 검증 / 본 룰 위반 시 PR 차단

PR 직전 §8 grep 4 항목 모두 0 line 또는 명시 예외 (주석 + memory entry).
위반 시 머지 차단 (anti-simplification 동등 강도). 사용자 결정 (2026-06-18).
