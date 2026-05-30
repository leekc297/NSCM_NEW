/**
 * DMF0043_01 Contribute_View — Wijmo FlexGrid (조회 전용)
 * AS-IS: spdMain (DMF0043_Contribute_View.cs) — 2단 헤더 Large/Small + SUM 머지
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import { FlexGrid as FlexGridReact, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { MutableRefObject } from 'react';

import type { ContributeViewRow } from '../contribute-view.types';

interface ContributeViewGridProps {
  gridRef: MutableRefObject<FlexGrid<ContributeViewRow> | undefined>;
  data: ContributeViewRow[];
}

export const ContributeViewGrid = ({ gridRef, data }: ContributeViewGridProps) => {
  return (
    <FlexGridReact
      itemsSource={data}
      initialized={(g: FlexGrid<ContributeViewRow>) => {
        gridRef.current = g;
      }}
      isReadOnly={true}
      style={{ height: 'calc(100vh - 280px)' }}
    >
      <FlexGridColumn header='Year' binding='YYYY' width={60} />
      <FlexGridColumn header='Version' binding='VERSION_ID' width={100} />
      <FlexGridColumn header='고객군' binding='CUSTOMER_GROUP' width={100} />
      <FlexGridColumn header='제품군' binding='PRODUCT_TYPE' width={100} />
      <FlexGridColumn header='Biz.Type' binding='BIZ_TYPE' width={80} />
      <FlexGridColumn header='Large Group' binding='LARGE_LABEL' width={120} />
      <FlexGridColumn header='Small Group' binding='SMALL_LABEL' width={120} />
      <FlexGridColumn header='SUM' binding='SUM_VALUE' width={100} align='right' format='n2' />
    </FlexGridReact>
  );
};
