import {
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { useSalesFuturePriceExpression } from '../hooks/useSalesFuturePriceExpression';
import { useSalesFuturePriceValidation } from '../hooks/useSalesFuturePriceValidation';
import { GROUP_KEY_COLUMNS } from '../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';

type DataRow = WijmoRowItem;

interface SalesFuturePriceGridProps {
  gridRef: MutableRefObject<FlexGrid<DataRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: DataRow[];
}

const groupKeyOf = (row: DataRow) =>
  GROUP_KEY_COLUMNS.map(c => String(row[c] ?? '')).join('|');

export const SalesFuturePriceGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: SalesFuturePriceGridProps) => {
  const editTrackerRef = useRef<EditTracker<DataRow>>();

  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const staticColumns = useSalesFuturePriceStore(state => state.staticColumns);
  const dynamicColumns = useSalesFuturePriceStore(state => state.dynamicColumns);
  const selectedGroupKey = useSalesFuturePriceStore(state => state.selectedGroupKey);
  const setSelectedGroupKey = useSalesFuturePriceStore(state => state.setSelectedGroupKey);
  const searchParams = useSalesFuturePriceStore(state => state.searchParams);

  const { onCellEditEnded, onComboSelChange, onCellDblClick, onCellClick, onRawCellClick } =
    useSalesFuturePriceValidation();
  const { buildLargeSumHeader, setExchangeValues } = useSalesFuturePriceExpression();

  const columns = useMemo(() => {
    const dyn = dynamicColumns.filter(c => c.visible);
    return [...staticColumns, ...buildLargeSumHeader(dyn)];
  }, [staticColumns, dynamicColumns, buildLargeSumHeader]);

  const handleFormatItem = (s: FlexGrid, e: FormatItemEventArgs) => {
    if (e.panel.cellType !== CellType.Cell) return;
    const row = s.rows[e.row]?.dataItem as DataRow | undefined;
    if (row && selectedGroupKey && groupKeyOf(row) === selectedGroupKey) {
      e.cell.classList.add('selected-group');
    }
  };

  /** AS-IS: spdMain_CellClick (L3690~3693) + Raw_CellClick (L3707~3743) 통합.
   *  Wijmo 에는 cellClick 이벤트 없음 → DataGrid 의 click (MouseEvent) + hitTest 사용. */
  const handleClick = (e: MouseEvent) => {
    const s = gridRef.current;
    if (!s) return;
    const ht = s.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const row = s.rows[ht.row]?.dataItem as DataRow | undefined;
    if (!row) return;

    // CellRangeEventArgs 와 유사한 객체 구성 (validation hook 호환)
    const eArgs = { row: ht.row, col: ht.col } as unknown as CellRangeEventArgs;

    const binding = GridUtils.getBinding(s, ht.col);
    if (binding === 'CURRENCY' && !row.CURRENCY) {
      void setAlert({ type: 'alert', content: t('MSG00447', '_Currency 가 비어 있습니다.') });
    }

    setSelectedGroupKey(groupKeyOf(row));

    onRawCellClick(s, eArgs, searchParams.divisionId);
    onCellClick(s, eArgs);
  };

  const handleCellDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell && ht.cellType !== CellType.ColumnHeader) return;

    onCellDblClick(grid, ht, searchParams.divisionId);
  };

  const handleCellEditEnded = (s: FlexGrid, e: CellRangeEventArgs) => {
    const dataItem = s.rows[e.row]?.dataItem as DataRow | undefined;
    if (!dataItem) return;

    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      dataItem.CRUD_TYPE = CRUD_TYPE.MODIFY;
    }

    onCellEditEnded(s, e, searchParams.divisionId);
    onComboSelChange(s, e, searchParams.divisionId);

    setExchangeValues(s, e, searchParams.divisionId);
  };

  return (
    <DataGrid<DataRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={columns}
      frozenColumns={11}
      allowMerging='Cells'
      formatItem={handleFormatItem}
      cellEditEnded={handleCellEditEnded}
      click={handleClick}
      dblClick={handleCellDblClick}
    />
  );
};
