import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { SHEET_INDEX, STEP_INFO_COLUMNS } from '../batch-log.constants';
import type { MENU_ID, SHEETS } from '../batch-log.constants';

interface BatchStepGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.STEP_INFO>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.STEP_INFO>[];
  // admin(SCM_MST_SHEET_COLUMNS) 등록 컬럼. 있으면 우선, 없으면 STEP_INFO_COLUMNS fallback.
  adminColumns?: RawFlexGridColumnConfig[];
  setActiveGrid: (activeGrid: SHEET_INDEX) => void;
}

export const BatchStepGrid = ({
  gridRef,
  gridFilterRef,
  data,
  adminColumns,
  setActiveGrid,
}: BatchStepGridProps) => {
  const handleFocus = () => {
    setActiveGrid(SHEET_INDEX.STEP_INFO);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.STEP_INFO>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={adminColumns && adminColumns.length > 0 ? adminColumns : STEP_INFO_COLUMNS}
      isReadOnly
      gotFocus={handleFocus}
    />
  );
};
