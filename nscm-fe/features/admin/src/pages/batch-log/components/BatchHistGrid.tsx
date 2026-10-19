import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { BATCH_LOG_HIST_COLUMNS, SHEET_INDEX } from '../batch-log.constants';
import type { MENU_ID, SHEETS } from '../batch-log.constants';

interface BatchHistGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.BATCH_LOG_HIST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.BATCH_LOG_HIST>[];
  // admin(SCM_MST_SHEET_COLUMNS) 등록 컬럼. 있으면 우선, 없으면 BATCH_LOG_HIST_COLUMNS fallback.
  adminColumns?: RawFlexGridColumnConfig[];
  setActiveGrid: (activeGrid: SHEET_INDEX) => void;
}

export const BatchHistGrid = ({
  gridRef,
  gridFilterRef,
  data,
  adminColumns,
  setActiveGrid,
}: BatchHistGridProps) => {
  const handleFocus = () => {
    setActiveGrid(SHEET_INDEX.BATCH_LOG_HIST);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.BATCH_LOG_HIST>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={
        adminColumns && adminColumns.length > 0 ? adminColumns : BATCH_LOG_HIST_COLUMNS
      }
      isReadOnly
      gotFocus={handleFocus}
    />
  );
};
