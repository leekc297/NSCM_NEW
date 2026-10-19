import { SelectionMode } from '@mescius/wijmo.grid';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID } from '../auth-request.constants';
import { SHEETS } from '../auth-request.constants';
import { attachRowNoHeader } from '../auth-request.grid-utils';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface AuthorityGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.AUTHORITY>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.AUTHORITY>[];
}

export const AuthorityGrid = ({ gridRef, gridFilterRef, data }: AuthorityGridProps) => {
  const { t } = useTranslation();
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.AUTHORITY]);

  // 기존 rowHeader 인덱스 컬럼 헤더에 'No' 라벨 추가 (사용자 요구 2026-06-28)
  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, data]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.AUTHORITY>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      isReadOnly
    />
  );
};
