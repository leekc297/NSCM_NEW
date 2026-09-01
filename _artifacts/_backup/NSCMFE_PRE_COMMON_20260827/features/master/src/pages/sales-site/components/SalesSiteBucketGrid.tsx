import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../sales-site.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';

interface SalesSiteBucketGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteBucketGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteBucketGridProps) => {
  const staticColumns = useSalesSiteStore(state => state.staticColumns);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.BUCKET);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.BUCKET] ?? []}
      allowMerging={AllowMerging.ColumnHeaders}
      gotFocus={handleFocus}
    />
  );
};
