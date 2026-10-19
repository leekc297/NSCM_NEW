import type { CellRangeEventArgs, FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS } from '../shipment-request-electrode.constants';
import type { RequestDetailRow } from '../shipment-request-electrode.types';
import { isRequestDetailCellEditable } from '../utils/shipment-request-electrode.editLock';

interface Props {
  rows: RequestDetailRow[];
  gridRef: MutableRefObject<FlexGridType<RequestDetailRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<RequestDetailRow> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  isEditMode: boolean;
  onFocus: () => void;
  onItemCellDoubleClick?: (row: RequestDetailRow) => void;
}

/**
 * spdDetail.shtRequestDetail — 요청상세, 유일한 편집 대상 시트(design 03 §1.2).
 *
 * 편집 가능 범위는 3중 소스로 결정된다(design 01 R6/R10, 03 §3 규칙#8/#11):
 * 1. 신규행(CRUD_TYPE='I') — Insert 직후 5컬럼 lock(MODEL_ID/NICK_NAME/DIVISION_ID/REQUESTOR/REQUEST_DATE).
 * 2. 기존행 + 편집모드(EditButton 진입) — EDIT_FLAG 값별 lock 범위(N=REQUEST_DATE만 / 그외=SHIPMENT_DATE+
 *    REQUESTOR~REQUEST_DATE).
 * 3. 편집모드 아님 — 전체 lock(조회 직후 기본상태, design 03 §3 규칙#18).
 *
 * ITEM_ID 셀은 더블클릭 시 BOD/Item 팝업(SSP0022_BodItemPopup)을 열어야 한다(design 01 §2 R6 연계,
 * 03 §1.2) — 이번 회차는 팝업 자체를 미착수(04 미완 항목)해 onItemCellDoubleClick 훅만 배선해 둔다.
 */
export const ShipmentRequestElectrodeDetailGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  isEditMode,
  onFocus,
  onItemCellDoubleClick,
}: Props) => {
  const handleBeginningEdit = (grid: FlexGridType<RequestDetailRow>, e: CellRangeEventArgs) => {
    const column = grid.columns[e.col];
    const dataItem = GridUtils.getRow(grid, e.row) as RequestDetailRow | undefined;
    if (!column?.binding || !dataItem) return;
    const editable = isRequestDetailCellEditable({
      columnBinding: column.binding,
      crudType: dataItem.CRUD_TYPE,
      editFlag: dataItem.EDIT_FLAG,
      isNewRow: dataItem.CRUD_TYPE === 'I',
      isEditMode,
    });
    if (!editable) e.cancel = true;
  };

  // ITEM_ID 더블클릭 = BOD/Item 팝업 트리거(design 03 §1.2, 03_grid-columns.md 규칙#13) — 인라인
  //   편집으로 먼저 빠지지 않도록 beginningEdit 에서 이미 취소되므로(위 handleBeginningEdit),
  //   dblClick 에서 팝업만 연다(nscm-patterns.md §5-16 팝업 셀 편집취소 원칙).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const column = grid.columns[ht.col];
    if (column?.binding !== 'ITEM_ID') return;
    const dataItem = GridUtils.getRow(grid, ht.row) as RequestDetailRow | undefined;
    if (dataItem) onItemCellDoubleClick?.(dataItem);
  };

  return (
    <DataGrid<RequestDetailRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      sheetName={ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL]}
      gotFocus={onFocus}
      dblClick={handleDblClick}
      beginningEdit={handleBeginningEdit}
    />
  );
};
