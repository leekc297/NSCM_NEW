import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  ACTIVE_GRID,
  COMBO_ID,
  MAIN_EDITABLE_COLUMNS,
  MENU_ID,
  OPERATION_GROUP_LOOKUP_TYPE,
  SHEETS,
} from '../demand-group-master.constants';
import type { GroupMasterRow } from '../demand-group-master.types';
import { useDemandGroupMasterStore } from '../useDemandGroupMasterStore';
import { buildGridColumns } from '../utils/demand-group-master.columns';

interface GroupMasterGridProps {
  gridRef: MutableRefObject<FlexGrid<GroupMasterRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: GroupMasterRow[];
  onFocus: (grid: ACTIVE_GRID) => void;
  // master 더블클릭 → 해당 GROUP_ID 로 Model List 재조회 (L10). 빈 그리드면 무시(순수 가드).
  onRowDblClick: (groupId: string) => void;
}

export const GroupMasterGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onFocus,
  onRowDblClick,
}: GroupMasterGridProps) => {
  const editTrackerRef = useRef<EditTracker<GroupMasterRow> | undefined>();
  const staticColumns = useDemandGroupMasterStore(state => state.staticColumns);

  // OPERATION_GROUP 표시 콤보(LookupCommon, 'E' 제외) + ONLY_STOCK 편집 콤보(YesOrNo).
  const [operationGroupRows, yesOrNoRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO_ID.LOOKUP_COMMON, lookupType: OPERATION_GROUP_LOOKUP_TYPE, mnuId: MENU_ID },
      COMBO_ID.YES_OR_NO,
    ],
  });

  const operationGroupComboRows = useMemo<ComboResponse[]>(
    () => (operationGroupRows ?? []).filter(row => row.CODE !== 'E'),
    [operationGroupRows]
  );
  const yesOrNoComboRows = useMemo<ComboResponse[]>(() => yesOrNoRows ?? [], [yesOrNoRows]);

  const columns = useMemo(
    () =>
      buildGridColumns(staticColumns[SHEETS.GROUP_NAME], MAIN_EDITABLE_COLUMNS, {
        OPERATION_GROUP: operationGroupComboRows,
        ONLY_STOCK: yesOrNoComboRows,
      }),
    [staticColumns, operationGroupComboRows, yesOrNoComboRows]
  );

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    // main 빈 그리드면 무시 (AS-IS SpdMain_CellDoubleClick guard cs L1028 — 순수 가드).
    if (data.length === 0) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    // 편집 가능 셀 더블클릭은 편집 진입이므로 하위 로드하지 않는다.
    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    onRowDblClick(String(dataItem.GROUP_ID ?? ''));
  };

  return (
    <DataGrid<GroupMasterRow>
      key={columns.map(c => c.colNm).join(',')}
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={columns}
      gotFocus={() => onFocus(ACTIVE_GRID.MAIN)}
      dblClick={handleDblClick}
    />
  );
};
