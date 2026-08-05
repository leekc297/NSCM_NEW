import { type Control, type EventArgs } from '@mescius/wijmo';
import {
  AllowDragging,
  AllowMerging,
  AllowResizing,
  AllowSorting,
  Column,
  SelectionMode,
  type FlexGrid as TFlexGrid,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid, type FlexGridProps } from '@mescius/wijmo.react.grid';
import { memo, type MutableRefObject, useContext, useEffect, useRef } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import { type FlexGridColumnConfig, type RawFlexGridColumnConfig } from '@foundation/models';
import {
  CustomMergeManager,
  EditTracker,
  ensureTopLeftMergeManager,
  GridAction,
  mapRawColumnsToWijmoColumns,
} from '@foundation/utils';
import { useTabComboQueries } from '@shared/hooks';
import { DialogScopeContext, useDialogStore } from '@shared/stores';

import { useDataGridUtils } from './dataGridUtils';

const initialIndexRowHeaderWidth = 50;

interface DataGridProps<T extends WijmoRowItem = WijmoRowItem> extends FlexGridProps {
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  gridRef?: MutableRefObject<TFlexGrid | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<T> | undefined>;
  itemsSource?: T[];
  staticColumns?: RawFlexGridColumnConfig[];
  dynamicColumns?: FlexGridColumnConfig[];
  useSummaryTooltip?: boolean;
  useCellTooptip?: boolean;
  useCheckbox?: boolean;
  useResultColumns?: boolean;
  useAggregationRow?: boolean;
  aggregationRowPlacement?: 'above' | 'below';
  /**
   * 자동 콤보(cellCtrlObjTpCd=COMBO)의 SQL 바인드 파라미터(@mnuId / @divisionId 등) 해소용 공통 파라미터.
   * comboId 와 함께 admin/combo 로 전달되어 @키 치환에 사용됨.
   * ⚠ BE makeComboQuery 는 raw 치환이므로 **문자열 리터럴 값은 작은따옴표로 감싸 전달**해야 함
   *   (예: { mnuId: "'DMF0048'" } → PROGRAM_ID = 'DMF0048'). BE resolveComboBoxDataMaps 와 동일 규약.
   * 미지정 시 기존 동작(파라미터 없는 콤보만 정상) — 회귀 0. 미사용 콤보는 여분 파라미터를 무시(무해).
   */
  comboParams?: Record<string, string>;
  /**
   * 다단(2단/3단) 헤더 행 높이(px). 미지정(default)이면 Wijmo 기본 동작 — 기존 화면 무영향(회귀 0).
   * 지정 시 columnHeaders 의 모든 헤더 row 를 이 높이로 강제(예: 3단 헤더 총높이 48px → 16 전달).
   * 화면 useEffect/CSS 로는 wrapper 의 columnGroups 재적용에 덮여 무효 → wrapper-level 적용만 유효.
   */
  headerRowHeight?: number;
  /**
   * @deprecated
   * Wijmo 'Initialized' property is hard to handle rendering of component with other states or properties.
   * Add and remove handler with useEffect to set handler for wijmo component.
   */
  initialized?: (grid: TFlexGrid) => void;
  dblClick?: (mouseEvent: MouseEvent) => void;
  click?: (mouseEvent: MouseEvent) => void;
  gotFocus?: (sender: Control, args: EventArgs) => void;
}

const DataGridComp = <T extends WijmoRowItem = WijmoRowItem>({
  gridFilterRef,
  gridRef,
  editTrackerRef,
  itemsSource = [],
  staticColumns = [],
  dynamicColumns = [],
  useSummaryTooltip = true,
  useCellTooptip = true,
  useCheckbox = false,
  useResultColumns = false,
  useAggregationRow = false,
  aggregationRowPlacement = 'below',
  comboParams = {},
  allowMerging = AllowMerging.ColumnHeaders,
  selectionMode = SelectionMode.MultiRange,
  initialized,
  headerRowHeight,
  dblClick,
  click,
  ...gridProps
}: DataGridProps<T>) => {
  const dblClickRef = useRef(dblClick);
  const clickRef = useRef(click);
  dblClickRef.current = dblClick;
  clickRef.current = click;
  // headerRowHeight 는 매 렌더 변경 가능 → ref 로 최신값 유지 (handleInitialized 1회 closure 보완).
  const headerRowHeightRef = useRef(headerRowHeight);
  headerRowHeightRef.current = headerRowHeight;

  // 다이얼로그(팝업) 안이면 그 스코프 id, 페이지 최상위면 null. 팝업일 때만 F3/F4를 자동 등록한다.
  const scopeId = useContext(DialogScopeContext);
  // 스코프 단축키 핸들러가 이벤트 시점에 참조할 grid/filter 인스턴스.
  const internalGridRef = useRef<TFlexGrid<T>>();
  const internalFilterRef = useRef<FlexGridFilter>();

  useEffect(
    () => () => {
      if (gridRef) gridRef.current = undefined;
      if (gridFilterRef) gridFilterRef.current = undefined;
      if (editTrackerRef) editTrackerRef.current = undefined;
    },
    [gridRef, gridFilterRef, editTrackerRef]
  );

  const {
    setSummaryTooltip,
    setCellTooltip,
    setAggregationRow,
    setCheckbox,
    formatEditableColumns,
    formatSortableColumns,
    setEditableColumns,
    setMoveCellByTab,
    setMoveByMetakey,
    setSortableColumnHeaderClick,
    setResultColumn,
    setHandleUppercase,
  } = useDataGridUtils<T>();

  // 자동 콤보 필터 — comboId + comboParams(@mnuId/@divisionId 등) 를 함께 전달해 파라미터 콤보 해소.
  //   (기존엔 comboId 만 전달 → @mnuId 필요 콤보가 빈 결과가 되던 문제 fix. comboParams 미지정 시 종전과 동일)
  //
  // 여러 컬럼이 같은 콤보(cellCboDataTp)를 쓰면 동일 queryKey 가 useQueries 에 중복 전달되어
  //   [QueriesObserver]: Duplicate Queries 경고 발생 → 중복 제거 필수.
  //   ⚠ 중복 제거는 반드시 문자열 comboId 단계에서 끝내고 그 뒤에 객체로 만든다.
  //     객체 상태에서 Set 을 쓰면 매번 새 참조라 하나도 걸러지지 않아 버그가 조용히 되살아난다.
  const comboFilters = [
    ...new Set(
      staticColumns
        .filter(
          column =>
            column.display &&
            column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
            column.cellCboDataTp
        )
        .map(column => String(column.cellCboDataTp))
    ),
  ].map(comboId => ({ comboId, ...comboParams }));

  const comboQueries = useTabComboQueries({ filters: comboFilters });
  const comboQueryMap = Object.fromEntries(
    comboFilters.map((filter, i) => [filter.comboId, comboQueries[i]])
  );

  const mappedStaticColumns = mapRawColumnsToWijmoColumns(
    staticColumns
      .filter(column => column.display)
      .map(column => ({
        ...column,
        dataMap:
          column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO && column.cellCboDataTp
            ? comboQueryMap[column.cellCboDataTp]
            : undefined,
      }))
  ).map(col => ({
    ...col,
    allowMerging: allowMerging !== AllowMerging.None,
  }));

  // 2단/3단 헤더(TWO_DEPTH/THREE_DEPTH)에서는 mappedStaticColumns 최상위가 그룹 wrapper라 _fixed가
  //   leaf(columns 내부)에만 있음 — GridUtils.getColumn과 동일한 2단 flatMap으로 leaf까지 펼쳐서 찾는다.
  const flatStaticColumns = mappedStaticColumns
    .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
    .flatMap(smallGroup => smallGroup.columns ?? [smallGroup]);
  const frozenColumns = flatStaticColumns.findLastIndex(column => column._fixed) + 1;

  const handleInitialized = (grid: TFlexGrid<T>) => {
    if (gridRef) gridRef.current = grid;
    internalGridRef.current = grid;

    if (gridFilterRef)
      gridFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });
    // 팝업(다이얼로그 스코프)인데 외부 filter ref가 없으면 F4용 filter를 내부 생성.
    else if (scopeId !== null)
      internalFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });

    if (editTrackerRef) editTrackerRef.current = new EditTracker(grid);
    else new EditTracker(grid);
    grid.allowDragging = AllowDragging.None;
    grid.allowSorting = AllowSorting.None;
    grid.allowResizing = AllowResizing.ColumnsAllCells;
    grid.deferResizing = true;
    grid.selectionMode = selectionMode as SelectionMode;
    // 세로 병합 셀 복사/붙여넣기 보정
    grid.expandSelectionOnCopyPaste = false;
    if (allowMerging !== AllowMerging.None && !gridProps.mergeManager)
      grid.mergeManager = new CustomMergeManager(grid);
    // ⭐ rowHeader corner(No/Status) 세로병합 — 화면이 mergeManager 를 커스텀으로 덮어써도
    //   기존 매니저를 감싸 TopLeft 병합만 보강(위임 데코레이터). 공통 grid 전체 corner 병합 일관.
    ensureTopLeftMergeManager(grid);

    grid.formatItem.addHandler(formatEditableColumns);
    grid.formatItem.addHandler(formatSortableColumns);

    setEditableColumns(grid);
    setMoveCellByTab(grid);
    setSortableColumnHeaderClick(grid);
    setMoveByMetakey(grid, staticColumns.length);
    setHandleUppercase(grid);

    if (useSummaryTooltip) setSummaryTooltip(grid);
    if (useCellTooptip) setCellTooltip(grid);
    if (useAggregationRow) setAggregationRow(grid, aggregationRowPlacement);
    if (useCheckbox) setCheckbox(grid);
    if (useResultColumns) setResultColumn(grid);

    if (!gridProps.isReadOnly) grid.rowHeaders.columns.push(new Column({ align: 'center' }));
    grid.rowHeaders.columns[0].width = initialIndexRowHeaderWidth;
    /**
     * TODO: wijmo 객체와 hostElement의 렌더링 시점 차이로 인해 hostElement 등에 핸들러를 추가하는 경우 다음과 같이 ref로 적용하였음.
     * keyboard event, mouse event 등은 다음과 같이 새로 추가하여 ref로 관리하는 방식 사용 필요 - 강민재
     */
    grid.hostElement.addEventListener('dblclick', e => dblClickRef.current?.(e));
    grid.hostElement.addEventListener('click', e => clickRef.current?.(e));

    // ⭐ 다단 헤더 행 높이 — columnGroups 재적용으로 헤더 row 높이가 리셋되므로
    //   updatedLayout(매 layout refresh 후)에 재적용. 미지정(undefined) 화면은 무영향(회귀 0).
    //   guard: 이미 목표 높이면 skip → 무한 루프 방지.
    grid.updatedLayout.addHandler(() => {
      ensureTopLeftMergeManager(grid);

      const h = headerRowHeightRef.current;
      if (h == null) return;
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      if (Math.round(headerRows.defaultSize) === h) return;
      headerRows.defaultSize = h;
    });
  };

  // 팝업(다이얼로그 스코프) 안의 그리드에만 F3(Sort)/F4(Filter)를 자동 등록.
  // 메인화면 그리드는 scopeId === null 이라 등록하지 않는다(SubTitle이 담당).
  useEffect(() => {
    if (scopeId === null) return;

    const hotkeyHandler = (keyboardEvent: KeyboardEvent) => {
      // 현재 활성(최상위) 다이얼로그의 그리드에서, 그리고 그 그리드가 포커스일 때만 동작.
      if (!useDialogStore.getState().isActiveScope(scopeId)) return;
      const grid = internalGridRef.current;
      if (!grid?.containsFocus()) return;

      if (keyboardEvent.key === 'F3') {
        GridAction.toggleColumnSort(grid);
      } else if (keyboardEvent.key === 'F4') {
        const filter = gridFilterRef?.current ?? internalFilterRef.current;
        if (!filter) return;
        // F4에서 wijmo 기본 동작(datamap)이 열리므로 캡처 단계에서 차단 (SubTitle과 동일)
        keyboardEvent.preventDefault();
        keyboardEvent.stopImmediatePropagation();
        GridAction.toggleColumnFilter(grid, filter);
      }
    };

    globalThis.window.addEventListener('keydown', hotkeyHandler, true);
    return () => globalThis.window.removeEventListener('keydown', hotkeyHandler, true);
  }, [scopeId, gridFilterRef]);

  return (
    <FlexGrid
      style={{
        // flex 부모(페이지 .view 등) 안에서는 flex:1 1 0 이 우선 적용되어 "남은 높이"를 채우고,
        // block 부모(모달의 고정 높이 wrapper 등) 안에서는 flex 가 무시되고 height:100% 가 적용된다.
        // minHeight:0 은 flex 컨테이너에서 내용만큼 늘어나 페이지가 스크롤되는 것을 방지(스크롤은 그리드 내부에).
        height: '100%',
        flex: '1 1 0%',
        minHeight: 0,
      }}
      itemsSource={itemsSource}
      frozenColumns={frozenColumns}
      columnGroups={[...mappedStaticColumns, ...dynamicColumns]}
      initialized={handleInitialized}
      allowMerging={allowMerging}
      {...gridProps}
    />
  );
};

export const DataGrid = memo(DataGridComp) as typeof DataGridComp;
