import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useState, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../dynamic-query.constants';
import { SHEETS } from '../dynamic-query.constants';
import { toAtToken } from '../dynamic-query.utils';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.PARAMETERS>> | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PARAMETERS, RESPONSE_SET.OUTPUT>[];
}

export const DynamicQueryParametersGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.PARAMETERS]);
  const dynamicQueryMeta = useDynamicQueryStore(s => s.dynamicQueryMeta);

  const [itemsSource, setItemSource] = useState<
    ResponseData<MENU_ID, SHEETS.PARAMETERS, RESPONSE_SET.OUTPUT>[]
  >([]);

  useEffect(() => {
    if (dynamicQueryMeta) {
      // View 탭 Condition 표시값도 '@Param' 으로 정규화한다(사용자 요구 2026-07-16).
      //   기존 DB 에 ':' 로 저장된 PARAMETER_ID 도 화면에는 '@' 로 보이게 한다.
      setItemSource(data.map(row => ({ ...row, PARAMETER_ID: toAtToken(row.PARAMETER_ID) })));
    } else {
      setItemSource([]);
    }
  }, [data, dynamicQueryMeta]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.PARAMETERS>>
      gridRef={gridRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
    />
  );
};
