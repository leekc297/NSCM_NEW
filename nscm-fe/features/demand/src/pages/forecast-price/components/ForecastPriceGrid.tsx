import { type FlexGrid, AllowMerging, SelectionMode } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import dayjs from '@foundation/dayjs';
import type { EditTracker } from '@foundation/utils';
import { DynamicColumnManager } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { ForecastPriceRow } from '../forecast-price.types';
import { useForecastPriceStore } from '../useForecastPriceStore';

interface ForecastPriceGridProps {
  gridRef: MutableRefObject<FlexGrid<ForecastPriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ForecastPriceRow[];
}

export const ForecastPriceGrid = ({ gridRef, gridFilterRef, data }: ForecastPriceGridProps) => {
  const monthMap = useRef<Map<string, Set<string>>>(new Map());
  const weekMap = useRef<Map<string, Set<string>>>(new Map());
  const editTrackerRef = useRef<EditTracker | null>(null);
  const bucketRef = useRef<string>('Weekly');

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const dateColumns = useForecastPriceStore(state => state.dateColumns);
  const setDateColumns = useForecastPriceStore(state => state.setDateColumns);

  const staticColumnsBinding = useMemo(
    () => new Set(staticColumns.map(column => column.colNm)),
    [staticColumns]
  );

  // TODO: initialized 함수 사용 X, 로직만 보기 - 강민재
  // const initGrid = (grid: FlexGrid): void => {
  //   editTrackerRef.current = new EditTracker(grid);
  //   // TODO: filter handle 구현 필요 - 강민재
  //   gridFilterRef.current = new FlexGridFilter(grid, {
  //     filterColumns: [''],
  //   });

  //   grid.hostElement.addEventListener('keydown', (keyboardEvent: KeyboardEvent) => {
  //     if (keyboardEvent.key !== 'Delete') return;

  //     keyboardEvent.preventDefault();
  //     keyboardEvent.stopPropagation();

  //     const ranges = grid.selectedRanges;
  //     ranges.forEach(range => {
  //       for (let row = range.topRow; row <= range.bottomRow; row++) {
  //         for (let col = range.leftCol; col <= range.rightCol; col++) {
  //           const dataItem = grid.rows[row]?.dataItem as WijmoRowItem;
  //           const binding = grid.columns[col].binding;

  //           if (!binding || grid.columns[col].isReadOnly) continue;

  //           const crudType = dataItem['CRUD_TYPE'];
  //           const measure = dataItem['MEASURE'];

  //           // 추가한 행의 static column인 경우
  //           if (staticColumnsBinding.has(binding)) {
  //             if (crudType && (crudType === CRUD_TYPE.CREATE || crudType === CRUD_TYPE.INSERT))
  //               dataItem[binding] = null;
  //             continue;
  //           }

  //           // Bucket에 해당하는 dynamic column인 경우 AND MEASURE가 MKT_FCST, SCM_FCST, LOC중 하나인 경우 AND NOT NULL
  //           if (
  //             ((bucketRef.current === 'Monthly' && binding?.startsWith('M_')) ||
  //               (bucketRef.current === 'Weekly' && binding?.startsWith('W_')) ||
  //               (bucketRef.current === 'Daily' && binding?.startsWith('D_'))) &&
  //             typeof measure === 'string' &&
  //             editableMeasures.has(measure) &&
  //             !isNonEditableDateColumn(binding, weekMap.current) &&
  //             dataItem[binding]
  //           ) {
  //             const oldValue = dataItem[binding];
  //             editTrackerRef.current?.storeChange(dataItem, binding, oldValue, 0);
  //             dataItem[binding] = 0;
  //             const measure = dataItem['MEASURE'];

  //             if (editTrackerRef.current === null) return;

  //             if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
  //               if (binding?.startsWith('M_'))
  //                 divideByMonth(
  //                   binding,
  //                   dataItem,
  //                   0,
  //                   monthMap.current,
  //                   weekMap.current,
  //                   editTrackerRef.current
  //                 );
  //               else if (binding?.startsWith('W_'))
  //                 divideByWeek(
  //                   binding,
  //                   dataItem,
  //                   0,
  //                   oldValue,
  //                   weekMap.current,
  //                   editTrackerRef.current
  //                 );
  //             } else if (measure === 'LOC')
  //               allocateLoc(
  //                 binding,
  //                 dataItem,
  //                 0,
  //                 monthMap.current,
  //                 weekMap.current,
  //                 editTrackerRef.current
  //               );
  //           }
  //         }
  //       }
  //     });
  //     grid.invalidate();
  //   });

  //   // 셀 수정 여부 핸들러
  //   const cellEditableHandler = (sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
  //     const row = cellRangeEventArgs.row;
  //     const col = cellRangeEventArgs.col;
  //     const binding = sender.columns[col]?.binding;
  //     const dataItem = sender.rows[row]?.dataItem as WijmoRowItem;

  //     if (binding == null) {
  //       cellRangeEventArgs.cancel = true;
  //       return;
  //     }

  //     if (col >= staticColumns.length) {
  //       if (isNonEditableCell(sender, binding, dataItem, weekMap.current, bucketRef.current))
  //         cellRangeEventArgs.cancel = true;
  //     } else if (isUndefined(dataItem['CRUD_TYPE'])) {
  //       // 추가된 행이 아니라면 수정 불가능
  //       cellRangeEventArgs.cancel = true;
  //     }
  //   };

  //   // 셀 수정 이벤트 핸들러
  //   const cellEditHandler = (sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
  //     const row = cellRangeEventArgs.row;
  //     const col = cellRangeEventArgs.col;
  //     const binding = sender.columns[col]?.binding;
  //     const dataItem = sender.rows[row]?.dataItem as WijmoRowItem;
  //     const val = sender.getCellData(row, col, false) as WijmoPrimitive;
  //     const oldVal = cellRangeEventArgs.data as WijmoPrimitive;
  //     const measure = dataItem['MEASURE'];

  //     if (
  //       ((oldVal === undefined || oldVal === null) &&
  //         (val === undefined || val === null || val === '')) ||
  //       !binding
  //     )
  //       return;

  //     if (!editTrackerRef.current) return;
  //     if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
  //       if (binding?.startsWith('M_'))
  //         divideByMonth(
  //           binding,
  //           dataItem,
  //           val,
  //           monthMap.current,
  //           weekMap.current,
  //           editTrackerRef.current
  //         );
  //       else if (binding?.startsWith('W_'))
  //         divideByWeek(binding, dataItem, val, oldVal, weekMap.current, editTrackerRef.current);
  //       else if (binding?.startsWith('D_'))
  //         divideByDate(binding, dataItem, val, oldVal, editTrackerRef.current);
  //     } else if (measure === 'LOC')
  //       allocateLoc(
  //         binding,
  //         dataItem,
  //         val,
  //         monthMap.current,
  //         weekMap.current,
  //         editTrackerRef.current
  //       );

  //     sender.invalidate();
  //   };

  //   const cellFormatHandler = (sender: FlexGrid, formatItemEventArgs: FormatItemEventArgs) => {
  //     const row = formatItemEventArgs.row;
  //     const col = formatItemEventArgs.col;
  //     const panel = formatItemEventArgs.panel;
  //     const dataItem = sender.rows[row]?.dataItem as WijmoRowItem;
  //     const binding = sender.columns[col]?.binding;
  //     const isVisible = sender.columns[col]?.visible;
  //     const cell = formatItemEventArgs.cell;

  //     if (!binding || panel.cellType !== CellType.Cell || !isVisible) return;

  //     const cellValue = dataItem[binding];
  //     const crudType = dataItem['CRUD_TYPE'];

  //     if (col >= staticColumns.length) {
  //       if (!isNonEditableCell(sender, binding, dataItem, weekMap.current, bucketRef.current))
  //         cell.classList.add('wj-cell-editable');

  //       if (!sender.editRange?.contains(row, col)) {
  //         if (cellValue === undefined || cellValue === null || cellValue === 0) cell.innerText = '';
  //         else cell.innerText = toNumber(cellValue).toLocaleString();
  //       }
  //     } else if (crudType === CRUD_TYPE.CREATE || crudType === CRUD_TYPE.INSERT)
  //       cell.classList.add('wj-cell-editable');

  //     if (isNonEditableDateColumn(binding, weekMap.current))
  //       cell.classList.add('wj-cell-non-editable');
  //   };

  //   grid.beginningEdit.addHandler(cellEditableHandler);
  //   grid.pastingCell.addHandler(cellEditableHandler);
  //   grid.cellEditEnded.addHandler(cellEditHandler);
  //   grid.pastedCell.addHandler(cellEditHandler);
  //   grid.formatItem.addHandler(cellFormatHandler);
  // };

  useEffect(() => {
    // TODO: 임시 데이터 및 날짜 컬럼, 삭제 필요 - 강민재
    if (!searchParams.period[0] || !searchParams.period[1]) return;

    const dateColumns = DynamicColumnManager.getDateColumnsWithAggregation(
      dayjs(searchParams.period[0]),
      dayjs(searchParams.period[1]),
      undefined,
      monthMap.current,
      weekMap.current
    );
    setDateColumns(dateColumns);
    // }, [data]);
  }, [data]);

  useEffect(() => {
    bucketRef.current = searchParams.bucketType;
  }, [searchParams.bucketType]);

  return (
    <DataGrid<ForecastPriceRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dateColumns}
      selectionMode={SelectionMode.MultiRange}
      allowMerging={AllowMerging.Cells}
      alternatingRowStep={0}
      useSummaryTooltip
      useAggregationRow
      useResultColumns
      useHotkey
    />
  );
};
