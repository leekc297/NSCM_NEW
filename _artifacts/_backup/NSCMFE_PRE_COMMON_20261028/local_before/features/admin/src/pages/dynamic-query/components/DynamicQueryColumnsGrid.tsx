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

  // 이 그리드는 <TabWrapper persist> 안에서 View 탭이 display:none 인 동안 먼저 마운트된다.
  // 그 상태로 Wijmo FlexGrid 가 컬럼 레이아웃을 계산해두면(컨테이너 폭 0), 이후 itemsSource 가
  // 실제 데이터로 바뀌어도 헤더가 처음 계산된 1개 컬럼에 그대로 굳어 있는다 — 강제 재계산.
  useEffect(() => {
    gridRef.current?.invalidate();
  }, [gridRef, itemsSource]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.COLUMNS>>
      gridRef={gridRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
    />
  );
};
