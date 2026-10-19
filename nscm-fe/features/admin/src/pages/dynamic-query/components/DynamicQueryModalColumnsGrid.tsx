import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { attachRowNoHeader } from '@foundation/utils';
import { DataGrid, ResultArea } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { Columns } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<Columns> | null>;
  data: Columns[];
}

export const DynamicQueryModalColumnsGrid = ({ gridRef, data }: Props) => {
  const { t } = useTranslation();
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.POPUP_COLUMNS]);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, data]);

  return (
    <ResultArea
      title=''
      count={data.length}
      gridRef={gridRef as MutableRefObject<FlexGrid<Columns> | undefined>}
      gridFilterRef={gridFilterRef}
    >
      <DataGrid<Columns>
        gridRef={gridRef as MutableRefObject<FlexGrid<Columns> | undefined>}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={staticColumns}
      />
    </ResultArea>
  );
};
