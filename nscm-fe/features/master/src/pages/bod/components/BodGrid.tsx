import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../bod.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../bod.constants';
import { useBodStore } from '../useBodStore';

interface BodGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.MAIN>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

/**
 * DMF0015 BOD — Main Grid (Master)
 * AS-IS spdMain — 29 column (Days/Lead Time 2-row header group)
 * 룰 v2: _tobe/07_datagrid.md (DataGrid wrapper + EditTracker)
 *
 * 동작:
 * - dblClick (read-only) → setBodItemFilter (자식 grid refresh — AS-IS spdMain_CellDoubleClick)
 * - cellEditEnded (DIVISION_ID/END_CUSTOMER) → cascade (combo refresh)
 * - InsertButton → 부모 (Bod.tsx 안 handleInsert) 처리
 */
export const BodGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: BodGridProps) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>();

  const staticColumns = useBodStore(state => state.staticColumns);
  const setBodItemFilter = useBodStore(state => state.setBodItemFilter);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.MAIN);
  };

  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    // editable cell → 기본 편집 (cell edit)
    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    // read-only master row 더블클릭 → 자식 grid refresh (AS-IS spdMain_CellDoubleClick)
    setBodItemFilter({
      divisionId: dataItem?.DIVISION_ID,
      bodId: dataItem?.BOD_ID,
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.MAIN>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.MAIN]}
      gotFocus={handleFocus}
      dblClick={handleGridDblClick}
    />
  );
};
