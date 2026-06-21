import type { CellRangeEventArgs, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { ApprovalRow } from '../auth-approval.types';
import { useAuthApprovalStore } from '../useAuthApprovalStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ApprovalRow> | null>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ApprovalRow[];
}

export const AuthApprovalGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const staticColumns = useAuthApprovalStore(s => s.staticColumns);

  const onSelectionchange = (s: FlexGrid, e: CellRangeEventArgs) => {
    const rowDataItem = s.rows[e.row]?.dataItem as ApprovalRow;
    if (rowDataItem && rowDataItem.STATUS !== 'REQUEST') {
      e.cancel = true;
    }
  };

  // formatItem: 비활성화된 체크박스 시각적 비활성화 처리
  const handleFormatItem = (s: FlexGrid, e: FormatItemEventArgs) => {
    if (e.panel.cellType === CellType.RowHeader && e.col === 0) {
      const row = s.rows[e.row];

      const rowDataItem = row.dataItem as ApprovalRow;
      if (rowDataItem && rowDataItem.STATUS !== 'REQUEST') {
        row.isSelected = false;
        e.cell.classList.add('wj-state-disabled');
        e.cell.style.pointerEvents = 'none';
        const checkbox = e.cell.querySelector('input[type="checkbox"]') as HTMLInputElement;
        if (checkbox) {
          checkbox.disabled = true;
        }
      }
    }
  };

  return (
    <DataGrid<ApprovalRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ApprovalRow> | undefined>}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      useCheckbox
      isReadOnly
      selectionChanged={onSelectionchange}
      formatItem={handleFormatItem}
    />
  );
};
