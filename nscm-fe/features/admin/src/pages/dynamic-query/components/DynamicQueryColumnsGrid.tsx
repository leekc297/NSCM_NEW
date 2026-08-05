import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useState, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../dynamic-query.constants';
import { SHEETS } from '../dynamic-query.constants';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.COLUMNS>> | undefined>;
  data: ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>[];
}

export const DynamicQueryColumnsGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.COLUMNS]);

  const dynamicQueryMeta = useDynamicQueryStore(s => s.dynamicQueryMeta);

  const [itemsSource, setItemSource] = useState<
    ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>[]
  >([]);

  useEffect(() => {
    if (dynamicQueryMeta) {
      setItemSource(data);
    } else {
      setItemSource([]);
    }
  }, [data, dynamicQueryMeta]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.COLUMNS>>
      gridRef={gridRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
    />
  );
};
