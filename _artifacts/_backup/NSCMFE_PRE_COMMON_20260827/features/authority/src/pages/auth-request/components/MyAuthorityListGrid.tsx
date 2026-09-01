import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../auth-request.constants';
import { SHEETS } from '../auth-request.constants';
import { buildNoColumn, withRowNo } from '../auth-request.grid-utils';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface MyAuthorityListGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[];
  recentlyAddedKeys?: Set<string>;
}

export const MyAuthorityListGrid = ({
  gridRef,
  gridFilterRef,
  data,
  recentlyAddedKeys,
}: MyAuthorityListGridProps) => {
  const { t } = useTranslation();
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.MY_AUTHORITY_LIST]);
  // No 컬럼 — useCheckbox 로 rowHeader 가 체크박스 점유 → 별도 행번호 컬럼 주입 (사용자 요구 2026-06-28)
  const columns = useMemo(
    () => [buildNoColumn(t('LBL00674', 'No')), ...(staticColumns ?? [])],
    [staticColumns, t]
  );
  const rows = useMemo(() => withRowNo(data), [data]);
  const recentKeysRef = useRef<Set<string> | undefined>(recentlyAddedKeys);
  recentKeysRef.current = recentlyAddedKeys;
  const handlerInstalledRef = useRef(false);

  const applyRowSelection = (grid: FlexGrid) => {
    const recent = recentKeysRef.current;
    const hasRecentAdd = !!recent && recent.size > 0;

    for (let i = 0; i < grid.rows.length; i += 1) {
      const row = grid.rows[i];
      const item = row?.dataItem as
        | ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>
        | undefined;
      if (!row || !item) continue;

      if (hasRecentAdd) {
        const key = `${item.USER_GR_ID}::${item.DIVISION_ID}`;
        row.isSelected = recent.has(key);
      } else {
        row.isSelected = false;
      }
    }
  };

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    if (!handlerInstalledRef.current) {
      grid.loadedRows.addHandler((sender: FlexGrid) => {
        applyRowSelection(sender);
      });
      handlerInstalledRef.current = true;
    }

    applyRowSelection(grid);
  }, [data, gridRef, recentlyAddedKeys]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows}
      staticColumns={columns}
      useCheckbox
      isReadOnly
    />
  );
};
