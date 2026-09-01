import { CollectionView } from '@mescius/wijmo';
import { AllowMerging, CellType, Column, type DataMap, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { IFlexGridXlsxOptions, XlsxFormatItemEventArgs } from '@mescius/wijmo.grid.xlsx';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import {
  HAlign,
  VAlign,
  Workbook,
  WorkbookCell,
  WorkbookFill,
  WorkbookFont,
  WorkbookRow,
  WorkbookStyle,
  WorkSheet,
} from '@mescius/wijmo.xlsx';
import dayjs from 'dayjs';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';

import type { EditTracker } from './editTracker';
import { GridUtils } from './gridUtils';
import { CustomMergeManager } from './mergeManager';

/**
 * 필터가 걸린 상태에서 추가한 신규행이 화면에서 사라지는 문제 보정.
 *
 * FlexGridFilter._filter 는 `grid._newAddedRowsSet`(WeakSet) 에 든 행을 조건 검사 없이 통과시킨다
 * — 편집한 행이 필터 때문에 눈앞에서 사라지지 않게 하려는 Wijmo 자체 장치다.
 * 그런데 "행 추가" 쪽 등록은 FlexSheet 전용 `rowChanged` 이벤트에만 걸려 있어(FlexGrid 에는
 * 그 이벤트가 없음) FlexGrid 는 편집(cellEditEnded/rowEditEnding)만 등록된다. 그래서 값이 빈
 * 신규행은 필터 조건에 걸려 CollectionView.items 에서 제외되고 화면에 안 보인다.
 * → 추가 시점에 직접 등록한다.
 *
 * 등록은 FlexGridFilter.excludedRowsSet getter 와 같은 lazy 생성 규약을 따르므로, 필터가 나중에
 * 만들어져도 같은 WeakSet 을 공유한다. 필터가 없는 그리드에서는 아무 영향이 없다.
 *
 * 주의: 이후 사용자가 필터를 다시 적용하면 FlexGridFilter.apply() 가 이 Set 을 null 로 비워
 *   신규행이 다시 필터 대상이 된다(Wijmo 기본 동작). 행 자체는 sourceCollection·itemsAdded 에
 *   남아 저장 대상이지만 화면에서는 숨는다.
 */
export const keepRowVisibleUnderFilter = <T extends WijmoRowItem = WijmoRowItem>(
  grid: FlexGrid<T>,
  row: T
) => {
  const gridWithExcludedSet = grid as FlexGrid<T> & { _newAddedRowsSet?: WeakSet<object> };
  gridWithExcludedSet._newAddedRowsSet ??= new WeakSet<object>();
  gridWithExcludedSet._newAddedRowsSet.add(row);
};

/**
 * columnGroups 재대입으로 버려진 Column 을 붙들고 있는 필터를 현재 컬럼에 다시 묶는다.
 *
 * wijmo 의 `set columnGroups(e){ this.columns.clear(); this._grpHdl.createColumnGroups(...) }` 는
 * 대입할 때마다 Column 객체를 통째로 재생성한다. 공용 DataGrid 는 매 렌더 새 배열을 넘기므로
 * 이 재대입이 사실상 모든 리렌더에서 일어난다(폭/헤더높이/dataMap 을 updatedLayout 마다 다시
 * 적용하는 것과 같은 원인).
 *
 * FlexGridFilter 는 ColumnFilter 안에 Column 참조를 들고 있고, 재바인딩 훅
 * (_adjustBindingColumns)은 columns.collectionChanged 의 Reset 에서만 돈다. 그런데 Reset 은
 * columns.clear() 가 낸 것이라 그 시점엔 새 컬럼이 아직 하나도 없어 아무것도 못 하고,
 * 이어지는 컬럼 추가는 Add 라 훅이 돌지 않는다. 결과적으로 필터는 죽은 Column 을 붙든 채
 * _filters 에 남아 CollectionView 에서 계속 행을 걸러낸다. 사용자에게는 이렇게 보인다.
 *   - 헤더 필터 아이콘은 꺼져 있는데 행은 걸러진 상태 (재조회해도 필터된 항목만 보임)
 *   - 필터를 다시 열면 새 Column 용 ColumnFilter 가 새로 생기는데, 값 목록은 죽은 필터가
 *     통과시킨 행에서만 만들어진다 (getUniqueValues 는 자기 자신만 건너뛴다) -> 전체 항목이 안 나옴
 *   - Clear 를 눌러도 새 ColumnFilter 만 비워지고 죽은 필터는 그대로 -> 필터가 안 풀림
 *
 * filterDefinition 왕복(get 후 set)이면 wijmo 가 clear() 로 죽은 필터를 버리고 binding 으로
 * 현재 컬럼을 다시 찾아 필터를 재구성한다 — 공개 API 만으로 재바인딩이 끝나고 선택 값/조건도
 * 그대로 승계된다.
 *
 * 판정에 _filters 를 직접 보는 이유: 헤더가 한 번이라도 다시 그려지면 wijmo 가 새 Column 용
 *   ColumnFilter 를 따로 만들어 밀어넣는다(_formatItem -> getColumnFilter(col, true)). 그래서
 *   getColumnFilter(binding) 은 그 새 필터를 돌려주고, 죽은 필터는 공개 API 로는 보이지 않는다.
 *   "그리드에 없는 Column 을 붙든 필터가 남아 있는가" 가 유일하게 정확한 판정이다.
 *
 * 필수: 끊어진 필터가 있을 때만 왕복한다. 매번 왕복하면 apply() -> refresh -> updatedLayout 이
 *   다시 이 함수를 부르는 되먹임이 생긴다. 같은 binding 의 컬럼이 레이아웃에서 아예 빠진 필터는
 *   되살릴 대상에서 제외한다 — 되살려도 다음 호출에서 또 끊어진 것으로 보여 왕복이 반복된다.
 *
 * @returns 재바인딩을 실제로 했으면 true
 */
export const rebindFilterColumns = <T extends WijmoRowItem = WijmoRowItem>(
  grid: FlexGrid<T>,
  gridFilter?: FlexGridFilter | null
): boolean => {
  if (!gridFilter) return false;

  const columnFilters = (gridFilter as unknown as { _filters?: { column?: Column | null }[] })
    ._filters;
  if (!Array.isArray(columnFilters) || columnFilters.length === 0) return false;

  const hasStaleFilter = columnFilters.some(({ column }) => {
    if (!column?.binding) return false;
    return grid.columns.indexOf(column) < 0 && Boolean(grid.getColumn(column.binding));
  });
  if (!hasStaleFilter) return false;

  const definition = gridFilter.filterDefinition;

  // 필터 예외로 등록된 신규행(keepRowVisibleUnderFilter 참고)을 보존한다.
  //   FlexGridFilter.apply() 가 이 Set 을 무조건 비우므로, 재바인딩만으로 사용자가 방금 추가한
  //   행이 필터에 걸려 사라지면 안 된다. 되돌린 뒤엔 refresh 로 판정만 다시 시킨다.
  const gridWithExcludedSet = grid as FlexGrid<T> & { _newAddedRowsSet?: WeakSet<object> | null };
  const excludedRows = gridWithExcludedSet._newAddedRowsSet;

  gridFilter.filterDefinition = definition;

  if (excludedRows) {
    gridWithExcludedSet._newAddedRowsSet = excludedRows;
    grid.collectionView?.refresh();
  }
  return true;
};

/** filterDefinition JSON 중 이 파일이 다루는 부분만. 나머지 필드는 손대지 않고 그대로 넘긴다. */
interface FilterDefinition {
  filters?: { binding?: string }[];
}

/**
 * 조회로 데이터가 다시 실리기 직전의 컬럼 필터를 떠 둔다 (restoreGridFilter 와 한 쌍).
 *
 * wijmo 는 `itemsSourceChanged` 에서 필터를 통째로 비운다(FlexGridFilter 생성자가 clear 를
 * 직접 건다). 이 프로젝트는 "재조회해도 사용자가 건 필터는 유지" 가 요구사항이라, 비우기 전에
 * 떠 두었다가 비운 직후 되돌린다.
 *
 * @returns 걸린 필터가 있으면 filterDefinition JSON, 없으면 null
 */
export const captureGridFilter = (gridFilter?: FlexGridFilter | null): string | null => {
  if (!gridFilter) return null;
  const definition = gridFilter.filterDefinition;
  try {
    return (JSON.parse(definition) as FilterDefinition).filters?.length ? definition : null;
  } catch {
    return null;
  }
};

/**
 * captureGridFilter 로 떠 둔 필터를 새로 실린 데이터 위에 다시 적용한다.
 *
 * 지금 그리드에 없는 컬럼의 필터는 버린다. wijmo 는 binding 으로 컬럼을 못 찾으면 화면에 없는
 * Column 을 즉석에서 만들어 필터를 붙이는데(set filterDefinition), 그러면 사용자가 볼 수도
 * 풀 수도 없는 필터가 계속 행을 걸러낸다. division 전환처럼 컬럼 구성이 바뀌는 조회에서
 * 조회 결과가 통째로 사라지는 사고가 되므로 복원 대상에서 제외한다.
 *
 * @returns 되돌린 필터가 있으면 true
 */
export const restoreGridFilter = <T extends WijmoRowItem = WijmoRowItem>(
  grid: FlexGrid<T>,
  gridFilter: FlexGridFilter | null | undefined,
  definition: string | null
): boolean => {
  if (!gridFilter || !definition) return false;

  let parsed: FilterDefinition;
  try {
    parsed = JSON.parse(definition) as FilterDefinition;
  } catch {
    return false;
  }

  const filters = (parsed.filters ?? []).filter(
    columnFilter => columnFilter.binding && grid.getColumn(columnFilter.binding)
  );
  if (filters.length === 0) return false;

  gridFilter.filterDefinition = JSON.stringify({ ...parsed, filters });
  return true;
};

/**
 * 컬럼에 붙을 수 있는 dataMap 의 모든 형태.
 *   살아있는 `Column.dataMap` 은 `DataMap | null`, `columnGroups` 설정값은 `DataMap | string[] |
 *   undefined` 라 양쪽을 함께 다루려면 합집합이 필요하다.
 */
type ExportDataMap = DataMap | string[] | null | undefined;

/** 살아있는 그리드 컬럼에서 export 직전에 읽어야 하는 최소 형태. */
type LiveColumnLike = {
  binding?: string | null;
  visible?: boolean;
  dataMap?: ExportDataMap;
};

/** `collectLiveColumnExportMeta` 결과 — 컬럼을 갈아끼우기 전에 떠 둔 화면 상태. */
export interface LiveColumnExportMeta {
  /** 화면에 실제 표시중인 컬럼 binding 집합 (컬럼설정 팝업의 런타임 숨김까지 반영). */
  visibleBindings: Set<string>;
  /** binding → 그 컬럼에 실제로 붙어 있는 dataMap (콤보 CODE→NAME). */
  liveDataMaps: Map<string, NonNullable<ExportDataMap>>;
  /** export 컬럼에 붙일 dataMap 결정 — 살아있는 값 우선, 없으면 columnGroups 설정값. */
  resolveDataMap: (
    binding: string | null | undefined,
    fromColumnGroup: ExportDataMap
  ) => ExportDataMap;
}

/**
 * `grid.columns.clear()` 로 컬럼을 갈아끼우기 전에, 원본 컬럼에서 export 에 필요한 정보를 뜬다.
 *
 * ⭐ dataMap 스냅샷 (2026-08-11 사용자 요구 — 전체 화면 공통).
 *   콤보의 CODE→NAME dataMap 이 붙는 경로가 둘이다.
 *     ① 관리자 메타 경로 — `columnMapping` 이 columnGroups 설정 객체에 심는다.
 *     ② 화면 자체 경로 — 공용 DataGrid 가 매 렌더 columnGroups 를 재적용하며 `col.dataMap` 을
 *        undefined 로 덮으므로, 화면이 `updatedLayout` 마다 살아있는 컬럼에 직접 붙인다
 *        (Sales Price 의 Team=DEPT_ID, Sales Plan, Mkt Fcst, Business Plan, Sales Reports …).
 *   export 는 columnGroups **설정** 에서 컬럼을 새로 만들기 때문에 ② 경로는 설정에 흔적이 없어
 *   화면엔 명칭인데 엑셀에만 코드가 떨어졌다. 그래서 설정이 아니라 "화면에 실제로 붙어 있는"
 *   값을 뜬다 — 엑셀은 언제나 화면에 보이는 그대로.
 *
 *   승계 우선순위는 살아있는 값 → 설정값 폴백. ① 경로 화면은 살아있는 컬럼에도 같은 dataMap 이
 *   붙어 있어 결과가 같다(회귀 0).
 */
export const collectLiveColumnExportMeta = (
  columns: ReadonlyArray<LiveColumnLike>
): LiveColumnExportMeta => {
  const visibleBindings = new Set<string>();
  const liveDataMaps = new Map<string, NonNullable<ExportDataMap>>();

  for (const column of columns) {
    const binding = column?.binding;
    if (!binding) continue;
    if (column.visible) visibleBindings.add(binding);
    // 숨긴 컬럼도 dataMap 은 담아 둔다 — 담는 비용이 없고, 표시 여부 판정은 visibleBindings 전담.
    if (column.dataMap) liveDataMaps.set(binding, column.dataMap);
  }

  return {
    visibleBindings,
    liveDataMaps,
    resolveDataMap: (binding, fromColumnGroup) =>
      (binding ? liveDataMaps.get(binding) : undefined) ?? fromColumnGroup,
  };
};

/**
 * 그리드 없이 **데이터만으로** 미저장 변경을 되돌린다 — 신규행 제거 · 삭제/수정 마킹 해제 ·
 * 수정 셀 원본값 복원.
 *
 * 언마운트 시점처럼 wijmo 컨트롤이 이미 파괴됐을 수 있는 경로에서 쓰라고 분리했다.
 * rows 는 화면이 넘긴 배열 그 자체를 in-place 로 정리한다 — 새 배열로 갈면 화면·react-query
 * 캐시가 들고 있는 배열은 오염된 채 남는다.
 *
 * @returns 되돌린 변경이 있었으면 true
 */
export const revertRowChanges = <T extends WijmoRowItem = WijmoRowItem>(
  rows: T[] | null | undefined,
  editTracker?: EditTracker<T> | null
): boolean => {
  editTracker?.getOriginalValues().forEach((originalValues, row) => {
    Object.entries(originalValues).forEach(([binding, value]) => {
      (row as WijmoRowItem)[binding] = value;
    });
  });
  try {
    // clearChanges 는 내부에서 grid.invalidate() 를 부른다 — 언마운트 후엔 파괴된 컨트롤일 수 있다.
    editTracker?.clearChanges();
  } catch {
    // 값 복원은 위에서 이미 끝났고 남은 건 화면 갱신뿐 — 사라진 그리드라면 갱신할 것도 없다.
  }

  if (!rows) return false;

  let reverted = false;
  for (let index = rows.length - 1; index >= 0; index -= 1) {
    const crudType = rows[index]?.CRUD_TYPE;
    if (!crudType) continue;
    reverted = true;
    // 신규행은 조회 결과에 없던 행 — 통째로 제거. 기존 행은 마킹만 해제(값은 위에서 이미 원복).
    if (crudType === CRUD_TYPE.INSERT || crudType === CRUD_TYPE.CREATE) rows.splice(index, 1);
    else rows[index].CRUD_TYPE = undefined;
  }

  return reverted;
};

/**
 * 머지 블록에 포커스가 있을 때 행추가의 기준이 될 행 — 블록의 첫 행(top) 또는 마지막 행(bottom).
 *
 * 화면의 머지 셀은 사용자에게 "행 여러 개" 가 아니라 "묶음 하나" 로 보인다. 포커스 행 그대로
 * 끼워 넣으면 묶음 한가운데가 갈라져 같은 값이 위아래로 나뉘고 그 사이에 신규행이 낀다.
 * 기준행을 묶음의 경계로 밀어 주면 신규행이 그룹 앞(above)/뒤(below)에 서고 기존 머지는 그대로다.
 *
 * 머지가 아니거나(단일 셀 = null) 머지 매니저가 없으면 선택 행을 그대로 돌려준다. 판정 대상은
 * 포커스가 놓인 그 컬럼 한 곳이다 — 계층 머지(좌측 컬럼이 더 크게 묶이는 화면)에서 사용자가
 * 보고 있는 묶음이 곧 그 셀의 묶음이기 때문이다.
 *
 * 필수: 한 행씩 되짚어 올라간다(내려간다). 이 프로젝트의 머지 매니저는 뷰포트 sticky 머지를
 *   위해 결과를 panel.viewRange 로 잘라 돌려주므로(CustomMergeManager._getCellMergedRange),
 *   블록의 진짜 첫 행이 스크롤 위로 벗어나 있으면 한 번의 호출로는 "화면 맨 윗행" 만 나온다.
 *   경계 바로 바깥 행을 다시 물어 그 결과가 지금 블록까지 이어지면(= 같은 머지키) 계속 잇는다.
 *   이어지지 않으면(단일 셀이거나 다른 블록) 거기서 멈춘다. wijmo 의 clip 인자로는 못 푼다 —
 *   자르는 주체가 wijmo 가 아니라 우리 머지 매니저다.
 */
const mergeBoundaryRow = <T extends WijmoRowItem = WijmoRowItem>(
  grid: FlexGrid<T>,
  row: number,
  col: number,
  edge: 'top' | 'bottom'
): number => {
  if (row < 0 || col < 0) return row;
  if (grid.allowMerging === AllowMerging.None || !grid.mergeManager) return row;

  // 화면 자체 머지 매니저가 던져도 행추가 자체는 막지 않는다 — 보정 없이 선택 행 기준.
  const rangeAt = (targetRow: number): { row: number; row2: number } | null => {
    try {
      const merged = grid.getMergedRange(grid.cells, targetRow, col, false);
      return merged && merged.row2 > merged.row ? { row: merged.row, row2: merged.row2 } : null;
    } catch {
      return null;
    }
  };

  const focused = rangeAt(row);
  if (!focused) return row;

  if (edge === 'top') {
    let top = Math.min(focused.row, row);
    while (top > 0) {
      const above = rangeAt(top - 1);
      // row2 가 현재 블록까지 닿지 않으면 별개 블록 — 잇지 않는다.
      if (!above || above.row2 < top) break;
      top = Math.min(above.row, top - 1); // 매번 최소 1 감소 = 반드시 끝난다
    }
    return top;
  }

  const lastRow = grid.rows.length - 1;
  let bottom = Math.max(focused.row2, row);
  while (bottom < lastRow) {
    const below = rangeAt(bottom + 1);
    if (!below || below.row > bottom) break;
    bottom = Math.max(below.row2, bottom + 1);
  }
  return bottom;
};

export type GridRowPlacement = 'below' | 'top' | 'bottom' | 'above';

/**
 * 신규행이 들어갈 원본 배열(sourceCollection) 인덱스를 계산한다 — 행추가 위치의 공통 규칙.
 *
 * 주의: grid.selection.row 는 필터·정렬을 거친 뷰(collectionView.items) 기준 인덱스인데
 *   삽입 대상은 원본 배열이다. 두 인덱스는 필터가 없을 때만 일치한다. 예전 코드는 뷰 인덱스를
 *   그대로 splice 에 넘겨, 필터가 걸리면 신규행이 원본 앞쪽에 박히고 그 앞 행들은 대부분
 *   숨겨져 있어 화면상 항상 맨 위에 붙은 것처럼 보였다(정렬도 같은 원인).
 *   선택 행을 아이템으로 잡아 원본에서의 위치를 역산한다. items 의 선언 타입은
 *   T | Partial<T>(wijmo 의 addNew 경로) 라 indexOf 대신 findIndex 로 참조 비교한다.
 *
 * 머지 셀에 포커스가 있으면 그 묶음의 경계로 기준행을 민다 (mergeBoundaryRow 주석 참고).
 *
 * options.groupKey 는 "화면이 아는 묶음" 을 알려 주는 통로다. 머지가 걸리지 않은 컬럼
 *   (예: DMF0068 의 월 컬럼)에 포커스가 있으면 머지 경계 보정이 걸리지 않아 한 건을 이루는
 *   여러 행 사이에 신규행이 끼어든다. 같은 키가 이어지는 구간까지 기준행을 밀어 이를 막는다.
 *
 * GridAction.addRow 가 이 함수를 쓰고, 배열을 직접 다루는 화면(useState + useMemo 로 rows 를
 *   만드는 화면)도 같은 규칙을 쓰도록 밖으로 내보낸다.
 */
const resolveInsertIndex = <T extends WijmoRowItem = WijmoRowItem>(
  grid: FlexGrid<T>,
  source: readonly T[],
  placement: GridRowPlacement = 'above',
  options?: { groupKey?: (row: T) => string }
): number => {
  if (placement === 'top') return 0;
  if (placement === 'bottom') return source.length;

  const view = grid.collectionView as CollectionView<T> | undefined;
  const selectedRow = grid.selection?.row ?? -1;
  const anchorRow =
    selectedRow < 0
      ? -1
      : mergeBoundaryRow(
          grid,
          selectedRow,
          grid.selection?.col ?? -1,
          placement === 'below' ? 'bottom' : 'top'
        );
  const selectedItem = anchorRow < 0 ? undefined : view?.items?.[anchorRow];
  let index = selectedItem ? source.findIndex(item => item === selectedItem) : -1;

  // 선택이 없으면(-1) 맨 위 — 기존 동작 유지.
  if (index < 0) return 0;

  const groupKey = options?.groupKey;
  const anchorItem = source[index];
  if (groupKey && anchorItem) {
    const key = groupKey(anchorItem);
    const keyAt = (i: number): string | undefined => {
      const item = source[i];
      return item ? groupKey(item) : undefined;
    };
    if (key) {
      if (placement === 'below') while (keyAt(index + 1) === key) index++;
      else while (index > 0 && keyAt(index - 1) === key) index--;
    }
  }

  return placement === 'below' ? index + 1 : index;
};

export const GridAction = {
  GridAction: {},

  clear: <T extends WijmoRowItem = WijmoRowItem>(
    funcSetGridData: (gridData: CollectionView<T>) => void,
    funcSetDataCount: (dataCount: number) => void,
    grid: FlexGrid<T>,
    gridFilter?: FlexGridFilter
  ) => {
    funcSetGridData(new CollectionView());
    funcSetDataCount(0);
    grid.select(-1, -1);
    grid.mergeManager = new CustomMergeManager(grid);
    gridFilter?.clear();
  },

  // F1: Open manual
  getManual: (manualUrl: string) => {
    // TODO: 화면 별 manual file (pdf or ppt) - 강민재
    console.error(manualUrl);
  },

  // F2: Toggle edit mode - deprecated
  toggleEditMode: <T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>) => {
    grid.isReadOnly = !grid.isReadOnly;
    grid.invalidate();
  },

  // F3: Toggle sort property of columns
  toggleColumnSort: <T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>) => {
    const selection = grid?.selection;
    const minCol = Math.min(selection.col, selection.col2);
    const maxCol = Math.max(selection.col, selection.col2);

    for (let selectedCol = minCol; selectedCol <= maxCol; selectedCol++) {
      const binding = grid.columns[selectedCol].binding;
      if (!grid.collectionView.sortDescriptions.some(sd => sd.property === binding))
        grid.columns[selectedCol].allowSorting = !grid.columns[selectedCol].allowSorting;
    }

    grid.invalidate();
  },

  // F4 : Toggle filter
  toggleColumnFilter: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    gridFilter: FlexGridFilter
  ) => {
    const selection = grid.selection;
    const minCol = Math.min(selection.col, selection.col2);
    const maxCol = Math.max(selection.col, selection.col2);

    for (let selectedCol = minCol; selectedCol <= maxCol; selectedCol++) {
      const binding = grid.columns[selectedCol].binding ?? '';
      const bindingIndex = gridFilter.filterColumns.indexOf(binding);

      if (bindingIndex === -1) {
        gridFilter.filterColumns.push(binding);
        continue;
      }

      gridFilter.filterColumns.splice(bindingIndex, 1);

      // filterColumns 에서만 빼면 헤더 필터 아이콘만 사라질 뿐, 이미 걸린 필터 조건은
      // 그대로 남아 필터링된 데이터가 계속 표시된다 — 해당 컬럼의 조건도 함께 지운다.
      try {
        const definition = JSON.parse(gridFilter.filterDefinition) as FilterDefinition;
        const filters = (definition.filters ?? []).filter(f => f.binding !== binding);
        if (filters.length !== (definition.filters ?? []).length)
          gridFilter.filterDefinition = JSON.stringify({ ...definition, filters });
      } catch {
        // filterDefinition 파싱 실패 시엔 필터 목록(filterColumns) 갱신만 반영한다.
      }
    }

    grid.invalidate();
  },

  // F6: Save personalized condition
  //   ⚠️ BE SearchCondition.paramCtn 은 String — 값이 배열(multi-select)/불리언이면 그대로 보내면
  //      Jackson 역직렬화 실패(400)로 저장이 조용히 안 됨. → payload 는 항상 문자열로 coerce.
  //      (배열=콤마 join / null·undefined='' / 그 외 String). string 값 화면은 무변경(회귀 0).
  personalizeCondition: async (menuId: string, searchParam: Record<string, unknown>) => {
    await apiClient.post(
      `/admin/menu/${menuId}/search-conditions`,
      Object.entries(searchParam)
        .map(([key, data]) => {
          let paramCtn: string;
          if (Array.isArray(data)) paramCtn = data.join(',');
          else if (data == null) paramCtn = '';
          else paramCtn = String(data as string | number | boolean);
          return { paramNm: key, paramCtn };
        })
        // 빈값 제외 — 저장 SP(P_SCM0000_SAVE_SRCH_COND)가 빈 PRAM_CTN 을 어차피 skip 하므로 무손실.
        //   동시에 payload 축소로 SP 디버그 청크로깅(v_description VARCHAR2(500)) 오버플로(ORA-06502) 회피.
        .filter(item => item.paramCtn !== '')
    );
  },

  // 행추가 위치 계산 — 배열을 직접 다루는 화면이 addRow 와 같은 규칙을 쓰도록 공개한다.
  resolveInsertIndex,

  // F8: Add row
  addRow: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    defaultCopyProps: Partial<T>,
    placement: GridRowPlacement = 'above',
    preserveMergeManager = false
  ) => {
    if (grid.isReadOnly) return undefined;
    const itemsSource = grid.itemsSource as T[];
    const editFlag = itemsSource.every(item => item?.EDIT_FLAG === 'N');
    // TODO: 조회 없이 (그리드에 데이터 없이) 추가할 때 handle 추가적으로 필요  - 강민재
    if (itemsSource.length !== 0 && editFlag) return undefined;

    const view = grid.collectionView as CollectionView<T>;
    const source = view.sourceCollection as T[];

    const newRow = {
      ...defaultCopyProps,
      CRUD_TYPE: 'I',
    } as unknown as T;

    // 삽입 위치 계산은 resolveInsertIndex 한 곳에 모여 있다 — 그 주석 참고.
    source.splice(resolveInsertIndex(grid, source, placement), 0, newRow);
    (grid.collectionView as CollectionView).itemsAdded.push(newRow);
    // 필터가 걸려 있어도 신규행은 보여야 한다 — refresh 전에 필터 예외로 등록.
    keepRowVisibleUnderFilter(grid, newRow);

    // 주의: 아래 한 줄뿐이다. 예전에는 같은 대입이 무조건 실행되는 줄이 하나 더 있어
    //   preserveMergeManager=true 로 넘겨도 화면 전용 머지 매니저가 매번 덮였다.
    if (!preserveMergeManager) grid.mergeManager = new CustomMergeManager(grid);
    grid.collectionView.refresh();
    grid.invalidate();
    return newRow;
  },

  // F9: Remove row
  removeRow: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    deleteOnlyNew: boolean = false
  ) => {
    if (grid.isReadOnly) return false;

    const rows = GridUtils.getSelectedRows(grid);
    if (!rows?.length) return false;

    rows.forEach(row => {
      if (row.CRUD_TYPE === CRUD_TYPE.CREATE || row.CRUD_TYPE === CRUD_TYPE.INSERT)
        grid.editableCollectionView.remove(row);
      else if (!deleteOnlyNew) row['CRUD_TYPE'] = CRUD_TYPE.DELETE;
    });

    grid.editableCollectionView.commitEdit();
    grid.mergeManager = new CustomMergeManager(grid);
    grid.invalidate();

    return true;
  },

  /**
   * 미저장 변경을 실제로 버린다 — 신규행 제거 · 삭제/수정 마킹 해제 · 수정 셀 원본값 복원.
   *
   * 배경(2026-08-11 리포트 — Contribution Version 팝업):
   *   "작업중인 데이터가 있습니다"(MSG00703/MSG00704) confirm 은 묻기만 하고 아무것도 버리지
   *   않았다. 그런데 addRow 는 `collectionView.sourceCollection.splice` 로 **화면이 넘긴 배열
   *   자체**를 변형한다. 그 배열은 화면의 useMemo 결과이거나(팝업) react-query 캐시 배열이라
   *   (Program 화면 등) 그리드만 언마운트되고 화면/캐시가 살아 있는 경로 — 팝업 재오픈, 탭 닫고
   *   재진입 — 에서 사용자가 버린 신규행이 그대로 되살아났다. 저장까지 되는 상태였다.
   *
   * 주의: sourceCollection 을 새 배열로 교체하지 말 것. in-place 로 정리해야 화면·캐시가 들고 있는
   *   같은 배열까지 함께 깨끗해진다. 배열 공유는 버그가 아니라 현재 저장 경로의 전제다
   *   (여러 화면이 자기 배열에서 `filter(item => item.CRUD_TYPE)` 로 payload 를 만든다).
   *
   * 신규행을 React state 로 관리하는 화면(useInsertedRows 등)은 그리드에서 지워도 다음 렌더에
   *   state 가 다시 밀어 넣는다 — 그런 화면은 useDirtyReset 으로 자기 state 초기화를 따로 등록한다.
   *
   * @returns 되돌린 변경이 있었으면 true
   */
  discardChanges: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T> | null | undefined,
    editTracker?: EditTracker<T> | null
  ): boolean => {
    if (!grid) return false;

    // 편집 중인 셀을 먼저 끝낸다 — 커밋되어야 EditTracker 가 원본을 기록하고, 그래야 아래에서 되돌린다.
    grid.finishEditing(true);

    const view = grid.collectionView as CollectionView<T> | undefined;
    const source = (view?.sourceCollection ?? []) as T[];

    const discarded = revertRowChanges(source, editTracker);

    // CollectionView 의 변경 추적 목록(itemsAdded/Edited/Removed)도 비운다 — 저장 경로가 참조한다.
    view?.clearChanges();
    grid.mergeManager = new CustomMergeManager(grid);
    view?.refresh();
    grid.invalidate();

    return discarded;
  },

  // F10: Reset personalized condition
  resetPersonalizedCondition: async (menuId: string) => {
    await apiClient.post(`/admin/menu/${menuId}/search-conditions/reset`);
  },

  // Excel Upload 양식 다운로드 — 그리드가 아닌 데이터에서 직접 만드는 평탄 헤더 1행 export.
  //   BE ExcelUtils.convertExcelToJson 은 엑셀 1행을 헤더 키로 사용(이름 기반 매핑)하므로
  //   2단 병합 헤더(하위명 중복)로는 업로드 매핑이 불가능하다.
  //   전 셀 문자열 — 숫자 셀이면 POI getNumericCellValue 가 '0.0' 을 돌려 SP 정수 검증에서 탈락한다.
  //   저장은 saveAsync 필수 — Workbook.save() 는 JSZip 2.x 전용이라 현재 3.x 환경에서 동작하지 않는다.
  //   ⭐ [2026-08-14] `cellFill` — 화면 미리보기의 셀 배경색을 **다운로드 파일에도 유지**한다.
  //     양식에서 배경색은 장식이 아니라 "여기에 입력하라"는 유일한 표식이다. 화면에만 칠하면
  //     사용자가 파일을 연 순간 입력 가능 컬럼을 알 수 없다(2026-08-14 사용자 보고).
  //     반환값 = `#RRGGBB` (undefined 면 채움 없음). 색상별 WorkbookStyle 은 캐시해 재사용한다
  //     — 셀마다 새 스타일을 만들면 수천 개가 생겨 xlsx 가 비대해진다.
  flatExcelDownload: (
    rows: ReadonlyArray<Record<string, string | number | null | undefined>>,
    columns: ReadonlyArray<{ header: string; key: string }>,
    fileNamePrefix: string,
    cellFill?: (
      row: Record<string, string | number | null | undefined>,
      column: { header: string; key: string },
      rowIndex: number
    ) => string | undefined
  ): Promise<void> => {
    const headerFont = new WorkbookFont();
    headerFont.family = 'Spoqa Han Sans Neo';
    headerFont.size = 12;
    headerFont.bold = true;

    // format '@' (텍스트) 필수 — 없으면 wijmo 가 '40' / '202607' / '0' 을 숫자 셀로 기록하고
    //   POI getNumericCellValue 가 '40.0' 을 돌려줘 업로드 검증(정수·날짜)에서 전량 탈락한다.
    const headerStyle = new WorkbookStyle();
    headerStyle.font = headerFont;
    headerStyle.hAlign = HAlign.Center;
    headerStyle.vAlign = VAlign.Center;
    headerStyle.format = '@';

    const textStyle = new WorkbookStyle();
    textStyle.format = '@';

    const toCell = (value: string, style: WorkbookStyle) => {
      const cell = new WorkbookCell();
      cell.value = value;
      cell.style = style;
      return cell;
    };

    // 색상별 스타일 캐시 — 같은 색이면 스타일 인스턴스를 공유한다(셀마다 생성 금지).
    const fillStyles = new Map<string, WorkbookStyle>();
    const filledStyle = (color: string) => {
      const cached = fillStyles.get(color);
      if (cached) return cached;
      const fill = new WorkbookFill();
      fill.color = color;
      const style = new WorkbookStyle();
      style.format = '@'; // 텍스트 유지 — 채움색을 넣어도 숫자 셀로 바뀌면 안 된다
      style.fill = fill;
      fillStyles.set(color, style);
      return style;
    };

    // cells / rows / sheets 는 readonly 배열 — 재할당이 아닌 push 로 채운다.
    const buildRow = (values: string[], styleAt: (index: number) => WorkbookStyle) => {
      const sheetRow = new WorkbookRow();
      values.forEach((value, index) => sheetRow.cells.push(toCell(value, styleAt(index))));
      return sheetRow;
    };

    const sheet = new WorkSheet();
    sheet.name = 'Sheet1';
    sheet.rows.push(
      buildRow(
        columns.map(column => column.header),
        () => headerStyle
      )
    );
    rows.forEach((row, rowIndex) =>
      sheet.rows.push(
        buildRow(
          columns.map(column => String(row[column.key] ?? '')),
          index => {
            const color = cellFill?.(row, columns[index], rowIndex);
            return color ? filledStyle(color) : textStyle;
          }
        )
      )
    );

    const workbook = new Workbook();
    workbook.sheets.push(sheet);

    return new Promise<void>((resolve, reject) => {
      workbook.saveAsync(
        `${fileNamePrefix}_${dayjs().format('YYYYMMDD_hhmmss')}.xlsx`,
        () => resolve(),
        (reason?: unknown) =>
          reject(
            reason instanceof Error
              ? reason
              : new Error(typeof reason === 'string' ? reason : 'xlsx save failed')
          )
      );
    });
  },

  // F11 : Excel download
  excelDownload: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    menuName: string,
    setProgress?: (progress: number) => void
  ) => {
    grid.beginUpdate();

    const fileName = `${menuName}_${dayjs().format('YYYYMMDD_hhmmss')}`;

    const clonedAllowMerging = grid.allowMerging;
    const clonedColumnGroups = [...(grid.columnGroups as FlexGridColumnConfig[])];
    const clonedColumnHeaderHeight = grid.columnHeaders.rows[0].height;
    // 화면에 실제 표시중인 컬럼 binding 집합 (grid.columns.clear() 이전 = 원본 상태).
    //   컬럼설정 팝업으로 런타임 숨김한 컬럼까지 정확히 반영(정적 display + 런타임 visible 모두).
    const visibleBindings = new Set<string>();
    // ⭐ [통합테스트 1st No.60-① 2026-08-12 — 전체 화면 공통] 콤보 컬럼 dataMap 승계용 채집.
    //   아래 컬럼 재구성(new Column)이 dataMap 을 복사하지 않아 엑셀에 표시명(Name) 대신
    //   Code 가 출력되던 결함 — 라이브 컬럼의 dataMap 을 binding 별로 보관했다가 재구성 시 주입.
    const liveDataMaps = new Map<string, unknown>();
    for (let i = 0; i < grid.columns.length; i++) {
      const liveColumn = grid.columns[i];
      if (liveColumn?.visible && liveColumn.binding) visibleBindings.add(liveColumn.binding);
      if (liveColumn?.binding && liveColumn.dataMap) {
        liveDataMaps.set(liveColumn.binding, liveColumn.dataMap);
      }
    }

    const flatColumnGroups = clonedColumnGroups
      .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
      .flatMap(smallGroup => smallGroup.columns ?? [smallGroup])
      // 숨긴 컬럼은 엑셀 export 에서 제외 (2026-07-01 사용자 요구 — 전체 화면 공통).
      .filter(columnGroup => !columnGroup.binding || visibleBindings.has(columnGroup.binding));

    /**
     * TODO: 현재 Wijmo 버전에서는 columnGroups 사용시,
     * includeStyles: false, includeColumnHeaders: true
     * 위 속성들과 호환이 되지 않음 (컬럼헤더의 로우 개수만큼 데이터의 상위 n개가 엑셀에 불러와지지 않음... formatItem에서 애초에 index를 찍을 때 스킵되는 버그)
     */
    grid.columns.clear();
    grid.columnGroups = [];
    // grid.columnHeaders.rows.clear();

    flatColumnGroups.forEach(columnGroup =>
      grid.columns.push(
        new Column({
          binding: columnGroup.binding,
          header: columnGroup.header,
          align: columnGroup.align,
          allowMerging: false,
          visible: columnGroup.visible,
          width: columnGroup.width,
          // [No.60-①] 콤보 표시명(Name) 승계 — dataMap 없던 컬럼은 undefined 그대로 (회귀 0)
          dataMap: liveDataMaps.get(columnGroup.binding ?? '') as never,
        })
      )
    );

    grid.allowMerging = AllowMerging.None;
    grid.columnHeaders.rows[0].height = 48;

    const headerFontStyle = new WorkbookFont();
    headerFontStyle.family = 'Spoqa Han Sans Neo';
    headerFontStyle.size = 12;
    headerFontStyle.bold = true;

    const fontStyle = new WorkbookFont();
    fontStyle.family = 'Spoqa Han Sans Neo';
    fontStyle.size = 12;
    fontStyle.bold = false;

    const columnHeaderStyle = new WorkbookStyle();
    columnHeaderStyle.wordWrap = true;
    columnHeaderStyle.vAlign = VAlign.Center;
    columnHeaderStyle.hAlign = HAlign.Center;
    columnHeaderStyle.font = headerFontStyle;

    const cellStyle = new WorkbookStyle();
    cellStyle.vAlign = VAlign.Center;
    cellStyle.font = fontStyle;

    // ⭐ 다단 헤더 depth (2026-07-04 사용자 요구 — 2단/3단 헤더 유지 다운로드).
    //   depth 1 = 기존 경로 그대로 (회귀 0). depth>1 = 데이터만 변환 후 헤더 행을 수동 구성(병합).
    //   (wijmo 변환기의 columnGroups+includeColumnHeaders 조합 버그 회피 — 아래 TODO 참조)
    const headerDepth = clonedColumnGroups.reduce((depth, group) => {
      const groupDepth = group.columns?.some(sub => !!sub.columns?.length)
        ? 3
        : group.columns?.length
          ? 2
          : 1;
      return Math.max(depth, groupDepth);
    }, 1);

    const convertOptions: IFlexGridXlsxOptions = {
      includeStyles: false,
      includeColumnHeaders: headerDepth === 1,
      includeRowHeaders: false,
      formatItem: (xlsxFormatItemEventArgs: XlsxFormatItemEventArgs) => {
        const cellType = xlsxFormatItemEventArgs.panel.cellType;
        const xlsxCell = xlsxFormatItemEventArgs.xlsxCell;
        const col = xlsxFormatItemEventArgs.col;

        /**
         * TODO: 느려지는 원인 (window에서 실제로 보이는 style을 가져오는 작업)
         * const cellEelement = xlsxFormatItemEventArgs.panel.getCellElement(row, col);
         * const computedStyle = window.getComputedStyle(cellEelement);
         */

        if (cellType === CellType.ColumnHeader)
          xlsxCell.style = { ...xlsxCell.style, ...columnHeaderStyle };
        else if (cellType === CellType.Cell) {
          // BACKCOLOR 처리 제외 (2026-07-01 사용자 요구 — 전체 화면 공통): fill 미설정 → 셀 배경색 없음.
          xlsxCell.style = {
            ...xlsxCell.style,
            ...cellStyle,
          };

          const dataType = flatColumnGroups[col]._ctrlType;
          xlsxCell.isDate = dataType === CELL_CONTROL_TYPE.DATE; // TODO: CELL_CONTROL_TYPE DATE 타입 추가 시 조건 변경 필요 - 강민재
          xlsxCell.isNumber = dataType === CELL_CONTROL_TYPE.NUMBER;
        }
      },
    };

    let gridRestored = false;
    const resetGridProps = () => {
      if (gridRestored) return;
      gridRestored = true;
      grid.allowMerging = clonedAllowMerging;
      grid.columns.clear();
      grid.columnGroups = clonedColumnGroups;
      grid.columnHeaders.rows[0].height = clonedColumnHeaderHeight;
      grid.endUpdate();
    };

    const settleProgress = () => setProgress?.(100);

    // 기존 평탄화(1단 헤더) 저장 경로 — depth 1 기본 + 다단 구성 실패 시 공통 폴백.
    //   폴백은 헤더 포함 옵션으로 저장 (includeColumnHeaders:false 였다면 헤더 없는 파일 방지).
    const saveFlat = (resolve: () => void, reject: (reason?: unknown) => void) => {
      const fail = (reason: unknown) => {
        resetGridProps();
        settleProgress();
        reject(reason instanceof Error ? reason : new Error(String(reason)));
      };
      try {
        const workbook = FlexGridXlsxConverter.save(grid, {
          ...convertOptions,
          includeColumnHeaders: true,
        });
        resetGridProps(); // 파일 생성 전에 원복 — 이후 리렌더는 workbook 에 영향 없음
        workbook.saveAsync(
          fileName,
          () => {
            settleProgress();
            resolve();
          },
          fail,
          setProgress
        );
      } catch (reason) {
        fail(reason);
      }
    };

    if (headerDepth > 1) {
      return new Promise<void>((resolve, reject) => {
        try {
          const workbook = FlexGridXlsxConverter.save(grid, convertOptions);
          const sheet = workbook.sheets[0];

          // WorkbookRow.cells 는 readonly lazy-init getter — 반환 배열을 index/push 로 변이해 채운다
          const headerRows: WorkbookRow[] = Array.from(
            { length: headerDepth },
            () => new WorkbookRow()
          );
          const makeCell = (value: string, colSpan: number, rowSpan: number): WorkbookCell => {
            const cell = new WorkbookCell();
            cell.value = value;
            if (colSpan > 1) cell.colSpan = colSpan;
            if (rowSpan > 1) cell.rowSpan = rowSpan;
            cell.style = columnHeaderStyle;
            return cell;
          };
          const visibleLeafCount = (node: FlexGridColumnConfig): number =>
            node.columns?.length
              ? node.columns.reduce((sum, child) => sum + visibleLeafCount(child), 0)
              : !node.binding || visibleBindings.has(node.binding)
                ? 1
                : 0;

          let colIdx = 0;
          // 단일 visible leaf 를 따라 내려가며 반환(분기=leaf 2개 이상이면 null).
          const singleVisibleLeaf = (node: FlexGridColumnConfig): FlexGridColumnConfig | null => {
            if (!node.columns?.length) return node;
            const vis = node.columns.filter(child => visibleLeafCount(child) > 0);
            if (vis.length !== 1) return null;
            return singleVisibleLeaf(vis[0]);
          };
          const walk = (node: FlexGridColumnConfig, level: number) => {
            const leafSpan = visibleLeafCount(node);
            if (leafSpan === 0) return; // 전부 숨김 그룹 — 헤더 미출력
            if (node.columns?.length) {
              // ⭐ 같은 라벨의 degenerate single-leaf 체인 = '실질 flat 컬럼'(예: UI Category Setup 에서
              //   LARGE(대분류) 라벨 공란 → SMALL=colLbl 만 존재 → single-leaf group 으로 매핑된 정적 컬럼)
              //   → 세로 병합 1셀로 collapse. UI(HierarchicalMergeManager content-merge)가 이미 세로 병합하므로
              //   export 도 동일하게 재현(라벨 값 유무 무관). leafSpan≥2 정상 다단 그룹은 미영향. 2026-07-07.
              const only = leafSpan === 1 ? singleVisibleLeaf(node) : null;
              if (only && String(only.header ?? '') === String(node.header ?? '')) {
                headerRows[level].cells[colIdx] = makeCell(
                  String(node.header ?? ''),
                  1,
                  headerDepth - level // 남은 행 세로 병합
                );
                colIdx += 1;
                return;
              }
              headerRows[level].cells[colIdx] = makeCell(String(node.header ?? ''), leafSpan, 1);
              node.columns.forEach(child => walk(child, level + 1));
            } else {
              // leaf (얕은 정적 컬럼 포함) — 남은 행을 세로 병합
              headerRows[level].cells[colIdx] = makeCell(
                String(node.header ?? ''),
                1,
                headerDepth - level
              );
              colIdx += 1;
            }
          };
          clonedColumnGroups.forEach(group => walk(group, 0));

          // 무결성 가드 — 헤더 leaf 수 ≠ 데이터 컬럼 수면 위치가 어긋나므로 폴백
          if (colIdx !== flatColumnGroups.length || !sheet) {
            saveFlat(resolve, reject);
            return;
          }

          // 병합 anchor 외 위치는 빈 셀로 densify (sparse 배열 직렬화 회피)
          headerRows.forEach(row => {
            for (let i = 0; i < colIdx; i++) {
              if (!row.cells[i]) {
                const empty = new WorkbookCell();
                empty.style = columnHeaderStyle;
                row.cells[i] = empty;
              }
            }
          });

          // WorkSheet.rows 도 readonly getter — unshift 로 헤더 행을 데이터 앞에 삽입
          sheet.rows.unshift(...headerRows);
          workbook.saveAsync(
            fileName,
            () => {
              resetGridProps();
              settleProgress();
              resolve();
            },
            () => {
              saveFlat(resolve, reject);
            },
            setProgress
          );
        } catch {
          saveFlat(resolve, reject);
        }
      });
    }

    return new Promise<void>((resolve, reject) => {
      saveFlat(resolve, reject);
    });
  },
};
