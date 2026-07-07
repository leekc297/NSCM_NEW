import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { type MENU_ID, SHEETS } from '../group-user.constants';
import { useGroupUserStore } from '../useGroupUserStore';

type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

interface Props {
  gridRef: MutableRefObject<FlexGrid<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MainRow[];
  onFocus?: () => void;
}

export const GroupUserMainGrid = ({ gridRef, gridFilterRef, data, onFocus }: Props) => {
  const editTrackerRef = useRef<EditTracker<MainRow>>();
  const staticColumns = useGroupUserStore(state => state.staticColumns[SHEETS.MAIN]);
  const setSelectedUserGrId = useGroupUserStore(state => state.setSelectedUserGrId);

  const handleSelectionChanged = (g: FlexGrid) => {
    const row = g.selectedItems[0] as { USER_GR_ID?: string } | undefined;
    if (row?.USER_GR_ID) setSelectedUserGrId(String(row.USER_GR_ID));
  };

  // Recently-added 패턴 (룰 07 §10): INSERT 행을 loadedRows 발화 시 isSelected=true 로 시각 강조.
  // hook #70 P2 — useEffect + gridRef.current + dependency[staticColumns] + cleanup(removeHandler) 의무.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid) => {
      for (let i = 0; i < s.rows.length; i += 1) {
        const row = s.rows[i];
        const item = row?.dataItem as { CRUD_TYPE?: string } | undefined;
        if (row && item?.CRUD_TYPE === CRUD_TYPE.INSERT) row.isSelected = true;
      }
    };
    grid.loadedRows.addHandler(handler);
    return () => grid.loadedRows.removeHandler(handler);
  }, [gridRef, staticColumns]);

  // GROUP INFO 마지막 컬럼 우측 여백 제거 — Wijmo star('*')로 남는 폭 채움 (공용 DataGrid 무변경, 화면-로컬).
  // updatedLayout(컬럼 재구성/리사이즈 후) 발화 시 설정. 이미 '*' 면 skip(재설정 루프 방지) + cleanup(#70 P2).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const fillLast = (g: FlexGrid) => {
      const cols = g.columns;
      const last = cols.length > 0 ? cols[cols.length - 1] : undefined;
      if (last && last.width !== '*') last.width = '*';
    };
    grid.updatedLayout.addHandler(fillLast);
    fillLast(grid);
    return () => grid.updatedLayout.removeHandler(fillLast);
  }, [gridRef, staticColumns]);

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      selectionChanged={handleSelectionChanged}
      gotFocus={() => onFocus?.()}
    />
  );
};
