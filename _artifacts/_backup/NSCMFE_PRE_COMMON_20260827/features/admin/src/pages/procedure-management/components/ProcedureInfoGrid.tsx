import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEET_INDEX } from '../procedure-management.constants';
import type { SHEETS, MENU_ID } from '../procedure-management.constants';
import { useProcedureManagementStore } from '../useProcedureManagementStore';

interface ProcedureManagementGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.PROCEDURE_INFO>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PROCEDURE_INFO>[];
  setActiveGrid: (activeGrid: SHEET_INDEX) => void;
}

export const ProcedureInfoGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveGrid,
}: ProcedureManagementGridProps) => {
  const staticColumns = useProcedureManagementStore(state => state.staticColumns);

  const handleFocus = () => {
    setActiveGrid(SHEET_INDEX.PROCEDURE_INFO);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.PROCEDURE_INFO>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns.procInfo}
      gotFocus={handleFocus}
    />
  );
};
