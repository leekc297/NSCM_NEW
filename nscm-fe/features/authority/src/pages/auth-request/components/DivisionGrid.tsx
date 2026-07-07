import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useTabid } from '@shared/stores';

import { MENU_ID, SHEETS } from '../auth-request.constants';
import { buildNoColumn, withRowNo } from '../auth-request.grid-utils';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface DivisionGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.DIVISION>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
}

export const DivisionGrid = ({ gridRef, gridFilterRef }: DivisionGridProps) => {
  const { t } = useTranslation();
  const tabId = useTabid();
  const filters = useAuthRequestStore(state => state.filters[SHEETS.DIVISION]);
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.DIVISION]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId,
    filters,
    enabled: !!filters,
  });

  // No 컬럼 — useCheckbox 로 rowHeader 가 체크박스 점유 → 별도 행번호 컬럼 주입 (사용자 요구 2026-06-28)
  const columns = useMemo(
    () => [buildNoColumn(t('LBL00674', 'No')), ...(staticColumns ?? [])],
    [staticColumns, t]
  );
  const rows = useMemo(() => withRowNo(data?.o_rc ?? []), [data]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.DIVISION>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows}
      staticColumns={columns}
      useCheckbox
      isReadOnly
    />
  );
};
