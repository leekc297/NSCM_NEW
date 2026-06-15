import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterRepairGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.REPAIR>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.REPAIR>[];
  onDblClick: (col: number, row: ResponseData<MENU_ID, SHEETS.REPAIR>) => void;
}

const REPAIR_STATUS_COLUMNS = new Set([
  'GSCM_SALES_SITE_ID',
  'ACTIVE_SS',
  'GSCM_SSPM',
  'GSCM_SSPM_INCOTERMS',
  'ACTIVE_SSPM',
  'PROJECT_STATUS',
  'PLANT_SITE_STATUS',
]);

export const ErpEdiMasterRepairGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onDblClick,
}: ErpEdiMasterRepairGridProps) => {
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.repair);

  // Repair 셀 더블클릭 → Sub 탭 분기 (col < GSCM_SSPM ? SALES_SITE : SSPM)
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    onDblClick(ht.col, dataItem);
  };

  // 셀 시각: 값=='확인필요' 이고 컬럼 ∈ REPAIR_STATUS_COLUMNS → ForeColor=Red, BackColor=Azure
  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.REPAIR>>,
    args: FormatItemEventArgs
  ) => {
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string' || !REPAIR_STATUS_COLUMNS.has(binding)) return;
    const row = GridUtils.getRow(grid, args.row);
    if (!row) return;
    const value = row[binding];
    if (value === '확인필요') {
      args.cell.style.color = 'red';
      args.cell.style.backgroundColor = 'azure';
    }
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.REPAIR>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleDblClick}
      formatItem={handleFormatItem}
    />
  );
};
