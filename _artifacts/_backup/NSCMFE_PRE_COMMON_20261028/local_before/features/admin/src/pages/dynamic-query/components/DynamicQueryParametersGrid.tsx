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

  // 이 그리드는 <TabWrapper persist> 안에서 View 탭이 display:none 인 동안 먼저 마운트된다.
  // 그 상태로 Wijmo FlexGrid 가 컬럼 레이아웃을 계산해두면(컨테이너 폭 0), 이후 itemsSource 가
  // 실제 데이터로 바뀌어도 헤더가 처음 계산된 1개 컬럼에 그대로 굳어 있는다 — 강제 재계산.
  useEffect(() => {
    gridRef.current?.invalidate();
  }, [gridRef, itemsSource]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.PARAMETERS>>
      gridRef={gridRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
    />
  );
};
