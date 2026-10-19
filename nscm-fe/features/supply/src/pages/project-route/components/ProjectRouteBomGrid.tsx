import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { BomKey, BomRow } from '../project-route.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<BomRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: BomRow[];
  staticColumns: RawFlexGridColumnConfig[];
  // BOM 더블클릭 → bom key 확정 + Plant 조회(design/00 A3).
  onRowDblClick: (bomKey: BomKey) => void;
  // 툴바 Filter(F4) 대상 추적용 — 이 그리드가 포커스를 얻으면 화면이 focusedSheetRef 를 갱신한다.
  gotFocus?: () => void;
}

// BOM Explosion(siBOM) — read-only 연쇄 그리드. 더블클릭 시 Plant Assign 조회를 트리거한다.
export const ProjectRouteBomGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  onRowDblClick,
  gotFocus,
}: Props) => {
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const row = grid.rows[ht.row]?.dataItem as BomRow | undefined;
    if (!row) return;
    // AS-IS spdBOM_CellDoubleClick(L1223): _bomItemId/_bomOperationId/_bomCellType 저장.
    onRowDblClick({
      itemId: String(row.ITEM_ID ?? ''),
      operationId: String(row.OPERATION_GROUP_ID ?? ''),
      cellType: String(row.CELL_TYPE ?? ''),
    });
  };

  return (
    <DataGrid<BomRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
