import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS } from '../shipment-request-electrode.constants';
import type { StockDetailRow } from '../shipment-request-electrode.types';

interface Props {
  rows: StockDetailRow[];
  gridRef: MutableRefObject<FlexGridType<StockDetailRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

/**
 * spdDetail.shtStockDetail — 재고상세, 완전 읽기전용 시트(design 01 R10, 03 §1.3 — AS-IS
 * `ReadOnlySheetList.Add(SpdSheet.shtStockDetail)`, EditButton 진입 시 항상 차단).
 */
export const ShipmentRequestElectrodeStockGrid = ({ rows, gridRef, gridFilterRef, staticColumns, onFocus }: Props) => (
  <DataGrid<StockDetailRow>
    gridRef={gridRef}
    gridFilterRef={gridFilterRef}
    itemsSource={rows}
    staticColumns={staticColumns}
    sheetName={ADMIN_SHEET_NAME[SHEETS.STOCK_DETAIL]}
    isReadOnly
    gotFocus={onFocus}
  />
);
