import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../group-user.constants';
import { useGroupUserStore } from '../useGroupUserStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: { USER_GR_ID: string; USER_GR_NM: string; USE_YN: string; CRUD_TYPE?: string }[];
}

export const GroupUserMainGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const staticColumns = useGroupUserStore(state => state.staticColumns[SHEETS.MAIN]);
  const setSelectedUserGrId = useGroupUserStore(state => state.setSelectedUserGrId);
  const handlerInstalledRef = useRef(false);

  const handleSelectionChanged = (g: FlexGrid) => {
    const row = g.selectedItems[0] as { USER_GR_ID?: string } | undefined;
    if (row?.USER_GR_ID) setSelectedUserGrId(String(row.USER_GR_ID));
  };

  // Recently-added 패턴 (룰 07 §10): INSERT 행을 loadedRows 발화 시 isSelected=true 로 시각 강조
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || handlerInstalledRef.current) return;
    handlerInstalledRef.current = true;
    grid.loadedRows.addHandler((s: FlexGrid) => {
      for (let i = 0; i < s.rows.length; i += 1) {
        const row = s.rows[i];
        const item = row?.dataItem as { CRUD_TYPE?: string } | undefined;
        if (row && item?.CRUD_TYPE === CRUD_TYPE.INSERT) row.isSelected = true;
      }
    });
  }, [gridRef]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      selectionChanged={handleSelectionChanged}
    />
  );
};
