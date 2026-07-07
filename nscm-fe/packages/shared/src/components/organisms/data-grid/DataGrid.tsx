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
import { memo, type MutableRefObject, useRef } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import { type FlexGridColumnConfig, type RawFlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, EditTracker, mapRawColumnsToWijmoColumns } from '@foundation/utils';
import { useTabComboQueries } from '@shared/hooks';

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
  useCheckbox?: boolean;
  useResultColumns?: boolean;
  useAggregationRow?: boolean;
  aggregationRowPlacement?: 'above' | 'below';
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
  useCheckbox = false,
  useResultColumns = false,
  useAggregationRow = false,
  aggregationRowPlacement = 'below',
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

  const {
    setSummaryTooltip,
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

  const comboIds = staticColumns
    .filter(
      column =>
        column.display && column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO && column.cellCboDataTp
    )
    .map(column => {
      const comboId = String(column.cellCboDataTp);
      return comboId;
    });

  const comboQueries = useTabComboQueries({ filters: comboIds });
  const comboQueryMap = Object.fromEntries(comboIds.map((f, i) => [comboIds[i], comboQueries[i]]));

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

  const frozenColumns = mappedStaticColumns.findLastIndex(column => column._fixed) + 1;

  const handleInitialized = (grid: TFlexGrid<T>) => {
    if (gridRef) gridRef.current = grid;

    if (gridFilterRef)
      gridFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });

    if (editTrackerRef) editTrackerRef.current = new EditTracker(grid);
    else new EditTracker(grid);
    grid.allowDragging = AllowDragging.None;
    grid.allowSorting = AllowSorting.None;
    grid.allowResizing = AllowResizing.ColumnsAllCells;
    grid.deferResizing = true;
    grid.selectionMode = selectionMode as SelectionMode;
    if (allowMerging !== AllowMerging.None && !gridProps.mergeManager)
      grid.mergeManager = new CustomMergeManager(grid);

    grid.formatItem.addHandler(formatEditableColumns);
    grid.formatItem.addHandler(formatSortableColumns);

    setEditableColumns(grid);
    setMoveCellByTab(grid);
    setSortableColumnHeaderClick(grid);
    setMoveByMetakey(grid, staticColumns.length);
    setHandleUppercase(grid);

    if (useSummaryTooltip) setSummaryTooltip(grid);
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
      const h = headerRowHeightRef.current;
      if (h == null) return;
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      if (Math.round(headerRows.defaultSize) === h) return;
      headerRows.defaultSize = h;
    });
  };

  return (
    <FlexGrid
      style={{
        height: '100%',
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
