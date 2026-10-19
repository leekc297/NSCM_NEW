import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../group-menu.constants';
import { SHEET_INDEX } from '../group-menu.constants';
import { useGroupMenuStore } from '../useGroupMenuStore';

interface ButtonGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.BUTTON, RESPONSE_SET.OUTPUT>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  setActiveTab: (tab: SHEET_INDEX) => void;
  data: ResponseData<MENU_ID, SHEETS.BUTTON, RESPONSE_SET.OUTPUT>[];
}

export const ButtonGrid = ({ gridRef, gridFilterRef, setActiveTab, data }: ButtonGridProps) => {
  const staticColumns = useGroupMenuStore(state => state.staticColumns);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.BUTTON);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.BUTTON, RESPONSE_SET.OUTPUT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      allowMerging={AllowMerging.Cells}
      itemsSource={data}
      staticColumns={staticColumns.button ?? []}
      gotFocus={handleFocus}
    />
  );
};
